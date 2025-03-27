//
//  FolderView.swift
//  Sample Wrangler
//
//  Created by Rio Edwards on 3/27/25.
//

import SwiftUI

struct FolderView: View {
    @Binding var baseFolder: URL?
    
    var body: some View {
        if let baseFolder = baseFolder {
         HStack(alignment: .center) {
                Text("Selected folder: ")
                    .font(.system(size: 14))
                    .foregroundColor(.white)
                Text(baseFolder.lastPathComponent)
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.white.opacity(0.9))
 
             Button(action: {
                 NSWorkspace.shared.selectFile(nil, inFileViewerRootedAtPath: baseFolder.path)
             }) {
                 HStack {
                     Text("Reveal in Finder")
                         .font(.system(size:12, weight: .bold))
                     // Large text
                     Image(systemName: "arrowshape.turn.up.backward.fill")
                     .font(.system(size: 12, weight: .bold))
                 }
                 .frame(minWidth: 150)
             }
             .buttonStyle(MyCoolButton(size: .small))
             .focusable(false)
             
                FolderPickerButton(baseFolder: $baseFolder, buttonType: .changeFolder)
            }
        .padding(.top, 60)
        .frame(maxWidth: .infinity, alignment: .center)
        FileView(baseFolder)
        } else {
            Text("Something went wrong")
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(.white.opacity(0.9))
        }
    }
}

#Preview {
    FolderView(baseFolder: .constant(URL(string: "https://www.google.com")!))
}
