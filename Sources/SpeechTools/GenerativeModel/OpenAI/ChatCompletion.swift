//
//  ChatCompletion.swift
//  
//
//  Created by Tibor Felföldy on 2024-06-18.
//

import Foundation

private let log = Log.generativeAgent

public struct ChatGPTModel: Codable, RawRepresentable, Sendable {
    public var rawValue: String
    
    public init(rawValue: String) {
        self.rawValue = rawValue
    }
}

public extension ChatGPTModel {
    static let gpt4_1 = ChatGPTModel(rawValue: "gpt-4.1")
    static let gpt4o_mini = ChatGPTModel(rawValue: "gpt-4o-mini")
    static let gpt4_1_mini = ChatGPTModel(rawValue: "gpt-4.1-mini")
    static let gpt5 = ChatGPTModel(rawValue: "gpt-5")
    static let gpt5_mini = ChatGPTModel(rawValue: "gpt-5-mini")
    
    /// gpt-5
    static let large = gpt5
    /// gpt-5-mini
    static let small = gpt5_mini
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
    let usage: GPTUsage
    
    struct Choice: Decodable {
        let message: ChatGPTMessage
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
    
    public func fetchResponse(instructions: String, history: [ChatMessage]) async throws -> GPTResponse {
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
        
        guard let responseMessage = result.choices.first?.message else {
            throw Error.invalidResponse
        }

        let message = ChatMessage(role: .model,
                                  content: .text(responseMessage.content))
        
        return GPTResponse(message: message, usage: result.usage)
    }
}

extension ChatCompletion {
    enum Error: LocalizedError {
        case invalidResponse
    }
}
