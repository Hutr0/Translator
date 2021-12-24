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
    
    static func getLexicalFailure(of value: String, in place: Int, program: String) -> String {
        var rowCount = 0
        for (i, symbol) in program.enumerated() {
            if i == place {
                return "[Строк №\(rowCount+1)]: \(value)"
            }
            if symbol == "\n" {
                rowCount += 1
            }
        }
        
        return "\(value)"
    }
}
