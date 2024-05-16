//
//  Utterance.swift
//
//
//  Created by Tibor Felföldy on 2024-05-16.
//

public protocol Utterance {}

public struct TextUtterance: Utterance {
    public let text: String
    public let rate: Double?
    
    public init(text: String, rate: Double? = nil) {
        self.text = text
        self.rate = rate
    }
}

public extension Utterance where Self == TextUtterance {
    static func text(_ text: String, rate: Double? = nil) -> TextUtterance {
        TextUtterance(text: text, rate: rate)
    }
}
