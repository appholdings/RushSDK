//
//  SDKSettingsStorage.swift
//  RushSDK
//
//  Created by Andrey Chernyshev on 09.10.2020.
//

public final class SDKStorage {
    public static let shared = SDKStorage()
    
    private init() {}
    
    // MARK: Variables
    var backendBaseUrl: String?
    var backendApiKey: String?
    var amplitudeApiKey: String?
    var facebookActive: Bool = false
    var branchActive: Bool = false 
    var applicationTag: String?
    var userToken: String?
    var userId: Int?
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
    public var featureAppMediator: FeatureAppMediator {
        FeatureAppMediator.shared
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
    
    // MARK: Computed
    public var applicationAnonymousID: String {
        ApplicationAnonymousID.anonymousID
    }
    public var abTestsOutput: ABTestsOutput? {
        abTestsManager.getCachedTests()
    }
}
