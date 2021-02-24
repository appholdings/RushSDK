//
//  SetADServiceTokenRequest.swift
//  RushSDK
//
//  Created by Andrey Chernyshev on 24.02.2021.
//

import Alamofire

struct SetADServiceTokenRequest: APIRequestBody {
    private let domain: String
    private let apiKey: String
    private let anonymousId: String
    private let adServiceToken: String
    
    init(domain: String,
         apiKey: String,
         anonymousId: String,
         adServiceToken: String) {
        self.domain = domain
        self.apiKey = apiKey
        self.anonymousId = anonymousId
        self.adServiceToken = adServiceToken
    }
    
    var url: String {
        domain + "/api/sdk/ad_service_attribution"
    }
    
    var method: HTTPMethod {
        .post
    }
    
    var parameters: Parameters? {
        [
            "_api_key": apiKey,
            "anonymous_id": anonymousId,
            "adservice_token": adServiceToken
        ]
    }
}
