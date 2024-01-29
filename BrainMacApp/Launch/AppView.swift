//
//  AppView.swift
//  BrainMacApp
//
//  Created by Nick Crews on 1/28/24.
//

import SwiftUI

@main
struct AppView: App {

    @ObservedObject var applicationState = ApplicationState.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(applicationState)
        }.commands {
            SidebarCommands()
        }
    }
}
