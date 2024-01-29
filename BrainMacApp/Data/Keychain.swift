//
//  Keychain.swift
//  BrainMacApp
//
//  Created by Nick Crews on 1/28/24.
//

import Foundation
import OSLog

public struct Keychain {

    private let logger = Logger.create("keychain")
    private let service: String

    public init(service: String) {
        self.service = service
    }

    public func save<T: Codable>(_ item: T, key: String) {
        do {
            let data = try JSONEncoder.api.encode(item)
            save(data, service: service, account: key)
        } catch {
            logger.error("Failed to save item to keychain with error: \(error.localizedDescription)")
        }
    }

    public func read<T: Codable>(key: String, type: T.Type) -> T? {
        guard let data = read(service: service, account: key) else {
            return nil
        }

        do {
            let item = try JSONDecoder().decode(type, from: data)
            return item
        } catch {
            logger.error("Failed to read item from keychain with error: \(error.localizedDescription)")
            return nil
        }
    }

    public func delete(key: String) {
        delete(account: key, service: service)
    }

    private func save(_ data: Data, service: String, account: String) {
        Task.detached {
            let query = [
                kSecValueData: data,
                kSecClass: kSecClassGenericPassword,
                kSecAttrService: service,
                kSecAttrAccount: account,
            ] as CFDictionary

            let status = SecItemAdd(query, nil)

            if status == errSecDuplicateItem {
                let query = [
                    kSecAttrService: service,
                    kSecAttrAccount: account,
                    kSecClass: kSecClassGenericPassword,
                ] as CFDictionary

                let attributesToUpdate = [kSecValueData: data] as CFDictionary
                SecItemUpdate(query, attributesToUpdate)
            }
        }
    }

    private func read(service: String, account: String) -> Data? {

        let query = [
            kSecAttrService: service,
            kSecAttrAccount: account,
            kSecClass: kSecClassGenericPassword,
            kSecReturnData: true
        ] as CFDictionary

        var result: AnyObject?
        SecItemCopyMatching(query, &result)

        return (result as? Data)
    }

    private func delete(account: String, service: String) {
        Task.detached {
            let query = [
                kSecAttrService: service,
                kSecAttrAccount: account,
                kSecClass: kSecClassGenericPassword,
            ] as CFDictionary

            SecItemDelete(query)
        }
    }
}

public extension JSONEncoder {

    static var api: JSONEncoder {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .millisecondsSince1970
        encoder.outputFormatting = .prettyPrinted
        return encoder
    }
}
