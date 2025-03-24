//
//  FileReader.swift
//  Sample Wrangler
//
//  Created by Rio Edwards on 3/22/25.
//

import Foundation
import SwiftUI

struct FileObj {
    let url: URL
    let originalName: String
    let newName: String
}

// ViewModel to handle file operations
class AudioFileViewModel: ObservableObject {
    private let fileManager = FileManager.default
    var baseFolder: URL
    
    @Published var audioFiles: [URL] = [] {
        didSet {
            generateFileObjArr()
        }
    }
    @Published var fileObjArr: [FileObj] = []
    @Published var isProcessing: Bool = false
    @Published var errorMessage: String? = nil
    
    init(_ baseFolder: URL) {
        self.baseFolder = baseFolder
        loadAudioFiles()
    }
    
    func loadAudioFiles() {
        audioFiles = returnFilePathsDeepSearch(at: baseFolder.path)
    }
    
    func generateFileObjArr() {
        if !audioFiles.isEmpty {
            fileObjArr = audioFiles.map { file in
                let originalName = file.lastPathComponent
                let newName = getNewFileName(from: originalName)
                return FileObj(url: file, originalName: originalName, newName: newName)
            }
        } else {
            fileObjArr = []
        }
    }
    
    func getNewFileName(from original: String) -> String {
        if original.contains("frog") {
            return original.replacingOccurrences(of: "frog", with: "cow")
        } else if original.contains("cow") {
            return original.replacingOccurrences(of: "cow", with: "frog")
        } else {
            return original
        }
    }
    
    func renameAllFiles() {
        isProcessing = true
        errorMessage = nil
        
        for fileObj in fileObjArr {
            do {
                try renameFile(at: fileObj.url, to: fileObj.newName)
            } catch {
                errorMessage = "Error renaming files: \(error.localizedDescription)"
                print("Rename failed for \(fileObj.url.lastPathComponent): \(error.localizedDescription)")
            }
        }
        
        // Refresh file list after renaming
        loadAudioFiles()
        isProcessing = false
    }
    
    private func renameFile(at originalURL: URL, to newName: String) throws {
        let newURL = originalURL.deletingLastPathComponent()
            .appendingPathComponent(newName)
        
        try fileManager.moveItem(at: originalURL, to: newURL)
        print("Successfully Renamed \(originalURL.lastPathComponent) to \(newName)!")
    }
    
    private func fileIsAudio(at fileURL: URL) -> Bool {
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
    @StateObject private var viewModel: AudioFileViewModel
    let baseFolder: URL
    
    init(_ baseFolder: URL) {
        // This is the standard way to initialize a @StateObject with parameters
        _viewModel = StateObject(wrappedValue: AudioFileViewModel(baseFolder))
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
                    viewModel.renameAllFiles()
                }
                .padding()
                .buttonStyle(.borderedProminent)
            }
        }
        .onChange(of: baseFolder) { _, newFolder in
            // When baseFolder changes, update the viewModel's baseFolder and reload
            viewModel.baseFolder = newFolder
            viewModel.loadAudioFiles()
        }
    }
}
