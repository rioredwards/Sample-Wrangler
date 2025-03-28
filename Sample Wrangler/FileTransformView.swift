//
//  FileTransformView.swift
//  Sample Wrangler
//
//  Created by Rio Edwards on 3/24/25.
//

import Foundation
import SwiftUI

enum ButtonType {
    case rename, revert
}

// View that uses the ViewModel
struct FileTransformView: View {
    @ObservedObject private var viewModel: FileTransformViewModel
    @State private var showingConfirmationForRename = false
    @State private var showingConfirmationForRevert = false
    let baseFolder: URL
    
    init(viewModel: FileTransformViewModel, baseFolder: URL) {
        _viewModel = .init(wrappedValue: viewModel)
        self.baseFolder = baseFolder
    }
    
    var body: some View {
        FileListView(viewModel.fileTransformData)
        
        HStack{
            if viewModel.transformationsFileExists {
                Button(action: { showingConfirmationForRevert = true }) {
                    HStack {
                        Text("Revert")
                            .font(.system(size: 14))
                        Image(systemName: "arrow.uturn.backward")
                            .font(.system(size: 14))
                    }
                    .frame(minWidth: 150)
                }
                .confirmationDialog("Revert All Renamed Files?", isPresented: $showingConfirmationForRevert) {
                    Button("Cancel", role: .cancel) { }
                    Button("Confirm") {
                        viewModel.revertAllFileRenames()
                    }
                } message: {
                    Text("Are you sure?")
                }.buttonStyle(MyDestructiveButton())
            } else {
                Button(action: { showingConfirmationForRename = true }) {
                    HStack {
                        Text("Rename All Files")
                            .font(.system(size: 14))
                        Image(systemName: "play.square.stack.fill")
                            .font(.system(size: 14))
                    }
                    .frame(minWidth: 150)
                }
                .buttonStyle(MyOtherCoolButton())
                .confirmationDialog("Rename All Files?", isPresented: $showingConfirmationForRename) {
                    Button("Cancel", role: .cancel) { }
                    Button("Confirm") {
                        viewModel.renameAllFiles()
                        viewModel.saveToDisk()
                    }
                } message: {
                    Text("Are you sure?")
                }
            }
        }
    }
}
