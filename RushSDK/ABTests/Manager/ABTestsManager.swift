//
//  ABTestingManager.swift
//  RushSDK
//
//  Created by Andrey Chernyshev on 12.10.2020.
//

import RxSwift
import RxCocoa

protocol ABTestsManager: class {
    // MARK: API
    func clearCache()
    func getCachedTests() -> ABTestsOutput?
    
    // MARK: API(Rx)
    func rxClearCache() -> Completable
    func rxObtainTests() -> Single<ABTestsOutput?>
    
    // MARK: Triggers(Rx)
    var didUpdatedTests: Signal<ABTestsOutput> { get }
    
    // MARK: Observer
    func add(observer: ABTestsManagerDelegate)
    func remove(observer: ABTestsManagerDelegate)
}
