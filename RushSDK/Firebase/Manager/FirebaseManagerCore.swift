//
//  FirebaseManagerCore.swift
//  RushSDK
//
//  Created by Andrey Chernyshev on 21.10.2020.
//

import FirebaseAnalytics

final class FirebaseManagerCore: FirebaseManager {
    static let shared = FirebaseManagerCore()
    
    private init() {}
}

// MARK: FirebaseManager
extension FirebaseManagerCore {
    @discardableResult
    func initialize() -> Bool {
        guard SDKStorage.shared.isFirstLaunch else {
            log(text: "firebase not active")
            
            return false
        }
        
        SDKIAPMediator.shared.add(delegate: self)
        
        installFirstLaunchIfNeeded()
        
        return true 
    }
}

// MARK: SDKIAPMediatorDelegate
extension FirebaseManagerCore: SDKIAPMediatorDelegate {
    func iapMediatorBiedProduct(with result: IAPActionResult) {
        logEvent(name: "start_trial")
    }
}

// MARK: Private
private extension FirebaseManagerCore {
    func logEvent(name: String, parameters: [String: Any] = [:]) {
        var dictionary = parameters
        dictionary["anonymous_id"] = SDKStorage.shared.applicationAnonymousID
        
        Analytics.logEvent(name, parameters: dictionary)
        
        log(text: "firebase log event with name: \(name), parameters: \(dictionary)")
    }
    
    func installFirstLaunchIfNeeded() {
        guard SDKStorage.shared.isFirstLaunch else {
            return
        }
        
        logEvent(name: "install_app")
    }
}
