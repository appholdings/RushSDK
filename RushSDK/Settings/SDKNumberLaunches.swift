//
//  SDKNumberLaunches.swift
//  RushSDK
//
//  Created by Andrey Chernyshev on 15.10.2020.
//

final class SDKNumberLaunches {
    struct Constants {
        static let countLaunchKey = "sdk_number_launches_key"
    }
    
    @discardableResult
    func launch() -> Self {
        var count = UserDefaults.standard.integer(forKey: Constants.countLaunchKey)
        
        if count <= (Int.max - 1) {
            count += 1
        }
        
        UserDefaults.standard.set(count, forKey: Constants.countLaunchKey)
        
        return self
    }
    
    func isFirstLaunch() -> Bool {
        UserDefaults.standard.integer(forKey: Constants.countLaunchKey) == 0
    }
}
