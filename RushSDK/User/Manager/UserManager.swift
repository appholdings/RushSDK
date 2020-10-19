//
//  UserManager.swift
//  RushSDK
//
//  Created by Andrey Chernyshev on 19.10.2020.
//

import RxSwift

protocol UserManager: class {
    @discardableResult
    func initialize() -> Bool
    
    func rxUpdateMetaData() -> Single<Bool>
}
