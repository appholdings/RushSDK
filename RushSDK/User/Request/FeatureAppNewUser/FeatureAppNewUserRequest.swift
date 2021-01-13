//
//  FeatureAppNewUserRequest.swift
//  RushSDK
//
//  Created by Andrey Chernyshev on 13.01.2021.
//

import Alamofire

struct FeatureAppNewUserRequest: APIRequestBody {
    private let domain: String
    private let apiKey: String
    
    init(domain: String,
         apiKey: String) {
        self.domain = domain
        self.apiKey = apiKey
    }
    
    var url: String {
        domain + "/api/users/new"
    }
    
    var method: HTTPMethod {
        .post
    }
    
    var parameters: Parameters? {
        [
            "_api_key": apiKey
        ]
    }
}
