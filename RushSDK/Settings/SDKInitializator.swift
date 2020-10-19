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
    private let validateReceiptTrigger = PublishRelay<Bool>()
    private let userUpdateMetaDataTrigger = PublishRelay<Bool>()
    
    private let iapManager = SDKStorage.shared.iapManager
    
    private let disposeBag = DisposeBag()
    
    func initialize(completion: (() -> Void)?) {
        iapManager.initialize()
        
        SDKStorage.shared.facebookManager.initialize()
        SDKStorage.shared.branchManager.initialize()
        SDKStorage.shared.amplitudeManager.initialize()
        
        SDKStorage.shared.userManager.initialize()
        
        initializeABTests()
        initializeRegisterInstall()
        
        Observable
            .zip([
                registerInstallTrigger,
                validateReceiptTrigger,
                userUpdateMetaDataTrigger
            ])
            .subscribe(onNext: { _ in
                completion?()
            })
            .disposed(by: disposeBag)
    }
}

// MARK: Private
private extension SDKInitializator {
    func initializeABTests() {
        SDKStorage.shared
            .abTestsManager
            .rxObtainTests()
            .subscribe(onSuccess: { [weak self] _ in
                self?.abTestsTrigger.accept(true)
            }, onError: { [weak self] _ in
                self?.abTestsTrigger.accept(false)
            })
            .disposed(by: disposeBag)
    }
    
    func validateReceipt() {
        abTestsTrigger
            .flatMap { success in
                SDKStorage.shared
                    .purchaseManager
                    .validateReceipt()
                    .map { _ in true }
                    .catchErrorJustReturn(false)
            }
            .subscribe(onNext: { [weak self] success in
                self?.validateReceiptTrigger.accept(success)
            }, onError: { [weak self] _ in
                self?.validateReceiptTrigger.accept(false)
            })
            .disposed(by: disposeBag)
    }
    
    func initializeRegisterInstall() {
        SDKStorage.shared
            .registerInstallManager
            .register { [weak self] result in
                self?.registerInstallTrigger.accept(result)
            }
    }
    
    func initializeUserUpdateMetaData() {
        abTestsTrigger
            .flatMap { success in
                SDKStorage.shared
                    .userManager
                    .rxUpdateMetaData()
                    .map { _ in true }
                    .catchErrorJustReturn(false)
            }
            .subscribe(onNext: { [weak self] success in
                self?.userUpdateMetaDataTrigger.accept(success)
            }, onError: { [weak self] _ in
                self?.userUpdateMetaDataTrigger.accept(false)
            })
            .disposed(by: disposeBag)
    }
}
