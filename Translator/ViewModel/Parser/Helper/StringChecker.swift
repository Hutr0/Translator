//
//  StringChecker.swift
//  Translator
//
//  Created by Леонид Лукашевич on 15.12.2021.
//

import Foundation

struct StringChecker {
    
    /// Get tokens from string of tokens and return it
    /// - Parameter stringTokens: Array of string tokens
    /// - Returns: Array of tokens
    static func getTokens(stringTokens: [String]) -> ([Token]?, Bool, Bool) {
        var startIsSet = false
        var endIsSet = false
        var tokens: [Token] = []
        
        for stringToken in stringTokens {
            let type = getTokenType(stringToken: stringToken)
            
            if type == nil {
                if isNumber(string: stringToken) {
                    tokens.append(Token(type: .number, value: stringToken))
                } else if isWord(string: stringToken) {
                    tokens.append(Token(type: .word, value: stringToken))
                } else if stringToken == "" {
                    continue
                } else {
                    tokens.append(Token(type: .none, value: stringToken))
                }
            } else {
                if type == .startOfProgram && !startIsSet {
                    startIsSet = true
                } else if type == .endOfProgram && !endIsSet {
                    endIsSet = true
                } else if (type == .startOfProgram && startIsSet) || (type == .endOfProgram && endIsSet) { return (nil, true, true) }
                
                tokens.append(Token(type: type, value: stringToken))
            }
        }
        
        return (tokens, startIsSet, endIsSet)
    }
    
    private static func getTokenType(stringToken: String) -> TokenType? {
        switch stringToken {
        case "Begin":
            return .startOfProgram
        case "End":
            return .endOfProgram
        case "First", "Second":
            return .zveno
        case "=":
            return .equal
        case "+", "-", "*", "/", "^":
            return .operation
        case ",":
            return .comma
        case "sin", "cos", "tg", "ctg":
            return .function
        case "\n":
            return .endOfLine
        default:
            return nil
        }
    }

    static func isNumber(string: String) -> Bool {
        return Int(string) != nil
    }

    static func isWord(string: String) -> Bool {
        let pattern = "^([a-zA-Z]){1,}([a-zA-Z0-7])*"

        do {
            let reg = try NSRegularExpression(pattern: pattern)
            let result = reg.matches(in: string, range: NSRange(string.startIndex..., in: string))

            return !result.isEmpty
        } catch {
            print(error.localizedDescription)
        }

        return false
    }
}
