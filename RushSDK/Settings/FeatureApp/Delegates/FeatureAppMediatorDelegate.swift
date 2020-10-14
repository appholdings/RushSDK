//
//  UserCredentialsMediatorDelegate.swift
//  RushSDK
//
//  Created by Andrey Chernyshev on 13.10.2020.
//

protocol FeatureAppMediatorDelegate: class {
    func featureAppMediatorDidUpdate(userId: Int, userToken: String)
}

extension FeatureAppMediatorDelegate {
    func featureAppMediatorDidUpdate(userId: Int, userToken: String) {}
}
