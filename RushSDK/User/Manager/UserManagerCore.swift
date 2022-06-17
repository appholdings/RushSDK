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
    
    private let requestWrapper = RequestWrapper()
    
    // Храним в менеджере токен, чтобы сверять его с новым полученным после валидации токеном. Напрямую из SDKStorage нельзя брать токен, потому что он обновляется сам после покупки и может быть рассинхронизация.
    private var userToken: String?
    
    private init() {}
}

// MARK: UserManager
extension UserManagerCore {
    @discardableResult
    func initialize() -> Bool {
        SDKStorage.shared.purchaseMediator.add(delegate: self)
        SDKStorage.shared.featureAppMediator.add(delegate: self)
        SDKStorage.shared.userManagerMediator.add(delegate: self)
        
        userToken = SDKStorage.shared.userToken
        
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
        
        return requestWrapper
            .callServerApi(requestBody: UpdateUserMetaDataRequest(domain: domain,
                                                                  apiKey: apiKey,
                                                                  userToken: userToken,
                                                                  currency: InfoHelper.currencyCode ?? "USD",
                                                                  country: InfoHelper.countryCode ?? "",
                                                                  locale: InfoHelper.locale ?? "en",
                                                                  applicationAnonymousID: SDKStorage.shared.applicationAnonymousID))
            .map { _ in true }
            .catchAndReturn(false)
    }
    
    func rxNewFeatureAppUser() -> Single<String?> {
        guard
            let domain = SDKStorage.shared.featureAppBackendUrl,
            let apiKey = SDKStorage.shared.featureAppBackendApiKey
        else {
            return .error(UserError(code: .sdkNotInitialized))
        }
        
        let request = FeatureAppNewUserRequest(domain: domain, apiKey: apiKey)
        
        return requestWrapper
            .callServerApi(requestBody: request)
            .map(FeatureAppNewUserResponseMapper.map(from:))
            .flatMap(flatMap(newFeatureAppUserToken:))
    }
    
    func rxFeatureAppLoginUser(with userToken: String) -> Single<Bool> {
        guard
            let domain = SDKStorage.shared.featureAppBackendUrl,
            let apiKey = SDKStorage.shared.featureAppBackendApiKey
        else {
            return .error(UserError(code: .sdkNotInitialized))
        }
        
        let request = FeatureAppLoginUserRequest(domain: domain,
                                                 apiKey: apiKey,
                                                 userToken: userToken)
        
        return requestWrapper
            .callServerApi(requestBody: request)
            .map { CheckTokenResponseMapper.isValideToken(in: $0)}
            .catchAndReturn(false)
    }
    
    func check(token: String) -> Single<Bool> {
        guard
            let domain = SDKStorage.shared.featureAppBackendUrl,
            let apiKey = SDKStorage.shared.featureAppBackendApiKey
        else {
            return .error(UserError(code: .sdkNotInitialized))
        }
        
        let request = CheckTokenRequest(domain: domain,
                                        apiKey: apiKey,
                                        token: token)
        
        return requestWrapper
            .callServerApi(requestBody: request)
            .map(CheckTokenResponseMapper.isValideToken(in:))
    }
}

// MARK: SDKPurchaseMediatorDelegate
extension UserManagerCore: SDKPurchaseMediatorDelegate {
    func purchaseMediatorDidValidateReceipt(response: ReceiptValidateResponse?) {
        guard let userToken = response?.userToken else {
            return
        }
        
        updateMetaDataAfterReceive(userToken: userToken)
        syncTokens(userToken: userToken)
        
        self.userToken = userToken
    }
}

// MARK: FeatureAppMediatorDelegate
extension UserManagerCore: FeatureAppMediatorDelegate {
    func featureAppMediatorDidUpdate(userId: String, userToken: String) {
        updateMetaDataAfterReceive(userToken: userToken)
        syncTokens(userToken: userToken)
        
        self.userToken = userToken
    }
}

// MARK: SDKUserManagerMediatorDelegate
extension UserManagerCore: SDKUserManagerMediatorDelegate {
    func userManagerMediatorDidReceivedFeatureApp(userToken: String) {
        updateMetaDataAfterReceive(userToken: userToken)
        
        self.userToken = userToken
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
        
        requestWrapper
            .callServerApi(requestBody: UpdateUserMetaDataRequest(domain: domain,
                                                                  apiKey: apiKey,
                                                                  userToken: userToken,
                                                                  currency: InfoHelper.currencyCode ?? "USD",
                                                                  country: InfoHelper.countryCode ?? "",
                                                                  locale: InfoHelper.locale ?? "en",
                                                                  applicationAnonymousID: SDKStorage.shared.applicationAnonymousID))
            .subscribe(onSuccess: { response in
                log(text: "userManager did updated meta data with result: \(response)")
            })
            .disposed(by: disposeBag)
    }
    
    func syncTokens(userToken: String) {
        guard
            let domain = SDKStorage.shared.featureAppBackendUrl,
            let apiKey = SDKStorage.shared.featureAppBackendApiKey,
            let oldToken = self.userToken
        else {
            return
        }
        
        guard oldToken != userToken else {
            return
        }
        
        let request = FeatureAppSyncTokensRequest(domain: domain,
                                                  apiKey: apiKey,
                                                  oldToken: oldToken,
                                                  newToken: userToken)
        
        requestWrapper
            .callServerApi(requestBody: request)
            .subscribe(onSuccess: { response in
                log(text: "userManager did sync tokens; old: \(oldToken), new: \(userToken)")
            })
            .disposed(by: disposeBag)
    }
    
    func flatMap(newFeatureAppUserToken: String?) -> Single<String?> {
        guard let token = newFeatureAppUserToken else {
            return .deferred { .just(newFeatureAppUserToken) }
        }
        
        return Single<String?>
            .create { [weak self] event in
                self?.userToken = token
                
                SDKStorage.shared.userManagerMediator.notifyAboutReceivedFeatureApp(userToken: token)
                
                event(.success(newFeatureAppUserToken))
                
                return Disposables.create()
            }
    }
}
