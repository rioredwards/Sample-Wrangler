//
//  HoverView.swift
//  Sample Wrangler
//
//  Created by Rio Edwards on 3/27/25.
//

import SwiftUI

// Add this helper view to handle hover state
struct HoverView<Content: View>: View {
    let content: (Bool) -> Content
    @State private var isHovering = false
    
    init(@ViewBuilder content: @escaping (Bool) -> Content) {
        self.content = content
    }
    
    var body: some View {
        content(isHovering)
            .onHover { hovering in
                isHovering = hovering
            }
    }
}
