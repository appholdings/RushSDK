//
//  FirebaseManager.swift
//  RushSDK
//
//  Created by Andrey Chernyshev on 21.10.2020.
//

protocol FirebaseManager: class {
    @discardableResult
    func initialize() -> Bool
}
