//
//  ProgramExecutor.swift
//  Translator
//
//  Created by Леонид Лукашевич on 15.12.2021.
//

import Foundation

class ProgramExecutor {
    func execute(program: String, completion: @escaping (String, NSMutableAttributedString?) -> ()) {
        let lexicalResult = LexicalWorker.getLexicalResult(program: program)
        
        switch lexicalResult.type {
        case .success:
            guard let tokens = lexicalResult.successValue else { return }
            
            let parserResult = ParserWorker.getParserResult(tokens: tokens, program: program)
            
            completion(parserResult.0, parserResult.1)
        case .failure:
            guard let failureValue = lexicalResult.failureValue,
                    let failurePlace = lexicalResult.failurePlace
            else {
                completion(ErrorDescription.failureValueOrPlace, nil)
                return
            }
            
            let error = LexicalWorker.getLexicalFailure(of: failureValue, in: failurePlace, program: program)
            
            completion(error.0, error.1)
        }
    }
}
