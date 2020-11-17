//
//  SendUserPushNotificationsTokenRequest.swift
//  RushSDK
//
//  Created by Andrey Chernyshev on 22.10.2020.
//

import Alamofire

struct SendUserPushNotificationsTokenRequest: APIRequestBody {
    private let domain: String
    private let apiKey: String
    private let pushDeviceToken: String
    private let userToken: String
    private let applicationAnonymousID: String
    
    init(domain: String,
         apiKey: String,
         pushDeviceToken: String,
         userToken: String,
         applicationAnonymousID: String) {
        self.domain = domain
        self.apiKey = apiKey
        self.pushDeviceToken = pushDeviceToken
        self.userToken = userToken
        self.applicationAnonymousID = applicationAnonymousID
    }
    
    var method: HTTPMethod {
        .post
    }
    
    var url: String {
        domain + "/api/sdk/user"
    }
    
    var parameters: Parameters? {
        [
            "anonymous_id": applicationAnonymousID,
            "_api_key": apiKey,
            "_user_token": userToken,
            "notification_key": pushDeviceToken
        ]
    }
}
