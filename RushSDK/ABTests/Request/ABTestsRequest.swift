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
    
    init(domain: String, apiKey: String, dictionary: [String: Any]? = nil) {
        self.domain = domain
        self.apiKey = apiKey
        self.dictionary = dictionary
    }
    
    var method: HTTPMethod {
        .post
    }
    
    var url: String {
        domain + "/api/sdk/ab_tests"
    }
    
    var parameters: Parameters? {
        [
            "_api_key": apiKey
        ]
    }
}
