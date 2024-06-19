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
}

public protocol GPTModel {
    func fetchResponse(instructions: String, history: [ChatMessage]) async throws -> ChatMessage
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

        try await updateHistory(with: result)
        return result
    }
    
    public func updateHistory(with message: ChatMessage? = nil) async throws {
        if let historyModel = model as? HistoryManagedGPTModel {
            history = try await historyModel.fetchHistory()
        } else if let message {
            history.append(message)
        }
    }
}
