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
        userManagerMediator.add(delegate: self)
    }
    
    // MARK: Variables
    var backendBaseUrl: String?
    var backendApiKey: String?
    var amplitudeApiKey: String?
    var appsFlyerApiKey: String?
    var facebookActive: Bool = false
    var branchActive: Bool = false
    var firebaseActive: Bool = false 
    var applicationTag: String?
    var userToken: String?
    var userId: Int?
    var view: Weak<UIView>?
    var shouldAddStorePayment: Bool = false 
    var isTest: Bool = false
    var featureAppBackendUrl: String?
    var featureAppBackendApiKey: String?
    var appleAppID: String?
    
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
        PurchaseManagerCore()
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
    public var appsFlyerManager: AppsFlyerManager {
        AppsFlyerManagerCore.shared
    }
    public var pushNotificationsManager: PushNotificationsManager {
        PushNotificationsManagerCore.shared
    }
    public var userManagerMediator: SDKUserManagerMediator {
        SDKUserManagerMediator.shared
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
    var adServiceToken: ADServiceToken {
        ADServiceToken()
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
    }
}

// MARK: FeatureAppMediatorDelegate
extension SDKStorage: FeatureAppMediatorDelegate {
    func featureAppMediatorDidUpdate(userId: Int, userToken: String) {
        self.userId = userId
        self.userToken = userToken
    }
}

// MARK: SDKUserManagerMediatorDelegate
extension SDKStorage: SDKUserManagerMediatorDelegate {
    public func userManagerMediatorDidReceivedFeatureApp(userToken: String) {
        self.userToken = userToken
    }
}
