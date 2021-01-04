//
//  UserManagerCore.swift
//  RushSDK
//
//  Created by Andrey Chernyshev on 19.10.2020.
//

import RxSwift

final class UserManagerCore: UserManager {
    static let shared = UserManagerCore()
    
    private let disposeBag = DisposeBag()
    
    private init() {}
}

// MARK: UserManager
extension UserManagerCore {
    @discardableResult
    func initialize() -> Bool {
        SDKStorage.shared.purchaseMediator.add(delegate: self)
        SDKStorage.shared.featureAppMediator.add(delegate: self)
        
        return true 
    }
    
    func rxUpdateMetaData() -> Single<Bool> {
        guard
            let domain = SDKStorage.shared.backendBaseUrl,
            let apiKey = SDKStorage.shared.backendApiKey
        else {
            return .error(UserError(code: .sdkNotInitialized))
        }
        
        guard let userToken = SDKStorage.shared.userToken else {
            return .error(UserError(code: .userTokenNotFound))
        }
        
        return SDKStorage.shared
            .restApiTransport
            .callServerApi(requestBody: UpdateUserMetaDataRequest(domain: domain,
                                                                  apiKey: apiKey,
                                                                  userToken: userToken,
                                                                  abParameters: SDKStorage.shared.abTestsManager.getCachedTests()?.dictionary ?? [:],
                                                                  currency: InfoHelper.currencyCode ?? "USD",
                                                                  country: InfoHelper.countryCode ?? "",
                                                                  locale: InfoHelper.locale ?? "en",
                                                                  applicationAnonymousID: SDKStorage.shared.applicationAnonymousID,
                                                                  idfa: SDKStorage.shared.idfaManager.getIDFA()))
            .map { _ in true }
            .catchAndReturn(false)
    }
}

// MARK: SDKPurchaseMediatorDelegate
extension UserManagerCore: SDKPurchaseMediatorDelegate {
    func purchaseMediatorDidValidateReceipt(response: ReceiptValidateResponse?) {
        guard let userToken = response?.userToken else {
            return
        }
        
        updateMetaDataAfterReceive(userToken: userToken)
    }
}

// MARK: FeatureAppMediatorDelegate
extension UserManagerCore: FeatureAppMediatorDelegate {
    func featureAppMediatorDidUpdate(userId: Int, userToken: String) {
        updateMetaDataAfterReceive(userToken: userToken)
    }
}

// MARK: Private
private extension UserManagerCore {
    func updateMetaDataAfterReceive(userToken: String) {
        guard
            let domain = SDKStorage.shared.backendBaseUrl,
            let apiKey = SDKStorage.shared.backendApiKey
        else {
            return
        }
        
        SDKStorage.shared
            .restApiTransport
            .callServerApi(requestBody: UpdateUserMetaDataRequest(domain: domain,
                                                                  apiKey: apiKey,
                                                                  userToken: userToken,
                                                                  abParameters: SDKStorage.shared.abTestsManager.getCachedTests()?.dictionary ?? [:],
                                                                  currency: InfoHelper.currencyCode ?? "USD",
                                                                  country: InfoHelper.countryCode ?? "",
                                                                  locale: InfoHelper.locale ?? "en",
                                                                  applicationAnonymousID: SDKStorage.shared.applicationAnonymousID,
                                                                  idfa: SDKStorage.shared.idfaManager.getIDFA()))
            .subscribe(onSuccess: { response in
                log(text: "userManager did updated meta data with result: \(response)")
            })
            .disposed(by: disposeBag)
    }
}
