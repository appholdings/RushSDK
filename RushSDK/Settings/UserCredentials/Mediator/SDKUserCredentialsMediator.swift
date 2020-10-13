//
//  UserCredentialsMediator.swift
//  RushSDK
//
//  Created by Andrey Chernyshev on 13.10.2020.
//

public final class SDKUserCredentialsMediator {
    static let shared = SDKUserCredentialsMediator()
    
    private var delegates = [Weak<UserCredentialsMediatorDelegate>]()
    
    private init() {}
}

// MARK: API
extension SDKUserCredentialsMediator {
    // Вызывать ТОЛЬКО в фиче-приложении для уведомления SDK о получении/обновлении userId/userToken.
    // Обычно это требуется, когда в фиче-приложении авторизация происходит не через проверку чека (через емайл, например).
    public func notifyAboutUpdate(userId: Int, userToken: String) {
        DispatchQueue.main.async {
            SDKStorage.shared.userId = userId
            SDKStorage.shared.userToken = userToken
            
            SDKUserCredentialsMediator.shared.delegates.forEach { $0.weak?.userCredentialsMediatorDidUpdate(userId: userId, userToken: userToken) }
        }
    }
}

// MARK: Observer
extension SDKUserCredentialsMediator {
    func add(delegate: UserCredentialsMediatorDelegate) {
        let weakly = delegate as AnyObject
        delegates.append(Weak<UserCredentialsMediatorDelegate>(weakly))
        delegates = delegates.filter { $0.weak != nil }
    }
    
    func remove(delegate: UserCredentialsMediatorDelegate) {
        if let index = delegates.firstIndex(where: { $0.weak === delegate }) {
            delegates.remove(at: index)
        }
    }
}
