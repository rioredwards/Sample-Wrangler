//
//  FileList.swift
//  Sample Wrangler
//
//  Created by Rio Edwards on 3/23/25.
//

import SwiftUI

struct FileListView: View {
    let fileObjArr: [FileModel]
    @State private var selection: FileModel.ID?
    
    init(_ fileObjArr: [FileModel]) {
        self.fileObjArr = fileObjArr
    }
    
    var body: some View {
        if !fileObjArr.isEmpty {
            Table(fileObjArr, selection: $selection) {
                TableColumn("Current Name") { file in
                    Text(file.originalName)
                        .help(file.originalName)
                }
                .width(min: 200)
                TableColumn("") { file in
                    Image(systemName: "arrow.right")
                }
                .width(16)
                TableColumn("New Name") { file in
                    Text(file.newName)
                        .help(file.newName)
                }
                .width(min: 200)
            }
        }
    }
}

struct FileListView_Previews: PreviewProvider {
    static var previews: some View {
        // Sample data for preview; adjust as needed for your FileObj model
        let sampleFiles = [
            FileModel(url: URL("url")!, originalName: "Document1.pdf", newName: "Document1_Renamed.pdf"),
            FileModel(url: URL("url")!, originalName: "Image1.png", newName: "Image1_Renamed.png")
        ]
        return FileListView(sampleFiles)
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
