//
//  MainController.swift
//  Translator
//
//  Created by Леонид Лукашевич on 03.12.2021.
//

import Foundation

class MainController {
    
    let language = """
    Язык = "Begin" Звено...Звено Последнее Опер...Опер "End"
    Звено = "First" Цел","...Цел ! "Second" Перем...Перем
    Последнее = Перем "=" Прав.часть
    Опер = Перем "=" Прав.часть
    Прав.часть = </-/> Бл1 Зн1 Бл1
    Зн1 = "+" ! "-"
    Бл1 = Бл2 Зн2 Бл2
    Зн2 = "*" ! "/"
    Бл2 = Бл3 Зн3 Бл3
    Зн3 = "^"
    Бл3 = Функц Бл4
    Функц = "sin" ! "cos" ! ... ! "ctg"
    Бл4 = [Перем ! Цел]
    Перем = букв </знач...знач/>
    знач = [букв ! Цел]
    Цел = цифр...цифр
    цифр = "0"..."7"
    букв = "a"..."z"
    """
    
    let testProgram = """
    Begin
    
    First
    1, 2, 34, 5
    
    Second
    a b
    
    Second
    tr45 t3
    
    a = 1
    a = a * 10^2
    b = 12 + 3 - ctg 2 * 10 ^ 2
    b = b - 10
    c = ctg 2
    c = b / c
    
    End
    """
    
    func addRows(last: String?, completion: @escaping (Int) -> ()) {
        guard let last = last,
              let intLast = Int(last)
        else {
            print(ErrorDescription.lastRow)
            return
        }
        
        let num = intLast + 1
        completion(num)
    }
    
    func deleteRows(last: String?, completion: @escaping () -> ()) {
        guard let last = last else {
            print(ErrorDescription.lastRow)
            return
        }
        
        for _ in 0...last.count {
            completion()
        }
    }
    
    func execute(program: String, completion: @escaping (String) -> ()) {
        let result = LexicalAnalyzer.tokenize(inputProgram: program)
        
        switch result.type {
        case .success:
            guard let tokens = result.successValue else { return }
            
            let parserResult = Parser().parse(stringTokens: tokens)
            
            switch parserResult.type {
            case .success:
                guard let values = parserResult.successValue else { return }
                var resultString = ""

                for value in values {
                    resultString += "\(value)\n"
                }

                completion(resultString)
            case .failure:
                guard let failureValue = parserResult.failureValue,
                        let failurePlace = parserResult.failurePlace
                else { return }
                
                var tokenCount = 0
                var rowCount = 0
                var lastToken: String = "<ERROR>"
                for token in tokens {
                    tokenCount += 1
                    if tokenCount == failurePlace {
                        if lastToken == "\\n" {
                            completion("[After '\(lastToken)' in \(rowCount) row] \(failureValue)")
                        } else {                        
                            completion("[After '\(lastToken)' in \(rowCount+1) row] \(failureValue)")
                        }
                        return
                    }
                    if token == "\n" {
                        rowCount += 1
                        lastToken = "\\n"
                    } else {
                        lastToken = token
                    }
                }
                
                completion(failureValue)
            }
        case .failure:
            guard let failureValue = result.failureValue,
                    let failurePlace = result.failurePlace
            else { return }
            
            var i = 0
            var rowCount = 0
            for symbol in program {
                i += 1
                if i == failurePlace {
                    completion("[\(rowCount+1) row]: \(failureValue)")
                    return
                }
                if symbol == "\n" {
                    rowCount += 1
                }
            }
            
            completion(failureValue)
        }
    }
}
