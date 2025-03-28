//
//  WelcomeView.swift
//  Sample Wrangler
//
//  Created by Rio Edwards on 3/27/25.
//

import SwiftUI

struct WelcomeView: View {
    @Binding var baseFolder: URL?
    @State private var showingHelpOverlay = false

    var body: some View {
         Spacer()
                VStack(spacing: 24) {
                    ZStack {
                        HStack {
                            Spacer()
                            Button(action: {
                                showingHelpOverlay = true
                            }) {
                                Image(systemName: "questionmark.circle.fill")
                                    .font(.system(size: 22))
                            }
                            .buttonStyle(PlainButtonStyle())
                            .foregroundColor(.white)
                            .padding(.trailing, 20)
                            .focusable(false)
                        }
                        .position(x: 420, y: -10)
                    }
                    .frame(height: 0)
                    
                    Text("Howdy, Partner")
                        .font(.system(size: 36, weight: .bold))
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.5), radius: 2, x: 0, y: 2)
                    
                    Text(
                         """
Welcome to Sample Wrangler — the fastest way this side o' the Mississippi to get your audio files in line. Just drop a folder of unruly samples into the corral, and we'll rustle up their names nice and tidy. Key, BPM, the whole shebang — right up front where it belongs. Take a peek at the preview, and when you're ready, give the word. We'll do the fixin', you do the mixin'!
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
                
                FolderPickerButton(baseFolder: $baseFolder, buttonType: .selectFolder)
                Spacer()
        .sheet(isPresented: $showingHelpOverlay) {
            HelpOverlayView()
                .background(Color(red: 0.42, green: 0.22, blue: 0.13))
                .cornerRadius(16)
        }
    }
}

struct HelpOverlayView: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack(spacing: 20) {
            Text("About Sample Wrangler")
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(.white)
            
            VStack(alignment: .leading, spacing: 15) {
                infoSection(title: "What does it do?", 
                           content: "Sample Wrangler automatically detects BPM and musical key information in your audio filenames and reorganizes them so this information appears at the beginning of the filename, making your samples easier to browse and organize.")
                
                infoSection(title: "How to use:", 
                           content: "1. Select a folder containing audio files\n2. Preview the changes\n3. Click 'Rename Files' to apply the changes\n4. Use the 'Revert' button to undo changes if needed")
                
                infoSection(title: "Background Music:", 
                           content: "\"Ketamine Cowboy\" by Swayed Ways X Murkury")
                
                infoSection(title: "Version:", 
                           content: "Sample Wrangler v1.0")
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                .fill(Color.black.opacity(0.3))
            )
            
            Button("Close") {
                presentationMode.wrappedValue.dismiss()
            }
            .buttonStyle(MyCoolButton())
            .padding(.top)
            .focusable(false)
        }
        .padding(40)
        .frame(width: 600, height: 600)
        .background(
            Color.clear
        )
    }
    
    private func infoSection(title: String, content: String) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.white)
            
            Text(content)
                .font(.system(size: 16))
                .foregroundColor(.white.opacity(0.9))
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(.bottom, 5)
    }
}


#Preview {
    WelcomeView(baseFolder: .constant(nil))
}
