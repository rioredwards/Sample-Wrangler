//
//  FileList.swift
//  Sample Wrangler
//
//  Created by Rio Edwards on 3/23/25.
//

import SwiftUI

extension FileTransformModel {
    var sortOrder: Int {
        var order = 0
        if self.isMusicFile {
            order += 1
        }
        if self.isBPMDetected {
            order += 1
        }
        if self.isKeyDetected {
            order += 1
        }
        if self.isRenamable {
            order += 1
        }
        return order
    }
}

struct FileListView: View {
    let fileTransformArr: [FileTransformModel]
    @State private var selection: FileTransformModel.ID?
    
    init(_ fileTransformArr: [FileTransformModel]) {
        self.fileTransformArr = fileTransformArr
    }
    
    @State private var sortOrder = [KeyPathComparator(\FileTransformModel.sortOrder)]
    
    var body: some View {
        if !fileTransformArr.isEmpty {
            Table(fileTransformArr, selection: $selection,sortOrder: $sortOrder) {
                TableColumn("Current Name") { (fileTransform: FileTransformModel) in
                    Text(fileTransform.prevName)
                        .help(fileTransform.prevName)
                }
                .width(min: 200)
                TableColumn("") { file in
                    Image(systemName: "arrow.right")
                }
                .width(16)
                TableColumn("New Name") { (fileTransform: FileTransformModel) in
                    Text(fileTransform.newName ?? "")
                        .help(fileTransform.newName ?? "")
                }
                .width(min: 200)
            }
        }
    }
}

let mockArray: [FileTransformModel] = [
    FileTransformModel.mock(id: 1),
    FileTransformModel.mock(id: 2),
    FileTransformModel.mock(id: 3)
]

struct FileListView_Previews: PreviewProvider {
    static var previews: some View {
        // Sample data for preview; adjust as needed for your FileObj model
        return FileListView(mockArray)
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
