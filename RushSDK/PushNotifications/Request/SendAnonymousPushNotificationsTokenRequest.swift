//
//  SendAnonymousPushNotificationsTokenRequest.swift
//  RushSDK
//
//  Created by Andrey Chernyshev on 22.10.2020.
//

import Alamofire

struct SendAnonymousPushNotificationsTokenRequest: APIRequestBody {
    private let domain: String
    private let apiKey: String
    private let pushDeviceToken: String
    private let anonymousId: String
    
    init(domain: String,
         apiKey: String,
         pushDeviceToken: String,
         anonymousId: String) {
        self.domain = domain
        self.apiKey = apiKey
        self.pushDeviceToken = pushDeviceToken
        self.anonymousId = anonymousId
    }
    
    var method: HTTPMethod {
        .post
    }
    
    var url: String {
        domain + "/api/sdk/anonymous"
    }
    
    var parameters: Parameters? {
        [
            "_api_key": apiKey,
            "anonymous_id": anonymousId,
            "notification_key": pushDeviceToken
        ]
    }
}
