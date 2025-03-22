//
//  FileReader.swift
//  Sample Wrangler
//
//  Created by Rio Edwards on 3/22/25.
//

import Foundation
import SwiftUI

struct FileReader: View {
    let baseFolder: URL
    let fileManager = FileManager.default
    
    init(_ baseFolder: URL) {
        self.baseFolder = baseFolder
    }
    
    // Computed property that recalculates file paths on every render.
    var filePaths: [String] {
        (try? fileManager.contentsOfDirectory(at: baseFolder, includingPropertiesForKeys: nil)
            .map { $0.lastPathComponent }) ?? []
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
}
