//
//  PurchaseManagerCore.swift
//  RushSDK
//
//  Created by Andrey Chernyshev on 13.10.2020.
//

import RxSwift

final class PurchaseManagerCore: PurchaseManager {
    private let requestWrapper = RequestWrapper()
}

// MARK: PurchaseManager
extension PurchaseManagerCore {
    func validateReceipt() -> Single<ReceiptValidateResponse?> {
        executeValidateReceipt()
            .do(onSuccess: { response in
                SDKStorage.shared.purchaseMediator.notifyAboutValidateReceiptCompleted(with: response)
                
                log(text: "purchaseManager did validate receipt with response: \(response as Any)")
            })
    }
    
    func validateReceipt(by token: String) -> Single<ReceiptValidateResponse?> {
        executeValidate(token: token)
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
        
        return receipt
            .flatMap { [weak self] receipt -> Single<ReceiptValidateResponse?> in
                guard let self = self, let receipt = receipt else {
                    return Single<ReceiptValidateResponse?>.just(nil)
                }
                
                let request = ReceiptValidateRequest(domain: domain,
                                                     apiKey: apiKey,
                                                     receipt: receipt,
                                                     applicationAnonymousID: SDKStorage.shared.applicationAnonymousID)
                
                return self.requestWrapper
                    .callServerApi(requestBody: request)
                    .map { ReceiptValidateResponseMapper.map(from: $0) }
            }
    }
    
    func executeValidate(token: String) -> Single<ReceiptValidateResponse?> {
        guard
            let domain = SDKStorage.shared.backendBaseUrl,
            let apiKey = SDKStorage.shared.backendApiKey
        else {
            return Single.error(PurchaseError(code: .sdkNotInitialized))
        }
        
        let request = TokenValidateRequest(domain: domain,
                                           apiKey: apiKey,
                                           userToken: token,
                                           applicationAnonymousID: SDKStorage.shared.applicationAnonymousID)
        
        return requestWrapper
            .callServerApi(requestBody: request)
            .map { ReceiptValidateResponseMapper.map(from: $0) }
    }
}
