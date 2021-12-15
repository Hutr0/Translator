//
//  Parser.swift
//  Translator
//
//  Created by Леонид Лукашевич on 04.12.2021.
//

import Foundation

class Parser {
    
    let calculator = Calculator()
    
    /// This method is called of MainController for start token parsing
    /// - Parameter stringTokens: Array of string tokens from LexicalAnalyzer for parsing
    /// - Returns: All variables
    func parse(stringTokens: [String]) -> Result {
        var lastToken = Token(type: nil, value: "")             // Last token (Begin, Zveno, Variable, End)
        var lastContentToken = Token(type: nil, value: "")      // Last content of token (word, number, operation, ...)
        
        var lineWasEnded: Bool = false                          // Line was ended
        var elementsOFZveno: [Token] = []                       // Elements of Zveno
        
        var firstNumbersCounter = 0                             // Counter for 'First' numbers
        var secondWordsCounter = 0                              // Counter for 'Second' words
        
        var tokensOfVar: [Token] = []                           // Variables of current token

        var result: [String] = []                               // Result of variables calculation for current method
        
        guard let tokens = StringChecker.getTokens(stringTokens: stringTokens) else {
            return Result(failureValue: ErrorDescription.tooMuchBeginOrEnd, failurePlace: -1)
        }
        
        if tokens.first?.type != .startOfProgram || tokens.last?.type != .endOfProgram {
            return Result(failureValue: ErrorDescription.missedBeginOrEnd, failurePlace: -1)
        }
        
        var tokenCount = 0
        for token in tokens {
            tokenCount += 1
            if token.type == .startOfProgram {
                lastToken = token
                continue
            }
            
            if lastToken.type == .startOfProgram && token.type == .zveno {
                lastToken = token
                continue
            } else if lastToken.type == .startOfProgram && token.type == .endOfLine {
                continue
            } else if lastToken.type == .startOfProgram && token.type != .zveno && token.type != .endOfLine {
                return Result(failureValue: ErrorDescription.missedZveno, failurePlace: tokenCount)
            } else if lastToken.type == .zveno && token.type == .zveno {
                
                if lastContentToken.type == nil {
                    return Result(failureValue: ErrorDescription.zvenoInStructure, failurePlace: tokenCount)
                }
                
                lastContentToken = Token(type: nil, value: "")
                elementsOFZveno = []
                lastToken = token
                firstNumbersCounter = 0
                secondWordsCounter = 0
                continue
            }
            
            if lastToken.type == .zveno {
                if lastToken.value == "First" {
                    
                    if token.type == .endOfLine && lastContentToken.type == .comma {
                        return Result(failureValue: ErrorDescription.zvenoComma, failurePlace: tokenCount)
                    } else if lineWasEnded && token.type == .number && !elementsOFZveno.isEmpty {
                        return Result(failureValue: ErrorDescription.zvenoTooMuchNumbers, failurePlace: tokenCount)
                    } else if token.type == .number {
                        elementsOFZveno.append(token)
                        lastContentToken = token
                        lineWasEnded = false
                        firstNumbersCounter += 1
                        continue
                    } else if lastContentToken.type == .number && token.type == .comma {
                        lastContentToken = token
                        lineWasEnded = false
                        continue
                    } else if token.type == .endOfLine {
                        lineWasEnded = true
                        continue
                    } else if token.type == .word {
                        if firstNumbersCounter < 1 {
                            return Result(failureValue: ErrorDescription.zvenoNumber, failurePlace: tokenCount)
                        }
                        lastToken = token
                        lastContentToken = token
                        lineWasEnded = false
                        continue
                    } else {
                        return Result(failureValue: ErrorDescription.zvenoNumber, failurePlace: tokenCount)
                    }
                    
                } else if lastToken.value == "Second" {
                    
                    if token.type == .word {
                        lastContentToken = token
                        secondWordsCounter += 1
                        continue
                    } else if lastContentToken.type != .word && lastContentToken.type != nil && token.type == .endOfLine {
                        return Result(failureValue: ErrorDescription.zvenoWord, failurePlace: tokenCount)
                    } else if token.type == .endOfLine {
                        continue
                    } else if token.type == .equal {
                        if secondWordsCounter < 2 {
                            return Result(failureValue: ErrorDescription.zvenoWord, failurePlace: tokenCount)
                        }
                        lastToken = Token(type: .word, value: lastContentToken.value)
                        lastContentToken = token
                        continue
                    } else {
                        return Result(failureValue: ErrorDescription.zvenoWord, failurePlace: tokenCount)
                    }
                    
                } else {
                    return Result(failureValue: ErrorDescription.zvenoElememtMissedInStructure, failurePlace: tokenCount)
                }
            }
            
            if lastToken.type == .word {
                
                if lastContentToken.type == .equal && (token.type == .number || token.type == .word || token.type == .function) {
                    tokensOfVar.append(token)
                    lastContentToken = token
                    continue
                } else if lastContentToken.value == "-" && token.value == "-" {
                    return Result(failureValue: ErrorDescription.minus, failurePlace: tokenCount)
                } else if (lastContentToken.type == .equal || lastContentToken.type == .operation || lastContentToken.type == .function) && token.value == "-" {
                    lastContentToken = token
                    continue
                } else if lastContentToken.value == "-" && (token.type == .number || token.type == .word || token.type == .function) {
                    token.minus = true
                    tokensOfVar.append(token)
                    lastContentToken = token
                    continue
                } else if (lastContentToken.type == .number || lastContentToken.type == .word) && token.type == .operation {
                    tokensOfVar.append(token)
                    lastContentToken = token
                    continue
                } else if lastContentToken.type == .operation && (token.type == .number || token.type == .word || token.type == .function) {
                    tokensOfVar.append(token)
                    lastContentToken = token
                    continue
                } else if (lastContentToken.type == .number || lastContentToken.type == .word) && token.type == .endOfLine {
                    let varStringResult = calculator.getVarString(name: lastToken.value, tokens: tokensOfVar)
                    
                    switch varStringResult.type {
                    case .success:
                        guard let strings = varStringResult.successValue,
                              let str = strings.first
                        else {
                            return Result(failureValue: ErrorDescription.getVarString, failurePlace: tokenCount)
                        }
                        result.append(str)
                        tokensOfVar = []
                        lastContentToken = token
                        continue
                    case .failure:
                        let failureValue = varStringResult.failureValue
                        return Result(failureValue: failureValue ?? "Unknown error...", failurePlace: tokenCount)
                    }
                } else if lastContentToken.type == .endOfLine && token.type == .word {
                    lastContentToken = token
                    continue
                } else if lastContentToken.type == .word && token.value == "=" {
                    lastToken = lastContentToken
                    lastContentToken = token
                    continue
                } else if lastContentToken.type == .function && (token.type == .number || token.type == .word) {
                    tokensOfVar.append(token)
                    lastContentToken = token
                    continue
                } else if lastContentToken.type == .endOfLine && token.type == .endOfProgram {
                    print("Complete")
                    return Result(successValue: result)
                } else if token.type == .endOfLine {
                    continue
                } else {
                    return Result(failureValue: ErrorDescription.variableInStructure, failurePlace: tokenCount)
                }
                
            }
        }
        
        return Result(failureValue: ErrorDescription.incorrectTermination, failurePlace: -1)
    }
}
