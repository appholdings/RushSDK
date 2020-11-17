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
    private let receipt: String
    private let abTestsValues: [String: Any]?
    private let applicationAnonymousID: String
    
    init(domain: String,
         apiKey: String,
         receipt: String,
         abTestsValues: [String: Any]?,
         applicationAnonymousID: String) {
        self.domain = domain
        self.apiKey = apiKey
        self.receipt = receipt
        self.abTestsValues = abTestsValues
        self.applicationAnonymousID = applicationAnonymousID
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
        params["receipt"] = receipt
        params["anonymous_id"] = applicationAnonymousID
        
        return params
    }
}
