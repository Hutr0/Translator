//
//  ProgramExecutor.swift
//  Translator
//
//  Created by Леонид Лукашевич on 15.12.2021.
//

import Cocoa

class ProgramExecutor {
    func execute(program: String, completion: @escaping (String, NSMutableAttributedString?) -> ()) {
        let lexicalResult = LexicalWorker.getLexicalResult(program: program)
        
        switch lexicalResult.type {
        case .success:
            guard let tokens = lexicalResult.successValue else { return }
            
            let parserResult = ParserWorker.getParserResult(tokens: tokens)
            
            completion(parserResult, nil)
        case .failure:
            guard let failureValue = lexicalResult.failureValue,
                    let failurePlace = lexicalResult.failurePlace
            else {
                completion(ErrorDescription.failureValueOrPlace, nil)
                return
            }
            
            let lexicalFailure = LexicalWorker.getLexicalFailure(of: failureValue, in: failurePlace, program: program)
            let error = lexicalFailure.0
            
            guard let symbol = lexicalFailure.1 else {
                completion(error, nil)
                return
            }
            
            let attributedString = NSMutableAttributedString(string:program)

            let stringOneRegex = try! NSRegularExpression(pattern: "\\\(symbol)", options: [])
            let stringOneMatches = stringOneRegex.matches(in: program, options: [], range: NSMakeRange(0, attributedString.length))
            for stringOneMatch in stringOneMatches {
                let wordRange = stringOneMatch.range(at: 0)
                attributedString.addAttribute(.foregroundColor, value: NSColor.red, range: wordRange)
            }
            
            completion(error, attributedString)
        }
    }
}
