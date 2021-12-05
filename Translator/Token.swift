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
