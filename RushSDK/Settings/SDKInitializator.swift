//
//  SDKInitializator.swift
//  RushSDK
//
//  Created by Andrey Chernyshev on 14.10.2020.
//

final class SDKInitializator {
    func initialize(completion: ((Bool) -> Void)?) {
        let facebookActivate = SDKStorage.shared.facebookManager.initialize()
        let branchActivate = SDKStorage.shared.branchManager.initialize()
        
        let isSuccess = facebookActivate
            && branchActivate
        
        completion?(isSuccess)
    }
}
