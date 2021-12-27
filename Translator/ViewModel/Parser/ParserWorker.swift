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
            guard let values = parserResult.successValue else { return (ErrorDescription.failureValueOrPlace, NSMutableAttributedString(string: program)) }
            
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
                let attributedString = NSMutableAttributedString(string:program)
//
//                guard var programPlace = self.tokenize(inputProgram: program, place: place) else {
//                    if token == "\n" {
//                        return ("['\(lastToken)' в строке №\(rowCount)] \(value)", nil)
//                    } else {
//                        return ("['\(token)' в строке №\(rowCount)] \(value)", nil)
//                    }
//                }
                
                if token == "\n" {
//                    programPlace -= 1
//
//                    let stringOneRegex: NSRegularExpression?
//                    if isNumber(string: lastToken) {
//                        stringOneRegex = try? NSRegularExpression(pattern: "\(lastToken)", options: [])
//                    } else {
//                        stringOneRegex = try? NSRegularExpression(pattern: "\\\(lastToken)", options: [])
//                    }
//
//                    guard let stringOneRegex = stringOneRegex else { return ("['\(lastToken)' в строке №\(rowCount)] \(value)", nil) }
//
//                    let stringOneMatches = stringOneRegex.matches(in: program, options: [], range: NSMakeRange(0, attributedString.length))
//                    for stringOneMatch in stringOneMatches {
//                        let wordRange = stringOneMatch.range(at: 0)
//                        if wordRange.location == programPlace {
//                            attributedString.addAttribute(.foregroundColor, value: NSColor.red, range: wordRange)
//                        }
//                    }
                    
                    return ("['\(lastToken)' в строке №\(rowCount)] \(value)", attributedString)
                } else {
//                    let stringOneRegex: NSRegularExpression?
//                    if isNumber(string: token) || isWord(string: token) {
//                        stringOneRegex = try? NSRegularExpression(pattern: "\(token)", options: [])
//                    } else {
//                        programPlace += 1
//                        stringOneRegex = try? NSRegularExpression(pattern: "\\\(token)", options: [])
//                    }
//
//                    guard let stringOneRegex = stringOneRegex else { return ("['\(token)' в строке №\(rowCount)] \(value)", nil) }
//
//                    let stringOneMatches = stringOneRegex.matches(in: program, options: [], range: NSMakeRange(0, attributedString.length))
//                    for stringOneMatch in stringOneMatches {
//                        let wordRange = stringOneMatch.range(at: 0)
//                        if wordRange.location == programPlace {
//                            attributedString.addAttribute(.foregroundColor, value: NSColor.red, range: wordRange)
//                        }
//                    }
                    
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
    
//    static func tokenize(inputProgram: String, place: Int) -> Int? {
//        var temp = ""
//        var tokenNumber = 0
//
//        for (i, char) in inputProgram.enumerated() {
//            if tokenNumber == place {
//                return i
//            }
//
//            let symbolClass = Symbol.getSymbolClass(symbol: char)
//
//            guard let symbolClass = symbolClass else {
//                return nil
//            }
//
//            if symbolClass == .separator {
//                if temp != "" {
//                    tokenNumber += 1
//                    temp = ""
//                }
//                continue
//            }
//
//            if symbolClass == .modifier {
//                if temp != "" {
//                    tokenNumber += 1
//                    temp = ""
//                }
//                tokenNumber += 1
//                continue
//            }
//
//            temp += String(char)
//        }
//
//        return nil
//    }
//
//    private static func isNumber(string: String) -> Bool {
//        return Int(string) != nil
//    }
//
//    private static func isWord(string: String) -> Bool {
//        let pattern = "^([a-zA-Z]){1,}([a-zA-Z0-7])*"
//
//        do {
//            let reg = try NSRegularExpression(pattern: pattern)
//            let result = reg.matches(in: string, range: NSRange(string.startIndex..., in: string))
//
//            return !result.isEmpty
//        } catch {
//            print(error.localizedDescription)
//        }
//
//        return false
//    }
}
