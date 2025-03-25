//
//  TransformationViewModel.swift
//  Sample Wrangler
//
//  Created by Rio Edwards on 3/24/25.
//

import SwiftUI

class FileTransformViewModel: ObservableObject {
    private let fileManager = FileManager.default
    @Published var fileTransformData: [FileTransformModel]
    @Published var isProcessing: Bool = false
    @Published var errorMessage: String? = nil
    
    init(fileTransformData: [FileTransformModel]) {
        self.fileTransformData = fileTransformData
    }
    
    static func generateFileTransformData(from files: [URL]) -> [FileTransformModel] {
        if !files.isEmpty {
            let files = files.map { file in
                let id = UUID().uuidString
                let prevName = file.lastPathComponent
                let isMusicFile = fileIsAudio(at: file)
                let isBPMDetected = false // TODO implement
                let isKeyDetected = false // TODO implement
                let isRenamable = isMusicFile && (isBPMDetected || isKeyDetected)
                let newName = isRenamable ? getNewFileName(from: prevName) : nil
                return FileTransformModel(id: id, url: file, newName: newName, prevName: prevName, isRenamable: isRenamable, isMusicFile: isMusicFile, isBPMDetected: isBPMDetected, isKeyDetected: isKeyDetected)
            }
            return files
        } else {
           return []
        }
    }
    
    static private func fileIsAudio(at fileURL: URL) -> Bool {
        if let typeIdentifier = try? fileURL.resourceValues(forKeys: [.contentTypeKey]).contentType, typeIdentifier.conforms(to: .audio) {
            return true
        }
        return false
    }
    
    
    static private func getNewFileName(from original: String) -> String {
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
        
        for fileTransform in fileTransformData {
            if fileTransform.isRenamable == false { continue }
            do {
                if let newName = fileTransform.newName {
                    try renameFile(at: fileTransform.url, to: newName)
                } else {
                    fatalError("Tried to rename file with no new name!")
                }
            } catch {
                errorMessage = "Error renaming files: \(error.localizedDescription)"
                print("Rename failed for \(fileTransform.prevName): \(error.localizedDescription)")
            }
        }
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
extension FileTransformViewModel {
    private func encodeToData() -> Data? {
        let encoder = JSONEncoder()
        return try? encoder.encode(self.fileTransformData)
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
