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
                        .font(.system(size: 12))
                        .foregroundColor(.white)
                    Text(baseFolder.lastPathComponent)
                        .font(.system(size: 12, weight: .bold))
                            .foregroundColor(.mySecondary) // for example, blue to highlight it
                    FolderPickerButton(baseFolder: $viewModel.baseFolder, buttonType: .changeFolder)
                }
                .padding(.top, 60)
                .frame(maxWidth: .infinity, alignment: .center)
                FileView(baseFolder)
                
            } else {
                Spacer()
                FolderPickerButton(baseFolder: $viewModel.baseFolder, buttonType: .selectFolder)
                Spacer()
            }
        }
        .padding(20)
        //        Add background image
        .frame(width: 1200, height: 700, alignment: .center )
        .background(Image("bg")
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
