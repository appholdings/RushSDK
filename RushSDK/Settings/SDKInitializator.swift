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
    private let validateReceiptTrigger = PublishRelay<ReceiptValidateResponse?>()
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
        SDKStorage.shared.firebaseManager.initialize()
        
        SDKStorage.shared.pushNotificationsManager.initialize()
        SDKStorage.shared.pushNotificationsUpdater.initialize()
        
        userManager.initialize()
        
        initializeFeatureAppTrigger()
        validateReceipt()
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
    
    func validateReceipt() {
        abTestsTrigger
            .flatMap { [purchaseManager] success in
                purchaseManager
                    .validateReceipt()
                    .catchAndReturn(nil)
            }
            .subscribe(onNext: { [weak self] receipt in
                self?.validateReceiptTrigger.accept(receipt)
            }, onError: { [weak self] _ in
                self?.validateReceiptTrigger.accept(nil)
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
    
    func initializeFeatureAppTrigger() {
        validateReceiptTrigger
            .flatMap { [weak self] receipt -> Single<Bool> in
                guard let this = self else {
                    return .never()
                }
                
                guard let userToken = receipt?.userToken else {
                    return this.userManager
                        .rxNewFeatureAppUser()
                        .map { _ in true }
                        .catchAndReturn(false)
                }
                
                return this.userManager
                    .rxFeatureAppLoginUser(with: userToken)
                    .map { _ in true }
                    .catchAndReturn(false)
            }
            .subscribe(onNext: { [weak self] success in
                self?.featureAppUserTrigger.accept(success)
            }, onError: { [weak self] _ in
                self?.featureAppUserTrigger.accept(false)
            })
            .disposed(by: disposeBag)
    }
}
