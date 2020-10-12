//
//  IAPManagerCore.swift
//  RushSDK
//
//  Created by Andrey Chernyshev on 08.10.2020.
//

import RxSwift
import SwiftyStoreKit

public final class IAPManagerCore: IAPManager {}

// MARK: IAPManager(initialize)

public extension IAPManagerCore {
    static func initialize() {
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

public extension IAPManagerCore {
    func obtainProducts(ids: [String]) -> Single<[IAPProduct]> {
        Single<[IAPProduct]>
            .create { event in
                SwiftyStoreKit.retrieveProductsInfo(Set(ids)) {
                    let products = $0.retrievedProducts.map { IAPProduct(product: $0) }
                    
                    event(.success(products))
                }
                
                return Disposables.create()
            }
    }
}

// MARK: IAPManager(actions)

public extension IAPManagerCore {
    func buyProduct(with id: String) -> Single<IAPActionResult> {
        guard SwiftyStoreKit.canMakePayments else {
            return .error(IAPError(.paymentsDisabled))
        }
        
        return Single<IAPActionResult>
            .create { event in
                SwiftyStoreKit.purchaseProduct(id, quantity: 1, atomically: true) { result in
                    switch result {
                    case .success(let purchase):
                        if purchase.productId == id {
                            event(.success(.completed))
                        }
                    case .error(let error):
                        if IAPErrorHelper.treatErrorAsCancellation(error) {
                            event(.success(.cancelled))
                        } else if IAPErrorHelper.treatErrorAsSuccess(error) {
                            event(.success(.completed))
                        } else {
                            event(.error(IAPError(.paymentFailed, underlyingError: error)))
                        }
                    }
                }
                
                return Disposables.create()
            }
    }
    
    func restorePurchases() -> Completable {
        Completable
            .create { event in
                SwiftyStoreKit.restorePurchases { result in
                    if result.restoredPurchases.isEmpty {
                        event(.error(IAPError(.cannotRestorePurchases)))
                    } else {
                        event(.completed)
                    }
                }
                
                return Disposables.create()
            }
    }
}

// MARK: IAPManager(receipt)

public extension IAPManagerCore {
    func retrieveReceipt(forceUpdate: Bool) -> Single<String?> {
        Single<String?>
            .create { event in
                if forceUpdate {
                    SwiftyStoreKit.fetchReceipt(forceRefresh: true) { result in
                        switch result {
                        case .success(let receiptData):
                            let base64Receipt = receiptData.base64EncodedString()
                            event(.success(base64Receipt))
                        case .error:
                            event(.success(nil))
                        }
                    }
                } else {
                    let base64Receipt = SwiftyStoreKit.localReceiptData?.base64EncodedString()
                    event(.success(base64Receipt))
                }
                
                return Disposables.create()
            }
    }
}
