//
//  ChatViewModel.swift
//  BrainMacApp
//
//  Created by Nick Crews on 1/28/24.
//

import Foundation

final class ChatViewModel: ObservableObject {

    @Published var inputText = ""
    @Published var messages: [ChatMessageModel] = []
}
