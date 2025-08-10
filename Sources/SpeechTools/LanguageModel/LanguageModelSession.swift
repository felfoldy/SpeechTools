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
    static func apple() throws -> SessionModel {
        if #available(iOS 26, *) {
            AppleSessionModel()
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
    var model: SessionModel = try! .apple()
    var instructions = ""

    func respond(prompt: String) async throws -> String {
        try await (model as! RespondingSessionModel)
            .respond(prompt: prompt)
    }
}

@available(iOS 26, macOS 26.0, *)
class AppleSessionModel: SessionModel, RespondingSessionModel {
    let session = FoundationModels.LanguageModelSession()
    
    public func respond(prompt: String) async throws -> String {
        let response = try await session.respond(to: prompt)
        return response.content
    }
}
