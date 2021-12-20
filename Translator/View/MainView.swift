//
//  ViewController.swift
//  Translator
//
//  Created by Леонид Лукашевич on 02.12.2021.
//

import Cocoa

class MainView: NSViewController {

    @IBOutlet var languageFormat: NSTextView!{
        didSet {
            languageFormat.string = controller.getLanguage()
        }
    }
    @IBOutlet var output: NSTextView!
    
    @IBOutlet var rowsOfProgram: NSTextView! {
        didSet {
            rowsOfProgram.alignment = .right
            rowsOfProgram.string = "1"
        }
    }
    @IBOutlet weak var rowsScrollView: NSScrollView!
    
    @IBOutlet var program: NSTextView!
    @IBOutlet weak var programScrollView: NSScrollView!
    
    let controller = MainController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        program.delegate = self
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(boundsDidChangeNotification),
                                               name: NSView.boundsDidChangeNotification,
                                               object: programScrollView.contentView)
    }
    
    @IBAction func testProgramButton(_ sender: NSButton) {
        program.string = controller.getTestProgram()
        setCorrectlyRowsCount()
    }
    
    @IBAction func clearButtonTapped(_ sender: NSButton) {
        rowsOfProgram.string = "1"
        program.string = ""
        output.string = ""
    }
    
    @IBAction func executeButtonTapped(_ sender: NSButton) {
        controller.execute(program: program.string) { [weak self] result in
            guard let self = self else { return }
            
            self.output.string = result
        }
    }
}

extension MainView: NSTextViewDelegate {
    
    func textDidChange(_ notification: Notification) {
       setCorrectlyRowsCount()
    }
    
    private func setCorrectlyRowsCount() {
        while true {
            let rowsCount = self.rowsOfProgram.string.components(separatedBy: "\n").count
            let programRowsCount = self.program.string.components(separatedBy: "\n").count
            let last = self.rowsOfProgram.string.components(separatedBy: "\n").last
            
            if rowsCount < programRowsCount {
                controller.addRows(last: last) { num in
                    self.rowsOfProgram.string += "\n\(num)"
                }
            } else if rowsCount > programRowsCount {
                controller.deleteRows(last: last) {
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
