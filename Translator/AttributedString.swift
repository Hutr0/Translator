//
//  AttributedString.swift
//  Translator
//
//  Created by Леонид Лукашевич on 27.12.2021.
//

import Cocoa

struct AttributedString {
    static func getAttributedStringForLexicalAnalyzer(program: String, symbol: Character, place: Int) -> NSMutableAttributedString? {
        let attributedString = NSMutableAttributedString(string:program)
        let stringOneRegex: NSRegularExpression?
        
        if symbol.isNumber {
            stringOneRegex = try? NSRegularExpression(pattern: "\(symbol)", options: [])
        } else {
            stringOneRegex = try? NSRegularExpression(pattern: "\\\(symbol)", options: [])
        }
        
        guard let stringOneRegex = stringOneRegex else { return nil }

        let stringOneMatches = stringOneRegex.matches(in: program, options: [], range: NSMakeRange(0, attributedString.length))
        for stringOneMatch in stringOneMatches {
            let wordRange = stringOneMatch.range(at: 0)
            if wordRange.location == place {            
                attributedString.addAttribute(.foregroundColor, value: NSColor.red, range: wordRange)
            }
        }
        
        return attributedString
    }
}
