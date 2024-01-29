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

    @EnvironmentObject var applicationState: ApplicationState

    var body: some View {
        VStack {
            Image("logo-black")
                .renderingMode(.template)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundStyle(Color.white)
                .frame(width: 200, height: 200)
                .padding(.bottom, 16)
            Text("Welcome to your Brain")
                .font(.largeTitle)

            HStack {
                Spacer()
                if applicationState.openAI.key != nil {
                    Button {
                        applicationState.openAI.reset()
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
                .disabled(openAIKey.isEmpty && applicationState.openAI.key == nil)
                Spacer()
            }
        }
        .frame(maxWidth: 400)
        .padding()
    }
}

#Preview {
    WelcomeView(isRunning: .constant(false))
}
