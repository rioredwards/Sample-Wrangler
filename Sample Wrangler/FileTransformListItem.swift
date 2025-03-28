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
                .font(.system(size: 12, weight: .semibold))
                .help(prevName)
                .frame( width: 500, alignment: .leading)
            Image(systemName: isComplete ? "arrow.left" : "arrow.right")
                .font(.system(size: 12, weight: .semibold))
            Text(newName ?? "(No Change)")
                .font(.system(size: 12, weight: .semibold))
                .help(newName ?? "(No Change)")
                .frame(alignment: .leading)
        }
        .lineLimit(1)
        .truncationMode(.tail)
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            !isComplete ? (color).opacity(0.5) : Color.blue.opacity(0.5)
        )
        .clipShape(Capsule())
    }
}




// Preview
struct FileTransformListItem_Previews: PreviewProvider {
    static var previews: some View {
        FileTransformListItem(id: "1", prevName: "test.mp3", newName: "test.wav", color: .blue, isComplete: true)
    }
}
