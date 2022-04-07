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
    private let currency: String
    private let country: String
    private let locale: String
    private let applicationAnonymousID: String
    
    init(domain: String,
         apiKey: String,
         userToken: String,
         currency: String,
         country: String,
         locale: String,
         applicationAnonymousID: String) {
        self.domain = domain
        self.apiKey = apiKey
        self.userToken = userToken
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
            "currency": currency,
            "country": country,
            "locale": locale
        ]
    }
}
