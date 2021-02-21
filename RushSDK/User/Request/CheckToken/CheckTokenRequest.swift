//
//  CheckTokenRequest.swift
//  RushSDK
//
//  Created by Andrey Chernyshev on 21.02.2021.
//

import Alamofire

struct CheckTokenRequest: APIRequestBody {
    private let domain: String
    private let apiKey: String
    private let token: String
    
    init(domain: String,
         apiKey: String,
         token: String) {
        self.domain = domain
        self.apiKey = apiKey
        self.token = token
    }
    
    var url: String {
        domain + "/api/users/check_token"
    }
    
    var method: HTTPMethod {
        .post
    }
    
    var parameters: Parameters? {
        [
            "_api_key": apiKey,
            "_user_token": token,
        ]
    }
}
