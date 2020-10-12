//
//  SDKUserCredentialsFeatureAppDelegate.swift
//  RushSDK
//
//  Created by Andrey Chernyshev on 12.10.2020.
//

public protocol SDKUserCredentialsFeatureAppDelegate: class {
    func sdkUserCredentialsDidUpdated(credentials: SDKUserCredentials)
}

public extension SDKUserCredentialsFeatureAppDelegate {
    func sdkUserCredentialsDidUpdated(credentials: SDKUserCredentials) {}
}
