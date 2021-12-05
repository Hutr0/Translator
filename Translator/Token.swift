//
//  Token.swift
//  Translator
//
//  Created by Леонид Лукашевич on 04.12.2021.
//

import Foundation

class DeclaredVariables {
    let name: String
    var value: Int
    
    init(name: String, value: Int) {
        self.name = name
        self.value = value
    }
}

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
