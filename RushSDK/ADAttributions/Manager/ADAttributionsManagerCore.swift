//
//  ADAttributionsManagerCore.swift
//  RushSDK
//
//  Created by Andrey Chernyshev on 18.10.2020.
//

import UIKit
import RxSwift

final class ADAttributionsManagerCore: ADAttributionsManager {
    static let shared = ADAttributionsManagerCore()
    
    private let disposeBag = DisposeBag()
    
    private init() {}
}

// MARK: ADAttributionsManager
extension ADAttributionsManagerCore {
    func application(didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        guard SDKStorage.shared.isFirstLaunch else {
            return
        }
        
        uploadADServiceToken()
        
        if
            let userActivityDictionary = launchOptions?[UIApplication.LaunchOptionsKey.userActivityDictionary] as? [UIApplication.LaunchOptionsKey: Any],
            let userActivityId = userActivityDictionary[.userActivityType] as? String {
            let userActivity = NSUserActivity(activityType: userActivityId)
            
            application(with: userActivity)
        } else {
            parseWithFacebook { [weak self] facebookResult in
                guard let this = self else {
                    return
                }
                
                if let facebookLinkAttributions = facebookResult {
                    this.setLinkAttributions(facebookLinkAttributions)
                    
                    return
                }
                
                this.retrieveADAttributions { adResult in
                    if let adAttributions = adResult {
                        this.setAttributions(adAttributions)
                        
                        return
                    }
                }
            }
        }
    }
    
    func application(with userActivity: NSUserActivity) {
        guard SDKStorage.shared.isFirstLaunch else {
            return
        }
        
        parse(from: userActivity) { [weak self] result in
            guard let this = self else {
                return
            }
            
            if let linkAttributions = result {
                this.setLinkAttributions(linkAttributions)
                
                return
            }
            
            this.parseWithBranch { branchResult in
                if let branchLinkAttributions = branchResult {
                    this.setLinkAttributions(branchLinkAttributions)
                    
                    return
                }
                
                this.parseWithFacebook() { fbResult in
                    if let fbLinkAttributions = fbResult {
                        this.setLinkAttributions(fbLinkAttributions)
                        
                        return
                    }
                    
                    this.retrieveADAttributions { adResult in
                        if let adAttributions = adResult {
                            this.setAttributions(adAttributions)
                            
                            return
                        }
                    }
                }
            }
        }
    }
    
    func application(with url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) {
        guard SDKStorage.shared.isFirstLaunch else {
            return
        }
        
        parseWithBranch { [weak self] branchResult in
            guard let this = self else {
                return
            }
            
            if let branchLinkAttributions = branchResult {
                this.setLinkAttributions(branchLinkAttributions)
                
                return
            }
            
            this.parseWithFacebook(url: url) { facebookResult in
                if let facebookLinkAttributions = facebookResult {
                    this.setLinkAttributions(facebookLinkAttributions)
                    
                    return
                }
                
                this.retrieveADAttributions { adResult in
                    if let adAttributions = adResult {
                        this.setAttributions(adAttributions)
                        
                        return
                    }
                }
            }
        }
    }
}

// MARK: Private
private extension ADAttributionsManagerCore {
    func parse(from userActivity: NSUserActivity, handler: ((ADLinkAttributions?) -> Void)) {
        guard userActivity.activityType == NSUserActivityTypeBrowsingWeb, let url = userActivity.webpageURL else {
            handler(nil)
            
            return
        }
        
        let attributions = adLinkAttributions(from: url)
        
        handler(attributions)
    }
    
    func parseWithBranch(handler: ((ADLinkAttributions?) -> Void)) {
        guard let dict = SDKStorage.shared.branchManager.getLatestReferringParams() else {
            handler(nil)
            
            return
        }
        
        let attributions = ADLinkAttributions(channel: dict["channel"] as? String,
                                              campaign: dict["campaign"] as? String,
                                              adgroup: dict["adgroup"] as? String,
                                              feature: dict["feature"] as? String)
        
        let result = isEmpty(attributions: attributions) ? nil : attributions
        
        handler(result)
    }
    
    
    func parseWithFacebook(url: URL? = nil, handler: @escaping ((ADLinkAttributions?) -> Void)) {
        SDKStorage.shared.facebookManager.fetchDeferredLink { [weak self] result in
            guard let this = self, let link = (result ?? url) else {
                handler(nil)
                
                return
            }
            
            let attributions = this.adLinkAttributions(from: link)
            
            handler(attributions)
        }
    }
    
