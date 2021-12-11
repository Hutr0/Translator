//
//  Parser.swift
//  Translator
//
//  Created by Леонид Лукашевич on 04.12.2021.
//

import Foundation

class Parser {
    private var declaredVariables: [DeclaredVariables] = []

    func parse(stringTokens: [String]) -> Result {
        var lastToken = Token(type: nil, value: "")
        var lastContentToken = Token(type: nil, value: "")
        var firstNumbersCounter = 0
        var secondWordsCounter = 0
        var tokensOfVar: [Token] = []
        var result: [String] = []
        
        guard let tokens = getTokens(stringTokens: stringTokens) else {
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
                lastToken = token
                firstNumbersCounter = 0
                secondWordsCounter = 0
                continue
            }
            
            if lastToken.type == .zveno {
                if lastToken.value == "First" && token.type == .endOfLine && lastContentToken.type == .comma {
                    return Result(failureValue: ErrorDescription.zvenoComma, failurePlace: tokenCount)
                }
                
                if lastToken.value == "First" {
                    if token.type == .number {
                        lastContentToken = token
                        firstNumbersCounter += 1
                        continue
                    } else if lastContentToken.type == .number && token.type == .comma {
                        lastContentToken = token
                        continue
                    } else if token.type == .endOfLine {
                        continue
                    } else if token.type == .word {
                        if firstNumbersCounter < 1 {
                            return Result(failureValue: ErrorDescription.zvenoNumber, failurePlace: tokenCount)
                        }
                        lastToken = token
                        lastContentToken = token
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
                    let varStringResult = getVarString(name: lastToken.value, tokens: tokensOfVar)
                    
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
                } else {
                    return Result(failureValue: ErrorDescription.variableInStructure, failurePlace: tokenCount)
                }
            }
        }
        
        return Result(failureValue: ErrorDescription.incorrectTermination, failurePlace: -1)
    }
    
    /// Get tokens from string of tokens and return it
    /// - Parameter stringTokens: String of tokens
    /// - Returns: Tokens array
    private func getTokens(stringTokens: [String]) -> [Token]? {
        var startIsSet = false
        var endIsSet = false
        var tokens: [Token] = []
        
        for stringToken in stringTokens {
            let type = getTokenType(stringToken: stringToken)
            
            if type == nil {
                if isNumber(string: stringToken) {
                    tokens.append(Token(type: .number, value: stringToken))
                } else if isWord(string: stringToken) {
                    tokens.append(Token(type: .word, value: stringToken))
                } else {
                    tokens.append(Token(type: .none, value: stringToken))
                }
            } else {
                tokens.append(Token(type: type, value: stringToken))
                
                if type == .startOfProgram && !startIsSet {
                    startIsSet = true
                } else if type == .endOfProgram && !endIsSet {
                    endIsSet = true
                } else if (type == .startOfProgram && startIsSet) || (type == .endOfProgram && endIsSet) { return nil }
            }
        }
        
        return tokens
    }
    
    private func getVarString(name: String, tokens: [Token]) -> Result {
        var values: [Double] = []
        var operations: [String] = []
        var declared = false
        var currentDeclaredVariables: [DeclaredVariables] = []
        
        for token in tokens {
            switch token.type {
            case .operation:
                operations.append(token.value)
            case .number:
                guard var doubleValue = Double(token.value) else {
                    return Result(failureValue: ErrorDescription.convertToDouble(value: token.value), failurePlace: -1)
                }
                
                if token.minus {
                    doubleValue *= -1
                }
                
                values.append(Double(doubleValue))
            case .function:
                if token.minus {
                    operations.append("-\(token.value)")
                } else {
                    operations.append(token.value)
                }
            case .word:
                for declaredVariable in declaredVariables {
                    if token.value == declaredVariable.name {
                        
                        if token.minus {
                            declaredVariable.value *= -1
                        }
                        
                        values.append(declaredVariable.value)
                        currentDeclaredVariables.append(declaredVariable)
                        declared = true
                    }
                }
                
                if !declared {
                    return Result(failureValue: ErrorDescription.varNotDeclared(name: token.value), failurePlace: -1)
                }
            default:
                continue
            }
        }
        
        let result = calculate(values: values, operations: operations)
        guard let result = result else {
            return Result(failureValue: ErrorDescription.calculate, failurePlace: -1)
        }
        
        let dVariable = DeclaredVariables(name: name, value: result)
        if !currentDeclaredVariables.isEmpty {
            var notCurrent = true
            var num = 0
            var lastNum = 0
            for declaredVariable in declaredVariables {
                for currentDeclaredVariable in currentDeclaredVariables {
                    if declaredVariable.name == dVariable.name && currentDeclaredVariable.name == dVariable.name {
                        notCurrent = false
                        lastNum = num
                    }
                }
                num += 1
            }
            if notCurrent {
                self.declaredVariables.append(dVariable)
            } else {
                self.declaredVariables[lastNum].value = result
            }
        } else {
            self.declaredVariables.append(dVariable)
        }
        
        let variable: String
        if result.truncatingRemainder(dividingBy: 1) == 0 {
            variable = "\(name) = \(Int(result))"
        } else {
            let nf = NumberFormatter()
            nf.numberStyle = .decimal
            nf.maximumFractionDigits = 3
            
            let number = NSNumber(value: result)
            variable = "\(name) = \(nf.string(from: number) ?? String(result))"
        }
        
        print(variable)
        return Result(successValue: [variable])
    }
    
