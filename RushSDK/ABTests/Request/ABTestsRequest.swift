//
//  ABTestsRequest.swift
//  RushSDK
//
//  Created by Andrey Chernyshev on 12.10.2020.
//

import Alamofire

struct ABTestsRequest: APIRequestBody {
    private let domain: String
    private let apiKey: String
    private let dictionary: [String: Any]?
    private let applicationAnonymousID: String
    
    init(domain: String,
         apiKey: String,
         dictionary: [String: Any]? = nil,
         applicationAnonymousID: String) {
        self.domain = domain
        self.apiKey = apiKey
        self.dictionary = dictionary
        self.applicationAnonymousID = applicationAnonymousID
    }
    
    var method: HTTPMethod {
        .post
    }
    
    var url: String {
        domain + "/api/sdk/ab_tests"
    }
    
    var parameters: Parameters? {
        [
            "_api_key": apiKey,
            "ab_parameters": dictionary as Any,
            "anonymous_id": applicationAnonymousID
        ]
    }
}
