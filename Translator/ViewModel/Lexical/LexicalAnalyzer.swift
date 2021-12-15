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
        
        var symbolCount = 0
        for char in inputProgram {
            symbolCount += 1
            let symbolClass = Symbol.getSymbolClass(symbol: char)
            
            guard let symbolClass = symbolClass else {
                return Result(failureValue: ErrorDescription.wrongSymbol(symbol: char), failurePlace: symbolCount)
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
        return Result(successValue: tokens)
    }
}
