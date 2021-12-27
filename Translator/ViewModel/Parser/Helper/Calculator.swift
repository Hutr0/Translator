//
//  Calculator.swift
//  Translator
//
//  Created by Леонид Лукашевич on 15.12.2021.
//

import Foundation

class Calculator {
    
    var declaredVariables: [DeclaredVariable] = []
    
    /// Get result string of variable and calculated result
    /// - Parameters:
    ///   - name: Variable name
    ///   - tokens: Tokens for calculate of variable (numbers, operatons, ...)
    /// - Returns: String of variable and calculated result
    func getVarString(name: String, tokens: [Token]) -> Result {
        
        var values: [Double] = []
        var operations: [String] = []
        
        var currentDeclaredVariables: [DeclaredVariable] = []
        
        for token in tokens {
            var declared = false
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
                var currentVariables: [String: Double] = [:]
                
                for declaredVariable in declaredVariables {
                    var a: Bool = true
                    
                    if token.value == declaredVariable.name {
                        
                        for currentVariable in currentVariables {
                            if declaredVariable.name == currentVariable.key {
                                currentVariables.updateValue(declaredVariable.value, forKey: declaredVariable.name)
                                a = false
                            }
                        }
                        
                        if token.minus {
                            declaredVariable.value *= -1
                        }
                        
                        if a {
                            currentVariables[declaredVariable.name] = declaredVariable.value
                        }
                        declared = true
                    }
                }
                
                for currentVariable in currentVariables {
                    values.append(currentVariable.value)
                    let dVar = DeclaredVariable(name: currentVariable.key, value: currentVariable.value)
                    currentDeclaredVariables.append(dVar)
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
        
        let dVariable = DeclaredVariable(name: name, value: result)
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
    
    /// Calcualte variable
    /// - Parameters:
    ///   - values: Digits
    ///   - operations: Operations
    /// - Returns: Result of calculation for variable
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
}
