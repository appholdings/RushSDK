//
//  ADAttributionDetails.swift
//  RushSDK
//
//  Created by Andrey Chernyshev on 14.10.2020.
//

import iAd

final class ADAttributionDetails {
    func request(handler: @escaping ([String: Any]?) -> Void) {
        guard isAvailable() else {
            handler(nil)
            return
        }
        
        ADClient.shared().requestAttributionDetails { details, _ in
            let attributionsDetails = details?.first?.value as? [String: Any] ?? [:]
            
            handler(attributionsDetails)
        }
    }
    
    func isTest(attributionsDetails: [String: Any]) -> Bool {
        let iadCampaignId = attributionsDetails["iad-campaign-id"] as? String ?? "1234567890"
        
        return (iadCampaignId == "1234567890")
    }
}

// MARK: Private
private extension ADAttributionDetails {
    func isAvailable() -> Bool {
        let os = ProcessInfo().operatingSystemVersion
        
        guard os.majorVersion <= 14 else {
            return false
        }
        
        if os.majorVersion == 14 {
            return os.minorVersion < 3
        }
        
        return true
    }
}
