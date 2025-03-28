//
//  TransformationViewModel.swift
//  Sample Wrangler
//
//  Created by Rio Edwards on 3/24/25.
//

import SwiftUI
import CryptoKit

class FileTransformViewModel: ObservableObject {
    private let fileManager = FileManager.default
    @Published var fileTransformData: [FileTransformModel]
    @Published var isProcessing: Bool = false
    @Published var errorMessage: String? = nil
    @Published var baseURL: URL
    
    init(fileTransformData: [FileTransformModel], baseURL: URL) {
        self.fileTransformData = fileTransformData
        self.baseURL = baseURL
    }
    
    static func generateFileTransformData(from files: [URL], baseURL: URL) -> [FileTransformModel] {
        if !files.isEmpty {
            let prevFileTransforms: [FileTransformModel]? = Self.transformationFileExists(for: baseURL) ? Self.getTransformationLog(for: baseURL) : nil
            
            let files = files.map { file in
                let id = UUID().uuidString
                let prevNameFromPrevTransformsLog = prevFileTransforms?.first(where: { $0.url == file })
                let isComplete = (prevNameFromPrevTransformsLog != nil) ? prevNameFromPrevTransformsLog!.isComplete : false
                let fileName = prevNameFromPrevTransformsLog?.prevName ?? file.lastPathComponent
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
                return FileTransformModel(id: id, url: file, newName: newName, prevName: fileName, isRenamable: isRenamable, isMusicFile: isMusicFile, isBPMDetected: isBPMDetected, isKeyDetected: isKeyDetected, isComplete: isComplete)
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
                    fileTransformData[idx].isComplete = true
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
        
        let prevFileTransforms = Self.getTransformationLog(for: baseURL)
        guard prevFileTransforms != nil else { return  }
        
        for idx in 0..<fileTransformData.count {
            let fileTransform = fileTransformData[idx]
            if fileTransform.isRenamable == false { continue }
            do {
                let newURL = try renameFile(at: fileTransform.url, to: fileTransform.prevName)
                
                var fileNameWithUpdatedKey: String?
                if fileTransform.isMusicFile {
                    let keyResult = BPMAndKeyExtractor.extractKey(from: fileTransform.prevName)
                    if let keyResult = keyResult {
                        fileNameWithUpdatedKey = "\(keyResult.key)_\(keyResult.updatedFile)"
                    }
                }
                
                var fileNameWithUpdatedBPM: String?
                if fileTransform.isMusicFile {
                    let bpmResult = BPMAndKeyExtractor.extractBPM(from: fileNameWithUpdatedKey ?? fileTransform.prevName)
                    if let bpmResult = bpmResult {
                        fileNameWithUpdatedBPM = "\(bpmResult.bpm)_\(bpmResult.updatedFile)"
                    }
                }
                
                let newName = fileNameWithUpdatedBPM ?? fileNameWithUpdatedKey
                fileTransformData[idx].newName = newName
                fileTransformData[idx].url = newURL
                fileTransformData[idx].isComplete = false
            } catch {
                errorMessage = "Error renaming files: \(error.localizedDescription)"
            }
        }
        Self.clearTransformationLog(for: baseURL)
        isProcessing = false
    }
    
    static private func getTransformationLog(for baseURL: URL) -> [FileTransformModel]? {
        do {
            let json = try getOrCreatePathForTransformationsFile(for: baseURL)
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
    
    static private func clearTransformationLog(for baseURL: URL) {
        try? FileManager.default.removeItem(at: getOrCreatePathForTransformationsFile(for: baseURL))
    }
    
    private func renameFile(at originalURL: URL, to newName: String) throws -> URL {
        let newURL = originalURL.deletingLastPathComponent()
            .appendingPathComponent(newName)
        
        try fileManager.moveItem(at: originalURL, to: newURL)
        print("Successfully Renamed \(originalURL.lastPathComponent) to \(newName)!")
        return newURL
    }
}




extension String {
    func sha256() -> String {
        let inputData = Data(self.utf8)
        let hashed = SHA256.hash(data: inputData)
        // Convert hash to hex string
        return hashed.compactMap { String(format: "%02x", $0) }.joined()
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
            let fileTransformationsURL = try Self.getOrCreatePathForTransformationsFile(for: baseURL)
            try data.write(to: fileTransformationsURL)
        } catch {
            print("Error saving data to disk: \(error)")
        }
    }
    
    static private func getOrCreatePathForTransformationsFile(for baseURL: URL) throws -> URL {
        let path = getPathForTransformationsFileDirectory(for: baseURL)
        if let path = path {
            do {
                try FileManager().createDirectory(at: path, withIntermediateDirectories: true)
            } catch {
                fatalError( "Couldn't create application support directory")
            }
            let fileTransformationsURL = path.appendingPathComponent("transformations.json")
            return fileTransformationsURL
        } else {
            fatalError("Couldn't find application support directory")
        }
    }

    static private func getPathForTransformationsFileDirectory(for baseURL: URL) -> URL? {
          if let appSupportURL = FileManager().urls(for: .applicationSupportDirectory, in: .userDomainMask).first {
            let hashValue = baseURL.absoluteString.sha256()
            let appDirectory = appSupportURL.appendingPathComponent("SampleWrangler/\(hashValue)")
            return appDirectory
        } else {
            print("Couldn't find application support directory")
            return nil
        }
    }
    
    static private func getPathForTransformationsFile(for baseURL: URL) -> URL? {
        let path = getPathForTransformationsFileDirectory(for: baseURL)
        if let path = path {
            return path.appendingPathComponent("transformations.json")
        } else {
            return nil
        }
    }

    static func transformationFileExists(for baseURL: URL) -> Bool {
        let path = getPathForTransformationsFile(for: baseURL)
        if let path = path {
            return FileManager().fileExists(atPath: path.path)
        }
        return false
    }


    var transformationsFileExists: Bool {
        let path = Self.getPathForTransformationsFile(for: baseURL)
        if let path = path {
            return FileManager().fileExists(atPath: path.path)
        }
        return false
    }
}
