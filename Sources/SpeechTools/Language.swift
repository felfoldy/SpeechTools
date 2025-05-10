//
//  Language.swift
//  
//
//  Created by Tibor Felföldy on 2024-05-19.
//

import Foundation

public struct Language: Sendable{
    /// BCP-47 language code.
    public let code: String
}

public extension Language {
    static let englishUS = Language(code: "en-US")
    
    static let english = englishUS
    static let japanese = Language(code: "ja-JP")
    static let hungarian = Language(code: "hu-HU")
}
