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
    static let missedBegin = "Ошибка: Отсутствует 'Begin' в структуре программы."
    static let missedEnd = "Ошибка: Отсутствует 'End' в структуре программы."
    static let isNotStart = "Ошибка: 'Begin' должен быть первым элементом в программе."
    static let isNotEnd = "Ошибка: 'End' должен быть последним элементом в программе."
    
    static let missedZveno = "Ошибка: Ожидалось Звено в структуре программы."
    static let zvenoInStructure = "Ошибка: Нарушена структура программы (Звено)."
    static let noOneElementInFirst = "Ошибка: В Звено 'First' отсутствуют элементы."
    static let noOneElementInSecond = "Ошибка: В Звено 'Second' отсутствуют элементы."
    static let zvenoElememtMissedInStructure = "Ошибка: Нарушена структура программы. Ожидалось 'First' или 'Second' в Звено."
    
    static let zvenoComma = "Ошибка: Ожидалось число после запятой в Звено 'First'."
    static let zvenoNumber = "Ошибка: Ожидалось число в Звено 'First'."
    static let missedNumberAndVar = "Ошибка: Ожидалось число в Звено 'First' и ожидалась Последнее в структуре программы."
    static let missedFirstVar = "Ошибка: Ожидалось Последнее в структуре программы после Звено 'First'."
    static let zvenoTooMuchNumbers = "Ошибка: Элементы в Звено 'First' должны быть написаны в одну строку."
    static let firstZvenoInStructure = "Ошибка: Нарушена структура в Звено 'First'."
    
    static let zvenoTooMuchWords = "Ошибка: Элементы в Звено 'Second' должны быть написаны в одну строку."
    static let zvenoWord = "Ошибка: Ожидалась Переменная в Звено 'Second'."
    static let missedWordAndVar = "Ошибка: Ожидалась Переменная в Звено 'Second' и ожидалась Последнее в структуре программы."
    static let missedSecondVar = "Ошибка: Ожидалось Последнее в структуре программы после Звено 'Second'."
    static let secondNumber = "Ошибка: Число не может быть в Звено 'Second'. Ожидалась Переменная."
    static let secondZvenoInStructure = "Ошибка: Нарушена структура в Звено 'Second'."
    
    static let minus = "Ошибка: Слишком много минусов."
    static let tooMuchOperations = "Ошибка: Операции не могут идти подряд."
    static let operandsGoInARow = "Ошибка: Операнды не могут идти подряд. Требуется какая-либо операция."
    static let functionGoInARow = "Ошибка: Функция не может идти подряд за операндом без операции с ней. Требуется какая-либо операция."
    static let operationOnEnd = "Ошибка: Операция должна быть между двумя операндами."
    static let functionOnEnd = "Ошибка: У Функции должен быть операнд."
    static let commaInVar = "Ошибка: Запятая не может быть спользована, так как операды целочисленные."
    static let nameOfVar = "Ошибка: Название переменной должно начинаться с буквы."
    static let getVarString = "Ошибка: Невозможно получить строку переменной."
    static let variableInStructure = "Ошибка: Нарушена структура программы (Переменная)."
    static let incorrectTermination = "Ошибка: Программы была завершена некорректно."
    static let calculate = "Ошибка: Невозможно посчитать результат."
    static let failureValueOrPlace = "Ошибка: Значение 'failureValue' или 'failurePlace' равно nil. Невозможно вернуть ошибку."
    static let getParserFailure = "Ошибка: Функция 'getParserFailure' вернула некорректный результат."
    static let lexicalSuccessValue = "Ошибка: 'successValue' лексического анализатора равно nil. Невозможно вернуть результат."
    static let afterEqual = "Ошибка: После знака '=' должно быть выражение или значение."
    static let tooMuchEqual = "Ошибка: Слишком много занков '='."
    static let equalDoesNotExist = "Ошибка: Присвоения значения переменной невозможно, так как с ней проводится операция."
    static let equalForVar = "Ошибка: Присвоения значения возможно только для переменной."
    static let equalInEqual = "Ошибка: Присвоение значения переменной невозможно сразу после присвоения."
    static let wrong = "Ошибка: Неверное значение или название переменной."
    static let operationsAfterEqual = "Ошибка: Данная операция недопустима после знака '='."
    
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

