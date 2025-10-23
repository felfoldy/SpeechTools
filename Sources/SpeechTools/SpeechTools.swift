// The Swift Programming Language
// https://docs.swift.org/swift-book

import LogTools
import SwiftPy

typealias Log = Logger

extension Log {
    static let speechSynthesis = Logger(subsystem: "com.felfoldy.SpeechTools", category: "SpeechSynthesis")
    static let languageModel = Logger(subsystem: "com.felfoldy.SpeechTools", category: "LanguageModel")
}

public enum SpeechTools {
    @MainActor
    public static func initialize() {
        Interpreter.bindModule("speechtools", [
            LanguageModel.self,
            LanguageModelSession.self,
            LanguageModelResponse.self
        ])
    }
}
