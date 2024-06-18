//
//  GenerativeAgent.swift
//
//
//  Created by Tibor Felföldy on 2024-06-15.
//

import Foundation

protocol MessageContent {}
extension String: MessageContent {}

struct ChatMessage {
    let role: Role
    let content: MessageContent
    
    enum Role: String {
        case system, user, assistant
    }
}

protocol GPTModel {
    func fetchResponse(history: [ChatMessage]) async throws -> ChatMessage
}

protocol HistoryManagedGPTModel: GPTModel {
    func fetchHistory() async throws -> [ChatMessage]
}

@MainActor
final class GenerativeAgent: ObservableObject {
    var model: GPTModel
    @Published var history: [ChatMessage]
    
    init(model: GPTModel, history: [ChatMessage] = []) {
        self.model = model
        self.history = history
    }
    
    @discardableResult
    func generateResponse() async throws -> ChatMessage {
        let result = try await model.fetchResponse(history: history)
        try await updateHistory(with: result)
        return result
    }
    
    func updateHistory(with message: ChatMessage? = nil) async throws {
        if let historyModel = model as? HistoryManagedGPTModel {
            let newHistory = try await historyModel.fetchHistory()

            await MainActor.run {
                history = newHistory
            }
        } else if let message {
            await MainActor.run {
                history.append(message)
            }
        }
    }
}
