//
//  BranchManager.swift
//  RushSDK
//
//  Created by Andrey Chernyshev on 14.10.2020.
//

import UIKit

protocol BranchManager: AnyObject {
    @discardableResult
    func initialize() -> Bool
    
    func application(didFinishLaunchingWithOptions options: [UIApplication.LaunchOptionsKey: Any]?)
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any])
    func application(continue userActivity: NSUserActivity)
    
    func getLatestReferringParams() -> [AnyHashable: Any]?
}
