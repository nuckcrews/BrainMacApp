//
//  ChatModel.swift
//  BrainMacApp
//
//  Created by Nick Crews on 1/28/24.
//

import Foundation

struct ChatMessageModel: Codable, Hashable, Identifiable {
    let id: String
    let text: String
    let sender: Participant
    let timestamp: Date

    enum Participant: String, Codable {
        case client
        case bot
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: ChatMessageModel, rhs: ChatMessageModel) -> Bool {
        lhs.id == rhs.id
    }
}

struct NewChatMessageModel: Codable {
    let message: String
}
