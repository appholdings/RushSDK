//
//  PurchaseInteractor.swift
//  RushSDK
//
//  Created by Andrey Chernyshev on 13.10.2020.
//

import RxSwift

protocol PurchaseInteractor: class {
    func makeActiveSubscriptionByBuy(productId: String) -> Single<PurchaseActionResult>
    func makeActiveSubscriptionByRestore() -> Single<PurchaseActionResult>
}
