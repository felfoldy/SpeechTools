//
//  SpeechSynthesizer.swift
//  
//
//  Created by Tibor Felföldy on 2024-05-16.
//

public protocol SpeechSynthesizer {
    func speak(utterance: any Utterance) async throws
}
