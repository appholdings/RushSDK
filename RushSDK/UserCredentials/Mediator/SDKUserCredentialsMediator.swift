//
//  SDKUserCredentialsProvider.swift
//  RushSDK
//
//  Created by Andrey Chernyshev on 12.10.2020.
//

public final class SDKUserCredentialsMediator {
    static let shared = SDKUserCredentialsMediator()
    
    private var featureAppDelegates = [Weak<SDKUserCredentialsFeatureAppDelegate>]()
    private var sdkDelegates = [Weak<SDKUserCredentialsDelegate>]()
    
    private init() {}
}

// MARK: API(Public)
extension SDKUserCredentialsMediator {
    // Вызывается из фиче-приложения для уведомления SDK об изменении/получении
    public func notifySDKAboutUpdate(userId: String, userToken: String) {
        DispatchQueue.main.async {
            SDKUserCredentialsMediator.shared.sdkDelegates.forEach { $0.weak?.sdkUserCredentialsDidUpdated(userId: userId, userToken: userToken) }
        }
    }
    
    // Вызывается самим SDK для уведомления фиче-приложения об изменении/получении
    func notifyAboutUpdate(userCredentials: SDKUserCredentials) {
        DispatchQueue.main.async {
            SDKUserCredentialsMediator.shared.featureAppDelegates.forEach { $0.weak?.sdkUserCredentialsDidUpdated(credentials: userCredentials) }
        }
    }
}

// MARK: Observer
extension SDKUserCredentialsMediator {
    public func add(featureAppDelegate: SDKUserCredentialsFeatureAppDelegate) {
        let weakly = featureAppDelegate as AnyObject
        featureAppDelegates.append(Weak<SDKUserCredentialsFeatureAppDelegate>(weakly))
        featureAppDelegates = featureAppDelegates.filter { $0.weak != nil }
    }
    
    public func remove(featureAppDelegate: SDKUserCredentialsFeatureAppDelegate) {
        if let index = featureAppDelegates.firstIndex(where: { $0.weak === featureAppDelegate }) {
            featureAppDelegates.remove(at: index)
        }
    }
    
    func add(sdkDelegate: SDKUserCredentialsDelegate) {
        let weakly = sdkDelegate as AnyObject
        sdkDelegates.append(Weak<SDKUserCredentialsDelegate>(weakly))
        sdkDelegates = sdkDelegates.filter { $0.weak != nil }
    }
    
    func remove(sdkDelegate: SDKUserCredentialsDelegate) {
        if let index = sdkDelegates.firstIndex(where: { $0.weak === sdkDelegate }) {
            sdkDelegates.remove(at: index)
        }
    }
}
