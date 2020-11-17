//
//  PushNotificationsTokenUpdater.swift
//  RushSDK
//
//  Created by Andrey Chernyshev on 22.10.2020.
//

import RxSwift

final class PushNotificationsTokenUpdater {
    static let shared = PushNotificationsTokenUpdater()
    
    private let disposeBag = DisposeBag()
    
    private init() {}
}

// MARK: API
extension PushNotificationsTokenUpdater {
    func initialize() {
        SDKStorage.shared.pushNotificationsManager.add(observer: self)
    }
}

// MARK: PushNotificationsManagerDelegate
extension PushNotificationsTokenUpdater: PushNotificationsManagerDelegate {
    func pushNotificationsManagerDidReceive(token: String?) {
        guard
            let domain = SDKStorage.shared.backendBaseUrl,
            let apiKey = SDKStorage.shared.backendApiKey,
            let pushDeviceToken = token
        else {
            return
        }
        
        let request: APIRequestBody
        
        if let userToken = SDKStorage.shared.userToken {
            request = SendUserPushNotificationsTokenRequest(domain: domain,
                                                            apiKey: apiKey,
                                                            pushDeviceToken: pushDeviceToken,
                                                            userToken: userToken,
                                                            applicationAnonymousID: SDKStorage.shared.applicationAnonymousID)
            
            log(text: "send push token at /user")
        } else {
            request = SendAnonymousPushNotificationsTokenRequest(domain: domain,
                                                                 apiKey: apiKey,
                                                                 pushDeviceToken: pushDeviceToken,
                                                                 anonymousId: SDKStorage.shared.applicationAnonymousID)
            
            log(text: "send push token at /anonymous")
        }
        
        SDKStorage.shared
            .restApiTransport
            .callServerApi(requestBody: request)
            .subscribe()
            .disposed(by: disposeBag)
    }
}
