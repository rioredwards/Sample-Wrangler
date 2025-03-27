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
        print("viewModel.files", files)
        if !files.isEmpty {
            let files = files.map { file in
                let id = UUID().uuidString
                let fileName = file.lastPathComponent
                let prevName = fileName
                let isMusicFile = fileIsAudio(at: file)
                
                var isKeyDetected: Bool = false
                var fileNameWithUpdatedKey: String?
                if isMusicFile {
                    let keyResult = BPMAndKeyExtractor.extractKey(from: fileName)
                    if let keyResult = keyResult {
                        isKeyDetected = true
                        fileNameWithUpdatedKey = "\(keyResult.key)_\(keyResult.updatedFile)"
                    }
                }
                
                var isBPMDetected: Bool = false
                var fileNameWithUpdatedBPM: String?
                if isMusicFile {
                    let bpmResult = BPMAndKeyExtractor.extractBPM(from: fileNameWithUpdatedKey ?? fileName)
                    if let bpmResult = bpmResult {
                        isBPMDetected = true
                        fileNameWithUpdatedBPM = "\(bpmResult.bpm)_\(bpmResult.updatedFile)"
                    }
                }
                
                let isRenamable = isMusicFile && (isBPMDetected || isKeyDetected)
                let newName = isRenamable ? fileNameWithUpdatedBPM ?? fileNameWithUpdatedKey : nil
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
    
    
    func renameAllFiles() {
        isProcessing = true
        errorMessage = nil
        
        for idx in 0...fileTransformData.count - 1 {
            let fileTransform = fileTransformData[idx]
            if fileTransform.isRenamable == false { continue }
            do {
                if let newName = fileTransform.newName {
                    let newURL = try renameFile(at: fileTransform.url, to: newName)
                    fileTransformData[idx].url = newURL
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
    
    func revertAllFileRenames() {
        isProcessing = true
        errorMessage = nil
        
        let prevFileTransforms = Self.getTransformationLog()
        guard let prevFileTransforms = prevFileTransforms else { return  }
        
        for idx in 0...fileTransformData.count - 1 {
            let fileTransform = fileTransformData[idx]
            if fileTransform.isRenamable == false { continue }
            do {
                let newURL = try renameFile(at: fileTransform.url, to: fileTransform.prevName)
                fileTransformData[idx].url = newURL
            } catch {
                errorMessage = "Error renaming files: \(error.localizedDescription)"
            }
        }
        Self.clearTransformationLog()
        isProcessing = false
    }
    
    static func getTransformationLog() -> [FileTransformModel]? {
        do {
            let json = try getTransformationsLogFile()
            let data = try Data(contentsOf: json)
                if let decoded = try? JSONDecoder().decode([FileTransformModel].self, from: data) {
                    return decoded
                }
            return nil
        } catch {
            print("Error: \(error.localizedDescription)")
            return nil
        }
    }
    
    static func clearTransformationLog() {
        try? FileManager.default.removeItem(at: getTransformationsLogFile())
    }
    
    private func renameFile(at originalURL: URL, to newName: String) throws -> URL {
        let newURL = originalURL.deletingLastPathComponent()
            .appendingPathComponent(newName)
        
        try fileManager.moveItem(at: originalURL, to: newURL)
        print("Successfully Renamed \(originalURL.lastPathComponent) to \(newName)!")
        return newURL
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
            let applicationSupportDirectoryURL = try Self.getOrCreateTransformationsLogFile()
            try data.write(to: applicationSupportDirectoryURL)
        } catch {
            print("Error saving data to disk: \(error)")
        }
    }
    
    private static func getOrCreateTransformationsLogFile() throws -> URL {
        let fileManager = FileManager()
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
    
    private static func getTransformationsLogFile() throws -> URL {
        if let appSupportURL = FileManager().urls(for: .applicationSupportDirectory, in: .userDomainMask).first {
            let appDirectory = appSupportURL.appendingPathComponent("SampleWrangler")
            
            let jsonURL = appDirectory.appendingPathComponent("transformations.json")
            return jsonURL
        } else {
            fatalError( "Couldn't find application support directory")
        }
    }
}
