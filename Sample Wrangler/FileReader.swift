//
//  FileReader.swift
//  Sample Wrangler
//
//  Created by Rio Edwards on 3/22/25.
//

import Foundation
import SwiftUI

// ViewModel to handle file operations
class AudioFileViewModel: ObservableObject {
    private let fileManager = FileManager.default
    
    @Published var audioFiles: [URL] = []
    @Published var isProcessing: Bool = false
    @Published var errorMessage: String? = nil
    
    func loadAudioFiles(from baseFolder: URL) {
        audioFiles = returnFilePathsDeepSearch(at: baseFolder.path)
    }
    
    func renameAllFiles() {
        isProcessing = true
        errorMessage = nil
        
        for filePath in audioFiles {
            do {
                let newName = "frog-\(UUID().uuidString).\(filePath.pathExtension)"
                try renameFile(at: filePath, to: newName)
            } catch {
                errorMessage = "Error renaming files: \(error.localizedDescription)"
                print("Rename failed for \(filePath.lastPathComponent): \(error.localizedDescription)")
            }
        }
        
        // Refresh file list after renaming
        if let baseFolder = audioFiles.first?.deletingLastPathComponent() {
            loadAudioFiles(from: baseFolder)
        }
        
        isProcessing = false
    }
    
    private func renameFile(at originalURL: URL, to newName: String) throws {
        let newURL = originalURL.deletingLastPathComponent()
            .appendingPathComponent(newName)
        
        try fileManager.moveItem(at: originalURL, to: newURL)
        print("Successfully Renamed \(originalURL.lastPathComponent) to \(newName)!")
    }
    
    private func fileIsAudio(at fileURL: URL) -> Bool {
        print("Testing if file is audio: \(fileURL)")
        if let typeIdentifier = try? fileURL.resourceValues(forKeys: [.contentTypeKey]).contentType, typeIdentifier.conforms(to: .audio) {
            return true
        }
        return false
    }
    
    private func returnFilePathsDeepSearch(at baseFolderPath: String) -> [URL] {
        let dirEnum = fileManager.enumerator(atPath: baseFolderPath)
        var audioFilePaths: [URL] = []
        
        
        while let file = dirEnum?.nextObject() as? String {
            let fullPath = baseFolderPath.appending("/\(file)")
            let fileURL = URL(fileURLWithPath: fullPath)
            if fileIsAudio(at: fileURL) {
                audioFilePaths.append(fileURL)
            }
        }
        return audioFilePaths
    }
}

// View that uses the ViewModel
struct FileReader: View {
    @StateObject private var viewModel = AudioFileViewModel()
    let baseFolder: URL
    
    init(_ baseFolder: URL) {
        self.baseFolder = baseFolder
    }
    
    var body: some View {
        VStack {
            if viewModel.isProcessing {
                ProgressView("Processing files...")
            } else if let error = viewModel.errorMessage {
                Text(error)
                    .foregroundColor(.red)
            } else if viewModel.audioFiles.isEmpty {
                Text("No audio files found")
            } else {
                List(viewModel.audioFiles, id: \.self) { file in
                    Text(file.lastPathComponent)
                }
                
                Button("Rename All Files") {
                    viewModel.renameAllFiles()
                }
                .padding()
                .buttonStyle(.borderedProminent)
            }
        }
        .onAppear {
            viewModel.loadAudioFiles(from: baseFolder)
        }
    }
}
