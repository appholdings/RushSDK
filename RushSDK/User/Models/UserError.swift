//
//  UserError.swift
//  RushSDK
//
//  Created by Andrey Chernyshev on 19.10.2020.
//

import AVFoundation

struct UserError: Error {
    enum Code {
        case sdkNotInitialized
        case userTokenNotFound
    }
    
    let code: Code
    let underlyingError: Error?
    
    init(code: Code, underlyingError: Error? = nil) {
        self.code = code
        self.underlyingError = underlyingError
    }
}
