//  AppDelegate.swift
//  welfare
//
//  Created by 김동현 on 2020/07/29.
//  Copyright © 2020 com. All rights reserved.


import UIKit
import Firebase
import GoogleSignIn
import FirebaseCore
import FirebaseAuth
import Alamofire
import SwiftyJSON
import FirebaseMessaging
import UserNotifications


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate{
    
    var window: UIWindow?
    var value1: String?
    var naviController : UINavigationController?
    var userInfo : String = ""
    //ui기준이 되는 넓이,높이
    let withBase: CGFloat = 414
    let heightBase: CGFloat = 896
    
    var deviceToken: Data? = nil
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        //로그인 대리자 설정
        // Use Firebase library to configure APIs
        print("앱델리게이트 런칭메소드")
        
        //디바이스별 넓이 높이 지정
        DeviceManager.sharedInstance.heightRatio = UIScreen.main.bounds.height / heightBase
        DeviceManager.sharedInstance.widthRatio =  UIScreen.main.bounds.width / withBase
        DeviceManager.sharedInstance.height = UIScreen.main.bounds.height
        DeviceManager.sharedInstance.width =  UIScreen.main.bounds.width
        
        
        FirebaseApp.configure()
        
        //??
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        
        Messaging.messaging().delegate = self
        
        
        //탭바 설정
        UITabBar.appearance().backgroundColor = UIColor.white
        UITabBar.appearance().tintColor = UIColor(displayP3Red:238/255,green : 47/255, blue : 67/255, alpha: 1)
        
        
        //네비 배경 색상 설정
        UINavigationBar.appearance().tintColor = UIColor(displayP3Red:238/255,green : 47/255, blue : 67/255, alpha: 1)
        
        
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
        
        return true
    }
    
    
    // MARK: UISceneSession Lifecycle
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    
    //Called if unable to register for APNS.
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        print("등록실패")
        print(error)
    }
    
    
    //url여는 메소드
    @available(iOS 9.0, *)
    func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any])
    -> Bool {
        print("url여는 메소드")
        
        return GIDSignIn.sharedInstance().handle(url)
    }
    
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        print("url여는 메소드")
        return GIDSignIn.sharedInstance().handle(url)
    }
    
    
    //사용자가 푸쉬앙람응 허용하면 apns에 디바이스의 토큰값을 저장한다.
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
        print("델리게이트디바이스 토큰")
        print(Messaging.messaging().apnsToken)
    }
}


//푸수알람을 보낼 예정이라는 메소드
@available(iOS 10, *)
extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // print("\(#function)")
        print("푸쉬알람")
        userInfo = notification.request.content.title
        print(userInfo)
        
        LoginManager.sharedInstance.push = true
    }
    
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("푸쉬알람이동")
        // tell the app that we have finished processing the user’s action / response
        LoginManager.sharedInstance.push = true
        
        completionHandler()
    }
}


//카카오톡 로그인관련 메소드
func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
    if KOSession.isKakaoAccountLoginCallback(url.absoluteURL) {
        return KOSession.handleOpen(url)
    }
    
    return true
}


func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
    if KOSession.isKakaoAccountLoginCallback(url.absoluteURL) {
        return KOSession.handleOpen(url)
    }
    return true
}

extension AppDelegate: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
        
        let dataDict:[String: String] = ["token": fcmToken]
        NotificationCenter.default.post(name: Notification.Name("FCMToken"),
                                        object: nil, userInfo: dataDict)
        //fcm 토큰을 디바이스에 저장
        UserDefaults.standard.set(fcmToken, forKey:"fcmToken")
    }
    
    
    func askNotificationsPermissions() {
        if(UIApplication.instancesRespond(to: Selector("registerUserNotificationSettings:"))){
            print("i'm asking the question!")
            
            
            if #available(iOS 10.0, *) {
                // For iOS 10 display notification (sent via APNS)
                UNUserNotificationCenter.current().delegate = self
                
                let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
                UNUserNotificationCenter.current().requestAuthorization(
                    options: authOptions,
                    completionHandler: {_, _ in })
            } else {
                let settings: UIUserNotificationSettings =
                    UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
                UIApplication.shared.registerUserNotificationSettings(settings)
            }
            
            UIApplication.shared.registerForRemoteNotifications()
        }
    }
}
