//
//  ViewController.swift
//  Translator
//
//  Created by Леонид Лукашевич on 02.12.2021.
//

import Cocoa

class MainViewController: NSViewController {

    @IBOutlet var languageFormat: NSTextView!
    @IBOutlet var linesOfProgram: NSTextView!
    @IBOutlet var program: NSTextView!
    @IBOutlet var output: NSTextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
    }
    
    @IBAction func clearButtonTapped(_ sender: Any) {
        program.string = ""
        linesOfProgram.string = ""
    }
    
    @IBAction func executeButtonTapped(_ sender: Any) {
    }
}

