//
//  LanguageModelResponse.swift
//  SpeechTools
//
//  Created by Tibor Felföldy on 2025-10-05.
//

import SwiftUI
import SwiftPy
import DebugTools

@Observable
@Scriptable
public class LanguageModelResponse: ViewRepresentable {
    public var content: String = ""
    public var isFinished: Bool = false

    public var view: some View {
        LanguageModelResponseView(model: self)
    }
}

struct LanguageModelResponseView: View {
    @State var model: LanguageModelResponse

    var body: some View {
        LogContainerView(tint: model.isFinished ? .green : .indigo) {
            Text(.init(model.content))
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .animation(.bouncy, value: model.content)
    }
}

#Preview {
    LanguageModelResponseView(model: {
        let response = LanguageModelResponse()
        response.content = "Hello, World!"
        return response
    }())
}
