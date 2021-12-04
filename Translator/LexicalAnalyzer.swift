//
//  LexicalAnalyzer.swift
//  Translator
//
//  Created by Леонид Лукашевич on 04.12.2021.
//

import Foundation

class LexicalAnalyzer {
    let inputProgram: String
    
    init(inputProgram: String) {
        self.inputProgram = inputProgram
    }
    
    func tokenize() -> [String]? {
        var tokens: [String] = []
        var temp: String = ""
        
        for char in inputProgram {
            let id = getSybolType(symbol: char)
            
            guard let id = id else {
                print("Error: Wrong symbol.")
                return nil
            }
            
            if id == .separator {
                if temp != "" {
                    tokens.append(temp)
                    temp = ""
                }
                continue
            }
            
            if id == .modifier {
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
    
    func getSybolType(symbol: Character) -> SymbolClass? {
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
        case " ":
            return .separator
        case "\n":
            return .modifier
        default:
            return nil
        }
    }
    
    enum SymbolClass {
        case value
        case separator
        case modifier
    }
}
