//
//  ChatCompletionResponseBodyTests.swift
//  
//
//  Created by Tibor Felföldy on 2024-06-18.
//

@testable import SpeechTools
import XCTest

final class ChatCompletionResponseBodyTests: XCTestCase {
    func testDecoding() throws {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let responseBody = try decoder
            .decode(ChatCompletionResponseBody.self,
                    from: responseToDecode)
        
        XCTAssertEqual(responseBody.usage.promptTokens, 9)
        XCTAssertEqual(responseBody.usage.completionTokens, 12)
        
        XCTAssertEqual(responseBody.choices.count, 1)
        XCTAssertEqual(responseBody.choices.first?.message.role, .assistant)
        XCTAssertEqual(responseBody.choices.first?.message.content, "Hello there, how may I assist you today?")
    }
}

let responseToDecode = """
{
  "id": "chatcmpl-123",
  "object": "chat.completion",
  "created": 1677652288,
  "model": "gpt-3.5-turbo-0125",
  "system_fingerprint": "fp_44709d6fcb",
  "choices": [{
    "index": 0,
    "message": {
      "role": "assistant",
      "content": "Hello there, how may I assist you today?",
    },
    "logprobs": null,
    "finish_reason": "stop"
  }],
  "usage": {
    "prompt_tokens": 9,
    "completion_tokens": 12,
    "total_tokens": 21
  }
}
"""
.data(using: .utf8)!
