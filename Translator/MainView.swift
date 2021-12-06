//
//  ViewController.swift
//  Translator
//
//  Created by Леонид Лукашевич on 02.12.2021.
//

import Cocoa

class MainView: NSViewController {

    @IBOutlet var languageFormat: NSTextView!
    @IBOutlet var output: NSTextView!
    
    @IBOutlet var rowsOfProgram: NSTextView!
    @IBOutlet weak var rowsScrollView: NSScrollView!
    
    @IBOutlet var program: NSTextView!
    @IBOutlet weak var programScrollView: NSScrollView!
    
    let controller = MainController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        program.delegate = self
        
        languageFormat.string = controller.language
        program.string = controller.testProgram
        
        rowsOfProgram.alignment = .right
        rowsOfProgram.string = "1"
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(boundsDidChangeNotification),
                                               name: NSView.boundsDidChangeNotification,
                                               object: programScrollView.contentView)
    }
    
    @IBAction func clearButtonTapped(_ sender: Any) {
        rowsOfProgram.string = "1"
        program.string = ""
    }
    
    @IBAction func executeButtonTapped(_ sender: Any) {
        controller.execute(program: program.string)
    }
}

extension MainView: NSTextViewDelegate {
    
    func textDidChange(_ notification: Notification) {
        while true {
            let rowsCount = self.rowsOfProgram.string.components(separatedBy: "\n").count
            let programRowsCount = self.program.string.components(separatedBy: "\n").count
            let last = self.rowsOfProgram.string.components(separatedBy: "\n").last
            
            if rowsCount < programRowsCount {
                controller.addRows(last: last) { [weak self] num in
                    guard let self = self else { return }
                    
                    self.rowsOfProgram.string += "\n\(num)"
                }
            } else if rowsCount > programRowsCount {
                controller.deleteRows(last: last) { [weak self] in
                    guard let self = self else { return }
                    
                    self.rowsOfProgram.string.removeLast()
                }
            } else {
                return
            }
        }
    }
    
    @objc func boundsDidChangeNotification() {
        self.rowsScrollView.scroll(self.rowsScrollView.contentView, to: self.programScrollView.documentVisibleRect.origin)
    }
}
