//
//  SDKIAPMediator.swift
//  RushSDK
//
//  Created by Andrey Chernyshev on 13.10.2020.
//

public final class SDKIAPMediator {
    static let shared = SDKIAPMediator()
    
    private var delegates = [Weak<SDKIAPMediatorDelegate>]()
    
    private init() {}
}

// MARK: API
extension SDKIAPMediator {
    public func notifyAboutBiedProduct(with result: IAPActionResult) {
        DispatchQueue.main.async {
            SDKIAPMediator.shared.delegates.forEach {
                $0.weak?.iapMediatorBiedProduct(with: result)
            }
        }
    }
    
    public func notifyAboutRestoredPurchases() {
        DispatchQueue.main.async {
            SDKIAPMediator.shared.delegates.forEach {
                $0.weak?.iapMediatorRestoredPurchases()
            }
        }
    }
}

// MARK: Observer
extension SDKIAPMediator {
    public func add(delegate: SDKIAPMediatorDelegate) {
        let weakly = delegate as AnyObject
        delegates.append(Weak<SDKIAPMediatorDelegate>(weakly))
        delegates = delegates.filter { $0.weak != nil }
    }
    
    public func remove(delegate: SDKIAPMediatorDelegate) {
        if let index = delegates.firstIndex(where: { $0.weak === delegate }) {
            delegates.remove(at: index)
        }
    }
}
