//
//  ContentView.swift
//  Sample Wrangler
//
//  Created by Rio Edwards on 3/22/25.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedFolder: URL? = nil // Lifted state
    
    var body: some View {
        VStack {
                FolderPickerButton(folderURL: $selectedFolder)
                if let folder = selectedFolder {
                    Text("Parent sees folder: \(folder.path)")
                }
            FileReader()
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
