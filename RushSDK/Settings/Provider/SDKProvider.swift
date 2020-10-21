//
//  SDKProvider.swift
//  RushSDK
//
//  Created by Andrey Chernyshev on 09.10.2020.
//

import UIKit

// MARK: Точка входа в SDK
public final class SDKProvider {
    private let sdkInitializator = SDKInitializator()
    
    public init() {}
}

// MARK: Инициализация SDK
public extension SDKProvider {
    func initialize(settings: SDKSettings, completion: (() -> Void)? = nil) {
        let storage = SDKStorage.shared
        
        storage.backendBaseUrl = settings.backendBaseUrl
        storage.backendApiKey = settings.backendApiKey
        storage.amplitudeApiKey = settings.amplitudeApiKey
        storage.facebookActive = settings.facebookActive
        storage.branchActive = settings.branchActive
        storage.firebaseActive = settings.firebaseActive
        storage.applicationTag = settings.applicationTag
        storage.userToken = settings.userToken
        storage.userId = settings.userId
        storage.view = settings.view
        storage.shouldAddStorePayment = settings.shouldAddStorePayment
        storage.isTest = settings.isTest
        
        SDKNumberLaunches().launch()
        
        sdkInitializator.initialize(completion: completion)
    }
}

// MARK: Триггеры из AppDelegate
public extension SDKProvider {
    func application(_ app: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        SDKStorage.shared.facebookManager.application(app, didFinishLaunchingWithOptions: launchOptions)
        SDKStorage.shared.branchManager.application(didFinishLaunchingWithOptions: launchOptions)
        SDKStorage.shared.adAttributionsManager.application(didFinishLaunchingWithOptions: launchOptions)
        SDKStorage.shared.pushNotificationsManager.application(didFinishLaunchingWithOptions: launchOptions)
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) {
        SDKStorage.shared.facebookManager.application(app, open: url, options: options)
        SDKStorage.shared.branchManager.application(app, open: url, options: options)
        SDKStorage.shared.adAttributionsManager.application(with: url, options: options)
    }
    
    func application(_ app: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) {
        SDKStorage.shared.branchManager.application(continue: userActivity)
        SDKStorage.shared.adAttributionsManager.application(with: userActivity)
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        SDKStorage.shared.pushNotificationsManager.application(didRegisterForRemoteNotificationsWithDeviceToken: deviceToken)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        SDKStorage.shared.pushNotificationsManager.application(didFailToRegisterForRemoteNotificationsWithError: error)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        SDKStorage.shared.pushNotificationsManager.application(didReceiveRemoteNotification: userInfo, fetchCompletionHandler: completionHandler)
    }
}
