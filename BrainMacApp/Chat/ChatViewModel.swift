//
//  ChatViewModel.swift
//  BrainMacApp
//
//  Created by Nick Crews on 1/28/24.
//

import Foundation
import OSLog

final class ChatViewModel: ObservableObject {

    private let logger = Logger.create("chat")

    @Published var inputText = ""
    @Published var messages: [ChatMessageModel] = []

    private let client: WebsocketClient

    private var isReceiving = false

    init() {
        guard let endpoint = ApplicationState.shared.brain.endpoint else {
            fatalError("Brain URI must not be nil")
        }
        self.client = WebsocketClient(url: endpoint)
    }

    func open() {
        Task { [weak self] in
            guard let self else { return }
            do {
                try await self.client.connect()
                self.receive()
            } catch {
                logger.error("Failed to connect to socket with error: \(error.localizedDescription)")
            }
        }
    }

    func sendChat() {
        let text = self.inputText
        self.inputText = ""
        Task { [weak self] in
            guard let self else { return }
            await self.client.send(model: NewChatMessageModel(message: text))
        }
    }

    private func receive() {
        guard !isReceiving else { return }
        isReceiving = true
        Task { [weak self] in
            guard let self else { return }
            do {
                try await client.receive { [weak self] data in
                    guard let self else { return }
                    print(data)
                }
            } catch {
                self.client.close()
                Task { @MainActor [weak self] in
                    self?.isReceiving = false
                }
            }
        }
    }

    func close() {
        client.close()
    }
}
