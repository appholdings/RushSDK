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
    
    func rxNewFeatureAppUser() -> Single<String?>
    func rxFeatureAppLoginUser(with userToken: String) -> Single<Bool>
}
