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
    
    public static func voices(language: Language) -> [AVSpeechSynthesisVoice] {
        AVSpeechSynthesisVoice.speechVoices()
            .filter { voice in
                voice.language
                    .starts(with: language.code)
            }
    }
}

public extension AppleSpeechSynthesizer {
    convenience init?(language: Language) {
        guard let voice = AVSpeechSynthesisVoice(language: language.code) else {
            return nil
        }
        self.init(voice: voice)
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
