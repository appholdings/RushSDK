//
//  UniversalLinkAttributions.swift
//  RushSDK
//
//  Created by Andrey Chernyshev on 18.10.2020.
//

struct ADLinkAttributions {
    let channel: String?
    let campaign: String?
    let adgroup: String?
    let feature: String?
    let userToken: String? // может быть в branch
    
    init(channel: String? = nil,
         campaign: String? = nil,
         adgroup: String? = nil,
         feature: String? = nil,
         userToken: String? = nil) {
        self.channel = channel
        self.campaign = campaign
        self.adgroup = adgroup
        self.feature = feature
        self.userToken = userToken
    }
}
