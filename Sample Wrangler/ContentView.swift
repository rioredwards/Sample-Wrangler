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
    @Published var audioPlayer = AudioPlayerService()
    
    func selectFolder(url: URL) {
        baseFolder = url
    }
    
    func reset() {
        baseFolder = nil
        audioPlayer = AudioPlayerService()
    }
}

struct ContentView: View {
    @StateObject private var viewModel = AppViewModel()
    @State var isPlaying = false
    
    var body: some View {
        VStack {
            if let baseFolder = viewModel.baseFolder {
                FolderView(baseFolder: $viewModel.baseFolder)
                    .id(baseFolder)
            } else {
                WelcomeView(baseFolder: $viewModel.baseFolder)
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
        .overlay(alignment: .topTrailing) {
            Button(action: {
                viewModel.audioPlayer.togglePlayback()
                isPlaying.toggle()
            }) {
                Image(systemName: isPlaying ? "speaker.wave.3.fill" : "speaker.slash.fill")
                    .font(.system(size: 24))
                    .foregroundColor(.white)
                    .padding(12)
                    .background(Color.black.opacity(0.4))
                    .clipShape(Circle())
            }
            .buttonStyle(.plain)
            .focusable(false)
            .padding(20)
        }
        .onAppear {
            viewModel.audioPlayer.play()
            isPlaying = true
        }
    }
}

#Preview {
    ContentView()
}
