//
//  FolderPickerButton.swift
//  Sample Wrangler
//
//  Created by Rio Edwards on 3/22/25.
//


import SwiftUI
import AppKit

struct FolderPickerButton: View {
    @Binding var baseFolder: URL?
    
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
                            baseFolder = panel.url
                        }
                        print("Selected folder: \(panel.url?.path ?? "")")
                    }
                }
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
