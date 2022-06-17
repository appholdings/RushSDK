//
//  UserCredentialsMediatorDelegate.swift
//  RushSDK
//
//  Created by Andrey Chernyshev on 13.10.2020.
//

protocol FeatureAppMediatorDelegate: AnyObject {
    func featureAppMediatorDidUpdate(userId: String, userToken: String)
}

//extension FeatureAppMediatorDelegate {
//    func featureAppMediatorDidUpdate(userId: String, userToken: String) {}
//}
