// The Swift Programming Language
// https://docs.swift.org/swift-book

import OSLog

typealias Log = Logger

extension Log {
    static let speechSynthesis = Logger(subsystem: "com.felfoldy", category: "SpeechSynthesis")
}
