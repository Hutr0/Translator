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

        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

