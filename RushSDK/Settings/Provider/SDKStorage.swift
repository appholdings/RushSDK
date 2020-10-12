//
//  SDKSettingsStorage.swift
//  RushSDK
//
//  Created by Andrey Chernyshev on 09.10.2020.
//

final class SDKStorage {
    static let shared = SDKStorage()
    
    private init() {}
    
    // MARK: Variables
    var backendBaseUrl: String?
    var backendApiKey: String?
    var amplitudeApiKey: String?
    var applicationTag: String?
    var userToken: String?
    var userId: Int?
    var isTest: Bool = false
    
    // MARK: Dependencies
    var restApiTransport: RestAPITransport {
        RestAPITransport()
    }
    var iapManager: IAPManager {
        isTest ? IAPManagerMock() : IAPManagerCore()
    }
}
