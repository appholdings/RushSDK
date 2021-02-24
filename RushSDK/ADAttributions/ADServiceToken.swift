//
//  ADServiceToken.swift
//  RushSDK
//
//  Created by Andrey Chernyshev on 24.02.2021.
//

import AdServices

final class ADServiceToken {
    func retrieve() -> String? {
        if #available(iOS 14.3, *) {
            return try? AAAttribution.attributionToken()
        }
        
        return nil
    }
}
