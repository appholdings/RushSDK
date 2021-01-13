//
//  SDKUserManagerMediatorDelegate.swift
//  RushSDK
//
//  Created by Andrey Chernyshev on 13.01.2021.
//

public protocol SDKUserManagerMediatorDelegate: class {
    func userManagerMediatorDidReceivedFeatureApp(userToken: String)
}

public extension SDKUserManagerMediatorDelegate {
    func userManagerMediatorDidReceivedFeatureApp(userToken: String) {}
}
