//
//  PurchaseManagerCore.swift
//  RushSDK
//
//  Created by Andrey Chernyshev on 13.10.2020.
//

import RxSwift

final class PurchaseManagerCore: PurchaseManager {}

// MARK: PurchaseManager
extension PurchaseManagerCore {
    func validateReceipt() -> Single<ReceiptValidateResponse?> {
        executeValidateReceipt()
            .do(onSuccess: { response in
                SDKStorage.shared.purchaseMediator.notifyAboutValidateReceiptCompleted(with: response)
                
                log(text: "purchaseManager did validate receipt with response: \(response as Any)")
            })
    }
}

// MARK: Private
private extension PurchaseManagerCore {
    func executeValidateReceipt() -> Single<ReceiptValidateResponse?> {
        guard
            let domain = SDKStorage.shared.backendBaseUrl,
            let apiKey = SDKStorage.shared.backendApiKey
        else {
            return Single.error(PurchaseError(code: .sdkNotInitialized))
        }
        
        let receipt = SDKStorage.shared.iapManager.retrieveReceipt(forceUpdate: false)
        let abTestsValues = Single<[String: Any]?>
            .deferred {
                let dictionary = SDKStorage.shared.abTestsManager.getCachedTests()?.dictionary
                return .just(dictionary)
            }
        
        return Single
            .zip(receipt, abTestsValues)
            .map { ReceiptValidateRequest(domain: domain,
                                          apiKey: apiKey,
                                          receipt: $0,
                                          abTestsValues: $1) }
            .flatMap {
                SDKStorage.shared
                    .restApiTransport
                    .callServerApi(requestBody: $0)
                    .map { ReceiptValidateResponseMapper.map(from: $0) }
            }
    }
}
