//
//  IAPManagerMock.swift
//  RushSDK
//
//  Created by Andrey Chernyshev on 08.10.2020.
//

import RxSwift
import SwiftyStoreKit
import StoreKit

final class IAPManagerMock: IAPManager {}

// MARK: IAPManager(initialize)

extension IAPManagerMock {
    func initialize() {
        SwiftyStoreKit.completeTransactions { purchases in
            for purchase in purchases {
                let state = purchase.transaction.transactionState
                if state == .purchased || state == .restored {
                    SwiftyStoreKit.finishTransaction(purchase.transaction)
                }
            }
        }
    }
}

// MARK: IAPManager(obtain)

extension IAPManagerMock {
    // Мокер возвращает фейковые продукты, не применимые к использованию c Core менеджерами.
    func obtainProducts(ids: [String]) -> Single<[IAPProduct]> {
        Single<[IAPProduct]>
            .create { event in
                let products = [
                    SKProduct(),
                    SKProduct(),
                    SKProduct()
                ].map { IAPProduct(product: $0) }
                
                event(.success(products))
                
                return Disposables.create()
            }
    }
}

// MARK: IAPManager(actions)

extension IAPManagerMock {
    func buyProduct(with id: String) -> Single<IAPActionResult> {
        guard SwiftyStoreKit.canMakePayments else {
            return .error(IAPError(.paymentsDisabled))
        }
        
        return Single<IAPActionResult>
            .create { event in
                event(.success(.completed(id)))
                
                return Disposables.create()
            }
            .delaySubscription(RxTimeInterval.seconds(2), scheduler: MainScheduler.asyncInstance)
    }
    
    func restorePurchases() -> Completable {
        Completable
            .create { event in
                event(.completed)
                
                return Disposables.create()
            }
            .delaySubscription(RxTimeInterval.seconds(2), scheduler: MainScheduler.asyncInstance)
    }
}

// MARK: IAPManager(receipt)

extension IAPManagerMock {
    // forceUpdate игнорируется в мокере
    func retrieveReceipt(forceUpdate: Bool) -> Single<String?> {
        .deferred {
            .just("12dsf32ferggnj213d34hfb")
        }
    }
}
