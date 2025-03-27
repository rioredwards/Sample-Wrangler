//
//  TransformationModel.swift
//  Sample Wrangler
//
//  Created by Rio Edwards on 3/24/25.
//

import SwiftUI

struct FileTransformModel: Codable, Identifiable {
    let id: String
    var url: URL
    let newName: String?
    let prevName: String
    
    let isRenamable: Bool
    var isComplete: Bool
    let isMusicFile: Bool
    let isBPMDetected: Bool
    let isKeyDetected: Bool
    
    init(id: String, url: URL, newName: String?, prevName: String, isRenamable: Bool, isMusicFile: Bool, isBPMDetected: Bool, isKeyDetected: Bool) {
        self.id = id
        self.url = url
        self.newName = newName
        self.prevName = prevName
        self.isRenamable = isRenamable
        self.isComplete = false
        self.isMusicFile = isMusicFile
        self.isBPMDetected = isBPMDetected
        self.isKeyDetected = isKeyDetected
    }
    
    static func mock(id: Int = 0) -> FileTransformModel {
        return FileTransformModel(id: UUID().uuidString, url: URL(filePath: "file:///Users/fakeUser/fakeDirectory/file\(id).mp3"),newName: "file\(id).mp3", prevName: "file\(id).mp3", isRenamable: true, isMusicFile: true, isBPMDetected: true, isKeyDetected: true)
    }
}
