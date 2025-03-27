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
        
        Button(action: selectFolder) {
            HStack {
                Text("Select Folder")
                .font(.system(size: 16, weight: .bold))
                // Large text
                Image(systemName: "folder.fill.badge.plus")
                .font(.system(size: 18, weight: .bold))
            }
            .frame(minWidth: 150)
        }
        .buttonStyle(MyCoolButton())
    }
    
    private func selectFolder() {
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
