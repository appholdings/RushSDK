//
//  SDKSettings.swift
//  RushSDK
//
//  Created by Andrey Chernyshev on 09.10.2020.
//

import UIKit

public struct SDKSettings {
    let backendBaseUrl: String?
    let backendApiKey: String?
    
    let amplitudeApiKey: String?
    let facebookActive: Bool
    let branchActive: Bool
    let firebaseActive: Bool
    
    let applicationTag: String?
    
    let userToken: String?
    let userId: Int?
    
    let view: Weak<UIView>?
    
    let shouldAddStorePayment: Bool
    
    let featureAppBackendUrl: String?
    let featureAppBackendApiKey: String?
    
    public init(
        backendBaseUrl: String? = nil,
        backendApiKey: String? = nil,
        amplitudeApiKey: String? = nil,
        facebookActive: Bool = false,
        branchActive: Bool = false,
        firebaseActive: Bool = false,
        applicationTag: String? = nil,
        userToken: String? = nil,
        userId: Int? = nil,
        view: UIView? = nil,
        shouldAddStorePayment: Bool = false,
        featureAppBackendUrl: String? = nil,
        featureAppBackendApiKey: String? = nil) {
        self.backendBaseUrl = backendBaseUrl
        self.backendApiKey = backendApiKey
        self.amplitudeApiKey = amplitudeApiKey
        self.facebookActive = facebookActive
        self.branchActive = branchActive
        self.firebaseActive = firebaseActive
        self.applicationTag = applicationTag
        self.userToken = userToken
        self.userId = userId
        self.shouldAddStorePayment = shouldAddStorePayment
        self.featureAppBackendUrl = featureAppBackendUrl
        self.featureAppBackendApiKey = featureAppBackendApiKey
        
        let viewAsAny = view as AnyObject
        self.view = Weak<UIView>(viewAsAny)
    }
}
