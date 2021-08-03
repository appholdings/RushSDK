//
//  AmplitudeManager.swift
//  RushSDK
//
//  Created by Andrey Chernyshev on 14.10.2020.
//

public protocol AmplitudeManager: AnyObject {
    @discardableResult
    func initialize() -> Bool
    
    func logEvent(name: String, parameters: [String: Any])
}
