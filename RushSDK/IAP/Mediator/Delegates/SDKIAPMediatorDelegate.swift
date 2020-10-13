//
//  SDKIAPMediatorDelegate.swift
//  RushSDK
//
//  Created by Andrey Chernyshev on 13.10.2020.
//

public protocol SDKIAPMediatorDelegate: class {
    func iapMediatorBiedProduct(with result: IAPActionResult)
    func iapMediatorRestoredPurchases()
}

public extension SDKIAPMediatorDelegate {
    func iapMediatorBiedProduct(with result: IAPActionResult) {}
    func iapMediatorRestoredPurchases() {}
}
