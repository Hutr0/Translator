//
//  Parser.swift
//  Translator
//
//  Created by Леонид Лукашевич on 04.12.2021.
//

import Foundation

class Parser  {
    let stringTokens: [String]
    
    init(stringTokens: [String]) {
        self.stringTokens = stringTokens
    }
    
    func parse() {
        var startIsSet: Bool = false
        var endIsSet: Bool = false
        var tokens: [Token] = []
        var valuesOfVar: [String] = []
        var lastToken: Token = Token(type: nil, value: "")
        var lastContentToken: Token = Token(type: nil, value: "")
        
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
                } else if (type == .startOfProgram && startIsSet) || (type == .endOfProgram && endIsSet) {
                    print("Error: So many Begin or End in the program structure.")
                    return
                }
            }
        }
        
        if tokens.first?.type != .startOfProgram || tokens.last?.type != .endOfProgram {
            print("Error: Missing Begin or End in the program structure.")
            return
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
                print("Error: Zveno.")
                return
            } else if lastToken.type == .zveno && token.type == .zveno {
                lastToken = token
                continue
            }
            
            if lastToken.type == .zveno {
                
                if token.type == .endOfLine {
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
                        print("Error: number Zveno.")
                        return
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
                        print("Error: word Zveno.")
                        return
                    }
                } else {
                    print("Error: type Zveno.")
                    return
                }
            }
            
            if lastToken.type == .word {
                if lastContentToken.type == .equal && (token.type == .number || token.type == .word || token.type == .function) {
                    valuesOfVar.append(token.value)
                    lastContentToken = token
                    continue
                } else if (lastContentToken.type == .number || lastContentToken.type == .word) && token.type == .operation {
                    valuesOfVar.append(token.value)
                    lastContentToken = token
                    continue
                } else if lastContentToken.type == .operation && (token.type == .number || token.type == .word) {
                    valuesOfVar.append(token.value)
                    lastContentToken = token
                    continue
                } else if (lastContentToken.type == .number || lastContentToken.type == .word) && token.type == .endOfLine {
                    getVar(name: lastToken.value, values: valuesOfVar)
                    valuesOfVar = []
                    lastContentToken = token
                    continue
                } else if lastContentToken.type == .endOfLine && token.type == .word {
                    lastContentToken = token
                    continue
                } else if lastContentToken.type == .word && token.value == "=" {
                    lastToken = lastContentToken
                    lastContentToken = token
                    continue
                } else if lastContentToken.type == .function && (token.type == .number || token.type == .word) {
                    valuesOfVar.append(token.value)
                    lastContentToken = token
                    continue
                } else if lastContentToken.type == .endOfLine && token.type == .endOfProgram {
                    print("Complete")
                    return
                } else {
                    print("Error: ...")
                    return
                }
            }
        }
    }
    
    private func getVar(name: String, values: [String]) {
        print("\(name) = \(values)")
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
