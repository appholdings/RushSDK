//
//  SDKConfigurationManager.swift
//  RushSDK
//
//  Created by Andrey Chernyshev on 04.01.2021.
//

import RxSwift

protocol SDKConfigurationManager {
    // MARK: API
    func clearCache()
    func getCachedConfiguration() -> SDKConfiguration?
    
    // MARK: API(Rx)
    func rxObtainConfiguration() -> Single<SDKConfiguration?>
}
