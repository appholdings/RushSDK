//
//  PurchaseManagerMock.swift
//  RushSDK
//
//  Created by Andrey Chernyshev on 13.10.2020.
//

import RxSwift

final class PurchaseManagerMock: PurchaseManager {}

// MARK: PurchaseManager
extension PurchaseManagerMock {
    func validateReceipt() -> Single<ReceiptValidateResponse?> {
        guard
            SDKStorage.shared.backendBaseUrl != nil,
            SDKStorage.shared.backendApiKey != nil
        else {
            return Single.error(PurchaseError(code: .sdkNotInitialized))
        }
        
        return .deferred {
            let response = ReceiptValidateResponse(userId: -1,
                                                   userToken: "userToken",
                                                   activeSubscription: false,
                                                   onTrial: false)
            return .just(response)
        }
    }
}
