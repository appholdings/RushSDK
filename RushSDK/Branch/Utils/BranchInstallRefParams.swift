//
//  BranchInstallRefParams.swift
//  RushSDK
//
//  Created by Andrey Chernyshev on 04.08.2021.
//

import Branch
import RxSwift

final class BranchInstallRefParams {
    deinit {
        timer?.invalidate()
        timer = nil
    }
    
    private var timer: Timer?
    
    private var tick = 0
}

// MARK: Public
extension BranchInstallRefParams {
    func obtainInstallRefParams() -> Single<String?> {
        Single<String?>
            .create { [weak self] event in
                guard let self = self else {
                    event(.success(nil))
                    return Disposables.create()
                }
                
                self.getInstallRefParams { token in
                    event(.success(token))
                    
                    if let token = token {
                        SDKUserManagerMediator.shared.notifyAboutReceivedFeatureApp(userToken: token)
                               
                        log(text: "branch contained userToken: \(token)")
                    }
                }
                
                return Disposables.create()
            }
    }
}

// MARK: Private
private extension BranchInstallRefParams {
    func getInstallRefParams(handler: ((String?) -> Void)? = nil) {
        timer?.invalidate()
        tick = 0
        
        guard SDKStorage.shared.isFirstLaunch else {
            handler?(nil)
            return
        }
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let self = self else {
                return
            }
            
            let params = Branch.getInstance().getFirstReferringParams()
            let userToken = params?["user_token"] as? String
            
            if userToken != nil || self.tick > 10 {
                self.timer?.invalidate()
                self.timer = nil
                
                handler?(userToken)
                
                return
            }
            
            self.tick += 1
        }
    }
}
