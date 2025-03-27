//
//  FileTransformView.swift
//  Sample Wrangler
//
//  Created by Rio Edwards on 3/24/25.
//

import Foundation
import SwiftUI

// View that uses the ViewModel
struct FileTransformView: View {
    @ObservedObject private var viewModel: FileTransformViewModel
    @State private var showingConfirmation = false
    
    init(viewModel: FileTransformViewModel) {
        _viewModel = .init(wrappedValue: viewModel)
    }
    
    var body: some View {
        FileListView(viewModel.fileTransformData)
        
        Button("Rename All Files") {
            showingConfirmation = true
        }
        .padding()
        .buttonStyle(.borderedProminent)
        .confirmationDialog("Are you sure?", isPresented: $showingConfirmation) {
            Button("Cancel", role: .cancel) { }
            Button("Confirm") {
                print("Confirm Button Pressed!")
                viewModel.renameAllFiles()
                viewModel.saveToDisk()
            }
        } message: {
            Text("Are you sure?")
        }
        
        
        Button("Revert") {
            viewModel.revertAllFileRenames()
            
        }
    }
}
