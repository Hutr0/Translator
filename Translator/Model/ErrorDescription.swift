//
//  ErrorDescription.swift
//  Translator
//
//  Created by Леонид Лукашевич on 06.12.2021.
//

import Foundation

struct ErrorDescription {
    
//    static let smw = "Something went wrong..."
//    static let lAnalizer = "Error: LexicalAnalizer cannot analyze the program (wrong symbol)."
//    static let posledneeInStructure = "Error: Program structure was broken ('Последнее')."
//    static let convertToDouble = "Error: Cannot be converted to Double."
//    static let unsuccessfulParsing = "Error: Unsuccessful parsing."
    
    static let lastRow = "Ошибка: Неверный последний элемент строки."
    static let tooMuchBeginOrEnd = "Ошибка: Слишком много 'Begin' или 'End' в структуре программы."
    static let missedBeginOrEnd = "Ошибка: Отсутствует 'Begin' или 'End' в структуре программы."
    static let missedZveno = "Ошибка: Отсутствует Звено в структуре программы."
    static let zvenoInStructure = "Ошибка: Нарушена структура программы (Звено)."
    static let zvenoComma = "Ошибка: Ожидалось число после запятой в Звено 'First'."
    static let zvenoNumber = "Ошибка: Ожидалось число в Звено 'First'."
    static let zvenoTooMuchNumbers = "Ошибка: Элементы Звено 'First' должны быть написаны в одну строку."
    static let zvenoTooMuchWords = "Ошибка: Элементы Звено 'Second' должны быть написаны в одну строку."
    static let zvenoWord = "Ошибка: Ожидалась Переменная в Звено 'Second'."
    static let zvenoElememtMissedInStructure = "Ошибка: Нарушена структура программы. Ожидалось 'First' или 'Second' в Звено."
    static let minus = "Ошибка: Слишком много минусов."
    static let getVarString = "Ошибка: Невозможно получить строку переменной."
    static let variableInStructure = "Ошибка: Нарушена структура программы (Переменная)"
    static let incorrectTermination = "Ошибка: Программы была завершена некорректно."
    static let calculate = "Ошибка: Невозможно посчитать результат."
    static let failureValueOrPlace = "Ошибка: Значение 'failureValue' или 'failurePlace' равно nil. Невозможно вернуть ошибку."
    static let getParserFailure = "Ошибка: Функиця 'getParserFailure' вернула некорректный результат."
    static let lexicalSuccessValue = "Ошибка: 'successValue' лексического анализатора равно nil. Невозможно вернуть результат."
    
    static func varNotDeclared(name: String) -> String {
        return "Ошибка: '\(name)' переменная не объявлена."
    }
    
    static func wrongSymbol(symbol: Character) -> String {
        return "Ошибка: Лексический анализатор не смог проанализировать программу. Неверный символ: '\(symbol)'."
    }
    
    static func convertToDouble(value: String) -> String {
        return "Ошибка: '\(value)' Невозможно преобразовать в Double."
    }
}
