//
//  FileList.swift
//  Sample Wrangler
//
//  Created by Rio Edwards on 3/23/25.
//

import SwiftUI

struct FileListView: View {
    let fileObjArr: [FileObj]
    
    init(_ fileObjArr: [FileObj]) {
        self.fileObjArr = fileObjArr
    }
    
    var body: some View {
        if !fileObjArr.isEmpty {
            List(fileObjArr.indices, id: \.self) { idx in
                let originalName = fileObjArr[idx].originalName
                let newName = fileObjArr[idx].newName
                
                HStack {
                     Text("Original: \(originalName)")
                     Text("New: \(newName)")
                 }
            }
        }
    }
}
