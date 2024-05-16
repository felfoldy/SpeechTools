//
//  SpeechSynthesizerProcessor.swift
//
//
//  Created by Tibor Felföldy on 2024-05-16.
//

import AVFoundation

private let log = Log.speechSynthesis

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
