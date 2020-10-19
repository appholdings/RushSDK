//
//  ADAttributionDetails.swift
//  RushSDK
//
//  Created by Andrey Chernyshev on 14.10.2020.
//

import iAd

final class ADAttributionDetails {
    func request(handler: @escaping ([String: Any]) -> Void) {
        ADClient.shared().requestAttributionDetails { details, _ in
            let attributionsDetails = details?.first?.value as? [String: Any] ?? [:]
            
            handler(attributionsDetails)
        }
    }
    
    func isTest(attributionsDetails: [String: Any]) -> Bool {
        let iadAttribution = attributionsDetails["iad-attribution"] as? String ?? "false"
        let iadCampaignId = attributionsDetails["iad-campaign-id"] as? String ?? "1234567890"
        
        return (iadAttribution == "false") || (iadCampaignId == "1234567890")
    }
}
