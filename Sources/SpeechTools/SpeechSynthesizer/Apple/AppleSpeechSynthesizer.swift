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

// MARK: - AVSpeechUtterance conversion

protocol AVSpeechUtteranceConvertible {
    func convert() -> AVSpeechUtterance
}

extension TextUtterance: AVSpeechUtteranceConvertible {
    func convert() -> AVSpeechUtterance {
        AVSpeechUtterance(string: text)
    }
}
