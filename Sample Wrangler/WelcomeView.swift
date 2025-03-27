//
//  WelcomeView.swift
//  Sample Wrangler
//
//  Created by Rio Edwards on 3/27/25.
//

import SwiftUI

struct WelcomeView: View {
    @Binding var baseFolder: URL?

    var body: some View {
         Spacer()
                VStack(spacing: 24) {
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
    }
}
