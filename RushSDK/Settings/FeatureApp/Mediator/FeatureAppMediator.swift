//
//  UserCredentialsMediator.swift
//  RushSDK
//
//  Created by Andrey Chernyshev on 13.10.2020.
//

// Вызывать ТОЛЬКО в фиче-приложении для уведомления SDK о получении/обновлении данных
public final class FeatureAppMediator {
    static let shared = FeatureAppMediator()
    
    private var delegates = [Weak<FeatureAppMediatorDelegate>]()
    
    private init() {}
}

// MARK: API
extension FeatureAppMediator {
    // Обычно это требуется, когда в фиче-приложении авторизация происходит не через проверку чека (через емайл, например)
    public func notifyAboutUpdate(userId: String, userToken: String) {
        DispatchQueue.main.async {
            FeatureAppMediator.shared.delegates.forEach { $0.weak?.featureAppMediatorDidUpdate(userId: userId, userToken: userToken) }
        }
    }
}

// MARK: Observer
extension FeatureAppMediator {
    func add(delegate: FeatureAppMediatorDelegate) {
        let weakly = delegate as AnyObject
        delegates.append(Weak<FeatureAppMediatorDelegate>(weakly))
        delegates = delegates.filter { $0.weak != nil }
    }
    
    func remove(delegate: FeatureAppMediatorDelegate) {
        if let index = delegates.firstIndex(where: { $0.weak === delegate }) {
            delegates.remove(at: index)
        }
    }
}
