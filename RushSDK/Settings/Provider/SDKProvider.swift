//
//  SDKProvider.swift
//  RushSDK
//
//  Created by Andrey Chernyshev on 09.10.2020.
//

import UIKit

// MARK: Точка входа в SDK

public final class SDKProvider {}

// MARK: Инициализация SDK

public extension SDKProvider {
    func initialize(settings: SDKSettings) {
        let storage = SDKStorage.shared
        
        storage.backendBaseUrl = settings.backendBaseUrl
        storage.backendApiKey = settings.backendApiKey
        storage.amplitudeApiKey = settings.amplitudeApiKey
        storage.facebookActive = settings.facebookActive
        storage.branchActive = settings.branchActive
        storage.applicationTag = settings.applicationTag
        storage.userToken = settings.userToken
        storage.userId = settings.userId
        storage.isTest = settings.isTest
    }
}

// MARK: Триггеры из AppDelegate

public extension SDKProvider {
    func application(_ app: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) {
        
    }
    
    func application(_ app: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) {
        
    }
}
