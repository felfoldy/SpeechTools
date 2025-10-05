//
//  AppleLanguageModel.swift
//  SpeechTools
//
//  Created by Tibor Felföldy on 2025-10-05.
//

import FoundationModels
import SwiftPy

class AppleLanguageModel: LanguageModel, RespondingSessionModel {
    let session: FoundationModels.LanguageModelSession

    init(instructions: String) {
        session = FoundationModels.LanguageModelSession(instructions: instructions)
    }

    public func respond(prompt: String) -> LanguageModelResponse {
        let response = LanguageModelResponse()
        
        Task {
            do {
                for try await snapshot in session.streamResponse(to: prompt) {
                    response.content = snapshot.content
                }
            } catch {
                Log.languageModel.fault(error.localizedDescription)
            }
            
            response.isFinished = true
        }
        
        return response
    }
}
