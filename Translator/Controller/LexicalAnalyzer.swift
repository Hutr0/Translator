//
//  LexicalAnalyzer.swift
//  Translator
//
//  Created by Леонид Лукашевич on 04.12.2021.
//

import Foundation

class LexicalAnalyzer {
    
    static func tokenize(inputProgram: String) -> Result {
        var tokens: [String] = []
        var temp: String = ""
        
        var cymbolCounter = 0
        for char in inputProgram {
            let symbolClass = getSymbolClass(symbol: char)
            
            guard let symbolClass = symbolClass else {
                return Result(type: .failure, failureValue: ErrorDescription.wrongSymbol(symbol: char))
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
            cymbolCounter += 1
        }
        
        tokens.append(temp)
        return Result(type: .success, successValue: tokens)
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
