//
//  IAPError.swift
//  RushSDK
//
//  Created by Andrey Chernyshev on 08.10.2020.
//

public struct IAPError: Error {
    enum Code {
        case paymentsDisabled
        case paymentFailed
        case cannotRestorePurchases
    }

    let code: Code
    let underlyingError: Error?

    init(_ code: Code, underlyingError: Error? = nil) {
        self.code = code
        self.underlyingError = underlyingError
    }
}
