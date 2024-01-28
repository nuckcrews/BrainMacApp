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
            Image(systemName: "brain.head.profile")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 120, height: 120)
            Text("Welcome to your Brain")
                .font(.largeTitle)

            Text("Open AI Key")
            TextField("Secret Key", text: $openAIKey)
            Button {
                isRunning = true
            } label: {
                Text("Turn on")
            }
            .buttonStyle(.borderedProminent)
            .disabled(openAIKey.isEmpty)
        }
        .padding()
    }
}

#Preview {
    WelcomeView(isRunning: .constant(false))
}
