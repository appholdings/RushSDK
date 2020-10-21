//
//  AmplitudeManagerCore.swift
//  RushSDK
//
//  Created by Andrey Chernyshev on 14.10.2020.
//

import Amplitude_iOS

final class AmplitudeManagerCore: AmplitudeManager {
    static let shared = AmplitudeManagerCore()
    
    struct Constants {
        static let userIdListKey = "amplitude_manager_core_user_id_list_key"
    }
    
    private init() {}
}

// MARK: AmplitudeManager
extension AmplitudeManagerCore {
    @discardableResult
    func initialize() -> Bool {
        guard isActivate(), let amplitudeApiKey = SDKStorage.shared.amplitudeApiKey else {
            log(text: "amplitude not activate")
            
            return false
        }
        
        Amplitude.instance()?.initializeApiKey(amplitudeApiKey)
        
        setupInputSDKParams()
        installFirstLaunchIfNeeded()
        
        FeatureAppMediator.shared.add(delegate: self)
        SDKPurchaseMediator.shared.add(delegate: self)
        
        return true
    }
    
    func logEvent(name: String, parameters: [String: Any] = [:]) {
        guard isActivate() else {
            return
        }
        
        var dictionary = parameters
        dictionary["anonymous_id"] = SDKStorage.shared.applicationAnonymousID
        
        Amplitude.instance()?.logEvent(name, withEventProperties: dictionary)
        
        log(text: "amplitude log event with name: \(name), parameters: \(dictionary)")
    }
}

// MARK: FeatureAppMediatorDelegate
extension AmplitudeManagerCore: FeatureAppMediatorDelegate {
    func featureAppMediatorDidUpdate(userId: Int, userToken: String) {
        set(userId: userId)
        syncedUserIdIfNeeded(userId)
    }
}

// MARK: SDKPurchaseMediatorDelegate
extension AmplitudeManagerCore: SDKPurchaseMediatorDelegate {
    func purchaseMediatorDidValidateReceipt(response: ReceiptValidateResponse?) {
        if let userId = response?.userId {
            set(userId: userId)
            syncedUserIdIfNeeded(userId)
        }
    }
}

// MARK: Private
private extension AmplitudeManagerCore {
    func isActivate() -> Bool {
        SDKStorage.shared.amplitudeApiKey != nil && SDKStorage.shared.applicationTag != nil
    }
    
    func setupInputSDKParams() {
        if let userId = SDKStorage.shared.userId {
            set(userId: userId)
            syncedUserIdIfNeeded(userId)
        }
    }
    
    func set(userId: Int) {
        guard let applicationTag = SDKStorage.shared.applicationTag else {
            return
        }
        
        let logTag = String(format: "%@_%i", applicationTag, userId)
        
        Amplitude.instance()?.setUserId(logTag)
        
        log(text: "amplitude set userId: \(logTag)")
    }
    
    func syncedUserIdIfNeeded(_ userId: Int) {
        var userIdList = UserDefaults.standard.array(forKey: Constants.userIdListKey) as? [Int] ?? [Int]()
        
        if !userIdList.contains(userId) {
            logEvent(name: "UserIDSynced")
            
            userIdList.append(userId)
            
            UserDefaults.standard.set(userIdList, forKey: Constants.userIdListKey)
        }
    }
    
    func installFirstLaunchIfNeeded() {
        guard SDKStorage.shared.isFirstLaunch else {
            return 
        }
        
        logEvent(name: "First Launch")
    }
}
