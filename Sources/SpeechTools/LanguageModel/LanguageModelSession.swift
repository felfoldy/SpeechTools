//
//  LanguageModelSession.swift
//  SpeechTools
//
//  Created by Tibor Felföldy on 2025-07-20.
//

import SwiftPy
import FoundationModels
import Foundation

@MainActor
@Scriptable
class LanguageModel {
    static func apple(instructions: String) throws -> LanguageModel {
        AppleLanguageModel(instructions: instructions)
    }
}

@MainActor
protocol RespondingSessionModel {
    func respond(prompt: String) -> LanguageModelResponse
}

@MainActor
@Scriptable
public class LanguageModelSession {
    var model: LanguageModel

    init(instructions: String) throws {
        model = try .apple(instructions: instructions)
    }
    
    init(_ model: LanguageModel) {
        self.model = model
    }

    func respond(prompt: String) -> LanguageModelResponse {
        (model as! RespondingSessionModel)
            .respond(prompt: prompt)
    }
}
