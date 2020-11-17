//
//  UpdateUserMetaDataRequest.swift
//  RushSDK
//
//  Created by Andrey Chernyshev on 19.10.2020.
//

import Alamofire

struct UpdateUserMetaDataRequest: APIRequestBody {
    private let domain: String
    private let apiKey: String
    private let userToken: String
    private let abParameters: [String: Any]
    private let currency: String
    private let country: String
    private let locale: String
    private let applicationAnonymousID: String
    
    init(domain: String,
         apiKey: String,
         userToken: String,
         abParameters: [String: Any],
         currency: String,
         country: String,
         locale: String,
         applicationAnonymousID: String) {
        self.domain = domain
        self.apiKey = apiKey
        self.userToken = userToken
        self.abParameters = abParameters
        self.currency = currency
        self.country = country
        self.locale = locale
        self.applicationAnonymousID = applicationAnonymousID
    }
    
    var url: String {
        domain + "/api/sdk/user"
    }
    
    var method: HTTPMethod {
        .post
    }
    
    var parameters: Parameters? {
        [
            "anonymous_id": applicationAnonymousID,
            "_api_key": apiKey,
            "_user_token": userToken,
            "ab_parameters": abParameters,
            "currency": currency,
            "country": country,
            "locale": locale
        ]
    }
}
