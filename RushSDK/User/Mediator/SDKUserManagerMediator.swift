//
//  SDKUserManagerMediator.swift
//  RushSDK
//
//  Created by Andrey Chernyshev on 13.01.2021.
//

import RxCocoa

public final class SDKUserManagerMediator {
    public static let shared = SDKUserManagerMediator()
    
    private var delegates = [Weak<SDKUserManagerMediatorDelegate>]()
    
    private lazy var didReceivedFeatureAppUserToken = PublishRelay<String>()
    
    private init() {}
}

// MARK: API
extension SDKUserManagerMediator {
    func notifyAboutReceivedFeatureApp(userToken: String) {
        DispatchQueue.main.async { [weak self] in
            SDKUserManagerMediator.shared.delegates.forEach {
                $0.weak?.userManagerMediatorDidReceivedFeatureApp(userToken: userToken)
            }
            
            self?.didReceivedFeatureAppUserToken.accept(userToken)
        }
    }
}

// MARK: Triggers(Rx)
extension SDKUserManagerMediator {
    public var rxDidReceivedFeatureAppUserToken: Signal<String> {
        didReceivedFeatureAppUserToken.asSignal()
    }
}

// MARK: Observer
extension SDKUserManagerMediator {
    public func add(delegate: SDKUserManagerMediatorDelegate) {
        let weakly = delegate as AnyObject
        delegates.append(Weak<SDKUserManagerMediatorDelegate>(weakly))
        delegates = delegates.filter { $0.weak != nil }
    }
    
    public func remove(delegate: SDKUserManagerMediatorDelegate) {
        if let index = delegates.firstIndex(where: { $0.weak === delegate }) {
            delegates.remove(at: index)
        }
    }
}
