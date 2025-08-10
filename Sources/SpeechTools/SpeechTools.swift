// The Swift Programming Language
// https://docs.swift.org/swift-book

import LogTools
import SwiftPy

typealias Log = Logger

extension Log {
    static let speechSynthesis = Logger(subsystem: "com.felfoldy.SpeechTools", category: "SpeechSynthesis")
    static let generativeAgent = Logger(subsystem: "com.felfoldy.SpeechTools", category: "GenerativeAgent")
}

public enum SpeechTools {
    @MainActor
    public static func initialize() {
        if #available(macOS 26.0, *) {
            Interpreter.bindModule("speechtools", [LanguageModelSession.self])
        }
    }
}
