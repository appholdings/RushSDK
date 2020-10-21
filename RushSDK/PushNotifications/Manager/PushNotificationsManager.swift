//
//  PushNotificationsManager.swift
//  RushSDK
//
//  Created by Andrey Chernyshev on 22.10.2020.
//

import UIKit

public protocol PushNotificationsManager: class {
    @discardableResult
    func initialize() -> Bool
    
    func retriveAuthorizationStatus(handler: ((PushNotificationsAuthorizationStatus) -> Void)?)
    func requestAuthorization()
    
    func application(didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?)
    func application(didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data)
    func application(didFailToRegisterForRemoteNotificationsWithError error: Error)
    func application(didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void)
    
    func add(observer: PushNotificationsManagerDelegate)
    func remove(observer: PushNotificationsManagerDelegate)
}
