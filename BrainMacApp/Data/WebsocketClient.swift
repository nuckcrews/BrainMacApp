//
//  WebsocketClient.swift
//  BrainMacApp
//
//  Created by Nick Crews on 1/29/24.
//

import Foundation
import OSLog

public class WebsocketClient: NSObject {

    private let logger = Logger.create("websocket")

    private let session = URLSession.shared

    private let url: URL

    private var socket: URLSessionWebSocketTask?

    private var connecting = false

    public init(url: URL) {
        self.url = url
    }

    public func connect(params: [URLQueryItem] = []) async throws {
        guard !connecting else { throw WebsocketError.invalidResponse }
        connecting = true

        guard socket == nil, var components = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
            connecting = false
            throw WebsocketError.invalidResponse
        }

        if !params.isEmpty {
            var queryParams = components.queryItems ?? []
            queryParams.append(contentsOf: params)
            components.queryItems = queryParams
        }

        guard let hydratedURL = components.url else { throw WebsocketError.invalidResponse }

        let task = session.webSocketTask(with: URLRequest(url: hydratedURL))
        task.delegate = self
        self.socket = task
        self.socket?.resume()
        connecting = false
    }

    public func close() {
        socket?.cancel(
            with: .goingAway,
            reason: "Gracefully closed session".data(using: .utf8)
        )
        socket = nil
    }

    public func receive(_ perform: @escaping (Data) -> Void) async throws {
        guard socket?.closeCode == .invalid else {
            throw WebsocketError.closedSocket
        }

        do {
            let message = try await socket?.receive()
            switch message {
            case .data(let data):
                perform(data)

            case .string(let string):
                if let data = string.data(using: .utf8) {
                    perform(data)
                }
            case .none:
                break
            case .some( _):
                break
            }

            try await receive(perform)
        } catch {
            logger.error("Failed to receive message with error: \(error.localizedDescription)")
            throw error
        }
    }

    public func send<T: Codable>(model: T) async {
        do {
            guard let data = try? JSONEncoder.api.encode(model),
                  let string = String(data: data, encoding: .utf8)
            else { return }
            let message = URLSessionWebSocketTask.Message.string(string)

            try await socket?.send(message)
        } catch {
            logger.error("Failed to send message with error: \(error.localizedDescription)")
        }
    }
}

extension WebsocketClient: URLSessionWebSocketDelegate {

    public func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didOpenWithProtocol protocol: String?) {
        logger.log("Connected to websocket server.")
    }

    public func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didCloseWith closeCode: URLSessionWebSocketTask.CloseCode, reason: Data?) {
        logger.log("Disonnected to websocket server.")
    }
}

enum WebsocketError: Error {
    case invalidResponse
    case closedSocket
}

public protocol WebsocketData: Codable {
    var action: String? { get }
}
