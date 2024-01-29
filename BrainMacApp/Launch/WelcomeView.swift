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
    @State private var hasExistingKey: Bool
    @ObservedObject var applicationState: ApplicationState

    init(isRunning: Binding<Bool>, applicationState: ApplicationState) {
        _isRunning = isRunning
        self.applicationState = applicationState
        _hasExistingKey = State(initialValue: applicationState.openAI.key != nil)
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
                    if applicationState.openAI.key != nil {
                        isRunning = true
                    } else if !openAIKey.isEmpty {
                        applicationState.openAI.setKey(openAIKey)
                        isRunning = true
                    }
                } label: {
                    Text("Turn on")
                }
                .buttonStyle(.borderedProminent)
                .disabled(openAIKey.isEmpty && !hasExistingKey)
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
