//
//  AppleSpeechSynthesizer.swift
//
//
//  Created by Tibor Felföldy on 2024-05-16.
//

import AVFoundation

private let log = Log.speechSynthesis

public final class AppleSpeechSynthesizer: SpeechSynthesizer {
    private let voice: AVSpeechSynthesisVoice
    private let synthesizer = AVSpeechSynthesizer()
    private let processor = SpeechSynthesizerProcessor()
    
    public init(voice: AVSpeechSynthesisVoice) {
        self.voice = voice
        synthesizer.delegate = processor
        log.info("Initialized AppleSpeechSynthesizer with voice: \(voice.identifier, privacy: .public)")
    }
    
    public func speak(utterance: any Utterance) async throws {
        guard let utterance = utterance as? AVSpeechUtteranceConvertible else {
            log.warning("Unsupported utterance")
            throw SpeechError.unsupportedUtterance
        }
        
        let avUtterance = utterance.convert()

        avUtterance.voice = voice
        synthesizer.speak(avUtterance)
        
        try await processor.waitUntilFinish(avUtterance)
    }
}

extension AppleSpeechSynthesizer {
    class SpeechSynthesizerProcessor: NSObject, AVSpeechSynthesizerDelegate {
        private var activeContinuations = [Int : CheckedContinuation<Void, any Error>]()
        
        func waitUntilFinish(_ utterance: AVSpeechUtterance) async throws {
            try await withCheckedThrowingContinuation { continuation in
                activeContinuations[utterance.hash] = continuation
            }
        }
        
        func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didStart utterance: AVSpeechUtterance) {
            log.info("Started speech: \(utterance.speechString, privacy: .public)")
        }
        
        @available(iOS 17.0, *)
        func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, willSpeak marker: AVSpeechSynthesisMarker, utterance: AVSpeechUtterance) {
            log.debug("Speak \(marker.phoneme, privacy: .public)")
        }
        
        func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didCancel utterance: AVSpeechUtterance) {
            activeContinuations[utterance.hash]?.resume(throwing: SpeechError.didCancel)
            activeContinuations[utterance.hash] = nil
            
            log.warning("Cancelled speech: \(utterance.speechString, privacy: .public)")
        }
        
        func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
            activeContinuations[utterance.hash]?.resume()
            activeContinuations[utterance.hash] = nil
            
            log.info("Finished speech: \(utterance.speechString, privacy: .public)")
        }
    }
}

// MARK: - Error

public extension AppleSpeechSynthesizer {
    enum SpeechError: LocalizedError {
        case unsupportedUtterance
        case didCancel
        
        public var errorDescription: String? {
            switch self {
            case .unsupportedUtterance:
                return "The provided utterance is not supported."
            case .didCancel:
                return "The speech synthesis was canceled."
            }
        }
    }
}

// MARK: - AVSpeechUtterance conversion

protocol AVSpeechUtteranceConvertible {
    func convert() -> AVSpeechUtterance
}

extension TextUtterance: AVSpeechUtteranceConvertible {
    func convert() -> AVSpeechUtterance {
        AVSpeechUtterance(string: text)
    }
}
