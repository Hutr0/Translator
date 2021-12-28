//
//  LexicalWorker.swift
//  Translator
//
//  Created by Леонид Лукашевич on 15.12.2021.
//

import Foundation

struct LexicalWorker {
    static func getLexicalResult(program: String) -> Result {
        return LexicalAnalyzer.tokenize(inputProgram: program)
    }
    
    static func getLexicalFailure(of value: String, in place: Int, program: String) -> (String, NSRange?, NSMutableAttributedString?) {
        var rowCount = 0
        for (i, symbol) in program.enumerated() {
            if i == place {
                let attributedString = AttributedString.getAttributedStringForLexicalAnalyzer(program: program, symbol: symbol, place: place)
                
                return ("[Строк №\(rowCount+1)]: \(value)", attributedString.0, attributedString.1)
            }
            if symbol == "\n" {
                rowCount += 1
            }
        }
        
        return ("\(value)", nil, nil)
    }
}
