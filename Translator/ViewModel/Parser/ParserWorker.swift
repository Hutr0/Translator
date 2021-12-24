//
//  ParserWorker.swift
//  Translator
//
//  Created by Леонид Лукашевич on 15.12.2021.
//

import Foundation

struct ParserWorker {
    static func getParserResult(tokens: [String]) -> String {
        let parserResult = Parser().parse(stringTokens: tokens)
        
        switch parserResult.type {
        case .success:
            guard let values = parserResult.successValue else { return ErrorDescription.failureValueOrPlace }
            
            var resultString = ""
            for value in values {
                resultString += "\(value)\n"
            }
            
            return resultString
        case .failure:
            guard let failureValue = parserResult.failureValue,
                  let failurePlace = parserResult.failurePlace
            else { return ErrorDescription.failureValueOrPlace }
            
            let error = getParserFailure(of: failureValue, in: failurePlace, tokens: tokens)
            
            return error
        }
    }
    
    static func getParserFailure(of value: String, in place: Int, tokens: [String]) -> String {
        var rowCount = 0
        var lastToken: String = "<ОШИБКА>"
        for (i, token) in tokens.enumerated() {
            if i == place {
                if lastToken == "\\n" {
                    return "['\(lastToken)' в строке №\(rowCount)] \(value)"
                } else {
                    return "['\(lastToken)' в строке №\(rowCount+1)] \(value)"
                }
            }
            if token == "\n" {
                rowCount += 1
                lastToken = "\\n"
            } else {
                lastToken = token
            }
        }
        
        return value
    }
}
