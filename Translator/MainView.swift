//
//  ViewController.swift
//  Translator
//
//  Created by Леонид Лукашевич on 02.12.2021.
//

import Cocoa

class MainView: NSViewController {

    @IBOutlet var languageFormat: NSTextView!
    @IBOutlet var rowsOfProgram: NSTextView!
    @IBOutlet var program: NSTextView!
    @IBOutlet var output: NSTextView!
    
    let controller = MainController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        program.delegate = self
        
        languageFormat.string = controller.language
        rowsOfProgram.string = "1"
    }
    
    @IBAction func clearButtonTapped(_ sender: Any) {
        program.string = ""
        rowsOfProgram.string = "1"
    }
    
    @IBAction func executeButtonTapped(_ sender: Any) {
    }
}

extension MainView: NSTextViewDelegate {
    
    func textDidChange(_ notification: Notification) {
        let rowsCount = self.rowsOfProgram.string.components(separatedBy: "\n").count
        let programRowsCount = self.program.string.components(separatedBy: "\n").count
        
        if rowsCount < programRowsCount {
            let last = self.rowsOfProgram.string.components(separatedBy: "\n").last
            controller.addRows(last: last) { num in
                self.rowsOfProgram.string += "\n\(num)"
            }
        } else if rowsCount > programRowsCount {
            controller.deleteRows(self)
        }
    }
}

