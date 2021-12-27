//
//  MainController.swift
//  Translator
//
//  Created by Леонид Лукашевич on 03.12.2021.
//

import Foundation

class MainController {
    
    //MARK: - Вспомогательные сервисы
    
    private let data = MainData()
    private let rowsEditor = RowsEditor()
    private let executor = ProgramExecutor()
    
    //MARK: - Язык и Тестовая программа
    
    func getLanguage() -> String {
        return data.language
    }
    
    func getTestProgram() -> String {
        return data.testProgram
    }
    
    //MARK: - Настройка строк
    
    func addRows(last: String?, completion: @escaping (Int) -> ()) {
        rowsEditor.addRows(last: last, completion: completion)
    }
    
    func deleteRows(last: String?, completion: @escaping () -> ()) {
        rowsEditor.deleteRows(last: last, completion: completion)
    }
    
    //MARK: - Выполнение программы
    
    func execute(program: String, completion: @escaping (String, NSMutableAttributedString?) -> ()) {
        executor.execute(program: program, completion: completion)
    }
}
