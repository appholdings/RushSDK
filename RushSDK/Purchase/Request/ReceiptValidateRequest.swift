//
//  ReceiptValidateRequest.swift
//  RushSDK
//
//  Created by Andrey Chernyshev on 13.10.2020.
//

import Alamofire

struct ReceiptValidateRequest: APIRequestBody {
    private let domain: String
    private let apiKey: String
    private let receipt: String?
    private let abTestsValues: [String: Any]?
    
    init(domain: String,
         apiKey: String,
         receipt: String?,
         abTestsValues: [String: Any]?) {
        self.domain = domain
        self.apiKey = apiKey
        self.receipt = receipt
        self.abTestsValues = abTestsValues
    }
    
    var method: HTTPMethod {
        .post
    }
    
    var url: String {
        domain + "/api/sdk/validate"
    }
    
    var parameters: Parameters? {
        var params = abTestsValues ?? [:]
        
        params["_api_key"] = apiKey
        
        if let receipt = self.receipt {
            params["receipt"] = receipt
        }
        
        return params
    }
}
