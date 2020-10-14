//
//  BranchManagerCore.swift
//  RushSDK
//
//  Created by Andrey Chernyshev on 14.10.2020.
//

import Branch

final class BranchManagerCore: BranchManager {
    static let shared = BranchManagerCore()
    
    private init() {}
}

// MARK: BranchManager
extension BranchManagerCore {
    @discardableResult
    func initialize() -> Bool {
        guard isActivate() else {
            return false
        }
        
        SDKStorage.shared.featureAppMediator.add(delegate: self)
        SDKStorage.shared.purchaseMediator.add(delegate: self)
        
        return true
    }
    
    func application(didFinishLaunchingWithOptions options: [UIApplication.LaunchOptionsKey: Any]?) {
        guard isActivate() else {
            return
        }
        
        Branch.getInstance().initSession(launchOptions: options)
        
        setupInputSDKParams()
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) {
        guard isActivate() else {
            return
        }
        
        Branch.getInstance().application(app, open: url, options: options)
    }
    
    func application(continue userActivity: NSUserActivity) {
        guard isActivate() else {
            return
        }
        
        Branch.getInstance().continue(userActivity)
    }
    
    func getLatestReferringParams() -> [AnyHashable: Any]? {
        guard isActivate() else {
            return nil
        }
        
        return Branch.getInstance().getLatestReferringParams()
    }
}

// MARK: FeatureAppMediatorDelegate
extension BranchManagerCore: FeatureAppMediatorDelegate {
    func featureAppMediatorDidUpdate(userId: Int, userToken: String) {
        Branch.getInstance().setIdentity(String(userId))
    }
}

// MARK: SDKPurchaseMediatorDelegate
extension BranchManagerCore: SDKPurchaseMediatorDelegate {
    func purchaseMediatorDidValidateReceipt(response: ReceiptValidateResponse?) {
        if let userId = response?.userId {
            Branch.getInstance().setIdentity(String(userId))
        }
    }
}

// MARK: Private
private extension BranchManagerCore {
    func isActivate() -> Bool {
        SDKStorage.shared.branchActive
    }
    
    func setupInputSDKParams() {
        if let userId = SDKStorage.shared.userId {
            Branch.getInstance().setIdentity(String(userId))
        }
    }
}
