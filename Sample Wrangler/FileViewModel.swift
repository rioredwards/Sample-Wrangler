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
    var baseFolder: URL
    private let fileManager = FileManager.default
    @Published var files: [URL] = []
    @Published var isProcessing: Bool = false
    
    init(_ baseFolder: URL) {
        self.baseFolder = baseFolder
        loadFiles()
    }
    
    func loadFiles() {
        isProcessing = true
        files = returnFilePathsDeepSearch(at: baseFolder.path)
        isProcessing = false
    }
    
    private func returnFilePathsDeepSearch(at baseFolderPath: String) -> [URL] {
        let dirEnum = fileManager.enumerator(atPath: baseFolderPath)
        var filePaths: [URL] = []
        
        while let file = dirEnum?.nextObject() as? String {
            let fullPath = baseFolderPath.appending("/\(file)")
            let fileURL = URL(fileURLWithPath: fullPath)
            filePaths.append(fileURL)
        }
        
        return filePaths
    }
}
