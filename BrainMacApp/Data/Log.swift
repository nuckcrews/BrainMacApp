//
//  Log.swift
//  BrainMacApp
//
//  Created by Nick Crews on 1/28/24.
//

import Foundation
import OSLog

extension Logger {

    static func create(_ category: String) -> Logger {
        Logger(subsystem: Bundle.main.bundleIdentifier!, category: category)
    }
}