    private func calculate(values: [Double], operations: [String]) -> Double? {
        var values = values
        var operations = operations
        
        var i = 0
        for operation in operations {
            if operation == "sin" || operation == "cos" || operation == "tg" || operation == "ctg" ||
                operation == "-sin" || operation == "-cos" || operation == "-tg" || operation == "-ctg" {
                switch operation {
                case "sin":
                    let equationResult = sin(values[i] * Double.pi / 180)
                    values[i] = equationResult
                case "cos":
                    let equationResult = cos(values[i] * Double.pi / 180)
                    values[i] = equationResult
                case "tg":
                    let equationResult = tan(values[i] * Double.pi / 180)
                    values[i] = equationResult
                case "ctg":
                    let equationResult = 1 / (values[i] * Double.pi / 180)
                    values[i] = equationResult
                case "-sin":
                    let equationResult = (sin(values[i] * Double.pi / 180)) * -1
                    values[i] = equationResult
                case "-cos":
                    let equationResult = (cos(values[i] * Double.pi / 180)) * -1
                    values[i] = equationResult
                case "-tg":
                    let equationResult = (tan(values[i] * Double.pi / 180)) * -1
                    values[i] = equationResult
                case "-ctg":
                    let equationResult = (1 / (values[i] * Double.pi / 180)) * -1
                    values[i] = equationResult
                default:
                    continue
                }

                operations.remove(at: i)
                i -= 1
            }

            i += 1
        }

        i = 0
        for operation in operations {
            if operation == "^" {
                let equationResult = pow(values[i], values[i+1])
                values[i] = equationResult

                values.remove(at: i+1)
                operations.remove(at: i)
                i -= 1
            }

            i += 1
        }

        i = 0
        for operation in operations {
            if operation == "*" || operation == "/" {
                switch operation {
                case "*":
                    let equationResult = values[i] * values[i+1]
                    values[i] = equationResult
                case "/":
                    let equationResult = values[i] / values[i+1]
                    values[i] = equationResult
                default:
                    continue
                }

                values.remove(at: i+1)
                operations.remove(at: i)
                i -= 1
            }

            i += 1
        }

        i = 0
        for operation in operations {
            if operation == "+" || operation == "-" {
                switch operation {
                case "+", "-":
                    let equationResult = values[i] + values[i+1]
                    values[i] = equationResult
                default:
                    continue
                }

                values.remove(at: i+1)
                operations.remove(at: i)
                i -= 1
            }

            i += 1
        }

        return values.first
    }

    private func getTokenType(stringToken: String) -> TokenType? {
        switch stringToken {
        case "Begin":
            return .startOfProgram
        case "End":
            return .endOfProgram
        case "First", "Second":
            return .zveno
        case "=":
            return .equal
        case "+", "-", "*", "/", "^":
            return .operation
        case ",":
            return .comma
        case "sin", "cos", "tg", "ctg":
            return .function
        case "\n":
            return .endOfLine
        default:
            return nil
        }
    }

    private func isNumber(string: String) -> Bool {
        return Int(string) != nil
    }

    private func isWord(string: String) -> Bool {
        let pattern = "^([a-zA-Z]){1,}([a-zA-Z0-7])*"

        do {
            let reg = try NSRegularExpression(pattern: pattern)
            let result = reg.matches(in: string, range: NSRange(string.startIndex..., in: string))

            return !result.isEmpty
        } catch {
            print(error.localizedDescription)
        }

        return false
    }
}
