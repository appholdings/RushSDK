//
//  PurchaseInteractorCore.swift
//  RushSDK
//
//  Created by Andrey Chernyshev on 13.10.2020.
//

import RxSwift

final class PurchaseInteractorCore: PurchaseInteractor {
    private lazy var iapManager = SDKStorage.shared.iapManager
    private lazy var purchaseManager = SDKStorage.shared.purchaseManager
}

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
        iapManager
            .buyProduct(with: productId)
            .flatMap { [weak self] result in
                guard let self = self else {
                    return .never()
                }
                
                switch result {
                case .cancelled:
                    return .just(PurchaseActionResult.cancelled)
                case .completed:
                    return self.purchaseManager
                        .validateReceipt()
                        .map { PurchaseActionResult.completed($0) }
                }
            }
    }
    
    func executeMakeActiveSubscriptionByRestore() -> Single<PurchaseActionResult> {
        iapManager
            .restorePurchases()
            .andThen(purchaseManager.validateReceipt())
            .map { PurchaseActionResult.completed($0) }
    }
}
