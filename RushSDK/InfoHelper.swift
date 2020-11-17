//
//  InfoHelper.swift
//  RushSDK
//
//  Created by Andrey Chernyshev on 17.11.2020.
//

import Foundation

final class InfoHelper {
    static var locale: String? {
        guard let mainPreferredLanguage = Locale.preferredLanguages.first else {
            return nil
        }
        
        return Locale(identifier: mainPreferredLanguage).languageCode
    }
    
    static var currencyCode: String? {
        Locale.current.currencyCode
    }
    
    static var countryCode: String? {
        (Locale.current as NSLocale).countryCode
    }
}
