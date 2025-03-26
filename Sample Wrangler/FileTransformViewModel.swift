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
                let fileName = file.lastPathComponent
                let prevName = fileName
                let isMusicFile = fileIsAudio(at: file)
                
                let bpmResult = extractBPM(from: fileName)
                var isBPMDetected: Bool = false
                var fileNameWithUpdatedBPM: String?
                if let bpmResult = bpmResult {
                    isBPMDetected = true
                    fileNameWithUpdatedBPM = "\(bpmResult.bpm)bpm_\(bpmResult.fileName)"
                }
                
                let isKeyDetected = false // TODO implement
                let isRenamable = isMusicFile && (isBPMDetected || isKeyDetected)
                let newName = isRenamable ? fileName : nil
                return FileTransformModel(id: id, url: file, newName: fileNameWithUpdatedBPM, prevName: prevName, isRenamable: isRenamable, isMusicFile: isMusicFile, isBPMDetected: isBPMDetected, isKeyDetected: isKeyDetected)
            }
            return files
        } else {
           return []
        }
    }
    
    static func extractBPM(from fileName: String) -> (bpm: Int, fileName: String)? {
        let pattern = "(?i)\\b(\\d+)\\s*bpm\\b"
        guard let regex = try? NSRegularExpression(pattern: pattern) else {
            return nil
        }
        let nsRange = NSRange(fileName.startIndex..<fileName.endIndex, in: fileName)
        guard let match = regex.firstMatch(in: fileName, options: [], range: nsRange) else {
            return nil
        }
        // Capture the BPM number from the first capturing group
        guard let bpmRange = Range(match.range(at: 1), in: fileName),
              let bpm = Int(String(fileName[bpmRange])) else {
            return nil
        }
        // Remove the entire matched BPM string from the file name
        guard let fullMatchRange = Range(match.range, in: fileName) else {
            return nil
        }
        var updatedFileName = fileName
        updatedFileName.removeSubrange(fullMatchRange)
        updatedFileName = updatedFileName.trimmingCharacters(in: .whitespacesAndNewlines)
        
        return (bpm: bpm, fileName: updatedFileName)
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
