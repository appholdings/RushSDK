//
//  ABTestsManagerCore.swift
//  RushSDK
//
//  Created by Andrey Chernyshev on 12.10.2020.
//

import RxSwift
import RxCocoa

final class ABTestsManagerCore: ABTestsManager {
    struct Constants {
        static let cachedTestsKey = "ab_tests_manager_core_cached_tests_key"
    }
    
    private let requestWrapper = RequestWrapper()
    
    private var delegates = [Weak<ABTestsManagerDelegate>]()
    
    private let didUpdatedTestsTrigger = PublishRelay<ABTestsOutput>()
}

// MARK: API
extension ABTestsManagerCore {
    func clearCache() {
        UserDefaults.standard.removeObject(forKey: Constants.cachedTestsKey)
        
        log(text: "abTestsManager clear cache")
    }
    
    func getCachedTests() -> ABTestsOutput? {
        guard let dictionary = UserDefaults.standard.object(forKey: Constants.cachedTestsKey) as? [String: Any] else {
            return nil
        }
        
        return ABTestsOutput(dictionary: dictionary)
    }
}

// MARK: API(Rx)
extension ABTestsManagerCore {
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
            let domain = SDKStorage.shared.backendBaseUrl,
            let apiKey = SDKStorage.shared.backendApiKey
        else {
            return Single.error(ABTestsError(code: .sdkNotInitialized))
        }
        
        let lastABTests = getCachedTests()?.dictionary
        
        let request = ABTestsRequest(domain: domain,
                                     apiKey: apiKey,
                                     dictionary: lastABTests,
                                     applicationAnonymousID: SDKStorage.shared.applicationAnonymousID)
        
        return requestWrapper
            .callServerApi(requestBody: request)
            .map { ABTestsResponse.map(from: $0) }
            .do(onSuccess: { [weak self] tests in
                guard let this = self, let tests = tests else {
                    return
                }
                
                this.store(tests: tests)
            })
    }
}

// MARK: Triggers(Rx)
extension ABTestsManagerCore {
    var didUpdatedTests: Signal<ABTestsOutput> {
        didUpdatedTestsTrigger.asSignal()
    }
}

// MARK: Observer
extension ABTestsManagerCore {
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
private extension ABTestsManagerCore {
    func store(tests: ABTestsOutput) {
        UserDefaults.standard.setValue(tests.dictionary, forKey: Constants.cachedTestsKey)
        
        didUpdatedTestsTrigger.accept(tests)
        
        delegates.forEach { $0.weak?.abTestsManagerDidUpdated(tests: tests) }
        
        log(text: "abTestsManager stored tests: \(tests)")
    }
}
