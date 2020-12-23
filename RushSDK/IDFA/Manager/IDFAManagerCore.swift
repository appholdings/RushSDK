//
//  IDFAManagerCore.swift
//  RushSDK
//
//  Created by Andrey Chernyshev on 23.12.2020.
//

import AdSupport

final class IDFAManagerCore: IDFAManager {
    static let shared = IDFAManagerCore()
    
    private init() {}
}

// MARK: IDFAManager
extension IDFAManagerCore {
    func getIDFA() -> String {
        ASIdentifierManager.shared().advertisingIdentifier.uuidString
    }
    
    func isAdvertisingTrackingEnabled() -> Bool {
        ASIdentifierManager.shared().isAdvertisingTrackingEnabled
    }
}
