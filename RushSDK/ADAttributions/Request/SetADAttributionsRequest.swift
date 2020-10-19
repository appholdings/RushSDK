//
//  SetADAttributionsRequest.swift
//  RushSDK
//
//  Created by Andrey Chernyshev on 18.10.2020.
//

import Alamofire

struct SetADAttributionsRequest: APIRequestBody {
    private let domain: String
    private let apiKey: String
    private let anonymousId: String
    private let attributions: [String: Any]
    
    init(domain: String,
         apiKey: String,
         anonymousId: String,
         attributions: [String: Any]) {
        self.domain = domain
        self.apiKey = apiKey
        self.anonymousId = anonymousId
        self.attributions = attributions
    }
    
    var url: String {
        domain + "/api/sdk/attribution"
    }
    
    var method: HTTPMethod {
        .post
    }
    
    var parameters: Parameters? {
        var params = attributions
        params["_api_key"] = apiKey
        params["anonymous_id"] = anonymousId
        
        return params
    }
}
