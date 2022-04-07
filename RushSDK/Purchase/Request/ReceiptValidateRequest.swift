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
    private let applicationAnonymousID: String
    
    init(domain: String,
         apiKey: String,
         receipt: String,
         applicationAnonymousID: String) {
        self.domain = domain
        self.apiKey = apiKey
        self.receipt = receipt
        self.applicationAnonymousID = applicationAnonymousID
    }
    
    var method: HTTPMethod {
        .post
    }
    
    var url: String {
        domain + "/api/sdk/validate"
    }
    
    var parameters: Parameters? {
        [
            "_api_key": apiKey,
            "receipt": receipt,
            "anonymous_id": applicationAnonymousID
        ]
    }
}
