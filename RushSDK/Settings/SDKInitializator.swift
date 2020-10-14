//
//  SDKInitializator.swift
//  RushSDK
//
//  Created by Andrey Chernyshev on 14.10.2020.
//

final class SDKInitializator {
    func initialize(completion: ((Bool) -> Void)?) {
        let facebookActivate = SDKStorage.shared.facebookManager.initialize()
        
        let notifyMetiatorsAboutStartValuesCompleted = notifyMetiatorsAboutStartValues()
        
        let isSuccess = facebookActivate
            && notifyMetiatorsAboutStartValuesCompleted
        
        completion?(isSuccess)
    }
}

// MARK: Private
private extension SDKInitializator {
    // Вызывать всегда после инициализаторов менеджерей и зависимостей, чтобы те установили делегаты
    @discardableResult
    func notifyMetiatorsAboutStartValues() -> Bool {
        if let userId = SDKStorage.shared.userId, let userToken = SDKStorage.shared.userToken {
            SDKStorage.shared.featureAppMediator.notifyAboutUpdate(userId: userId, userToken: userToken)
        }
        
        return true
    }
}
