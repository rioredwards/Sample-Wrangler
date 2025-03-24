//
//  FileModel.swift
//  Sample Wrangler
//
//  Created by Rio Edwards on 3/24/25.
//

import Foundation
import SwiftUI

struct FileModel: Identifiable {
    let id = UUID()
    let url: URL
    let originalName: String
    let newName: String
}
