//
//  ProgramExecutor.swift
//  Translator
//
//  Created by Леонид Лукашевич on 15.12.2021.
//

import Foundation

class ProgramExecutor {
    func execute(program: String, cursorPosition: NSRange, completion: @escaping (String, NSRange, NSMutableAttributedString?) -> ()) {
        let lexicalResult = LexicalWorker.getLexicalResult(program: program)
        
        switch lexicalResult.type {
        case .success:
            guard let tokens = lexicalResult.successValue else { return }
            
            let parserResult = ParserWorker.getParserResult(tokens: tokens, program: program)
            
            if parserResult.1 == nil {
                completion(parserResult.0, cursorPosition, parserResult.2)
            } else {
                completion(parserResult.0, parserResult.1!, parserResult.2)
            }
        case .failure:
            guard let failureValue = lexicalResult.failureValue,
                    let failurePlace = lexicalResult.failurePlace
            else {
                completion(ErrorDescription.failureValueOrPlace, cursorPosition, nil)
                return
            }
            
            let error = LexicalWorker.getLexicalFailure(of: failureValue, in: failurePlace, program: program)
            
            if error.1 == nil {
                completion(error.0, cursorPosition, error.2)
            } else {
                completion(error.0, error.1!, error.2)
            }
        }
    }
}
