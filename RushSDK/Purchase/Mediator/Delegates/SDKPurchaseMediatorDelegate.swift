//
//  PurchaseMediatorDelegate.swift
//  RushSDK
//
//  Created by Andrey Chernyshev on 13.10.2020.
//

public protocol SDKPurchaseMediatorDelegate: AnyObject {
    func purchaseMediatorDidValidateReceipt(response: ReceiptValidateResponse?)
    func purchaseMediatorDidMakedActiveSubscriptionByBuy(result: PurchaseActionResult)
    func purchaseMediatorDidMakedActiveSubscriptionByRestore(result: PurchaseActionResult)
}

public extension SDKPurchaseMediatorDelegate {
    func purchaseMediatorDidValidateReceipt(response: ReceiptValidateResponse?) {}
    func purchaseMediatorDidMakedActiveSubscriptionByBuy(result: PurchaseActionResult) {}
    func purchaseMediatorDidMakedActiveSubscriptionByRestore(result: PurchaseActionResult) {}
}
