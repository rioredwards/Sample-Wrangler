//
//  BPMTest.swift
//  Sample Wrangler
//
//  Created by Rio Edwards on 3/26/25.
//

import SwiftUI

class BPMExtractor {
    static func run() {
        print("Running BPMTest...")
    }
    
    static func extractBPM(from file: String) -> (bpm: Int, updatedFile: String)? {
        let bpmPattern = "(?i)(?<!\\d)(40|4[1-9]|[5-9]\\d|1\\d\\d|20\\d|210)(?!\\d)[-_ \\t]*bpm"
        let numberPattern = "(?<!\\d)(40|4[1-9]|[5-9]\\d|1\\d\\d|20\\d|210)(?!\\d)"

        let bpmRegex = try? NSRegularExpression(pattern: bpmPattern)
        let numberRegex = try? NSRegularExpression(pattern: numberPattern)

        let range = NSRange(file.startIndex..<file.endIndex, in: file)

        // Try the full BPM pattern first.
        if let match = bpmRegex?.firstMatch(in: file, options: [], range: range),
           let numberRange = Range(match.range(at: 1), in: file),
           let bpm = Int(file[numberRange]),
           let fullMatchRange = Range(match.range, in: file) {
            
            var updatedFile = file
            updatedFile.removeSubrange(fullMatchRange)
            updatedFile = updatedFile.trimmingCharacters(in: .whitespacesAndNewlines)
            return (bpm, updatedFile)
        }

        // Fallback to just the number pattern.
        if let match = numberRegex?.firstMatch(in: file, options: [], range: range),
           let numberRange = Range(match.range(at: 1), in: file),
           let bpm = Int(file[numberRange]),
           let fullMatchRange = Range(match.range, in: file) {
            
            var updatedFile = file
            updatedFile.removeSubrange(fullMatchRange)
            updatedFile = updatedFile.trimmingCharacters(in: .whitespacesAndNewlines)
            return (bpm, updatedFile)
        }

        return nil
    }
}
