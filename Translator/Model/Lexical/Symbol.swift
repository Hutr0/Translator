//
//  SymbolClass.swift
//  Translator
//
//  Created by Леонид Лукашевич on 15.12.2021.
//

import Foundation

struct Symbol {
    static func getSymbolClass(symbol: Character) -> SymbolClass? {
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
    
    enum SymbolClass {
        case value
        case separator
        case modifier
    }
}
