//
//  PushNotificationsManagerDelegate.swift
//  RushSDK
//
//  Created by Andrey Chernyshev on 22.10.2020.
//

public protocol PushNotificationsManagerDelegate: class {
    func pushNotificationsManagerDidReceive(authorizationStatus: PushNotificationsAuthorizationStatus)
    func pushNotificationsManagerDidReceive(token: String?)
    func pushNotificationsManagerDidReceive(model: PushNotificationsModel)
}

public extension PushNotificationsManagerDelegate {
    func pushNotificationsManagerDidReceive(authorizationStatus: PushNotificationsAuthorizationStatus) {}
    func pushNotificationsManagerDidReceive(token: String?) {}
    func pushNotificationsManagerDidReceive(model: PushNotificationsModel) {}
}
