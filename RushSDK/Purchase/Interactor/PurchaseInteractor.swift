//
//  PurchaseInteractor.swift
//  RushSDK
//
//  Created by Andrey Chernyshev on 13.10.2020.
//

import RxSwift

public protocol PurchaseInteractor: AnyObject {
    func makeActiveSubscriptionByBuy(productId: String) -> Single<PurchaseActionResult>
    func makeActiveSubscriptionByRestore() -> Single<PurchaseActionResult>
}
