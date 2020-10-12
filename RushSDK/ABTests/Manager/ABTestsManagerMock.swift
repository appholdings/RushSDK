//
//  ABTestsManagerMock.swift
//  RushSDK
//
//  Created by Andrey Chernyshev on 12.10.2020.
//

import RxSwift
import RxCocoa

final class ABTestsManagerMock: ABTestsManager {
    struct Constants {
        static let cachedTestsKey = "ab_tests_manager_mock_cached_tests_key"
    }
    
    private var delegates = [Weak<ABTestsManagerDelegate>]()
    
    private let didUpdatedTestsTrigger = PublishRelay<ABTestsOutput>()
}

// MARK: API
extension ABTestsManagerMock {
    func clearCache() {
        UserDefaults.standard.removeObject(forKey: Constants.cachedTestsKey)
    }
    
    func getCachedTests() -> ABTestsOutput? {
        guard let dictionary = UserDefaults.standard.object(forKey: Constants.cachedTestsKey) as? [String: Any] else {
            return nil
        }
        
        return ABTestsOutput(dictionary: dictionary)
    }
}

// MARK: API(Rx)
extension ABTestsManagerMock {
    func rxClearCache() -> Completable {
        .deferred { [weak self] in
            guard let this = self else {
                return Completable.empty()
            }
            
            this.clearCache()
            
            return Completable.empty()
        }
    }
    
    func rxObtainTests() -> Single<ABTestsOutput?> {
        guard
            SDKStorage.shared.backendBaseUrl != nil,
            SDKStorage.shared.backendApiKey != nil
        else {
            return Single.error(ABTestsError(code: .sdkNotInitialized))
        }
        
        return Single.deferred {
            let tests = ABTestsOutput(dictionary: [
                "ab_paygate_design": "var1",
                "ab_monthly_subscription": "com.stars.monthly_with_trial_2"
            ])
            
            return .just(tests)
        }
        .do(onSuccess: { [weak self] tests in
            guard let this = self, let tests = tests else {
                return
            }
            
            this.store(tests: tests)
        })
    }
}

// MARK: Triggers(Rx)
extension ABTestsManagerMock {
    var didUpdatedTests: Signal<ABTestsOutput> {
        didUpdatedTestsTrigger.asSignal()
    }
}

// MARK: Observer
extension ABTestsManagerMock {
    func add(observer: ABTestsManagerDelegate) {
        let weakly = observer as AnyObject
        delegates.append(Weak<ABTestsManagerDelegate>(weakly))
        delegates = delegates.filter { $0.weak != nil }
    }
    
    func remove(observer: ABTestsManagerDelegate) {
        if let index = delegates.firstIndex(where: { $0.weak === observer }) {
            delegates.remove(at: index)
        }
    }
}

// MARK: Private
private extension ABTestsManagerMock {
    func store(tests: ABTestsOutput) {
        UserDefaults.standard.setValue(tests.dictionary, forKey: Constants.cachedTestsKey)
        
        didUpdatedTestsTrigger.accept(tests)
        
        delegates.forEach { $0.weak?.abTestsManagerDidUpdated(tests: tests) }
    }
}
