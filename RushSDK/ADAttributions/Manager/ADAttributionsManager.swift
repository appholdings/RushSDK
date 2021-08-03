//
//  ADAttributionsManager.swift
//  RushSDK
//
//  Created by Andrey Chernyshev on 18.10.2020.
//

import UIKit

protocol ADAttributionsManager: AnyObject {
    func application(didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?)
    func application(with userActivity: NSUserActivity)
    func application(with url: URL, options: [UIApplication.OpenURLOptionsKey : Any])
}
