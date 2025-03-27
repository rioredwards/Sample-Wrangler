//
//  ContentView.swift
//  Sample Wrangler
//
//  Created by Rio Edwards on 3/22/25.
//

import SwiftUI

// Main ViewModel to handle application state
class AppViewModel: ObservableObject {
    @Published var baseFolder: URL? = nil
    
    func selectFolder(url: URL) {
        baseFolder = url
    }
}

struct ContentView: View {
    @StateObject private var viewModel = AppViewModel()
    
    var body: some View {
        VStack {
            if let baseFolder = viewModel.baseFolder {
                HStack(alignment: .center) {
                    Text("Selected folder: ")
                        .font(.system(size: 14))
                        .foregroundColor(.white)
                    Text(baseFolder.lastPathComponent)
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.white.opacity(0.9))
                    FolderPickerButton(baseFolder: $viewModel.baseFolder, buttonType: .changeFolder)
                }
                .padding(.top, 60)
                .frame(maxWidth: .infinity, alignment: .center)
                FileView(baseFolder)
                
            } else {
                Spacer()
                VStack(spacing: 24) {
                    Text("Howdy, Partner")
                        .font(.system(size: 36, weight: .bold))
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.5), radius: 2, x: 0, y: 2)
                    
                    Text(
                         """
Welcome to Sample Wrangler — the fastest way this side o' the Mississippi to get your audio files in line. Just drop a folder of unruly samples into the corral, and we'll rustle up their names nice and tidy. Key, BPM, the whole shebang — right up front where it belongs. Take a peek at the preview, and when you’re ready, give the word. We’ll do the fixin’, you do the mixin’!
"""
                    )
                    .font(.system(size: 18))
                    .foregroundColor(.white.opacity(0.9))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                    .shadow(color: .black.opacity(0.5), radius: 1, x: 0, y: 1)
                    
                    Text("Select a folder to get started")
                        .italic()
                        .font(.system(size: 16))
                        .foregroundColor(.white.opacity(0.8))
                        .padding(.top, 8)
                        .shadow(color: .black.opacity(0.5), radius: 1, x: 0, y: 1)
                }
                .frame(width: 800)
                .padding(.vertical, 40)
                .padding(.horizontal, 20)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.black.opacity(0.4))
                )
                .padding(.bottom, 30)
                
                FolderPickerButton(baseFolder: $viewModel.baseFolder, buttonType: .selectFolder)
                Spacer()
            }
        }
        .padding(20)
        .frame(width: 1200, height: 700, alignment: .center)
        .background(
            Image("bg")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 1200, height: 700)
                .clipped()
        )
    }
}

#Preview {
    ContentView()
}
