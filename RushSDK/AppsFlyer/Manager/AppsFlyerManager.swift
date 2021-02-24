//
//  AppsFlyerManager.swift
//  RushSDK
//
//  Created by Andrey Chernyshev on 24.02.2021.
//

import UIKit

public protocol AppsFlyerManager: class {
    @discardableResult
    func initialize() -> Bool
    
    func applicationDidBecomeActive(_ application: UIApplication)
}
