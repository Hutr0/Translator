//
//  Token.swift
//  Translator
//
//  Created by Леонид Лукашевич on 04.12.2021.
//

import Foundation

class Token {
    let type: TokenType?
    var value: String
    var minus: Bool = false
    
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
    case word
    case number
    case operation
    case function
    case comma
    case endOfLine
}
