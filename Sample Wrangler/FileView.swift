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
            } else if viewModel.files.isEmpty {
                Text("No files found")
            } else {
                let fileTransformArray = FileTransformViewModel.generateFileTransformData(from: viewModel.files)
                let fileTransformViewModel = FileTransformViewModel(fileTransformData: fileTransformArray)
                FileTransformView(viewModel: fileTransformViewModel)
            }
        }
        .onChange(of: baseFolder) { _, newFolder in
            // When baseFolder changes, update the viewModel's baseFolder and reload
            viewModel.baseFolder = newFolder
            viewModel.loadFiles()
        }
    }
}
