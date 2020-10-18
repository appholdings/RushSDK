//
//  SDKInitializator.swift
//  RushSDK
//
//  Created by Andrey Chernyshev on 14.10.2020.
//

final class SDKInitializator {
    private let iapManager = SDKStorage.shared.iapManager
    
    func initialize(completion: ((Bool) -> Void)?) {
        iapManager.initialize()
        
        let facebookActivate = SDKStorage.shared.facebookManager.initialize()
        let branchActivate = SDKStorage.shared.branchManager.initialize()
        let amplitudeActivate = SDKStorage.shared.amplitudeManager.initialize()
        
        let isSuccess = facebookActivate
            && branchActivate
            && amplitudeActivate
        
        completion?(isSuccess)
    }
}

// MARK: Private
private extension SDKInitializator {
    // ab tests
    // web view
}
