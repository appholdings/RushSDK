//
//  FacebookManager.swift
//  RushSDK
//
//  Created by Andrey Chernyshev on 14.10.2020.
//

import UIKit

protocol FacebookManager: AnyObject {
    @discardableResult
    func initialize() -> Bool
    
    func application(_ app: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?)
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any])
    
    func fetchDeferredLink(handler: @escaping ((URL?) -> Void))
}
