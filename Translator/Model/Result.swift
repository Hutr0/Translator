//
//  Result.swift
//  Translator
//
//  Created by Леонид Лукашевич on 06.12.2021.
//

import Foundation

class Result {
    let type: ResultType
    let successValue: [String]?
    let failureValue: String?
    let failurePlace: Int?
    
    init(successValue: [String]) {
        self.type = .success
        self.successValue = successValue
        
        self.failureValue = nil
        self.failurePlace = nil
    }
    
    init(failureValue: String, failurePlace: Int) {
        self.type = .failure
        self.failureValue = failureValue
        self.failurePlace = failurePlace
        
        self.successValue = nil
    }
}

enum ResultType {
    case success
    case failure
}
