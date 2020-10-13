//
//  PurchaseError.swift
//  RushSDK
//
//  Created by Andrey Chernyshev on 13.10.2020.
//

public struct PurchaseError: Error {
    public enum Code {
        case sdkNotInitialized
    }
    
    public let code: Code
    public let underlyingError: Error?
    
    init(code: Code, underlyingError: Error? = nil) {
        self.code = code
        self.underlyingError = underlyingError
    }
}
