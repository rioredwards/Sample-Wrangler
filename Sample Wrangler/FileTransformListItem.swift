//
//  FileTransformListItem.swift
//  Sample Wrangler
//
//  Created by Rio Edwards on 3/26/25.
//

import SwiftUI

struct FileTransformListItem: Identifiable, View {
    var id: String
    var prevName: String
    var newName: String?
    var color: Color
    var isComplete: Bool
    
    var body: some View {
        HStack {
            Text(prevName)
                .help(prevName)
                .frame( maxWidth: 400, alignment: .leading)
            Image(systemName: "arrow.right")
            Text(newName ?? "(No Change)")
                .help(newName ?? "(No Change)")
                .frame(alignment: .leading)
        }
        .lineLimit(1)
        .truncationMode(.tail)
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            !isComplete ? (color).opacity(0.15) : Color.blue.opacity(0.15)
        )
        .clipShape(Capsule())
    }
}
