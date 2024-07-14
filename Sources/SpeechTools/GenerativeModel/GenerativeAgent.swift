//
//  GenerativeAgent.swift
//
//
//  Created by Tibor Felföldy on 2024-06-15.
//

import Foundation

public enum MessageContent {
    case text(String)
}

public struct ChatMessage {
    public let role: Role
    public let content: MessageContent
    
    public enum Role: String {
        case user, model
    }
    
    public init(role: Role, content: MessageContent) {
        self.role = role
        self.content = content
    }
    
    public init(_ role: Role, _ content: String) {
        self.role = role
        self.content = .text(content)
    }
}

public extension ChatMessage {
    var text: String {
        switch content {
        case let .text(text):
            return text
        }
    }
}

public struct GPTUsage: Decodable {
    public let promptTokens: Int
    public let completionTokens: Int
}


public struct GPTResponse {
    let message: ChatMessage
    let usage: GPTUsage
}

public protocol GPTModel {
    func fetchResponse(instructions: String, history: [ChatMessage]) async throws -> GPTResponse
}

public protocol HistoryManagedGPTModel: GPTModel {
    func fetchHistory() async throws -> [ChatMessage]
}

@MainActor
public final class GenerativeAgent: ObservableObject {
    public var model: GPTModel
    let instructions: String

    @Published
    public var history: [ChatMessage]

    public private(set) var usage: [GPTUsage] = []
    
    public init(model: GPTModel, instructions: String, history: [ChatMessage] = []) {
        self.model = model
        self.instructions = instructions
        self.history = history
    }
    
    @discardableResult
    public func generateResponse() async throws -> ChatMessage {
        let result = try await model
            .fetchResponse(instructions: instructions,
                           history: history)
        
        usage.append(result.usage)

        try await updateHistory(with: result.message)
        return result.message
    }
    
    public func updateHistory(with message: ChatMessage? = nil) async throws {
        if let historyModel = model as? HistoryManagedGPTModel {
            history = try await historyModel.fetchHistory()
        } else if let message {
            history.append(message)
        }
    }
}
