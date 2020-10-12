//
//  SDKSettings.swift
//  RushSDK
//
//  Created by Andrey Chernyshev on 09.10.2020.
//

public struct SDKSettings {
    let backendBaseUrl: String?
    let backendApiKey: String?
    
    let amplitudeApiKey: String?
    
    let applicationTag: String?
    
    let userToken: String?
    let userId: Int?
    
    let isTest: Bool
    
    public init(backendBaseUrl: String? = nil,
         backendApiKey: String? = nil,
         amplitudeApiKey: String? = nil,
         applicationTag: String? = nil,
         userToken: String? = nil,
         userId: Int? = nil,
         isTest: Bool = false) {
        self.backendBaseUrl = backendBaseUrl
        self.backendApiKey = backendApiKey
        self.amplitudeApiKey = amplitudeApiKey
        self.applicationTag = applicationTag
        self.userToken = userToken
        self.userId = userId
        self.isTest = isTest
    }
}
