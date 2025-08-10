//
//  LanguageModelSession.swift
//  SpeechTools
//
//  Created by Tibor Felföldy on 2025-07-20.
//

import SwiftPy
import FoundationModels

@Scriptable
class SessionModel {
    static func apple(instructions: String) throws -> SessionModel {
        if #available(iOS 26, *) {
            AppleSessionModel(instructions: instructions)
        } else {
            fatalError("Not implemented")
        }
    }
}

protocol RespondingSessionModel {
    func respond(prompt: String) async throws -> String
}

@Scriptable
public class LanguageModelSession {
    var model: SessionModel
    var instructions: String

    init(instructions: String) throws {
        model = try .apple(instructions: instructions)
        self.instructions = instructions
    }

    func respond(prompt: String) async throws -> String {
        try await (model as! RespondingSessionModel)
            .respond(prompt: prompt)
    }
}

@available(iOS 26, macOS 26.0, *)
class AppleSessionModel: SessionModel, RespondingSessionModel {
    let session: FoundationModels.LanguageModelSession

    init(instructions: String) {
        session = FoundationModels.LanguageModelSession(instructions: instructions)
    }

    public func respond(prompt: String) async throws -> String {
        let response = try await session.respond(to: prompt)
        return response.content
    }
}
