//
//  SDKSettingsStorage.swift
//  RushSDK
//
//  Created by Andrey Chernyshev on 09.10.2020.
//

import UIKit

public final class SDKStorage {
    public static let shared = SDKStorage()
    
    private init() {
        purchaseMediator.add(delegate: self)
        featureAppMediator.add(delegate: self)
    }
    
    // MARK: Variables
    var backendBaseUrl: String?
    var backendApiKey: String?
    var amplitudeApiKey: String?
    var facebookActive: Bool = false
    var branchActive: Bool = false
    var firebaseActive: Bool = false 
    var applicationTag: String?
    var userToken: String?
    var userId: Int?
    var userOnTrial: Bool = false
    var view: Weak<UIView>?
    var shouldAddStorePayment: Bool = false 
    var isTest: Bool = false
    
    // MARK: Dependencies
    public var restApiTransport: RestAPITransport {
        RestAPITransport()
    }
    public var iapManager: IAPManager {
        isTest ? IAPManagerMock() : IAPManagerCore()
    }
    public var iapMediator: SDKIAPMediator {
        SDKIAPMediator.shared
    }
    public var purchaseManager: PurchaseManager {
        isTest ? PurchaseManagerMock() : PurchaseManagerCore()
    }
    public var purchaseMediator: SDKPurchaseMediator {
        SDKPurchaseMediator.shared
    }
    public var purchaseInteractor: PurchaseInteractor {
        PurchaseInteractorCore()
    }
    public var featureAppMediator: FeatureAppMediator {
        FeatureAppMediator.shared
    }
    public var amplitudeManager: AmplitudeManager {
        AmplitudeManagerCore.shared
    }
    public var pushNotificationsManager: PushNotificationsManager {
        PushNotificationsManagerCore.shared
    }
    var abTestsManager: ABTestsManager {
        isTest ? ABTestsManagerMock() : ABTestsManagerCore()
    }
    var facebookManager: FacebookManager {
        FacebookManagerCore.shared
    }
    var branchManager: BranchManager {
        BranchManagerCore.shared
    }
    var firebaseManager: FirebaseManager {
        FirebaseManagerCore.shared
    }
    var adAttributionDetails: ADAttributionDetails {
        ADAttributionDetails()
    }
    var adAttributionsManager: ADAttributionsManager {
        ADAttributionsManagerCore.shared
    }
    var registerInstallManager: RegisterInstallManager {
        RegisterInstallManagerCore()
    }
    var userManager: UserManager {
        UserManagerCore.shared
    }
    var pushNotificationsUpdater: PushNotificationsTokenUpdater {
        PushNotificationsTokenUpdater.shared
    }
    
    // MARK: Computed
    public var applicationAnonymousID: String {
        ApplicationAnonymousID.anonymousID
    }
    public var abTestsOutput: ABTestsOutput? {
        abTestsManager.getCachedTests()
    }
    var isFirstLaunch: Bool {
        SDKNumberLaunches().isFirstLaunch()
    }
}

// MARK: SDKPurchaseMediatorDelegate
extension SDKStorage: SDKPurchaseMediatorDelegate {
    public func purchaseMediatorDidValidateReceipt(response: ReceiptValidateResponse?) {
        guard let userId = response?.userId, let userToken = response?.userToken else {
            return
        }
        
        self.userId = userId
        self.userToken = userToken
        self.userOnTrial = response?.onTrial ?? false 
    }
}

// MARK: FeatureAppMediatorDelegate
extension SDKStorage: FeatureAppMediatorDelegate {
    func featureAppMediatorDidUpdate(userId: Int, userToken: String) {
        self.userId = userId
        self.userToken = userToken
    }
}
