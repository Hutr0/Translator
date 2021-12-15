//
//  RowsEditor.swift
//  Translator
//
//  Created by Леонид Лукашевич on 15.12.2021.
//

import Foundation

struct RowsEditor {
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
}
