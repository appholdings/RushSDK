//
//  SDKInitializator.swift
//  RushSDK
//
//  Created by Andrey Chernyshev on 14.10.2020.
//

import RxSwift
import RxCocoa

final class SDKInitializator {
    private let registerInstallTrigger = PublishRelay<Bool>()
    private let userUpdateMetaDataTrigger = PublishRelay<Bool>()
    private let featureAppUserTrigger = PublishRelay<Bool>()
    
    private let iapManager = SDKStorage.shared.iapManager
    private let purchaseManager = SDKStorage.shared.purchaseManager
    private let registerInstallManager = SDKStorage.shared.registerInstallManager
    private let userManager = SDKStorage.shared.userManager
    
    private let disposeBag = DisposeBag()
    
    func initialize(completion: ((Bool) -> Void)?) {
        Observable
            .zip(
                registerInstallTrigger,
                featureAppUserTrigger,
                userUpdateMetaDataTrigger
            )
            .subscribe(onNext: { stub in
                let (_, featureAppUser, _) = stub
                
                completion?(featureAppUser)
            })
            .disposed(by: disposeBag)
        
        iapManager.initialize()
        
        SDKStorage.shared.facebookManager.initialize()
        SDKStorage.shared.branchManager.initialize()
        SDKStorage.shared.amplitudeManager.initialize()
        SDKStorage.shared.appsFlyerManager.initialize()
        SDKStorage.shared.firebaseManager.initialize()
        
        SDKStorage.shared.pushNotificationsManager.initialize()
        SDKStorage.shared.pushNotificationsUpdater.initialize()
        
        userManager.initialize()
        
        initializeUserToken()
        initializeUserUpdateMetaData()
        
        initializeRegisterInstall()
    }
    
    func tryAgain(completion: ((Bool) -> Void)?) {
        tryAgainInitializeUserToken()
            .subscribe(onSuccess: { success in
                completion?(success)
            }, onFailure: { _ in 
                completion?(false)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: Private
private extension SDKInitializator {
    func initializeRegisterInstall() {
        registerInstallManager
            .register { [weak self] result in
                self?.registerInstallTrigger.accept(result)
            }
    }
    
    func initializeUserUpdateMetaData() {
        userManager
            .rxUpdateMetaData()
            .subscribe(onSuccess: { [weak self] _ in
                self?.userUpdateMetaDataTrigger.accept(true)
            }, onFailure: { [weak self] _ in
                self?.userUpdateMetaDataTrigger.accept(false)
            })
            .disposed(by: disposeBag)
    }
    
    func initializeUserToken() {
        checkToken()
            .flatMap { [weak self] stub -> Single<(ReceiptValidateResponse?, Bool)> in
                guard let self = self else {
                    return .never()
                }
                
                let (userToken, tokenIsValidated) = stub
                
                return self.validate(userTokenFromBranch: userToken)
                    .map { ($0, tokenIsValidated) }
            }
            .flatMap { [weak self] stub -> Single<Bool> in
                guard let this = self else {
                    return .never()
                }
                
                let (receipt, tokenIsValidated) = stub
                
                guard tokenIsValidated, let storedUserToken = SDKStorage.shared.userToken else {
                    return this.flatMapUserTokenIfTokenNil(receipt: receipt)
                }
                
                return this.flatMapUserTokenIfTokenNotNil(receipt: receipt, storedUserToken: storedUserToken)
            }
            .subscribe(onSuccess: { [weak self] success in
                self?.featureAppUserTrigger.accept(success)
            }, onFailure: { [weak self] _ in
                self?.featureAppUserTrigger.accept(false)
            })
            .disposed(by: disposeBag)
    }
    
    func tryAgainInitializeUserToken() -> Single<Bool> {
        checkToken()
            .flatMap { [weak self] stub -> Single<(ReceiptValidateResponse?, Bool)> in
                guard let self = self else {
                    return .never()
                }
                
                let (userToken, tokenIsValidated) = stub
                
                return self.validate(userTokenFromBranch: userToken)
                    .map { ($0, tokenIsValidated) }
            }
            .flatMap { [weak self] stub -> Single<Bool> in
                guard let this = self else {
                    return .never()
                }
                
                let (receipt, tokenIsValidated) = stub
                
                guard tokenIsValidated, let storedUserToken = SDKStorage.shared.userToken else {
                    return this.flatMapUserTokenIfTokenNil(receipt: receipt)
                }
                
                return this.flatMapUserTokenIfTokenNotNil(receipt: receipt, storedUserToken: storedUserToken)
            }
    }
}

// MARK: Private (utils)
private extension SDKInitializator {
    func checkToken() -> Single<(String?, Bool)> {
        SDKStorage.shared.branchManager
            .obtainInstallUserToken()
            .map { $0 ?? SDKStorage.shared.userToken }
            .flatMap { [weak self] token -> Single<(String?, Bool)> in
                guard let self = self else {
                    return .deferred { .just((token, false)) }
                }
                
                guard let userToken = token else {
                    return .deferred { .just((token, false)) }
                }
                
                return self.userManager
                    .check(token: userToken)
                    .catchAndReturn(false)
                    .map { (userToken, $0) }
            }
    }
    
    func validate(userTokenFromBranch: String?) -> Single<ReceiptValidateResponse?> {
        purchaseManager
            .validateReceipt()
            .flatMap { [weak self] receipt -> Single<ReceiptValidateResponse?> in
                guard let self = self else {
                    return .just(nil)
                }
                
                guard receipt?.userToken == nil else {
                    return .deferred { .just(receipt) }
                }
                
                guard let userToken = userTokenFromBranch else {
                    return .deferred { .just(nil) }
                }
                
                return self.purchaseManager
                    .validateReceipt(by: userToken)
            }
    }
    
    func flatMapUserTokenIfTokenNil(receipt: ReceiptValidateResponse?) -> Single<Bool> {
        guard let userToken = receipt?.userToken else {
            return userManager
                .rxNewFeatureAppUser()
                .map { $0 != nil }
                .catchAndReturn(false)
        }

        return userManager
            .rxFeatureAppLoginUser(with: userToken)
            .catchAndReturn(false)
    }
    
    func flatMapUserTokenIfTokenNotNil(receipt: ReceiptValidateResponse?, storedUserToken: String) -> Single<Bool> {
        guard let userToken = receipt?.userToken else {
            return .deferred { .just(true) }
        }
        
        guard userToken != storedUserToken else {
            return .deferred { .just(true) }
        }
        
        guard let core = (userManager as? UserManagerCore) else {
            return .deferred { .just(true) }
        }
        
        core.purchaseMediatorDidValidateReceipt(response: receipt)
        
        return .deferred { .just(true) }
    }
}
