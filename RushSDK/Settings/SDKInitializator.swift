//
//  SDKInitializator.swift
//  RushSDK
//
//  Created by Andrey Chernyshev on 14.10.2020.
//

import RxSwift
import RxCocoa

final class SDKInitializator {
    private let abTestsTrigger = PublishRelay<Bool>()
    private let registerInstallTrigger = PublishRelay<Bool>()
    private let userUpdateMetaDataTrigger = PublishRelay<Bool>()
    private let configurationTrigger = PublishRelay<Bool>()
    private let featureAppUserTrigger = PublishRelay<Bool>()
    
    private let abTestsManager = SDKStorage.shared.abTestsManager
    private let iapManager = SDKStorage.shared.iapManager
    private let purchaseManager = SDKStorage.shared.purchaseManager
    private let registerInstallManager = SDKStorage.shared.registerInstallManager
    private let userManager = SDKStorage.shared.userManager
    private let configurationManager = SDKStorage.shared.configurationManager
    
    private let disposeBag = DisposeBag()
    
    func initialize(completion: (() -> Void)?) {
        Observable
            .zip([
                registerInstallTrigger,
                featureAppUserTrigger,
                userUpdateMetaDataTrigger,
                configurationTrigger
            ])
            .subscribe(onNext: { _ in
                completion?()
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
        
        initializeABTests()
        initializeRegisterInstall()
        initializeConfiguration()
    }
}

// MARK: Private
private extension SDKInitializator {
    func initializeABTests() {
        abTestsManager
            .rxObtainTests()
            .subscribe(onSuccess: { [weak self] _ in
                self?.abTestsTrigger.accept(true)
            }, onFailure: { [weak self] _ in
                self?.abTestsTrigger.accept(false)
            })
            .disposed(by: disposeBag)
    }
    
    func initializeRegisterInstall() {
        registerInstallManager
            .register { [weak self] result in
                self?.registerInstallTrigger.accept(result)
            }
    }
    
    func initializeUserUpdateMetaData() {
        abTestsTrigger
            .flatMap { [userManager] success in
                userManager
                    .rxUpdateMetaData()
                    .map { _ in true }
                    .catchAndReturn(false)
            }
            .subscribe(onNext: { [weak self] success in
                self?.userUpdateMetaDataTrigger.accept(success)
            }, onError: { [weak self] _ in
                self?.userUpdateMetaDataTrigger.accept(false)
            })
            .disposed(by: disposeBag)
    }
    
    func initializeConfiguration() {
        configurationManager
            .rxObtainConfiguration()
            .subscribe(onSuccess: { [weak self] config in
                self?.configurationTrigger.accept(true)
            }, onFailure: { [weak self] error in
                self?.configurationTrigger.accept(false)
            })
            .disposed(by: disposeBag)
    }
    
    func initializeUserToken() {
        abTestsTrigger
            .flatMapLatest { [userManager] success -> Single<Bool> in
                guard let userToken = SDKStorage.shared.userToken else {
                    return .deferred { .just(false) }
                }
                
                return userManager
                    .check(token: userToken)
                    .catchAndReturn(false)
            }
            .flatMapLatest { [weak self] tokenIsValidated -> Single<(ReceiptValidateResponse?, Bool)> in
                guard let self = self else {
                    return .never()
                }
                
                return self.validate()
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
            .subscribe(onNext: { [weak self] success in
                self?.featureAppUserTrigger.accept(success)
            }, onError: { [weak self] _ in
                self?.featureAppUserTrigger.accept(false)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: Private (utils)
private extension SDKInitializator {
    func flatMapUserTokenIfTokenNil(receipt: ReceiptValidateResponse?) -> Single<Bool> {
        guard let userToken = receipt?.userToken else {
            return userManager
                .rxNewFeatureAppUser()
                .map { _ in true }
                .catchAndReturn(false)
        }

        return userManager
            .rxFeatureAppLoginUser(with: userToken)
            .map { _ in true }
            .catchAndReturn(false)
    }
    
    func flatMapUserTokenIfTokenNotNil(receipt: ReceiptValidateResponse?, storedUserToken: String) -> Single<Bool> {
        guard let userToken = receipt?.userToken else {
            return .deferred { .just(false) }
        }
        
        guard userToken != storedUserToken else {
            return .deferred { .just(true) }
        }
        
        guard let core = (userManager as? UserManagerCore) else {
            return .deferred { .just(false) }
        }
        
        core.purchaseMediatorDidValidateReceipt(response: receipt)
        
        return .deferred { .just(true) }
    }
    
    func validate() -> Single<ReceiptValidateResponse?> {
        purchaseManager
            .validateReceipt()
            .flatMap { [weak self] receipt -> Single<ReceiptValidateResponse?> in
                guard let self = self else {
                    return .just(nil)
                }
                
                guard receipt?.userToken == nil else {
                    return .deferred { .just(receipt) }
                }
                
                return self.purchaseManager
                    .validateReceiptBySDK()
            }
    }
}
