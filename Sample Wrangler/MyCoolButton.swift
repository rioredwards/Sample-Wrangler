//
//  NiceButton.swift
//  Sample Wrangler
//
//  Created by Rio Edwards on 3/26/25.
//

import SwiftUI

enum ButtonSize {
    case small
    case medium
    case large
}  

struct MyCoolButton: ButtonStyle {
    var size: ButtonSize = .medium

    func makeBody(configuration: Configuration) -> some View {
        HoverView {
            configuration.label
                .padding(.horizontal, size == .small ? 16 : size == .medium ? 24 : 32)
                .padding(.vertical, size == .small ? 8 : size == .medium ? 12 : 16)
                .focusable(false)
                .background(Color($0 ? "MyPrimaryColorHover" : "MyPrimaryColor"))
                .clipShape(Capsule())
        }
    }
}


// Preview
#if DEBUG
struct MyCoolButton_Previews: PreviewProvider {
    static var previews: some View {
        VStack{
            Button("Press Me") {
                print("Button pressed")
            }.buttonStyle(MyCoolButton())
        }.padding(20)
    }
}
#endif
