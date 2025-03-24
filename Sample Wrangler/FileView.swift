//
//  FileView.swift
//  Sample Wrangler
//
//  Created by Rio Edwards on 3/24/25.
//

//
//  FileReader.swift
//  Sample Wrangler
//
//  Created by Rio Edwards on 3/22/25.
//

import Foundation
import SwiftUI

// View that uses the ViewModel
struct FileView: View {
    @StateObject private var viewModel: FileViewModel
    let baseFolder: URL
    
    init(_ baseFolder: URL) {
        // This is the standard way to initialize a @StateObject with parameters
        _viewModel = StateObject(wrappedValue: FileViewModel(baseFolder))
        self.baseFolder = baseFolder
    }
    
    var body: some View {
        VStack {
            if viewModel.isProcessing {
                ProgressView("Processing files...")
            } else if let error = viewModel.errorMessage {
                Text(error)
                    .foregroundColor(.red)
            } else if viewModel.fileObjArr.isEmpty {
                Text("No audio files found")
            } else {
                FileListView(viewModel.fileObjArr)
                
                Button("Rename All Files") {
                    viewModel.showingConfirmation = true
                }
                .padding()
                .buttonStyle(.borderedProminent)
                .confirmationDialog("Change background", isPresented: $viewModel.showingConfirmation) {
                    Button("Cancel", role: .cancel) { }
                    Button("Confirm") {
                        print("Confirm Button Pressed!")
                        viewModel.renameAllFiles()
                        viewModel.saveToDisk()
                    }
                } message: {
                    Text("Are you sure?")
                }
            }
        }
        .onChange(of: baseFolder) { _, newFolder in
            // When baseFolder changes, update the viewModel's baseFolder and reload
            viewModel.baseFolder = newFolder
            viewModel.loadAudioFiles()
        }
    }
}
