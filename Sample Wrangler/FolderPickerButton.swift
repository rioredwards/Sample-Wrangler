//
//  FolderPickerButton.swift
//  Sample Wrangler
//
//  Created by Rio Edwards on 3/22/25.
//


import SwiftUI
import AppKit

struct FolderPickerButton: View {
    @Binding var folderURL: URL?
    
    var body: some View {
        VStack {
            Button("Select Folder") {
                let panel = NSOpenPanel()
                panel.canChooseDirectories = true
                panel.canChooseFiles = false
                panel.allowsMultipleSelection = false
                panel.prompt = "Choose Folder"
                panel.begin { response in
                    if response == .OK {
                        // Update binding on the main thread
                        DispatchQueue.main.async {
                            folderURL = panel.url
                        }
                        print("Selected folder: \(panel.url?.path ?? "")")
                    }
                }
            }
            if let folderURL = folderURL {
                Text("Selected folder: \(folderURL.path)")
                    .padding(.top)
            }
        }
        .padding()
    }
}

//struct FolderPickerButton_Previews: PreviewProvider {
//    static var previews: some View {
//        FolderPickerButton()
//    }
//}
