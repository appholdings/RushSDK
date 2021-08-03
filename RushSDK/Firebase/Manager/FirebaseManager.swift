//
//  FirebaseManager.swift
//  RushSDK
//
//  Created by Andrey Chernyshev on 21.10.2020.
//

protocol FirebaseManager: AnyObject {
    @discardableResult
    func initialize() -> Bool
}
