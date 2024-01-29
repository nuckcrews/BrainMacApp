//
//  MemoriesView.swift
//  BrainMacApp
//
//  Created by Nick Crews on 1/28/24.
//

import SwiftUI

struct MemoriesView: View {

    @State private var memoryText = ""

    var body: some View {
        VStack {
            HStack {
                TextField("Path to memory", text: $memoryText)
                Button(
                    action: {
                        
                    }, 
                    label: {
                        Text("Add Memory")
                    }
                )
                .buttonStyle(.borderedProminent)
                .disabled(memoryText.isEmpty)
            }
            Spacer()
        }
        .padding()
    }
}

#Preview {
    MemoriesView()
}