    func adLinkAttributions(from url: URL) -> ADLinkAttributions? {
        guard let queryItems = URLComponents(url: url, resolvingAgainstBaseURL: false)?.queryItems else {
            return nil
        }
        
        let attributions = ADLinkAttributions(channel: queryItems.first(where: { $0.name == "channel" })?.value,
                                              campaign: queryItems.first(where: { $0.name == "campaign" })?.value,
                                              adgroup: queryItems.first(where: { $0.name == "adgroup" })?.value,
                                              feature: queryItems.first(where: { $0.name == "feature" })?.value)
        
        return isEmpty(attributions: attributions) ? nil : attributions
    }
    
    func setLinkAttributions(_ attributions: ADLinkAttributions) {
        guard let domain = SDKStorage.shared.backendBaseUrl, let apiKey = SDKStorage.shared.backendApiKey else {
            return
        }
        
        RestAPITransport()
            .callServerApi(requestBody: SetADLinkAttributionsRequest(domain: domain,
                                                                     apiKey: apiKey,
                                                                     anonymousID: SDKStorage.shared.applicationAnonymousID,
                                                                     channel: attributions.channel,
                                                                     campaign: attributions.campaign,
                                                                     adgroup: attributions.adgroup,
                                                                     feature: attributions.feature))
            .subscribe()
            .disposed(by: disposeBag)
        
        let parameters: [String: Any] = [
            "adgroup": attributions.adgroup as Any,
            "campaign": attributions.campaign as Any,
            "channel": attributions.channel as Any,
            "feature": attributions.feature as Any
        ]
        SDKStorage.shared.amplitudeManager.logEvent(name: "Install Attribution", parameters: parameters)
        
        log(text: "adAttributionsManager set link attributes: \(attributions)")
    }
    
    func retrieveADAttributions(handler: @escaping (([String: Any]?) -> Void)) {
        SDKStorage.shared
            .adAttributionDetails
            .request { result in
                if let details = result, !SDKStorage.shared.adAttributionDetails.isTest(attributionsDetails: details) {
                    handler(details)
                } else {
                    handler(nil)
                }
            }
    }
    
    func setAttributions(_ attributions: [String: Any]) {
        guard let domain = SDKStorage.shared.backendBaseUrl, let apiKey = SDKStorage.shared.backendApiKey else {
            return
        }
        
        RestAPITransport()
            .callServerApi(requestBody: SetADAttributionsRequest(domain: domain,
                                                                 apiKey: apiKey,
                                                                 anonymousId: SDKStorage.shared.applicationAnonymousID,
                                                                 attributions: attributions))
            .subscribe()
            .disposed(by: disposeBag)
        
        let parameters: [String: Any] = [
            "adgroup": attributions["iad-adgroup-name"] as? String ?? "",
            "campaign": attributions["iad-campaign-name"] as? String ?? "",
            "channel": "Apple Search Ads",
            "feature": attributions["iad-keyword"] as? String ?? "",
        ]
        SDKStorage.shared.amplitudeManager.logEvent(name: "Install Attribution", parameters: parameters)
        
        log(text: "adAttributionsManager set attributes: \(attributions)")
    }
    
    func isEmpty(attributions: ADLinkAttributions) -> Bool {
        attributions.channel == nil
            && attributions.campaign == nil
            && attributions.adgroup == nil
            && attributions.feature == nil
    }
    
    func uploadADServiceToken() {
        guard
            let domain = SDKStorage.shared.backendBaseUrl,
            let apiKey = SDKStorage.shared.backendApiKey,
            let adServiceToken = SDKStorage.shared.adServiceToken.retrieve()
        else {
            return
        }
        
        let request = SetADServiceTokenRequest(domain: domain,
                                               apiKey: apiKey,
                                               anonymousId: SDKStorage.shared.applicationAnonymousID,
                                               adServiceToken: adServiceToken)
        
        SDKStorage.shared
            .restApiTransport
            .callServerApi(requestBody: request)
            .subscribe()
            .disposed(by: disposeBag)
    }
}
