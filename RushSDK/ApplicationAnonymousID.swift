//
//  ApplicationAnonymousID.swift
//  RushSDK
//
//  Created by Andrey Chernyshev on 12.10.2020.
//

struct ApplicationAnonymousID {
    static var anonymousID: String {
        let udKey = "app_random_key"
        
        if let randomKey = UserDefaults.standard.string(forKey: udKey) {
            return randomKey
        } else {
            let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
            let randomKey = String((0..<128).map{ _ in letters.randomElement()! })
            UserDefaults.standard.set(randomKey, forKey: udKey)
            return randomKey
        }
    }
}
