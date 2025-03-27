//
//  NiceButton.swift
//  Sample Wrangler
//
//  Created by Rio Edwards on 3/26/25.
//

import SwiftUI

struct MyDestructiveButton: ButtonStyle {
    @State private var isHovering = false
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.horizontal, 32)
            .padding(.vertical, 12)
            .focusable(false)
            .background(Color(isHovering ? "MyDestructiveColorHover": "MyDestructiveColor"))
            .clipShape(Capsule())
            .onHover { hovering in
                if hovering {
                    isHovering = true
                } else {
                    isHovering = false
                }
            }
    }
}

// Preview
#if DEBUG
struct MyDestructiveButton_Preview: PreviewProvider {
    static var previews: some View {
        VStack{
            Button("Press Me") {
                print("Button pressed")
            }.buttonStyle(MyDestructiveButton())
        }.padding(20)
    }
}
#endif
