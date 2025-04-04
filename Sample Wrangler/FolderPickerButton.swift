//
//  FolderPickerButton.swift
//  Sample Wrangler
//
//  Created by Rio Edwards on 3/22/25.
//


import SwiftUI
import AppKit

enum MyButtonType {
    case selectFolder, changeFolder
}

struct FolderPickerButton: View {
    @Binding var baseFolder: URL?
    var buttonType: MyButtonType = .selectFolder

    var body: some View {
        
        Button(action: selectFolder) {
            HStack {
                Text(buttonType == .changeFolder ? "Change Folder" : "Select Folder")
                    .font(.system(size: buttonType == .changeFolder ? 12 : 16, weight: .bold))
                // Large text
                Image(systemName: "folder.fill.badge.plus")
                .font(.system(size: buttonType == .changeFolder ? 12 : 16, weight: .bold))
            }
            .frame(minWidth: 150)
        }
        .buttonStyle(MyCoolButton(size: buttonType == .selectFolder ? .medium : .small))
        .focusable(false)
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
