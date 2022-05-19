//
//  FacebookManagerCore.swift
//  RushSDK
//
//  Created by Andrey Chernyshev on 14.10.2020.
//

import FBSDKCoreKit
import RxSwift
import StoreKit

final class FacebookManagerCore: FacebookManager {
    static let shared = FacebookManagerCore()
    
    private lazy var iapManager = SDKStorage.shared.iapManager
    
    private let disposeBag = DisposeBag()
    
    private init() {}
}

// MARK: FacebookManager
extension FacebookManagerCore {
    @discardableResult
    func initialize() -> Bool {
        guard isActivate() else {
            log(text: "facebook not activate")
            return false
        }
        
        Settings.shared.isAdvertiserTrackingEnabled = true
        
        SDKStorage.shared.purchaseMediator.add(delegate: self)
        SDKStorage.shared.featureAppMediator.add(delegate: self)
        SDKStorage.shared.iapMediator.add(delegate: self)
        
        log(text: "facebook activate")
        
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
        
        AppEvents.shared.activateApp()
        
        setupInputSDKParams()
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
            set(userID: userId)
            logEvent(name: "client_user_id_set")
            
            log(text: "facebook set userId: \(userId) in purchaseMediatorDidValidateReceipt")
        }
    }
}

// MARK: FeatureAppMediatorDelegate
extension FacebookManagerCore: FeatureAppMediatorDelegate {
    func featureAppMediatorDidUpdate(userId: Int, userToken: String) {
        set(userID: userId)
        logEvent(name: "client_user_id_set")
        
        log(text: "facebook set userId: \(userId) in featureAppMediatorDidUpdate")
    }
}

// MARK: SDKIAPMediatorDelegate
extension FacebookManagerCore: SDKIAPMediatorDelegate {
    func iapMediatorBiedProduct(with result: IAPActionResult) {
        guard case let .completed(productId) = result else {
            return
        }
        
        iapManager
            .obtainProducts(ids: [productId])
            .subscribe(onSuccess: { products in
                guard let product = products.first(where: { $0.product.productIdentifier == productId })?.product else {
                    return
                }
                
                FacebookManagerCore.shared.logPurchase(product: product)
                FacebookManagerCore.shared.logEventAfterPurchase(product: product)
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
            set(userID: userId)
            logEvent(name: "client_user_id_set")
            
            log(text: "facebook set userId: \(userId) in setupInputSDKParams")
        }
    }
    
    func set(userID: Int) {
        AppEvents.shared.userID = String(userID)
    }
    
    func logEvent(name: String) {
        let eventName = AppEvents.Name(name)
        AppEvents.shared.logEvent(eventName)
    }
    
    func logPurchase(product: SKProduct) {
        let isSubscription = Self.shared.iapManager.isSubscription(product: product)

        let factor: Double = isSubscription ? 0 : 1
        
        let price = product.price.doubleValue * factor
        let currency = product.priceLocale.currencyCode ?? "unknown"

        AppEvents.shared.logPurchase(amount: price, currency: currency)

        log(text: "faceboook log purchase with price: \(price), currency: \(currency)")
    }

     func logEventAfterPurchase(product: SKProduct) {
         if let userId = SDKStorage.shared.userId {
             set(userID: userId)
         }

         let isSubscription = SDKStorage.shared.iapManager.isSubscription(product: product)

         let logName = isSubscription ? "StartTrial" : "fb_mobile_purchase"
         logEvent(name: logName)
     }
}
