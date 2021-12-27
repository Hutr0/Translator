//
//  ParserWorker.swift
//  Translator
//
//  Created by Леонид Лукашевич on 15.12.2021.
//

import Foundation

struct ParserWorker {
    static func getParserResult(tokens: [String], program: String) -> (String, NSMutableAttributedString?) {
        let parserResult = Parser().parse(stringTokens: tokens)
        
        switch parserResult.type {
        case .success:
            guard let values = parserResult.successValue else {
                return (ErrorDescription.failureValueOrPlace, NSMutableAttributedString(string: program))
            }
            
            var resultString = ""
            for value in values {
                resultString += "\(value)\n"
            }
            
            return (resultString, nil)
        case .failure:
            guard let failureValue = parserResult.failureValue,
                  let failurePlace = parserResult.failurePlace
            else { return (ErrorDescription.failureValueOrPlace, nil) }
            
            let error = getParserFailure(of: failureValue, in: failurePlace, tokens: tokens, program: program)
            
            return (error.0, error.1)
        }
    }
    
    static func getParserFailure(of value: String, in place: Int, tokens: [String], program: String) -> (String, NSMutableAttributedString?) {
        var rowCount = 1
        var lastToken = "<ОШИБКА>"
        
        for (i, token) in tokens.enumerated() {
            
            if i == place {
                let attributedString = AttributedString.getAttributedStringForParser(program: program, token: token, place: place)

                if token == "\n" {
                    return ("['\(lastToken)' в строке №\(rowCount)] \(value)", attributedString)
                } else {
                    return ("['\(token)' в строке №\(rowCount)] \(value)", attributedString)
                }
            }
            
            if token == "\n" {
                rowCount += 1
            }
        
            lastToken = token
        }
        
        return (value, nil)
    }
}
