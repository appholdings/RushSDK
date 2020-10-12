//
//  NetworkError.swift
//  RushSDK
//
//  Created by Andrey Chernyshev on 08.10.2020.
//

public struct NetworkError: Error {
    enum Code {
        case serverNotAvailable
    }

    let code: Code
    let underlyingError: Error?

    init(_ code: Code, underlyingError: Error? = nil) {
        self.code = code
        self.underlyingError = underlyingError
    }
}
