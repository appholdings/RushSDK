//
//  UserCredentialsMediatorDelegate.swift
//  RushSDK
//
//  Created by Andrey Chernyshev on 13.10.2020.
//

protocol UserCredentialsMediatorDelegate: class {
    func userCredentialsMediatorDidUpdate(userId: Int, userToken: String)
}

extension UserCredentialsMediatorDelegate {
    func userCredentialsMediatorDidUpdate(userId: Int, userToken: String) {}
}
