//
//  ChatView.swift
//  BrainMacApp
//
//  Created by Nick Crews on 1/28/24.
//

import SwiftUI

struct ChatView: View {

    @StateObject private var viewModel = ChatViewModel()

    var body: some View {
        VStack {
            List {
                ForEach(viewModel.messages) { message in
                    HStack(alignment: .top) {
                        Image(systemName: message.sender == .bot ? "face.dashed" : "person")
                        Text(message.text)
                    }
                }
            }
            .listStyle(.plain)
            Spacer()
            HStack {
                TextField("Write something...", text: $viewModel.inputText)
                Button {
                    viewModel.sendChat()
                } label: {
                    Text("Send")
                }
                .buttonStyle(.borderedProminent)
                .disabled(viewModel.inputText.isEmpty)
            }
        }
        .padding()
        .task {
            viewModel.open()
        }
        .onDisappear {
            viewModel.close()
        }
    }
}

#Preview {
    ChatView()
}
