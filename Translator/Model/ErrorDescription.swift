//
//  ErrorDescription.swift
//  Translator
//
//  Created by Леонид Лукашевич on 06.12.2021.
//

import Foundation

struct ErrorDescription {
    static let smw = "Something went wrong..."
    static let lastRow = "Error: Invalid last row element."
    static let lAnalizer = "Error: LexicalAnalizer cannot analyze the program (wrong symbol)."
    static let missedBeginOrEnd = "Error: Missing Begin or End in the program structure."
    static let tooMuchBeginOrEnd = "Error: So many Begin or End in the program structure."
    static let posledneeInStructure = "Error: Program structure was broken ('Последнее')."
    static let zvenoInStructure = "Error: Program structure was broken ('Звено')."
    static let zvenoTypeInStructure = "Error: Program structure was broken (type of 'Звено')."
    static let zvenoNumberInStructure = "Error: Program structure was broken (expected number in 'Звено')."
    static let zvenoCommaInStructure = "Error: Program structure was broken (expected number after comma in 'Звено')"
    static let zvenoWordInStructure = "Error: Program structure was broken (word in 'Звено')."
    static let variableInStructure = "Error: Program structure was broken (variables)"
    static let convertToInt = "Error: Cannot be converted to Int."
    static let calculate = "Error: Cannot calculate the result."
    static let getVarString = "Error: Cannot get var string."
    static let incorrectTermination = "Error: The program was terminated incorrectly."
    static let unsuccessfulParsing = "Error: Unsuccessful parsing."
    
    static func varNotDeclared(name: String) -> String{
        return "Error: \(name) was not declared."
    }
    
    static func wrongSymbol(symbol: Character) -> String{
        return "Error: LexicalAnalizer cannot analyze the program. Wrong symbol: '\(symbol)'."
    }
}
