//
//  ChatCompletion.swift
//  
//
//  Created by Tibor Felföldy on 2024-06-18.
//

import Foundation

public enum ChatGPTModel: String, Codable {
    case gpt3_5 = "gpt-3.5-turbo"
    case gpt4 = "gpt-4o"
}

struct ChatGPTMessage: Codable {
    let role: Role
    let content: String
    
    enum Role: String, Codable {
        case user, assistant, system
    }
}

struct ChatCompletionRequestBody: Encodable {
    let model: ChatGPTModel
    let messages: [ChatGPTMessage]
}

struct ChatCompletionResponseBody: Decodable {
    let choices: [Choice]
    let usage: Usage
    
    struct Choice: Decodable {
        let message: ChatGPTMessage
    }
    
    struct Usage: Decodable {
        let promptTokens: Int
        let completionTokens: Int
        let totalTokens: Int
    }
}

public struct ChatCompletion: GPTModel {
    let apiKey: String
    let model: ChatGPTModel
    
    private let endpoint = "https://api.openai.com/v1/chat/completions"
    
    public init(apiKey: String, model: ChatGPTModel) {
        self.apiKey = apiKey
        self.model = model
    }
    
    public func fetchResponse(instructions: String, history: [ChatMessage]) async throws -> ChatMessage {
        let url = URL(string: endpoint)!
        var request = URLRequest(url: url)

        request.httpMethod = "POST"
        
        // Set headers.
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        
        // Set http body.
        var messages = [ChatGPTMessage(role: .system, content: instructions)]
        
        messages.append(
            contentsOf: history
                .map { message in
                    switch message.content {
                    case let .text(content):
                        ChatGPTMessage(
                            role: message.role == .user ? .user : .assistant,
                            content: content
                        )
                    }
                }
        )
        
        let requestBody = ChatCompletionRequestBody(model: model, messages: messages)
        
        request.httpBody = try JSONEncoder().encode(requestBody)
        
        // Request.
        let (data, _) = try await URLSession.shared
            .data(for: request)
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        let result = try decoder
            .decode(ChatCompletionResponseBody.self, from: data)
        
        Log.generativeAgent
            .trace("Tokens 􁾨\(result.usage.promptTokens) 􁾬\(result.usage.completionTokens)")
        
        guard let responseMessage = result.choices.first?.message else {
            throw Error.invalidResponse
        }

        return ChatMessage(role: .model, content: .text(responseMessage.content))
    }
}

extension ChatCompletion {
    enum Error: LocalizedError {
        case invalidResponse
    }
}
