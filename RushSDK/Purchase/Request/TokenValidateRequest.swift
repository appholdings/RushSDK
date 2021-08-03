//
//  TokenValidateRequest.swift
//  RushSDK
//
//  Created by Andrey Chernyshev on 03.08.2021.
//

import Alamofire

struct TokenValidateRequest: APIRequestBody {
    let domain: String
    let apiKey: String
    let userToken: String
    let applicationAnonymousID: String
    
    var method: HTTPMethod {
        .post
    }
    
    var url: String {
        domain + "/api/sdk/validate_token"
    }
    
    var parameters: Parameters? {
        [
            "_api_key": apiKey,
            "_user_token": userToken,
            "anonymous_id": applicationAnonymousID
        ]
    }
}
