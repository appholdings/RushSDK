//
//  PurchaseManager.swift
//  RushSDK
//
//  Created by Andrey Chernyshev on 13.10.2020.
//

import RxSwift

public protocol PurchaseManager: class {
    // MARK: API
    func validateReceipt() -> Single<ReceiptValidateResponse?>
}
