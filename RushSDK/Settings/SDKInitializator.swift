//
//  SDKInitializator.swift
//  RushSDK
//
//  Created by Andrey Chernyshev on 14.10.2020.
//

import RxSwift
import RxCocoa

final class SDKInitializator {
    private let analyticstTrigger = PublishRelay<Bool>()
    private let abTestsTrigger = PublishRelay<Bool>()
    
    private let iapManager = SDKStorage.shared.iapManager
    
    private let disposeBag = DisposeBag()
    
    func initialize(completion: ((Bool) -> Void)?) {
        iapManager.initialize()
        
        
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
    
    func initializeAnalytics() -> Single<Bool> {
        Single<Bool>
            .create { event in
                let isSuccess = SDKStorage.shared.facebookManager.initialize()
                    && SDKStorage.shared.branchManager.initialize()
                    && SDKStorage.shared.amplitudeManager.initialize()
                
                event(.success(isSuccess))
                
                return Disposables.create()
            }
    }
}
