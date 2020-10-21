//
//  PushNotificationsManagerCore.swift
//  RushSDK
//
//  Created by Andrey Chernyshev on 22.10.2020.
//

import FirebaseMessaging

final class PushNotificationsManagerCore: NSObject, PushNotificationsManager {
    static let shared = PushNotificationsManagerCore()
    
    private let notificationsCenter = UNUserNotificationCenter.current()
    
    private var delegates = [Weak<PushNotificationsManagerDelegate>]()
    
    private override init() {}
}

// MARK: UNUserNotificationCenterDelegate
extension PushNotificationsManagerCore: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        received(userInfo: response.notification.request.content.userInfo)
    }
}

// MARK: PushNotificationsManager(API)
extension PushNotificationsManagerCore {
    @discardableResult
    func initialize() -> Bool {
        notificationsCenter.delegate = self
        
        return true
    }
    
    func retriveAuthorizationStatus(handler: ((PushNotificationsAuthorizationStatus) -> Void)?) {
        notificationsCenter.getNotificationSettings { settings in
            DispatchQueue.main.async { [weak self] in
                let result: PushNotificationsAuthorizationStatus
                
                switch settings.authorizationStatus {
                case .authorized:
                    result = .authorized
                case .notDetermined:
                    result = .notDetermined
                default:
                    result = .denied
                }
                
                log(text: "push notifications received authorization status: \(result)")
                
                handler?(result)
                self?.delegates.forEach { $0.weak?.pushNotificationsManagerDidReceive(authorizationStatus: result) }
            }
        }
    }
    
    func requestAuthorization() {
        notificationsCenter.requestAuthorization(options: [.alert, .sound]) { granted, _ in
            DispatchQueue.main.async {
                if granted {
                    UIApplication.shared.registerForRemoteNotifications()
                } else {
                    log(text: "push notifications not granted")
                    
                    self.delegates.forEach { $0.weak?.pushNotificationsManagerDidReceive(token: nil) }
                }
            }
        }
    }
}

// MARK: PushNotificationsManager(AppDelegate triggers)
extension PushNotificationsManagerCore {
    func application(didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {}
    
    func application(didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        received(pushToken: deviceToken, error: nil)
    }
    
    func application(didFailToRegisterForRemoteNotificationsWithError error: Error) {
        received(pushToken: nil, error: error)
    }
    
    func application(didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        received(userInfo: userInfo)
        
        completionHandler(.noData)
    }
}

// MARK: PushNotificationsManager(Observer)
extension PushNotificationsManagerCore {
    func add(observer: PushNotificationsManagerDelegate) {
        let weakly = observer as AnyObject
        delegates.append(Weak<PushNotificationsManagerDelegate>(weakly))
        delegates = delegates.filter { $0.weak != nil }
    }
    
    func remove(observer: PushNotificationsManagerDelegate) {
        if let index = delegates.firstIndex(where: { $0.weak === observer }) {
            delegates.remove(at: index)
        }
    }
}

// MARK: Private
private extension PushNotificationsManagerCore {
    func received(pushToken: Data?, error: Error?) {
        Messaging.messaging().apnsToken = pushToken
        
        DispatchQueue.main.async { [weak self] in
            if error == nil, let token = Messaging.messaging().fcmToken {
                log(text: "push notifications received pushToken: \(token)")
                
                self?.delegates.forEach { $0.weak?.pushNotificationsManagerDidReceive(token: token) }
            } else {
                log(text: "push notifications received error")
                
                self?.delegates.forEach { $0.weak?.pushNotificationsManagerDidReceive(token: nil) }
            }
        }
    }
    
    func received(userInfo: [AnyHashable : Any]) {
        let model = PushNotificationsModel(userInfo: userInfo)
        
        log(text: "push notifications received userInfo: \(userInfo)")
        
        DispatchQueue.main.async { [weak self] in
            self?.delegates.forEach { $0.weak?.pushNotificationsManagerDidReceive(model: model) }
        }
    }
}
