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
    
    static func getAttributedStringForParser(program: String, token: String, place: Int) -> NSMutableAttributedString? {
        let attributedString = NSMutableAttributedString(string:program)
        
        guard var programPlace = self.tokenize(inputProgram: program, place: place) else { return nil }
        
        /// При числе в центре строки нужно -1
        /// При числе в конце строки и пробеле после него нужно -1
        ///
            
        let stringOneRegex: NSRegularExpression?
        if StringChecker.isNumber(string: token) || StringChecker.isWord(string: token) {
            stringOneRegex = try? NSRegularExpression(pattern: "\(token)", options: [])
//            if
        } else {
            stringOneRegex = try? NSRegularExpression(pattern: "\\\(token)", options: [])
        }
        
        guard let stringOneRegex = stringOneRegex else { return nil }
        
        let stringOneMatches = stringOneRegex.matches(in: program, options: [], range: NSMakeRange(0, attributedString.length))
        for stringOneMatch in stringOneMatches {
            let wordRange = stringOneMatch.range(at: 0)
            if wordRange.location == programPlace {
                attributedString.addAttribute(.foregroundColor, value: NSColor.red, range: wordRange)
            }
        }
        
        return attributedString
    }
    
    private static func tokenize(inputProgram: String, place: Int) -> Int? {
        var tokens: [String] = []
        var temp: String = ""
        
        for (i, char) in inputProgram.enumerated() {
            
            print(tokens.count)
            
            let symbolClass = Symbol.getSymbolClass(symbol: char)
            
            guard let symbolClass = symbolClass else { return nil }
            
            if symbolClass == .separator {
                if temp != "" {
                    tokens.append(temp)
                    temp = ""
                    
                    if tokens.count == place + 1 {
                        return i - 1
                    }
                }
                continue
            }
            
            if symbolClass == .modifier {
                if temp != "" {
                    tokens.append(temp)
                    temp = ""
                }
                
                if tokens.count == place + 1 {
                    return i - 1
                }
                
                tokens.append(String(char))
                
                if tokens.count == place + 1 {
                    return i
                }
                
                continue
            }
            
            temp += String(char)
        }
        
        tokens.append(temp)
        
        if tokens.count == place + 1 {
            return inputProgram.count - 1
        }
        
        return nil
    }
}
