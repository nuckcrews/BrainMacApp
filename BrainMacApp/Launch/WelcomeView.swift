//
//  WelcomeView.swift
//  BrainMacApp
//
//  Created by Nick Crews on 1/28/24.
//

import SwiftUI

struct WelcomeView: View {

    @Binding var isRunning: Bool
    @State private var openAIKey = ""
    @State private var endpointText = ""
    @State private var hasExistingKey: Bool
    @FocusState private var focusState
    @ObservedObject var applicationState: ApplicationState

    init(isRunning: Binding<Bool>, applicationState: ApplicationState) {
        _isRunning = isRunning
        self.applicationState = applicationState
        _hasExistingKey = State(initialValue: applicationState.openAI.key != nil)
        _endpointText = State(initialValue: applicationState.brain.endpoint?.absoluteString ?? "")
    }

    var body: some View {
        VStack {
            Image("logo-black")
                .renderingMode(.template)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundStyle(Color.white)
                .frame(width: 200, height: 200)
            Text("Welcome to your Brain")
                .font(.largeTitle)
                .padding(.bottom, 24)

            TextField("Brain URI", text: $endpointText)
                .focused($focusState)
                .frame(width: 200)
                .padding(.bottom, 16)
            HStack {
                Spacer()
                if hasExistingKey {
                    Button {
                        applicationState.openAI.reset()
                        openAIKey = ""
                        hasExistingKey = false
                    } label: {
                        Text("Reset Keys")
                    }
                } else {
                    TextField("Open AI Secret Key", text: $openAIKey)
                        .onSubmit {
                            if !openAIKey.isEmpty {
                                applicationState.openAI.setKey(openAIKey)
                                isRunning = true
                            }
                        }
                }
                Button {
                    if applicationState.openAI.key != nil, let url = URL(string: endpointText) {
                        isRunning = true
                        applicationState.brain.setEndpoint(url)
                    } else if !openAIKey.isEmpty, let url = URL(string: endpointText) {
                        applicationState.openAI.setKey(openAIKey)
                        applicationState.brain.setEndpoint(url)
                        isRunning = true
                    }
                } label: {
                    Text("Turn on")
                }
                .buttonStyle(.borderedProminent)
                .disabled((openAIKey.isEmpty && !hasExistingKey) || URL(string: endpointText) == nil)
                Spacer()
            }
            .padding(.bottom, 24)
        }
        .frame(maxWidth: 400)
        .padding()
        .animation(.snappy, value: hasExistingKey)
    }
}

#Preview {
    WelcomeView(isRunning: .constant(false), applicationState: ApplicationState.shared)
}
