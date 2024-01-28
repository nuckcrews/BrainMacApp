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

            Text("Open AI Key")
            TextField("Secret Key", text: $openAIKey)
                .onSubmit {
                    if !openAIKey.isEmpty {
                        isRunning = true
                    }
                }
            Button {
                if !openAIKey.isEmpty {
                    isRunning = true
                }
            } label: {
                Text("Turn on")
            }
            .buttonStyle(.borderedProminent)
            .disabled(openAIKey.isEmpty)
        }
        .frame(maxWidth: 400)
        .padding()
    }
}

#Preview {
    WelcomeView(isRunning: .constant(false))
}
