//
//  AppsFlyerManagerCore.swift
//  RushSDK
//
//  Created by Andrey Chernyshev on 24.02.2021.
//

import UIKit
import AppsFlyerLib

final class AppsFlyerManagerCore: AppsFlyerManager {
    static let shared = AppsFlyerManagerCore()
    
    private init() {}
}

// MARK: AppsFlyerManager
extension AppsFlyerManagerCore {
    @discardableResult
    func initialize() -> Bool {
        guard
            let appsFlyerApiKey = SDKStorage.shared.appsFlyerApiKey,
            let appleAppID = SDKStorage.shared.appleAppID
        else {
            log(text: "appsFlyer not actiive")
            return false
        }
        
        AppsFlyerLib.shared().appsFlyerDevKey = appsFlyerApiKey
        AppsFlyerLib.shared().appleAppID = appleAppID
        
        FeatureAppMediator.shared.add(delegate: self)
        SDKPurchaseMediator.shared.add(delegate: self)
        
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        AppsFlyerLib.shared().start()
    }
}

// MARK: FeatureAppMediatorDelegate
extension AppsFlyerManagerCore: FeatureAppMediatorDelegate {
    func featureAppMediatorDidUpdate(userId: String, userToken: String) {
        set(userId: userId)
    }
}

// MARK: SDKPurchaseMediatorDelegate
extension AppsFlyerManagerCore: SDKPurchaseMediatorDelegate {
    func purchaseMediatorDidValidateReceipt(response: ReceiptValidateResponse?) {
        if let userId = response?.userId {
            set(userId: String(userId))
        }
    }
}

// MARK: AppsFlyerManager
private extension AppsFlyerManagerCore {
    func isActiive() -> Bool {
        SDKStorage.shared.appsFlyerApiKey != nil && SDKStorage.shared.appleAppID != nil
    }
    
    func set(userId: String) {
        AppsFlyerLib.shared().customerUserID = userId
    }
}
