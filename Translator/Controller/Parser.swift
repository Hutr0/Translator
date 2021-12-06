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
        var tokensOfVar: [Token] = []
        var result: [String] = []
        
        guard let tokens = getTokens(stringTokens: stringTokens) else {
            return Result(type: .failure, failureValue: ErrorDescription.tooMuchBeginOrEnd)
        }
        
        if tokens.first?.type != .startOfProgram || tokens.last?.type != .endOfProgram {
            return Result(type: .failure, failureValue: ErrorDescription.missedBeginOrEnd)
        }
        
        for token in tokens {
            if token.type == .startOfProgram {
                lastToken = token
                continue
            }
            
            if lastToken.type == .startOfProgram && token.type == .zveno {
                lastToken = token
                continue
            } else if lastToken.type == .startOfProgram && token.type != .zveno && token.type != .endOfLine {
                return Result(type: .failure, failureValue: ErrorDescription.zvenoInStructure)
            } else if lastToken.type == .zveno && token.type == .zveno {
                lastToken = token
                continue
            }
            
            if lastToken.type == .zveno {
                
                if lastToken.value == "First" && token.type == .endOfLine && lastContentToken.type == .comma {
                    return Result(type: .failure, failureValue: ErrorDescription.zvenoCommaInStructure)
                } else if token.type == .endOfLine {
                    continue
                }
                
                if lastToken.value == "First" {
                    if token.type == .number {
                        lastContentToken = token
                        continue
                    } else if lastContentToken.type == .number && token.type == .comma {
                        lastContentToken = token
                        continue
                    } else {
                        return Result(type: .failure, failureValue: ErrorDescription.zvenoNumberInStructure)
                    }
                } else if lastToken.value == "Second" {
                    if token.type == .word {
                        lastContentToken = token
                        continue
                    } else if lastContentToken.type == .word && token.value == "=" {
                        lastToken = lastContentToken
                        lastContentToken = token
                        continue
                    } else {
                        return Result(type: .failure, failureValue: ErrorDescription.zvenoWordInStructure)
                    }
                } else {
                    return Result(type: .failure, failureValue: ErrorDescription.zvenoTypeInStructure)
                }
            }
            
            if lastToken.type == .word {
                if lastContentToken.type == .equal && (token.type == .number || token.type == .word || token.type == .function) {
                    tokensOfVar.append(token)
                    lastContentToken = token
                    continue
                } else if (lastContentToken.type == .equal || lastContentToken.type == .operation || lastContentToken.type == .function) && token.value == "-" {
                    lastContentToken = token
                    continue
                } else if lastContentToken.value == "-" && (token.type == .number || token.type == .word) {
                    token.minus = true
                    tokensOfVar.append(token)
                    lastContentToken = token
                    continue
                } else if (lastContentToken.type == .number || lastContentToken.type == .word) && token.type == .operation {
                    tokensOfVar.append(token)
                    lastContentToken = token
                    continue
                } else if lastContentToken.type == .operation && (token.type == .number || token.type == .word) {
                    tokensOfVar.append(token)
                    lastContentToken = token
                    continue
                } else if (lastContentToken.type == .number || lastContentToken.type == .word) && token.type == .endOfLine {
                    let varStringResult = getVarString(name: lastToken.value, tokens: tokensOfVar)
                    
                    switch varStringResult.type {
                    case .success:
                        guard let str = varStringResult.successVarValue else {
                            return Result(type: .failure, failureValue: ErrorDescription.getVarString)
                        }
                        result.append(str)
                        tokensOfVar = []
                        lastContentToken = token
                        continue
                    case .failure:
                        let failureValue = varStringResult.failureValue
                        return Result(type: .failure, failureValue: failureValue)
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
                    return Result(type: .success, successValue: result)
                } else {
                    return Result(type: .failure, failureValue: ErrorDescription.variableInStructure)
                }
            }
        }
        
        return Result(type: .failure, failureValue: ErrorDescription.incorrectTermination)
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
        var values: [Int] = []
        var operations: [String] = []
        var declared = false
        
        for token in tokens {
            switch token.type {
            case .number:
                guard var intValue = Int(token.value) else {
                    return Result(type: .failure, failureValue: ErrorDescription.convertToInt)
                }
                
                if token.minus {
                    intValue *= -1
                }
                
                values.append(intValue)
            case .operation, .function:
                operations.append(token.value)
            case .word:
                for declaredVariable in declaredVariables {
                    if token.value == declaredVariable.name {
                        
                        if token.minus {
                            declaredVariable.value *= -1
                        }
                        
                        values.append(declaredVariable.value)
                        declared = true
                    }
                }
                
                if !declared {
                    return Result(type: .failure, failureValue: ErrorDescription.varNotDeclared(name: token.value))
                }
            default:
                continue
            }
        }
        
        let result = calculate(values: values, operations: operations)
        guard let result = result else {
            return Result(type: .failure, failureValue: ErrorDescription.calculate)
        }

        self.declaredVariables.append(DeclaredVariables(name: name, value: result))
        let variable = "\(name) = \(result)"
        print(variable)
        return Result(type: .success, successVarValue: variable)
    }
    
    private func calculate(values: [Int], operations: [String]) -> Int? {
        var values = values
        var operations = operations
        
        var i = 0
        for operation in operations {
            if operation == "sin" || operation == "cos" || operation == "tg" || operation == "ctg" {
                switch operation {
                case "sin":
                    let equationResult = Int(sin(Double(values[i])))
                    values[i] = equationResult
                case "cos":
                    let equationResult = Int(cos(Double(values[i])))
                    values[i] = equationResult
                case "tg":
                    let equationResult = Int(tan(Double(values[i])))
                    values[i] = equationResult
                case "ctg":
                    let equationResult = Int(1 / tan(Double(values[i])))
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
                let equationResult = Int(pow(Double(values[i]), Double(values[i+1])))
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
                case "+":
                    let equationResult = values[i] + values[i+1]
                    values[i] = equationResult
                case "-":
                    let equationResult = values[i] - values[i+1]
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
