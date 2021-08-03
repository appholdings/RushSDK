//
//  RegisterInstallManager.swift
//  RushSDK
//
//  Created by Andrey Chernyshev on 19.10.2020.
//

protocol RegisterInstallManager: AnyObject {
    func register(completion: ((Bool) -> Void)?)
}
