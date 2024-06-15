// The Swift Programming Language
// https://docs.swift.org/swift-book

#if canImport(LogTools)
import LogTools
#else
import OSLog
#endif

typealias Log = Logger

extension Log {
    static let speechSynthesis = Logger(subsystem: "com.felfoldy.SpeechTools", category: "SpeechSynthesis")
}
