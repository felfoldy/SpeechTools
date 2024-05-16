//
//  AppleSpeechSynthesizer+Error.swift
//
//
//  Created by Tibor Felföldy on 2024-05-16.
//

import Foundation

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
