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
    let successVarValue: String?
    let failureValue: String?
    
    init(type: ResultType, successValue: [String]? = nil, successVarValue: String? = nil, failureValue: String? = nil) {
        self.type = type
        self.successValue = successValue
        self.successVarValue = successVarValue
        self.failureValue = failureValue
    }
}

enum ResultType {
    case success
    case failure
}
