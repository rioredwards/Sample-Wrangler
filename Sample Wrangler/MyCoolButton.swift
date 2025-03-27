//
//  NiceButton.swift
//  Sample Wrangler
//
//  Created by Rio Edwards on 3/26/25.
//

import SwiftUI

struct MyCoolButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        HoverView {
            configuration.label
                .padding(.horizontal, 32)
                .padding(.vertical, 12)
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
