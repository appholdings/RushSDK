//
//  SetADLinkAttributionsRequest.swift
//  RushSDK
//
//  Created by Andrey Chernyshev on 18.10.2020.
//

import Alamofire

struct SetADLinkAttributionsRequest: APIRequestBody {
    private let domain: String
    private let apiKey: String
    private let anonymousID: String
    private let channel: String?
    private let campaign: String?
    private let adgroup: String?
    private let feature: String?
    
    init(domain: String,
         apiKey: String,
         anonymousID: String,
         channel: String? = nil,
         campaign: String? = nil,
         adgroup: String? = nil,
         feature: String? = nil) {
        self.domain = domain
        self.apiKey = apiKey
        self.anonymousID = anonymousID
        self.channel = channel
        self.campaign = campaign
        self.adgroup = adgroup
        self.feature = feature
    }
    
    var url: String {
        domain + "/api/sdk/attribution"
    }
    
    var method: HTTPMethod {
        .post
    }
    
    var parameters: Parameters? {
        var params: Parameters = [
            "_api_key": apiKey,
            "anonymous_id": anonymousID
        ]
        
        if let channel = channel {
            params["channel"] = channel
        }
        
        if let campaign = campaign {
            params["campaign"] = campaign
        }
        
        if let adgroup = adgroup {
            params["adgroup"] = adgroup
        }
        
        if let feature = feature {
            params["feature"] = feature
        }
        
        return params
    }
}
