//
//  FileModel.swift
//  Sample Wrangler
//
//  Created by Rio Edwards on 3/24/25.
//

import Foundation
import SwiftUI

struct FileModel: Identifiable, Codable {
    let id: String
    let url: URL
    let originalName: String
    let newName: String
}
