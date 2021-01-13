//
//  FeatureAppLoginUserRequest.swift
//  RushSDK
//
//  Created by Andrey Chernyshev on 13.01.2021.
//

import Alamofire

struct FeatureAppLoginUserRequest: APIRequestBody {
    private let domain: String
    private let apiKey: String
    private let userToken: String
    
    init(domain: String,
         apiKey: String,
         userToken: String) {
        self.domain = domain
        self.apiKey = apiKey
        self.userToken = userToken
    }
    
    var url: String {
        domain + "/api/users/login"
    }
    
    var method: HTTPMethod {
        .post
    }
    
    var parameters: Parameters? {
        [
            "_api_key": apiKey,
            "user_token": userToken
        ]
    }
}
