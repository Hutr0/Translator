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
    0,2,4,3
    First
    56,6,1
    Second
    d7da uh312d d2
    param1 = 1 + 2
    ar13 = 12 * 2
    arg = 14^2
    p2 = param1 / 2
    p = sin p2
    End
    """
    
    func addRows(last: String?, completion: @escaping (Int) -> ()) {
        guard let last = last,
              let intLast = Int(last)
        else {
            print("Error: Invalid last row element.")
            return
        }
        
        let num = intLast + 1
        completion(num)
    }
    
    func deleteRows(_ self: MainView) {
        guard let last = self.rowsOfProgram.string.components(separatedBy: "\n").last else {
            print("Error: Invalid last row element.")
            return
        }
        
        for _ in 0...last.count {
            self.rowsOfProgram.string.removeLast()
        }
        
        let rowsCount = self.rowsOfProgram.string.components(separatedBy: "\n").count
        let programRowsCount = self.program.string.components(separatedBy: "\n").count
        
        if rowsCount > programRowsCount {
            deleteRows(self)
        }
    }
    
    func startAnalyze(program: String) {
        let lAnalizer = LexicalAnalyzer(inputProgram: program)
        
        guard let tokens = lAnalizer.tokenize() else { return }
        
        let parser = Parser(stringTokens: tokens)
        parser.parse()
    }
}
