//
//  Utterance.swift
//
//
//  Created by Tibor Felföldy on 2024-05-16.
//

public protocol Utterance {}

public struct TextUtterance: Utterance {
    public let text: String
    
    public init(text: String) {
        self.text = text
    }
}

public extension Utterance where Self == TextUtterance {
    static func text(_ text: String, rate: Double? = nil) -> TextUtterance {
        TextUtterance(text: text)
    }
}
