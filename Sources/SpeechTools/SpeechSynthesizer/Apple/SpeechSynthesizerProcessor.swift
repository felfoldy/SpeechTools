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
            log.info("Started speech: \(utterance.speechString)")
        }
        
        @available(iOS 17.0, *)
        @available(macOS 14.0, *)
        func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, willSpeak marker: AVSpeechSynthesisMarker, utterance: AVSpeechUtterance) {
            if !marker.phoneme.isEmpty {
                log.debug("Speak \(marker.phoneme)")
            } else {
                let nsString = NSString(string: utterance.speechString)
                let substring = nsString.substring(with: marker.textRange)
                log.debug("Speak \(substring)")
            }
        }
        
        func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didCancel utterance: AVSpeechUtterance) {
            activeContinuations[utterance.hash]?.resume(throwing: SpeechError.didCancel)
            activeContinuations[utterance.hash] = nil
            
            log.warning("Cancelled speech: \(utterance.speechString)")
        }
        
        func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
            activeContinuations[utterance.hash]?.resume()
            activeContinuations[utterance.hash] = nil
            
            log.info("Finished speech: \(utterance.speechString)")
        }
    }
}
