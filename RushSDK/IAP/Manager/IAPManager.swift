//
//  IAPManager.swift
//  RushSDK
//
//  Created by Andrey Chernyshev on 08.10.2020.
//

import RxSwift

public protocol IAPManager: class {
    func initialize()
    
    func obtainProducts(ids: [String]) -> Single<[IAPProduct]>
    
    func buyProduct(with id: String) -> Single<IAPActionResult>
    func restorePurchases() -> Completable
    
    func retrieveReceipt(forceUpdate: Bool) -> Single<String?>
}
