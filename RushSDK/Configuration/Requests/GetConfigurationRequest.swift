//
//  GetConfigurationRequest.swift
//  RushSDK
//
//  Created by Andrey Chernyshev on 04.01.2021.
//

import Alamofire

struct GetConfigurationRequest: APIRequestBody {
    private let domain: String
    private let apiKey: String
    
    init(domain: String,
         apiKey: String) {
        self.domain = domain
        self.apiKey = apiKey
    }
    
    var method: HTTPMethod {
        .post
    }
    
    var url: String {
        domain + "/api/sdk/configuration"
    }
    
    var parameters: Parameters? {
        [
            "_api_key": apiKey,
        ]
    }
}
