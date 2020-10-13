//
//  SDKPurchaseMediator.swift
//  RushSDK
//
//  Created by Andrey Chernyshev on 13.10.2020.
//

public final class SDKPurchaseMediator {
    static let shared = SDKPurchaseMediator()
    
    private var delegates = [Weak<SDKPurchaseMediatorDelegate>]()
    
    private init() {}
}

// MARK: API
extension SDKPurchaseMediator {
    func notifyAboutValidateReceiptCompleted(with response: ReceiptValidateResponse?) {
        DispatchQueue.main.async {
            SDKPurchaseMediator.shared.delegates.forEach {
                $0.weak?.purchaseMediatorDidValidateReceipt(response: response)
            }
        }
    }
    
    func notifyAboutMakedActiveSubscriptionByBuy(with result: PurchaseActionResult) {
        DispatchQueue.main.async {
            SDKPurchaseMediator.shared.delegates.forEach {
                $0.weak?.purchaseMediatorDidMakedActiveSubscriptionByBuy(result: result)
            }
        }
    }
    
    func notifyAboutMakedActiveSubscriptionByRestore(with result: PurchaseActionResult) {
        DispatchQueue.main.async {
            SDKPurchaseMediator.shared.delegates.forEach {
                $0.weak?.purchaseMediatorDidMakedActiveSubscriptionByRestore(result: result)
            }
        }
    }
}

// MARK: Observer
extension SDKPurchaseMediator {
    public func add(delegate: SDKPurchaseMediatorDelegate) {
        let weakly = delegate as AnyObject
        delegates.append(Weak<SDKPurchaseMediatorDelegate>(weakly))
        delegates = delegates.filter { $0.weak != nil }
    }
    
    public func remove(delegate: SDKPurchaseMediatorDelegate) {
        if let index = delegates.firstIndex(where: { $0.weak === delegate }) {
            delegates.remove(at: index)
        }
    }
}
