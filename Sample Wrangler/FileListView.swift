//
//  FileList.swift
//  Sample Wrangler
//
//  Created by Rio Edwards on 3/23/25.
//

import SwiftUI

extension FileTransformModel {
    var sortOrder: Int {
        if self.isBPMDetected && self.isKeyDetected {
            return 0
        }
        if self.isBPMDetected {
            return 1
        }
        if self.isKeyDetected {
            return 2
        }
        return 3
    }
    
    var color: Color {
        switch self.sortOrder {
        case 0:
            return FileColors.green.color
        case 1:
            return FileColors.yellow.color
        case 2:
            return FileColors.orange.color
        default:
            return FileColors.red.color
        }
    }
}

extension Color {
    static let fileGreen = Color(red: 0.2, green: 0.41, blue: 0.17)
    static let fileYellow = Color(red: 0.7, green: 0.57, blue: 0.16)
    static let fileOrange: Color = .init(red: 0.95, green: 0.4, blue: 0.1)
    static let fileRed = Color(red: 1.0, green: 0.0, blue: 0.0)
}

enum FileColors {
    case green,  yellow, orange, red
    
    var color: Color {
        switch self {
        case .green:
            return Color.fileGreen
        case .yellow:
            return Color.fileYellow
        case .orange:
            return Color.fileOrange
        case .red:
            return Color.fileRed
        }
    }
}

struct FileListView: View {
    let fileTransformArr: [FileTransformModel]
    
    init(_ fileTransformArr: [FileTransformModel]) {
        self.fileTransformArr = fileTransformArr
    }
    
    var body: some View {
        if !fileTransformArr.isEmpty {
            let sorted = Array(fileTransformArr).sorted { $0.sortOrder < $1.sortOrder }
            
            ScrollView {
                LazyVStack(spacing: 2) {
                    ForEach(sorted) { fileTransform in
                        FileTransformListItem(id: fileTransform.id, prevName: fileTransform.prevName, newName: fileTransform.newName, color: fileTransform.color, isComplete: fileTransform.isComplete)
                    }
                    .padding(.horizontal)
                }
            }.padding(12)
        }
    }
}


// Mock data

// Incorrect argument labels in call (have 'id:prevName:newName:url:isRenamable:isMusicFile:isBPMDetected:isKeyDetected:', expected 'id:url:newName:prevName:isRenamable:isMusicFile:isBPMDetected:isKeyDetected:')
let mockFileTransformArr = [
    FileTransformModel(id: "1", url: URL(string: "test.mp3")!, newName: "test.wav", prevName: "test.mp3", isRenamable: true, isMusicFile: true, isBPMDetected: true, isKeyDetected: true),
    FileTransformModel(id: "2", url: URL(string: "test.wav")!, newName: "test.mp3", prevName: "test.wav", isRenamable: true, isMusicFile: true, isBPMDetected: true, isKeyDetected: true),
    FileTransformModel(id: "3", url: URL(string: "test.mp3")!, newName: "test.wav", prevName: "test.mp3", isRenamable: true, isMusicFile: true, isBPMDetected: true, isKeyDetected: true),
    // No BPM or Key
    FileTransformModel(id: "4", url: URL(string: "test.mp3")!, newName: "test.wav", prevName: "test.mp3", isRenamable: true, isMusicFile: true, isBPMDetected: false, isKeyDetected: false),
    FileTransformModel(id: "5", url: URL(string: "test.mp3")!, newName: "test.wav", prevName: "test.mp3", isRenamable: true, isMusicFile: true, isBPMDetected: false, isKeyDetected: false),
    // No BPM
    FileTransformModel(id: "6", url: URL(string: "test.mp3")!, newName: "test.wav", prevName: "test.mp3", isRenamable: true, isMusicFile: true, isBPMDetected: false, isKeyDetected: true),
    FileTransformModel(id: "7", url: URL(string: "test.mp3")!, newName: "test.wav", prevName: "test.mp3", isRenamable: true, isMusicFile: true, isBPMDetected: false, isKeyDetected: true),
    // No Key
    FileTransformModel(id: "8", url: URL(string: "test.mp3")!, newName: "test.wav", prevName: "test.mp3", isRenamable: true, isMusicFile: true, isBPMDetected: true, isKeyDetected: false),
    FileTransformModel(id: "9", url: URL(string: "test.mp3")!, newName: "test.wav", prevName: "test.mp3", isRenamable: true, isMusicFile: true, isBPMDetected: true, isKeyDetected: false),
]

// Preview
struct FileListView_Previews: PreviewProvider {
    static var previews: some View {
        FileListView(mockFileTransformArr)
    }
}
