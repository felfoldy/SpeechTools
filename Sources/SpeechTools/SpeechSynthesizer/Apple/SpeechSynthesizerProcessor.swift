//
//  SpeechSynthesizerProcessor.swift
//
//
//  Created by Tibor Felföldy on 2024-05-16.
//

import AVFoundation

private let log = Log.speechSynthesis

extension AppleSpeechSynthesizer {
    final class SpeechSynthesizerProcessor: NSObject, AVSpeechSynthesizerDelegate {
        @MainActor
        private var activeContinuations = [Int: CheckedContinuation<Void, any Error>]()
        
        func waitUntilFinish(_ utterance: AVSpeechUtterance) async throws {
            try await withCheckedThrowingContinuation { continuation in
                let hash = utterance.hash
                Task { @MainActor in
                    activeContinuations[hash] = continuation
                }
            }
        }
        
        func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didStart utterance: AVSpeechUtterance) {
            log.info("Started speech: \(utterance.speechString)")
        }
        
        func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didCancel utterance: AVSpeechUtterance) {
            let hash = utterance.hash
            Task { @MainActor in
                activeContinuations[hash]?.resume(throwing: SpeechError.didCancel)
                activeContinuations[hash] = nil
            }
            
            log.warning("Cancelled speech: \(utterance.speechString)")
        }
        
        func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
            let hash = utterance.hash
            Task { @MainActor in
                activeContinuations[hash]?.resume()
                activeContinuations[hash] = nil
            }
            
            log.info("Finished speech: \(utterance.speechString)")
        }
    }
}
