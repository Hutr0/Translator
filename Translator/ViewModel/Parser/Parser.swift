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
        
//        var lineWasEnded: Bool = false                          // Line was ended
        var elementsOFZveno: [Token] = []                       // Elements of Zveno
        
        var firstNumbersCounter = 0                             // Counter for 'First' numbers
        var secondWordsCounter = 0                              // Counter for 'Second' words
        var endOfLineArray: [Int] = []
        var endOfLineCounter = 0
        
        var tokensOfVar: [Token] = []                           // Variables of current token
        
        var result: [String] = []                               // Result of variables calculation for current method
      
        var maybeNewVar = false
        var maybeNewBrokenVar = false
        var maybeNewEqualBrokenVar = false
        
        let tokensResult = StringChecker.getTokens(stringTokens: stringTokens)
        guard let tokens = tokensResult.0 else {
            return Result(failureValue: ErrorDescription.tooMuchBeginOrEnd, failurePlace: -1)
        }
        
        if !tokensResult.1 {
            return Result(failureValue: ErrorDescription.missedBegin, failurePlace: -1)
        } else if !tokensResult.2 {
            return Result(failureValue: ErrorDescription.missedEnd, failurePlace: -1)
        } else {
            var currentToken: Token! = nil
            
            for (i, token) in tokens.enumerated() {
                if token.value != "\n" {
                    if currentToken == nil {
                        if token.type != .startOfProgram {
                            return Result(failureValue: ErrorDescription.isNotStart, failurePlace: i)
                        }
                    } else {
                        if currentToken.type == .endOfProgram {
                            return Result(failureValue: ErrorDescription.isNotEnd, failurePlace: i)
                        }
                    }
                    
                    currentToken = token
                }
            }
        }
        
        for (tokenNum, token) in tokens.enumerated() {
            if token.type == .startOfProgram {
                lastToken = token
                continue
            }
            
            if token.type == .endOfLine {
                endOfLineCounter += 1
                continue
            }
            
            if lastToken.type == .startOfProgram && token.type == .zveno {
                lastToken = token
                continue
            } else if lastToken.type == .startOfProgram && token.type != .zveno {
                return Result(failureValue: ErrorDescription.missedZveno, failurePlace: tokenNum)
            }
            
            if lastToken.type == .zveno && token.type == .zveno {
                if lastContentToken.type == nil {
                    if lastToken.value == "First" {
                        return Result(failureValue: ErrorDescription.noOneElementInFirst, failurePlace: tokenNum - 1)
                    } else if lastToken.value == "Second" {
                        return Result(failureValue: ErrorDescription.noOneElementInSecond, failurePlace: tokenNum - 1)
                    } else {
                        return Result(failureValue: ErrorDescription.zvenoInStructure, failurePlace: tokenNum)
                    }
                }
                
                if lastToken.value == "First" && lastContentToken.type == .comma {
                    return Result(failureValue: ErrorDescription.zvenoComma, failurePlace: tokenNum - 1)
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
                    
                    // Error Block
//                    if lastContentToken.type == .comma && token.type != .number {
//                        return Result(failureValue: ErrorDescription.zvenoComma, failurePlace: tokenNum - 1)
//                    }
//                    if lineWasEnded && token.type == .number && !elementsOFZveno.isEmpty {
//                        return Result(failureValue: ErrorDescription.zvenoTooMuchNumbers, failurePlace: tokenNum)
//                    }
                    if token.type == .endOfProgram {
                        if firstNumbersCounter < 1 {
                            return Result(failureValue: ErrorDescription.missedNumberAndVar, failurePlace: tokenNum)
                        } else {
                            return Result(failureValue: ErrorDescription.missedFirstVar, failurePlace: tokenNum)
                        }
                    }
                    if token.type == .word && firstNumbersCounter < 1 {
                        return Result(failureValue: ErrorDescription.zvenoNumber, failurePlace: tokenNum)
                    }
                    
                    // Main Block
                    if token.type == .number {
                        elementsOFZveno.append(token)
                        lastContentToken = token
//                        lineWasEnded = false
                        firstNumbersCounter += 1
                        continue
                    }
                    if lastContentToken.type == .number && token.type == .comma {
                        lastContentToken = token
//                        lineWasEnded = false
                        continue
                    }
//                    if token.type == .endOfLine {
//                        lineWasEnded = true
//                        continue
//                    }
                    if token.type == .word {
                        lastToken = token
                        lastContentToken = token
                        endOfLineCounter = 0
//                        lineWasEnded = false
                        continue
                    }
                    
                    if token.type != .number {
                        return Result(failureValue: ErrorDescription.zvenoNumber, failurePlace: tokenNum)
                    }
                    
                    return Result(failureValue: ErrorDescription.firstZvenoInStructure, failurePlace: tokenNum)
                    
                } else if lastToken.value == "Second" {
                    
                    // Error Block
//                    if lastContentToken.type != .word && lastContentToken.type != nil && token.type == .endOfLine {
//                        return Result(failureValue: ErrorDescription.zvenoWord, failurePlace: tokenNum - 1)
//                    }
                    if token.type == .endOfProgram {
                        if secondWordsCounter < 1 {
                            return Result(failureValue: ErrorDescription.missedWordAndVar, failurePlace: tokenNum)
                        } else {
                            return Result(failureValue: ErrorDescription.missedSecondVar, failurePlace: tokenNum)
                        }
                    }
                    if token.type == .equal && secondWordsCounter < 2 {
                        return Result(failureValue: ErrorDescription.zvenoWord, failurePlace: tokenNum)
                    }
                    if token.type == .number {
                        return Result(failureValue: ErrorDescription.secondNumber, failurePlace: tokenNum)
                    }
                    
                    // Main Block
                    if token.type == .word {
                        lastContentToken = token
                        secondWordsCounter += 1
                        continue
                    }
//                    if token.type == .endOfLine {
//                        continue
//                    }
                    if token.type == .equal {
                        lastToken = Token(type: .word, value: lastContentToken.value)
                        lastContentToken = token
                        endOfLineCounter = 0
                        continue
                    }
                    
                    if token.type != .word {
                        return Result(failureValue: ErrorDescription.zvenoWord, failurePlace: tokenNum)
                    }
                    
                    return Result(failureValue: ErrorDescription.secondZvenoInStructure, failurePlace: tokenNum)
                    
                } else {
                    return Result(failureValue: ErrorDescription.zvenoElememtMissedInStructure, failurePlace: tokenNum)
                }
            }
            
            if lastToken.type == .word {
                
                endOfLineArray.append(endOfLineCounter)
                endOfLineCounter = 0
                
                if maybeNewVar {
                    if lastContentToken.type == .word && token.type == .equal {
                        let varStringResult = calculator.getVarString(name: lastToken.value, tokens: tokensOfVar)
                        
                        switch varStringResult.type {
                        case .success:
                            guard let strings = varStringResult.successValue,
                                  let str = strings.first
                            else {
                                return Result(failureValue: ErrorDescription.getVarString, failurePlace: tokenNum - 1)
                            }
                            result.append(str)
                            tokensOfVar = []
                            lastToken = lastContentToken
                            lastContentToken = token
                            maybeNewVar = false
                            maybeNewBrokenVar = false
                            maybeNewEqualBrokenVar = false
                            endOfLineArray = []
                            continue
                        case .failure:
                            guard let failureValue = varStringResult.failureValue, let failurePlace = varStringResult.failurePlace else {
                                return Result(failureValue: ErrorDescription.getVarString, failurePlace: -1)
                            }
                            
                            var count = 0
                            for f in failurePlace+1...endOfLineArray.count-1 {
                                count += endOfLineArray[f]
                            }
                            let place = tokenNum - (tokensOfVar.count - failurePlace + 1) - count // +1, потому что -1 для count + 2
                            return Result(failureValue: failureValue, failurePlace: place)
                        }
                    } else {
                        return Result(failureValue: ErrorDescription.operandsGoInARow, failurePlace: tokenNum - 1)
                    }
                }
                
                // Result Block
                if (lastContentToken.type == .number || lastContentToken.type == .word) && token.type == .endOfProgram {
                    print("Выполнено")
                    
                    let varStringResult = calculator.getVarString(name: lastToken.value, tokens: tokensOfVar)

                    switch varStringResult.type {
                    case .success:
                        guard let strings = varStringResult.successValue,
                              let str = strings.first
                        else {
                            return Result(failureValue: ErrorDescription.getVarString, failurePlace: tokenNum - 1)
                        }
                        result.append(str)
                    case .failure:
                        guard let failureValue = varStringResult.failureValue, let failurePlace = varStringResult.failurePlace else {
                            return Result(failureValue: ErrorDescription.getVarString, failurePlace: -1)
                        }
                        
                        var count = 0
                        for f in failurePlace+1...endOfLineArray.count-1 {
                            count += endOfLineArray[f]
                        }
                        let place = tokenNum - (tokensOfVar.count - failurePlace) - count
                        return Result(failureValue: failureValue, failurePlace: place)
                    }
                    
                    return Result(successValue: result)
                }
                
                // Error Block
                if token.type == nil {
                    return Result(failureValue: ErrorDescription.wrong, failurePlace: tokenNum)
                }
                
                if token.type == .comma {
                    return Result(failureValue: ErrorDescription.commaInVar, failurePlace: tokenNum)
                }
//                if lastContentToken.type == .endOfLine && token.type != .word && token.type != .endOfLine {
//                    return Result(failureValue: ErrorDescription.nameOfVar, failurePlace: tokenNum)
//                }
                
                if lastContentToken.type != .word && token.type == .equal {
                    return Result(failureValue: ErrorDescription.equalForVar, failurePlace: tokenNum)
                }
                
                if lastContentToken.value == "-" && token.value == "-" {
                    return Result(failureValue: ErrorDescription.minus, failurePlace: tokenNum)
                }

                if (lastContentToken.type == .number || lastContentToken.type == .word) && token.type == .number {
                    return Result(failureValue: ErrorDescription.operandsGoInARow, failurePlace: tokenNum)
                }
                if (lastContentToken.type == .number || lastContentToken.type == .word) && token.type == .function {
                    return Result(failureValue: ErrorDescription.functionGoInARow, failurePlace: tokenNum)
                }
                
                if lastContentToken.type == .operation && token.type == .endOfProgram {
                    return Result(failureValue: ErrorDescription.operationOnEnd, failurePlace: tokenNum)
                }
                if lastContentToken.type == .function && token.type == .endOfProgram {
                    return Result(failureValue: ErrorDescription.functionOnEnd, failurePlace: tokenNum)
                }
                if lastContentToken.type == .equal && token.type == .endOfProgram {
                    return Result(failureValue: ErrorDescription.afterEqual, failurePlace: tokenNum)
                }
                
//                if lastContentToken.type == .operation && token.type == .endOfLine {
//                    return Result(failureValue: ErrorDescription.operationOnEnd, failurePlace: tokenNum - 1)
//                }
//                if lastContentToken.type == .function && token.type == .endOfLine {
//                    return Result(failureValue: ErrorDescription.functionOnEnd, failurePlace: tokenNum - 1)
//                }
//                if lastContentToken.type == .equal && token.type == .endOfLine {
//                    return Result(failureValue: ErrorDescription.afterEqual, failurePlace: tokenNum - 1)
//                }
                
                if lastContentToken.type == .equal && token.type == .equal {
                    return Result(failureValue: ErrorDescription.tooMuchEqual, failurePlace: tokenNum)
                }
                
                if lastContentToken.type == .equal && token.type == .operation && token.value != "-" {
                    return Result(failureValue: ErrorDescription.operationsAfterEqual, failurePlace: tokenNum)
                }
                
                // Main block
                if (lastContentToken.type == .number || lastContentToken.type == .word) && token.type == .word {
                    maybeNewVar = true
                    lastContentToken = token
                    continue
                }
                
                if lastContentToken.type == .equal && (token.type == .number || token.type == .word || token.type == .function) {
                    tokensOfVar.append(token)
                    lastContentToken = token
                    maybeNewEqualBrokenVar = true
                    continue
                }
                
                if (lastContentToken.type == .equal || lastContentToken.type == .operation || lastContentToken.type == .function) && token.value == "-" {
                    lastContentToken = token
                    continue
                }
                
                if lastContentToken.value == "-" && (token.type == .number || token.type == .word || token.type == .function) {
                    token.minus = true
                    tokensOfVar.append(token)
                    lastContentToken = token
                    maybeNewBrokenVar = true
                    continue
                }
                
                if (lastContentToken.type == .number || lastContentToken.type == .word) && token.type == .operation {
                    tokensOfVar.append(token)
                    lastContentToken = token
                    continue
                }
                
                if lastContentToken.type == .operation && (token.type == .number || token.type == .word || token.type == .function) {
                    tokensOfVar.append(token)
                    lastContentToken = token
                    maybeNewBrokenVar = true
                    continue
                }
                
//                if (lastContentToken.type == .number || lastContentToken.type == .word) && token.type == .endOfLine {
//                    let varStringResult = calculator.getVarString(name: lastToken.value, tokens: tokensOfVar)
//
//                    switch varStringResult.type {
//                    case .success:
//                        guard let strings = varStringResult.successValue,
//                              let str = strings.first
//                        else {
//                            return Result(failureValue: ErrorDescription.getVarString, failurePlace: tokenNum - 1)
//                        }
//                        result.append(str)
//                        tokensOfVar = []
//                        lastContentToken = token
//                        maybeNewBrokenVar = false
//                        maybeNewEqualBrokenVar = false
//                        continue
//                    case .failure:
//                        guard let failureValue = varStringResult.failureValue, let failurePlace = varStringResult.failurePlace else {
//                            return Result(failureValue: ErrorDescription.getVarString, failurePlace: -1)
//                        }
//                        let place = tokenNum - (tokensOfVar.count - failurePlace)
//                        return Result(failureValue: failureValue, failurePlace: place)
//                    }
//                }
                
//                if lastContentToken.type == .endOfLine && token.type == .word {
//                    lastContentToken = token
//                    continue
//                }
                
                if lastContentToken.type == .word && token.type == .equal {
                    if !maybeNewBrokenVar && !maybeNewEqualBrokenVar {
                        lastToken = lastContentToken
                        lastContentToken = token
                        continue
                    } else {
                        if maybeNewBrokenVar {
                            return Result(failureValue: ErrorDescription.equalDoesNotExist, failurePlace: tokenNum)
                        } else if maybeNewEqualBrokenVar {
                            return Result(failureValue: ErrorDescription.equalInEqual, failurePlace: tokenNum)
                        }
                    }
                }
                
                if lastContentToken.type == .function && (token.type == .number || token.type == .word) {
                    tokensOfVar.append(token)
                    lastContentToken = token
                    maybeNewBrokenVar = true
                    continue
                }
                
                if lastContentToken.type == .function && token.type == .function {
                    tokensOfVar.append(lastContentToken)
                    lastContentToken = token
                    continue
                }
                
//                if token.type == .endOfLine {
//                    continue
//                }
                
                if lastContentToken.type == .operation && token.type == .operation {
                    return Result(failureValue: ErrorDescription.tooMuchOperations, failurePlace: tokenNum)
                }
               
                return Result(failureValue: ErrorDescription.variableInStructure, failurePlace: tokenNum)
            }
        }
        
        return Result(failureValue: ErrorDescription.incorrectTermination, failurePlace: -1)
    }
}
