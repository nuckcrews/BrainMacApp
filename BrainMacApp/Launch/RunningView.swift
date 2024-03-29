//
//  RunningView.swift
//  BrainMacApp
//
//  Created by Nick Crews on 1/28/24.
//

import SwiftUI

struct RunningView: View {

    @Binding var isRunning: Bool
    @State private var selection = 0

    var body: some View {
        NavigationView {
            List(selection: $selection) {
                NavigationLink {
                    ChatView()
                } label: {
                    Text("Chat")
                }
                .tag(0)

                NavigationLink {
                    MemoriesView()
                } label: {
                    Text("Memories")
                }
                .tag(1)
            }
            .listStyle(.sidebar)
        }.toolbar {
            ToolbarItem(placement: .navigation) {
                Button(action: toggleSidebar, label: {
                    Image(systemName: "sidebar.leading")
                })
            }

            ToolbarItem(placement: .cancellationAction) {
                Button(
                    action: {
                        isRunning = false
                    }, label: {
                        Image(systemName: "pause")
                    }
                )
            }
        }
    }

    private func toggleSidebar() {
#if os(iOS)
#else
        NSApp.keyWindow?.firstResponder?.tryToPerform(#selector(NSSplitViewController.toggleSidebar(_:)), with: nil)
#endif
    }
}

#Preview {
    RunningView(isRunning: .constant(true))
}
