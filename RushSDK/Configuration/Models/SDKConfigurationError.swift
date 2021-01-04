//
//  SDKConfigurationError.swift
//  RushSDK
//
//  Created by Andrey Chernyshev on 04.01.2021.
//

struct ABConfigurationError: Error {
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
