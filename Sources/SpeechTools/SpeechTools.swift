// The Swift Programming Language
// https://docs.swift.org/swift-book

import LogTools

typealias Log = Logger

extension Log {
    static let speechSynthesis = Logger(subsystem: "com.felfoldy.SpeechTools", category: "SpeechSynthesis")
    static let generativeAgent = Logger(subsystem: "com.felfoldy.SpeechTools", category: "GenerativeAgent")
}
