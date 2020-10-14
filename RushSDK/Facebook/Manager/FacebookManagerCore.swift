//
//  FacebookManagerCore.swift
//  RushSDK
//
//  Created by Andrey Chernyshev on 14.10.2020.
//

import FBSDKCoreKit
import RxSwift

final class FacebookManagerCore: FacebookManager {
    static let shared = FacebookManagerCore()
    
    private let disposeBag = DisposeBag()
    
    private init() {}
}

// MARK: FacebookManager
extension FacebookManagerCore {
    @discardableResult
    func initialize() -> Bool {
        guard isActivate() else {
            return false
        }
        
        SDKStorage.shared.purchaseMediator.add(delegate: self)
        SDKStorage.shared.featureAppMediator.add(delegate: self)
        SDKStorage.shared.iapMediator.add(delegate: self)
        
        AppEvents.activateApp()
        
        setupInputSDKParams()
        
        return true
    }
    
    func fetchDeferredLink(handler: @escaping ((URL?) -> Void)) {
        guard isActivate() else {
            handler(nil)
            
            return
        }
        
        AppLinkUtility.fetchDeferredAppLink { url, _ in
            handler(url)
        }
    }
    
    func application(_ app: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        guard isActivate() else {
            return
        }
        
        ApplicationDelegate.shared.application(app, didFinishLaunchingWithOptions: launchOptions)
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) {
        guard isActivate() else {
            return
        }
        
        ApplicationDelegate.shared.application(app, open: url, options: options)
    }
}

// MARK: SDKPurchaseMediatorDelegate
extension FacebookManagerCore: SDKPurchaseMediatorDelegate {
    func purchaseMediatorDidValidateReceipt(response: ReceiptValidateResponse?) {
        if let userId = response?.userId {
            AppEvents.userID = String(userId)
        }
    }
}

// MARK: FeatureAppMediatorDelegate
extension FacebookManagerCore: FeatureAppMediatorDelegate {
    func featureAppMediatorDidUpdate(userId: Int, userToken: String) {
        AppEvents.userID = String(userId)
    }
}

// MARK: SDKIAPMediatorDelegate
extension FacebookManagerCore: SDKIAPMediatorDelegate {
    func iapMediatorBiedProduct(with result: IAPActionResult) {
        guard case let .completed(productId) = result else {
            return
        }
        
        SDKStorage.shared
            .iapManager
            .obtainProducts(ids: [productId])
            .subscribe(onSuccess: { products in
                guard let product = products.first(where: { $0.product.productIdentifier == productId })?.product else {
                    return
                }
                
                let price = product.price.doubleValue * 0.7
                let currency = product.priceLocale.currencyCode ?? "unknown"
                
                AppEvents.logPurchase(price, currency: currency)
                
                AppEvents.logEvent(AppEvents.Name("fb_mobile_purchase"))
            })
            .disposed(by: disposeBag)
    }
}

// MARK: Private
extension FacebookManagerCore {
    func isActivate() -> Bool {
        SDKStorage.shared.facebookActive
    }
    
    func setupInputSDKParams() {
        if let userId = SDKStorage.shared.userId {
            AppEvents.userID = String(userId)
        }
    }
}
