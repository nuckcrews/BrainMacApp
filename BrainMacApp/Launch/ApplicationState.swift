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

    init() {}

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
