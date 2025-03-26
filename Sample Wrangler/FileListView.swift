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
    static let fileGreen = Color(red: 0.0, green: 0.8, blue: 0.0)
    static let fileYellow = Color(red: 1.0, green: 0.8, blue: 0.0)
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
    @State private var selection: FileTransformModel.ID?
    
    init(_ fileTransformArr: [FileTransformModel]) {
        self.fileTransformArr = fileTransformArr
    }
    
    var body: some View {
        if !fileTransformArr.isEmpty {
            let sorted = Array(fileTransformArr).sorted { $0.sortOrder < $1.sortOrder }
            
            ScrollView {
                LazyVStack(spacing: 4) {
                    ForEach(sorted) { fileTransform in
                        HStack {
                            Text(fileTransform.prevName)
                                .help(fileTransform.prevName)
                                .frame( maxWidth: 400, alignment: .leading)
                            Image(systemName: "arrow.right")
                            Text(fileTransform.newName ?? "")
                                .help(fileTransform.newName ?? "")
                                .frame(alignment: .leading)
                        }
                        .lineLimit(1)
                        .truncationMode(.tail)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(
                            (fileTransform.color).opacity(0.15)
                        )
                        .clipShape(Capsule())
                    }
                }
                .padding(.horizontal)
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
