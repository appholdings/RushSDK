//
//  SDKConfigurationManagerCore.swift
//  RushSDK
//
//  Created by Andrey Chernyshev on 04.01.2021.
//

import RxSwift

final class SDKConfigurationManagerCore: SDKConfigurationManager {
    struct Constants {
        static let cachedConfigurationKey = "configuration_manager_core_cached_configuration"
    }
    
    private let requestWrapper = RequestWrapper()
}

// MARK: API
extension SDKConfigurationManagerCore {
    func clearCache() {
        UserDefaults.standard.removeObject(forKey: Constants.cachedConfigurationKey)
        
        log(text: "sdkConfigurationManager clear cache")
    }
    
    func getCachedConfiguration() -> SDKConfiguration? {
        guard let data = UserDefaults.standard.data(forKey: Constants.cachedConfigurationKey) else {
            return nil
        }
        
        return try? JSONDecoder().decode(SDKConfiguration.self, from: data)
    }
}

// MARK: API(Rx)
extension SDKConfigurationManagerCore {
    func rxObtainConfiguration() -> Single<SDKConfiguration?> {
        guard
            let domain = SDKStorage.shared.backendBaseUrl,
            let apiKey = SDKStorage.shared.backendApiKey
        else {
            return Single.error(ABConfigurationError(code: .sdkNotInitialized))
        }
        
        let request = GetConfigurationRequest(domain: domain,
                                              apiKey: apiKey)
        
        return requestWrapper
            .callServerApi(requestBody: request)
            .map(GetConfigurationResponseMapper.map(from:))
            .flatMap(store(configuration:))
    }
}

// MARK: Private
private extension SDKConfigurationManagerCore {
    func store(configuration: SDKConfiguration?) -> Single<SDKConfiguration?> {
        guard
            let config = configuration,
            let data = try? JSONEncoder().encode(config)
        else {
            return .just(configuration)
        }
        
        UserDefaults.standard.setValue(data, forKey: Constants.cachedConfigurationKey)
        
        log(text: "sdkConfigurationManager stored config: \(config)")
        
        return .just(configuration)
    }
}
