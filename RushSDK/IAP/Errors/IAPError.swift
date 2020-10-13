//
//  IAPError.swift
//  RushSDK
//
//  Created by Andrey Chernyshev on 08.10.2020.
//

public struct IAPError: Error {
    public enum Code {
        case paymentsDisabled
        case paymentFailed
        case cannotRestorePurchases
    }

    public let code: Code
    public let underlyingError: Error?

    init(_ code: Code, underlyingError: Error? = nil) {
        self.code = code
        self.underlyingError = underlyingError
    }
}
