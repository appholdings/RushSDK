//
//  ABTestsError.swift
//  RushSDK
//
//  Created by Andrey Chernyshev on 12.10.2020.
//

struct ABTestsError: Error {
    enum Code {
        case sdkNotInitialized
    }
    
    let code: Code
    let underlyingError: Error?
    
    init(code: Code, underlyingError: Error? = nil) {
        self.code = code
        self.underlyingError = underlyingError
    }
}
