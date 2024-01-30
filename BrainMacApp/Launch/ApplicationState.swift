//
//  AppDelegate.swift
//  BrainMacApp
//
//  Created by Nick Crews on 1/28/24.
//

import Foundation
import SwiftUI

final class ApplicationState: ObservableObject {

    static let shared = ApplicationState()

    private let keychain = Keychain(service: "\(Bundle.main.bundleIdentifier!).keychain")

    lazy var openAI: OpenAI = {
        OpenAI(keychain: keychain)
    }()

    let brain = Brain()

    init() {}

    struct Brain {

        private let userDefaults = UserDefaults.standard

        static let endpointLocation = "com.brain.endpoint"

        var endpoint: URL? {
            guard let url = userDefaults.string(forKey: Self.endpointLocation) else { return nil }
            return URL(string: url)
        }

        func setEndpoint(_ endpoint: URL) {
            userDefaults.setValue(endpoint.absoluteString, forKey: Self.endpointLocation)
        }

        func reset() {
            userDefaults.removeObject(forKey: Self.endpointLocation)
        }
    }

    struct OpenAI {

        private let keychain: Keychain

        static let keyLocation = "com.openai.key"

        init(keychain: Keychain) {
            self.keychain = keychain
        }

        var key: String? {
            keychain.read(key: Self.keyLocation, type: String.self)
        }

        func setKey(_ key: String) {
            keychain.save(key, key: Self.keyLocation)
        }

        func reset() {
            keychain.delete(key: Self.keyLocation)
        }
    }
}
