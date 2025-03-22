//
//  ContentView.swift
//  Sample Wrangler
//
//  Created by Rio Edwards on 3/22/25.
//

import SwiftUI

struct ContentView: View {
    @State private var baseFolder: URL? = nil
    
    var body: some View {
        VStack {
                FolderPickerButton(baseFolder: $baseFolder)
                if let baseFolder = baseFolder {
                    Text("Selected folder: \(baseFolder.path)")
                        .padding(.top)
                    FileReader(baseFolder)
                }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
