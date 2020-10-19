//
//  RegisterInstallManager.swift
//  RushSDK
//
//  Created by Andrey Chernyshev on 19.10.2020.
//

protocol RegisterInstallManager: class {
    func register(completion: ((Bool) -> Void)?)
}
