//
//  ViewController.swift
//  Translator
//
//  Created by Леонид Лукашевич on 02.12.2021.
//

import Cocoa

class MainViewController: NSViewController {

    @IBOutlet var languageFormat: NSTextView!
    @IBOutlet var rowsOfProgram: NSTextView!
    @IBOutlet var program: NSTextView!
    @IBOutlet var output: NSTextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        program.delegate = self

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
        
        languageFormat.string = language
        rowsOfProgram.string = "1"
    }
    
    @IBAction func clearButtonTapped(_ sender: Any) {
        program.string = ""
        rowsOfProgram.string = ""
    }
    
    @IBAction func executeButtonTapped(_ sender: Any) {
    }
}

extension MainViewController: NSTextViewDelegate {
    
    func textDidChange(_ notification: Notification) {
        let rowsCount = self.rowsOfProgram.string.components(separatedBy: "\n").count
        let programRowsCount = self.program.string.components(separatedBy: "\n").count
        
        if rowsCount < programRowsCount {
            addRows()
        } else if rowsCount > programRowsCount {
            deleteRows()
        }
    }
    
    private func addRows() {
        guard let last = self.rowsOfProgram.string.components(separatedBy: "\n").last,
              let intLast = Int(last)
        else {
            print("Error: Invalid last row element.")
            return
        }
        
        let num = intLast + 1
        self.rowsOfProgram.string += "\n\(num)"
    }
    
    private func deleteRows() {
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
            deleteRows()
        }
    }
}

