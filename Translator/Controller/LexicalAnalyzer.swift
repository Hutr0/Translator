//
//  LexicalAnalyzer.swift
//  Translator
//
//  Created by Леонид Лукашевич on 04.12.2021.
//

import Foundation

class LexicalAnalyzer {
    
    static func tokenize(inputProgram: String) -> [String]? {
        var tokens: [String] = []
        var temp: String = ""
        
        for char in inputProgram {
            let symbolClass = getSymbolClass(symbol: char)
            
            guard let symbolClass = symbolClass else {
                print("Error: Wrong symbol.")
                return nil
            }
            
            if symbolClass == .separator {
                if temp != "" {
                    tokens.append(temp)
                    temp = ""
                }
                continue
            }
            
            if symbolClass == .modifier {
                if temp != "" {
                    tokens.append(temp)
                    temp = ""
                }
                tokens.append(String(char))
                continue
            }
            
            temp += String(char)
        }
        
        tokens.append(temp)
        return tokens
    }
    
    private static func getSymbolClass(symbol: Character) -> SymbolClass? {
        switch symbol {
        case "a"..."z", "A"..."Z":
            return .value
        case "0"..."7":
            return .value
        case "=":
            return .modifier
        case "+", "-", "*", "/":
            return .modifier
        case "^":
            return .modifier
        case ",":
            return .modifier
        case "\n":
            return .modifier
        case " ":
            return .separator
        default:
            return nil
        }
    }
    
    private enum SymbolClass {
        case value
        case separator
        case modifier
    }
}
