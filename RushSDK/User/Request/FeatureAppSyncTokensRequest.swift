//
//  FeatureAppSyncTokensRequest.swift
//  RushSDK
//
//  Created by Andrey Chernyshev on 13.01.2021.
//

import Alamofire

struct FeatureAppSyncTokensRequest: APIRequestBody {
    private let domain: String
    private let apiKey: String
    private let oldToken: String
    private let newToken: String
    
    init(domain: String,
         apiKey: String,
         oldToken: String,
         newToken: String) {
        self.domain = domain
        self.apiKey = apiKey
        self.oldToken = oldToken
        self.newToken = newToken
    }
    
    var url: String {
        domain + "/api/users/set"
    }
    
    var method: HTTPMethod {
        .post
    }
    
    var parameters: Parameters? {
        [
            "_api_key": apiKey,
            "user_token": newToken,
            "_user_token": oldToken
        ]
    }
}
