//
//  FileReader.swift
//  Sample Wrangler
//
//  Created by Rio Edwards on 3/22/25.
//

import Foundation
import SwiftUI

struct FileReader: View {
    let fileManager = FileManager.default
    let baseFolder: URL
    
    init(_ baseFolder: URL) {
        self.baseFolder = baseFolder
    }
    
    // Computed property that recalculates file paths on every render.
    var filePaths: [URL] {
        returnFilePathsDeepSearch(at: baseFolder.path)
    }
    
    var body: some View {
        VStack {
            if !filePaths.isEmpty {
                List(filePaths, id: \.self) { file in
                    Text(file.lastPathComponent)
                }
            }
        }.onAppear() {
            if !filePaths.isEmpty {
                for filePath in filePaths {
                    do {
                        let newName = "frog-\(UUID().uuidString).\(filePath.pathExtension)"
                        try renameFile(at: filePath, to: newName)
                    } catch {
                        print("Rename failed for \(filePath.lastPathComponent): \(error.localizedDescription)")
                    }
                }
            }
        }
    }
    
    func renameFile(at originalURL: URL, to newName: String) throws {
        let newURL = originalURL.deletingLastPathComponent()
            .appendingPathComponent(newName)
        
        do {
            try fileManager.moveItem(at: originalURL, to: newURL)
            print("Successfully Renamed \(originalURL.lastPathComponent) to \(newName)!")
        } catch {
            print("Failed to rename: \(error.localizedDescription)")
        }
    }
    
    func fileIsAudio(at fileURL: URL) -> Bool {
        if let typeIdentifier = try? fileURL.resourceValues(forKeys: [.contentTypeKey]).contentType, typeIdentifier.conforms(to: .audio) {
            return true
        }
        return false
    }
    
    func returnFilePathsDeepSearch(at baseFolderPath: String) -> [URL] {
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
