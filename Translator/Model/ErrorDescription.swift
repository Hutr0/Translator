//
//  ErrorDescription.swift
//  Translator
//
//  Created by Леонид Лукашевич on 06.12.2021.
//

import Foundation

struct ErrorDescription {
    
//    static let smw = "Something went wrong..."
//    static let lAnalizer = "Error: LexicalAnalizer cannot analyze the program (wrong symbol)."
//    static let posledneeInStructure = "Error: Program structure was broken ('Последнее')."
//    static let convertToDouble = "Error: Cannot be converted to Double."
//    static let unsuccessfulParsing = "Error: Unsuccessful parsing."
    
    static let lastRow = "Error: Invalid last row element."
    static let tooMuchBeginOrEnd = "Error: So many 'Begin' or 'End' in the program structure."
    static let missedBeginOrEnd = "Error: Missing 'Begin' or 'End' in the program structure."
    static let missedZveno = "Error: Missing Звено in the program structure."
    static let zvenoInStructure = "Error: Program structure was broken (Звено)."
    static let zvenoComma = "Error: Number is expected after comma in Звено 'First'."
    static let zvenoNumber = "Error: Number is expected in Звено 'First'."
    static let zvenoTooMuchNumbers = "Error: Elements of Звено 'First' must be written in one line."
    static let zvenoTooMuchWords = "Error: Elements of Звено 'Second' must be written in one line."
    static let zvenoWord = "Error: Word is expected in Звено 'Second'."
    static let zvenoElememtMissedInStructure = "Error: Program structure was broken. Expected 'First' or 'Second' in Звено."
    static let minus = "Error: Too many minuses."
    static let getVarString = "Error: Cannot get string of variable."
    static let variableInStructure = "Error: Program structure was broken (variables)"
    static let incorrectTermination = "Error: The program was terminated incorrectly."
    static let calculate = "Error: Cannot calculate the result."
    static let failureValueOrPlace = "Error: Failure value or failure place is nil."
    static let getParserFailure = "Error: getParserFailure function returned an incorrect result."
    static let lexicalSuccessValue = "Error: Lexical analyzer success value is nil."
    
    static func varNotDeclared(name: String) -> String {
        return "Error: '\(name)' was not declared."
    }
    
    static func wrongSymbol(symbol: Character) -> String {
        return "Error: LexicalAnalizer cannot analyze the program. Wrong symbol: '\(symbol)'."
    }
    
    static func convertToDouble(value: String) -> String {
        return "Error: '\(value)' cannot be converted to Double."
    }
}
