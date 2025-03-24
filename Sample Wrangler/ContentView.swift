//
//  ContentView.swift
//  Sample Wrangler
//
//  Created by Rio Edwards on 3/22/25.
//

import SwiftUI

// Main ViewModel to handle application state
class AppViewModel: ObservableObject {
    @Published var baseFolder: URL? = nil
    
    func selectFolder(url: URL) {
        baseFolder = url
    }
}

struct ContentView: View {
    @StateObject private var viewModel = AppViewModel()
    
    var body: some View {
        VStack {
            FolderPickerButton(baseFolder: $viewModel.baseFolder)
            
            if let baseFolder = viewModel.baseFolder {
                Text("Selected folder: \(baseFolder.lastPathComponent)")
                    .padding(.top)
                    .font(.headline)
                
                FileView(baseFolder)
                    .padding()
            } else {
                Spacer()
                Text("Please select a folder to begin")
                    .font(.title2)
                    .foregroundColor(.secondary)
                Spacer()
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
