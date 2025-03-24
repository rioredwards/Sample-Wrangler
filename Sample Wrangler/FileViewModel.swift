//
//  FileViewModel.swift
//  Sample Wrangler
//
//  Created by Rio Edwards on 3/24/25.
//

import Foundation
import SwiftUI

// ViewModel to handle file operations
class FileViewModel: ObservableObject {
    @Published var showingConfirmation = false
    private let fileManager = FileManager.default
    var baseFolder: URL
    
    @Published var audioFiles: [URL] = [] {
        didSet {
            generateFileObjArr()
        }
    }
    @Published var fileObjArr: [FileModel] = []
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
                return FileModel(id: UUID().uuidString, url: file, originalName: originalName, newName: newName)
            }
        } else {
            fileObjArr = []
        }
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

// Renaming Logic
extension FileViewModel {
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
}

// Encoding and Decoding
extension FileViewModel {
    private func encodeToData() -> Data? {
        let encoder = JSONEncoder()
        return try? encoder.encode(self.fileObjArr)
    }
    
    func saveToDisk() {
        do {
            let data = self.encodeToData()!
            let applicationSupportDirectoryURL = try getOrCreateApplicationSupportDirectory()
            try data.write(to: applicationSupportDirectoryURL)
        } catch {
            print("Error saving data to disk: \(error)")
        }
    }
    
    private func getOrCreateApplicationSupportDirectory() throws -> URL {
        if let appSupportURL = fileManager.urls(for: .applicationSupportDirectory, in: .userDomainMask).first {
            let appDirectory = appSupportURL.appendingPathComponent("SampleWrangler")
            
            // Create the directory if it doesn't exist
            do {
                try fileManager.createDirectory(at: appDirectory, withIntermediateDirectories: true)
            } catch {
                fatalError( "Couldn't create application support directory")
            }
            
            let jsonURL = appDirectory.appendingPathComponent("transformations.json")
            return jsonURL
        } else {
            fatalError( "Couldn't find application support directory")
        }
    }
}
