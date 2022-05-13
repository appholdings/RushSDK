//
//  RegisterInstallManagerCore.swift
//  RushSDK
//
//  Created by Andrey Chernyshev on 19.10.2020.
//

import WebKit

final class RegisterInstallManagerCore: NSObject, RegisterInstallManager {
    private lazy var webView: WKWebView = {
        let view = WKWebView()
        view.frame.origin = CGPoint(x: 0, y: 0)
        view.frame.size = CGSize(width: 70, height: 70)
        view.backgroundColor = UIColor.clear
        view.alpha = 0.000000000000001
        view.navigationDelegate = self
        return view
    }()
    
    private var completion: ((Bool) -> Void)?
}

// MARK: RegisterInstallManager
extension RegisterInstallManagerCore {
    func register(completion: ((Bool) -> Void)?) {
        guard SDKStorage.shared.isFirstLaunch else {
            completion?(false)
            
            log(text: "register install manager not active because is not first launch")
            
            return
        }
        
        guard let containerView = SDKStorage.shared.view?.weak else {
            completion?(false)
            
            log(text: "register install manager not activate")
            
            return
        }
        
        guard
            let domain = SDKStorage.shared.backendBaseUrl,
            let apiKey = SDKStorage.shared.backendApiKey,
            let url = URL(string: String(format: "%@/api/sdk/register_install?_api_key=%@&anonymous_id=%@&currency=%@&locale=%@&country=%@&idfv=%@",
                                         domain, apiKey,
                                         SDKStorage.shared.applicationAnonymousID,
                                         InfoHelper.currencyCode ?? "",
                                         InfoHelper.locale ?? "",
                                         InfoHelper.countryCode ?? "",
                                         InfoHelper.idfv ?? "")),
            let request = try? URLRequest(url: url, method: .get)
        else {
            completion?(false)
            
            log(text: "register install manager not activate")
            
            return
        }
        
        self.completion = completion
        
        containerView.addSubview(webView)
        
        webView.load(request)
    }
}

// MARK: WKNavigationDelegate
extension RegisterInstallManagerCore: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        completion?(true)
        
        log(text: "register install manager complete success")
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        completion?(false)
        
        log(text: "register install manager complete failure")
    }
}
