//
//  AppDelegate.swift
//  RushSDKSample
//
//  Created by Andrey Chernyshev on 06.10.2020.
//

import UIKit
import RushSDK
import AdServices

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        if #available(iOS 14.3, *) {
            let d = try? AAAttribution.attributionToken()
            print()
        }
        
        return true
    }
}
