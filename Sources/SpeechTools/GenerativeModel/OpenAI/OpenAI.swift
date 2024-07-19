//
//  OpenAI.swift
//  
//
//  Created by Tibor Felföldy on 2024-07-14.
//

import Foundation

public struct OpenAI {
    let apiKey: String
    
    public init(apiKey: String) {
        self.apiKey = apiKey
    }
    
    public func chat(_ model: ChatGPTModel = .small) -> ChatCompletion {
        ChatCompletion(apiKey: apiKey, model: model)
    }
}
