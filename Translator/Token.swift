//
//  Token.swift
//  Translator
//
//  Created by Леонид Лукашевич on 04.12.2021.
//

import Foundation

class Token {
    let type: TokenType?
    let value: String
    
    init(type: TokenType?, value: String) {
        self.type = type
        self.value = value
    }
}

enum TokenType {
    case startOfProgram
    case endOfProgram
    case zveno
    case equal
    case operation
    case comma
    case function
    case number
    case word
    case endOfLine
    case non
}

//struct SymbolDesc {
//    let t: SymbolTypes
//    let c: SymbolClasses
//}
//
//
//    func getStringId(string: String) -> Int? {
//        switch string {
//        case "Begin":
//            return 0
//        case "First":
//            return 1
//        case "Second":
//            return 2
//        case "sin", "cos", "tg", "ctg":
//            return 3
//        case "End":
//            return 4
//        default:
//            return nil
//        }
//    }
