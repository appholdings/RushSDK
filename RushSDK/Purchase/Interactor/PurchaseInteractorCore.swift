//
//  PurchaseInteractorCore.swift
//  RushSDK
//
//  Created by Andrey Chernyshev on 13.10.2020.
//

import RxSwift

final class PurchaseInteractorCore: PurchaseInteractor {}

// MARK: PurchaseInteractor
extension PurchaseInteractorCore {
    func makeActiveSubscriptionByBuy(productId: String) -> Single<PurchaseActionResult> {
        executeMakeActiveSubscriptionByBuy(productId: productId)
            .do(onSuccess: { result in
                SDKStorage.shared.purchaseMediator.notifyAboutMakedActiveSubscriptionByBuy(with: result)
            })
    }
    
    func makeActiveSubscriptionByRestore() -> Single<PurchaseActionResult> {
        executeMakeActiveSubscriptionByRestore()
            .do(onSuccess: { result in
                SDKStorage.shared.purchaseMediator.notifyAboutMakedActiveSubscriptionByRestore(with: result)
            })
    }
}

// MARK: Private
private extension PurchaseInteractorCore {
    func executeMakeActiveSubscriptionByBuy(productId: String) -> Single<PurchaseActionResult> {
        SDKStorage.shared.iapManager
            .buyProduct(with: productId)
            .flatMap { result in
                switch result {
                case .cancelled:
                    return .just(PurchaseActionResult.cancelled)
                case .completed:
                    return SDKStorage.shared.purchaseManager
                        .validateReceipt()
                        .map { PurchaseActionResult.completed($0) }
                }
            }
    }
    
    func executeMakeActiveSubscriptionByRestore() -> Single<PurchaseActionResult> {
        SDKStorage.shared.iapManager
            .restorePurchases()
            .andThen(SDKStorage.shared.purchaseManager.validateReceipt())
            .map { PurchaseActionResult.completed($0) }
    }
}
