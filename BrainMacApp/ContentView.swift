//
//  ContentView.swift
//  BrainMacApp
//
//  Created by Nick Crews on 1/28/24.
//

import SwiftUI

struct ContentView: View {

    @State private var isRunning = false

    var body: some View {
        VStack {
            if !isRunning {
                WelcomeView(isRunning: $isRunning)
            } else {
                RunningView(isRunning: $isRunning)
            }
        }
        .animation(.snappy, value: isRunning)
    }
}



#Preview {
    ContentView()
}
