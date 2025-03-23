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
    var filePaths: [String] {
        returnFilePathsDeepSearch(at: baseFolder.path)
    }
    
    var body: some View {
        VStack {
            if !filePaths.isEmpty {
                List(filePaths, id: \.self) { file in
                    Text(file)
                }
            }
        }
    }
    
    func fileIsAudio(at fileURL: URL) -> Bool {
        if let typeIdentifier = try? fileURL.resourceValues(forKeys: [.contentTypeKey]).contentType, typeIdentifier.conforms(to: .audio) {
            return true
        }
        return false
    }
    
    func returnFilePathsDeepSearch(at baseFolderPath: String) -> [String] {
        let dirEnum = fileManager.enumerator(atPath: baseFolderPath)
        var audioFilePaths: [String] = []
        
        while let file = dirEnum?.nextObject() as? String {
            // Filter out non-audio files
            let fullPath = baseFolderPath.appending("/\(file)")
            let fileURL = URL(fileURLWithPath: fullPath)
            if fileIsAudio(at: fileURL) {
                audioFilePaths.append(fullPath)
            }
        }
        return audioFilePaths
    }
}
