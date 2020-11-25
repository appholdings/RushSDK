//
//  SDKPurchaseMediator.swift
//  RushSDK
//
//  Created by Andrey Chernyshev on 13.10.2020.
//

import RxCocoa

public final class SDKPurchaseMediator {
    static let shared = SDKPurchaseMediator()
    
    private var delegates = [Weak<SDKPurchaseMediatorDelegate>]()
    
    private init() {}
    
    private let purchaseMediatorDidValidateReceiptTrigger = PublishRelay<ReceiptValidateResponse?>()
    private let purchaseMediatorDidMakedActiveSubscriptionByBuyTrigger = PublishRelay<PurchaseActionResult>()
    private let purchaseMediatorDidMakedActiveSubscriptionByRestoreTrigger = PublishRelay<PurchaseActionResult>()
}

// MARK: API
extension SDKPurchaseMediator {
    func notifyAboutValidateReceiptCompleted(with response: ReceiptValidateResponse?) {
        DispatchQueue.main.async { [weak self] in
            SDKPurchaseMediator.shared.delegates.forEach {
                $0.weak?.purchaseMediatorDidValidateReceipt(response: response)
            }
            
            self?.purchaseMediatorDidValidateReceiptTrigger.accept(response)
        }
    }
    
    func notifyAboutMakedActiveSubscriptionByBuy(with result: PurchaseActionResult) {
        DispatchQueue.main.async { [weak self] in
            SDKPurchaseMediator.shared.delegates.forEach {
                $0.weak?.purchaseMediatorDidMakedActiveSubscriptionByBuy(result: result)
            }
            
            self?.purchaseMediatorDidMakedActiveSubscriptionByBuyTrigger.accept(result)
        }
    }
    
    func notifyAboutMakedActiveSubscriptionByRestore(with result: PurchaseActionResult) {
        DispatchQueue.main.async { [weak self] in
            SDKPurchaseMediator.shared.delegates.forEach {
                $0.weak?.purchaseMediatorDidMakedActiveSubscriptionByRestore(result: result)
            }
            
            self?.purchaseMediatorDidMakedActiveSubscriptionByRestoreTrigger.accept(result)
        }
    }
}

// MARK: Triggers(Rx)
extension SDKPurchaseMediator {
    public var rxPurchaseMediatorDidValidateReceipt: Signal<ReceiptValidateResponse?> {
        purchaseMediatorDidValidateReceiptTrigger.asSignal()
    }
    
    public var rxPurchaseMediatorDidMakedActiveSubscriptionByBuy: Signal<PurchaseActionResult> {
        purchaseMediatorDidMakedActiveSubscriptionByBuyTrigger.asSignal()
    }
    
    public var rxPurchaseMediatorDidMakedActiveSubscriptionByRestore: Signal<PurchaseActionResult> {
        purchaseMediatorDidMakedActiveSubscriptionByRestoreTrigger.asSignal()
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
