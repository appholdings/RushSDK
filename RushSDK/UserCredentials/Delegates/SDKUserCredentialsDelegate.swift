//
//  SDKUserCredentialsDelegate.swift
//  RushSDK
//
//  Created by Andrey Chernyshev on 12.10.2020.
//

protocol SDKUserCredentialsDelegate: class {
    func sdkUserCredentialsDidUpdated(userId: String, userToken: String)
}

extension SDKUserCredentialsDelegate {
    func sdkUserCredentialsDidUpdated(userId: String, userToken: String) {}
}
