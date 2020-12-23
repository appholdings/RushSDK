//
//  IDFAManager.swift
//  RushSDK
//
//  Created by Andrey Chernyshev on 23.12.2020.
//

protocol IDFAManager {
    func getIDFA() -> String
    func isAdvertisingTrackingEnabled() -> Bool
}
