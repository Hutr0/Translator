//
//  AttributedString.swift
//  Translator
//
//  Created by Леонид Лукашевич on 27.12.2021.
//

import Cocoa

struct AttributedString {
    static func getAttributedStringForLexicalAnalyzer(program: String, symbol: Character, place: Int) -> (NSRange?, NSMutableAttributedString?) {
        let attributedString = NSMutableAttributedString(string:program)
        let stringOneRegex: NSRegularExpression?
        var cursorPosition: NSRange!
        
        if symbol.isNumber {
            stringOneRegex = try? NSRegularExpression(pattern: "\(symbol)", options: [])
        } else {
            stringOneRegex = try? NSRegularExpression(pattern: "\\\(symbol)", options: [])
        }
        
        guard let stringOneRegex = stringOneRegex else { return (nil, nil) }

        let stringOneMatches = stringOneRegex.matches(in: program, options: [], range: NSMakeRange(0, attributedString.length))
        for stringOneMatch in stringOneMatches {
            let wordRange = stringOneMatch.range(at: 0)
            if wordRange.location == place {
                cursorPosition = wordRange
                attributedString.addAttribute(.foregroundColor, value: NSColor.red, range: wordRange)
            }
        }
        
        return (cursorPosition, attributedString)
    }
    
    static func getAttributedStringForParser(program: String, token: String, place: Int) -> (NSRange?, NSMutableAttributedString?) {
        let attributedString = NSMutableAttributedString(string:program)
        var cursorPosition: NSRange!
        
        guard let programPlace = self.tokenize(inputProgram: program, place: place) else { return (nil, nil) }
            
        let stringOneRegex: NSRegularExpression?
        if StringChecker.isNumber(string: token) || StringChecker.isWord(string: token) {
            stringOneRegex = try? NSRegularExpression(pattern: "\(token)", options: [])
        } else {
            stringOneRegex = try? NSRegularExpression(pattern: "\\\(token)", options: [])
        }
        
        guard let stringOneRegex = stringOneRegex else { return (nil, nil) }
        
        let stringOneMatches = stringOneRegex.matches(in: program, options: [], range: NSMakeRange(0, attributedString.length))
        for stringOneMatch in stringOneMatches {
            let wordRange = stringOneMatch.range(at: 0)
            if wordRange.location == programPlace - wordRange.length {
                cursorPosition = wordRange
                attributedString.addAttribute(.foregroundColor, value: NSColor.red, range: wordRange)
            }
        }
        
        return (cursorPosition, attributedString)
    }
    
    private static func tokenize(inputProgram: String, place: Int) -> Int? {
        var tokenNumber = 0
        var temp = false
        
        for (i, char) in inputProgram.enumerated() {
            guard let symbolClass = Symbol.getSymbolClass(symbol: char) else { return nil }
            
            if symbolClass == .separator {
                if temp {
                    tokenNumber += 1
                    temp = false
                    
                    if tokenNumber == place + 1 {
                        return i
                    }
                }
                continue
            }
            
            if symbolClass == .modifier {
                if temp {
                    tokenNumber += 1
                    temp = false
                    
                    if tokenNumber == place + 1 {
                        return i
                    }
                }
                
                tokenNumber += 1
                
                if tokenNumber == place + 1 {
                    return i + 1
                }
                
                continue
            }
            
            temp = true
        }
        
        tokenNumber += 1
        
        if tokenNumber == place + 1 {
            return inputProgram.count
        }
        
        return nil
    }
}
