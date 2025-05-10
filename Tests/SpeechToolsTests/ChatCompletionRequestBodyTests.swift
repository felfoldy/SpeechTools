//
//  ChatCompletionRequestBodyTests.swift
//  
//
//  Created by Tibor Felföldy on 2024-06-18.
//

@testable import SpeechTools
import XCTest

final class ChatCompletionRequestBodyTests: XCTestCase {
    func testEncoding() throws {
        let expectedBody = """
            {
                "model": "gpt-4.1",
                "messages": [
                  {
                    "role": "system",
                    "content": "You are a helpful assistant."
                  },
                  {
                    "role": "user",
                    "content": "Hello!"
                  }
                ]
            }
        """.data(using: .utf8)!
        
        let body = ChatCompletionRequestBody(model: .gpt4_1, messages: [
            ChatGPTMessage(role: .system, content: "You are a helpful assistant."),
            ChatGPTMessage(role: .user, content: "Hello!")
        ])

        let result = try JSONEncoder().encode(body)
        
        let resultJSON = try JSONSerialization
            .jsonObject(with: result) as! [String : Any]
        let expectedJSON = try JSONSerialization
            .jsonObject(with: expectedBody) as! [String : Any]
        
        XCTAssertEqual(resultJSON as NSDictionary,
                       expectedJSON as NSDictionary)
    }
}
