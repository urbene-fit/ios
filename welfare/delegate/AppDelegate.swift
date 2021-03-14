//
//  AppDelegate.swift
//  welfare
//
//  Created by 김동현 on 2020/07/29.
//  Copyright © 2020 com. All rights reserved.
//

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
class AppDelegate: UIResponder, UIApplicationDelegate{ //GIDSignInDelegate {
    
    var window: UIWindow?
    var value1: String?
    var naviController : UINavigationController?
    var userInfo : String = ""
    //ui기준이 되는 넓이,높이
    let withBase: CGFloat = 414
    let heightBase: CGFloat = 896
    
    var deviceToken: Data? = nil

    //알림파싱 결과
    struct alramParse: Decodable {
        let Status : String
    
    }
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        //로그인 대리자 설정
        // Use Firebase library to configure APIs
        print("앱델리게이트 런칭메소드")
        
        //디바이스별 넓이 높이 지정
        //sharedDeviceManager.heightRatio = UIScreen.main.bounds.width / heightBase
        //sharedDeviceManager.widthRatio = UIScreen.main.bounds.width / withBase
        DeviceManager.sharedInstance.heightRatio = UIScreen.main.bounds.height / heightBase
        DeviceManager.sharedInstance.widthRatio =  UIScreen.main.bounds.width / withBase
        DeviceManager.sharedInstance.height = UIScreen.main.bounds.height
        DeviceManager.sharedInstance.width =  UIScreen.main.bounds.width

        //               FirebaseApp.configure()
        //
        //               GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        //               GIDSignIn.sharedInstance().delegate = self
        //
        // UINavigationBar.appearance().backgroundColor = UIColor.systemIndigo
        //UINavigationBar.appearance().tintColor = UIColor.white
        
        
        FirebaseApp.configure()
        
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        
        Messaging.messaging().delegate = self
        //   UNUserNotificationCenter.current().delegate = self
        //                let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        //                UNUserNotificationCenter.current().requestAuthorization(options: authOptions,completionHandler: {_, _ in })
        //                application.registerForRemoteNotifications()
        //            if #available(iOS 10, *) {
        //                    UNUserNotificationCenter.current().requestAuthorization(options:[.badge, .alert, .sound]){ (granted, error) in }
        //                    application.registerForRemoteNotifications()
        //                }
        
        
        //탭바 설정
        UITabBar.appearance().backgroundColor = UIColor.white
        UITabBar.appearance().tintColor = UIColor(displayP3Red:238/255,green : 47/255, blue : 67/255, alpha: 1)
        //네비 배경 색상 설정
        //UINavigationBar.appearance().backgroundColor = UIColor.red
        //UINavigationBar.appearance().sha
        
        //네비바 배경색 없애고 줄 없애는 처리
//        UINavigationBar.appearance().shadowImage = UIImage()
//        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        UINavigationBar.appearance().tintColor = UIColor(displayP3Red:238/255,green : 47/255, blue : 67/255, alpha: 1)
//        UINavigationBar.appearance().layer.borderWidth = 1
//        UINavigationBar.appearance().layer.backgroundColor = UIColor.black.cgColor
       

        //
//        UINavigationBar.appearance().tintColor = UIColor.white
//        UINavigationBar.appearance().backgroundColor =  UIColor(displayP3Red:238/255,green : 47/255, blue : 67/255, alpha: 1)
        //UINavigationBar.appearance().barStyle = .blackOpaque
        
        //알림 권한설정을 묻는 부분
    
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            print("알림권한 ios10버전")
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
        } else {
            print("알림권한 ios기타버전")
            UNUserNotificationCenter.current().delegate = self

            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
        
        
//        // 여기서는 태스크를 등록해줍니다. 스케줄하는 건 별도 에요!
//        BGTaskScheduler.shared.register(forTaskWithIdentifier: "com.example.apple-samplecode.ColorFeed.refresh", using: nil) { tas
//            //실제로 수행할 백그라운드 동작 구현 //나중에 스케쥴 할 때, 해당 태스크의 클래스를 알고 등록을 하게 됩니다. 그래서 다운 캐스팅이 가능해요.
//            self.handleAppRefresh(task: task as! BGAppRefreshTask) } BGTaskScheduler.shared.register(forTaskWithIdentifier: "com.example.apple-samplecode.ColorFeed.db_cleaning", using: nil) { task in
//                // Downcast the parameter to a processing task as this identifier is used for a processing request.
//                self.handleDatabaseCleaning(task: task as! BGProcessingTask) }
//
//
//
//
        
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
    
    //
    //    //수신 알림을 받으면 대리인이 콜하는 메소드
    //    func  application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
    //
    //
    //               if let info = userInfo["aps"] as? Dictionary<String, AnyObject>
    //                        {
    //                            var alertMsg = info["alert"] as! String
    //                            var alert: UIAlertView!
    //                            alert = UIAlertView(title: "", message: alertMsg, delegate: nil, cancelButtonTitle: "OK")
    //                            alert.show()
    //                        }
    //
    //
    //
    //    }
    
    
    //    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
    //
    //        print("Recived: \(userInfo)")
    //       //Parsing userinfo:
    //        typealias Dict = [String: AnyObject]
    //
    //        var temp : NSDictionary = userInfo as NSDictionary
    //        if let badge = ((userInfo["aps"] as? Dict) ?? Dict())["badge"] as? Int{
    //               self.updateAppIconBadgeNumber(badge)
    //           }
    //
    //
    ////       if let info = userInfo["aps"] as? Dictionary<String, AnyObject>
    ////                {
    ////                    var alertMsg = info["alert"] as! String
    ////                    var alert: UIAlertView!
    ////                    alert = UIAlertView(title: "", message: alertMsg, delegate: nil, cancelButtonTitle: "OK")
    ////                    alert.show()
    ////                }
    //    }
    
    
    
    //url여는 메소드
    
    //
    @available(iOS 9.0, *)
    func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any])
    -> Bool {
        print("url여는 메소드")
        
        return GIDSignIn.sharedInstance().handle(url)
    }
    
    
    //
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        print("url여는 메소드")
        
        return GIDSignIn.sharedInstance().handle(url)
    }
    
    
    
    
    //프로토콜
    //    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
    //      // ...
    //      if let error = error {
    //        // ...
    //        print("앱 델리게이트 구글로그인 에러")
    //        return
    //      }
    //
    //      guard let authentication = user.authentication else { return }
    //      let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
    //                                                        accessToken: authentication.accessToken)
    //      // ...
    //        print("앱 델리게이트 구글로그인 성공")
    //        print(credential)
    //        //로그인에 성공하면 사용자 정보를 이용해 firebase에
    //    Auth.auth().signIn(with: credential) { (authResult, error) in
    //        if let error = error {
    //         print("유저정보들고오기 실패")
    //
    //          return
    //        }
    //        // User is signed in
    //        // ...
    //
    //
    //        //구글로그인정보를 이용해서 파이어베이스에 인증하고
    //        let user = Auth.auth().currentUser
    //        if let user = user {
    //          // The user's ID, unique to the Firebase project.
    //          // Do NOT use this value to authenticate with your backend server,
    //          // if you have one. Use getTokenWithCompletion:completion: instead.
    //          let uid:String? = user.uid
    //            let email:String? = user.email
    //            let name:String? = user.displayName
    //         //let photoURL:String? = user.photoURL
    //
    //
    //          // 파이어베이스에서 받아온 정보를 almofire를 이용해서 서버로 전송한다.
    //            print("유저정보들고오기 성공")
    //
    //
    //
    //
    //
    //        //let parameters = ["username":"test"]
    //
    //        let PARAM:Parameters = [
    //            "username":email!,
    //            "BORN": 1992,
    //            "JOB": "축구선수"
    //        ]
    //
    //
    //
    //        //서버통신
    //        Alamofire.request("http://3.34.4.196/ios_login2.php", method: .post, parameters: PARAM)
    //                    //.validate(contentType: ["application/json"])
    //                    .responseJSON(completionHandler: { response in
    //                        switch response.result{
    //                        case .success:
    //                            print("Validation Successful")
    //
    //                            if let values = response.result.value{
    //                                let json = JSON(values)
    //                                print(response)
    //                                //let result = json["Key"].stringValue
    //                               // print(result)
    //                            }
    //
    //
    //
    //                            //메인화면으로 이동한다
    //
    //
    //
    //                        case .failure(let error):
    //                            print(error)
    //                    }
    //
    //                })
    //
    //
    //         }//user 언랩핑
    //
    //      }//파이어베이스 인증괄호
    //
    //
    //    }//프로토콜 메소드 종료
    
    
    //
    //
    
    
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
        // print(userInfo)
        print(userInfo)
        
        LoginManager.sharedInstance.push = true
        
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let viewController = storyboard.instantiateViewController(withIdentifier: "chatMessageVC") as! SplashViewController
//        UIApplication.topViewController()?.navigationController?.pushViewController(viewController, animated: false)
        
        
//        let sb = UIStoryboard(name: "Main", bundle: nil)
//        let otherVC = sb.instantiateViewController(withIdentifier: "DuViewController") as! DuViewController
//        otherVC.selectedPolicy = userInfo
//        //  window?.rootViewController = otherVC;
//        self.naviController = UINavigationController(rootViewController: otherVC)
//        self.naviController?.navigationBar.isHidden = true
//        self.window?.rootViewController = self.naviController
//        self.window?.makeKeyAndVisible()
//
//
        
        
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("푸쉬알람이동")
     
     
        //사용자가 푸쉬알림을 수신했다고 서버에 알린다.
        
        
        
        //푸쉬알림을 통해 받아온 혜택명과 혜택지역을 싱글톤에 저장한다.
        
        //널값체크

        PushManager.sharedInstance.welf_name = (response.notification.request.content.userInfo["welf_name"] as? String)!
        PushManager.sharedInstance.welf_local = (response.notification.request.content.userInfo["welf_local"] as? String)!

        PushManager.sharedInstance.pushId = (response.notification.request.content.userInfo["pushId"] as? String)!
        

        let data = response.notification.request.content.userInfo["welf_name"] as? String
        print("파싱 : \(data!)")
        print("푸쉬 아이디: \(PushManager.sharedInstance.pushId)")
        LoginManager.sharedInstance.push = true
        if(LoginManager.sharedInstance.push){
            print("푸쉬로 들어온걸로 변경")
        }
        
        let headers = [
            "LoginToken": LoginManager.sharedInstance.token
          ]


        let parameters = ["type":"pushRecv", "pushId":PushManager.sharedInstance.pushId]

        Alamofire.request("https://www.hyemo.com/push", method: .post,parameters: parameters, encoding: URLEncoding.default, headers: headers)
            .validate()
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    do {
                        
                        let data = try JSONSerialization.data(withJSONObject: value, options: .prettyPrinted)
                        let result = try JSONDecoder().decode(alramParse.self, from: data)
                        
                        print("대리자 알림 결과 : \(result.Status)")
                        
                        
                    } catch let DecodingError.dataCorrupted(context) {
                        debugPrint(context)
                    } catch let DecodingError.keyNotFound(key, context) {
                        debugPrint("Key '\(key)' not found:", context.debugDescription)
                        debugPrint("codingPath:", context.codingPath)
                    } catch let DecodingError.valueNotFound(value, context) {
                        debugPrint("Value '\(value)' not found:", context.debugDescription)
                        debugPrint("codingPath:", context.codingPath)
                    } catch let DecodingError.typeMismatch(type, context)  {
                        debugPrint("Type '\(type)' mismatch:", context.debugDescription)
                        debugPrint("codingPath:", context.codingPath)
                    } catch {
                        debugPrint("error: ", error)
                    }
                case .failure(let error):
                    debugPrint(error)
                    print("에러 알림수신 재시도")
                    //self.checkedAlarm()
                }
                
            }
        
        //print("받은 정보 \(userInfo)")

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
        
        
        
        //        var email = UserDefaults.standard.string(forKey: "email")
        //
        //        //자동로그인 된 경우
        //        if (email != nil){
        //        print("fcm토큰 수신")
        //        let PARAM:Parameters = [
        //            "userEmail":email!,
        //            "fcm_token": fcmToken
        //        ]
        //
        //
        //        Alamofire.request("http://3.34.4.196/backend/ios/ios_fcm_token_save.php", method: .post, parameters: PARAM)
        //                      .validate()
        //                      .responseJSON { response in
        //
        //                          //메인화면으로 이동한다
        //
        //                          switch response.result {
        //                          case .success(let value): //
        //                          print("성공")
        //
        //
        //                         case .failure(let error):
        //                             print(error)
        //                         }
        //
        //                 }//resoponse 종료괄호
        //
        //        }
    }
    
    
    

    
    
    
    
//    //앱이 백그라운드에 들어갔을 때 호출 됨.
//    func applicationDidEnterBackground(_ application: UIApplication) { scheduleAppRefresh()
//        scheduleDatabaseCleaningIfNeeded() }
//    // 실제로 태스크를 스케줄 하는 부분.
//    //BGAppRefreshTaskRequest를 만들어 봅니다
//    func scheduleAppRefresh() {
//        //1. 원하는 형태의 TaskRequest를 만듭니다. 이 때, 사용되는 identifier는 위의 1, 2과정에서 등록한 info.plist의 identifier여야 해요!
//        let request = BGAppRefreshTaskRequest(identifier: "com.example.apple-samplecode.ColorFeed.refresh")
//        //2. 리퀘스트가 언제 실행되면 좋겠는지 지정합니다. 기존의 setMinimumFetchInterval과 동일하다고 합니다.
//        //여전히, 언제 실행될지는 시스템의 마음입니다...
//        request.earliestBeginDate = Date(timeIntervalSinceNow: 15 * 60)
//        //3. 실제로 task를 submit 합니다.
//        //이 때 주의사항은, submit은 synchronous한 함수라, launching 때 실행하면 메인 스레드가 블락 될 수 있으니
//        //OperationQueue, GCD등을 이용해 다른 스레드에서 호출하는 것을 권장한다고 하네요.
//        do {
//            try BGTaskScheduler.shared.submit(request) } catch { print("Could not schedule app refresh: \(error)") } } //BGProcessingTaskRequest를 사용합니다. 옵션이 있는 걸 제외하면 위와 동일해요.
//    func scheduleDatabaseCleaningIfNeeded() { let lastCleanDate = PersistentContainer.shared.lastCleaned ?? .distantPast let now = Date() let oneWeek = TimeInterval(7 * 24 * 60 * 60)
//        // Clean the database at most once per week.
//        guard now > (lastCleanDate + oneWeek) else { return }
//        //이번엔 무거운 DB 작업이니까, BGProcessingTaskRequest를 스케쥴 해줍니다.
//        let request = BGProcessingTaskRequest(identifier: "com.example.apple-samplecode.ColorFeed.db_cleaning")
//        //네트워크 사용여부, 에너지 소모량 옵션도 있습니다.
//        request.requiresNetworkConnectivity = false request.requiresExternalPower = true do { try BGTaskScheduler.shared.submit(request) } catch { print("Could not schedule database cleaning: \(error)") } }
//

    
    
    //안쓰는 메소드
//    func askNotificationsPermissions() {
//        if(UIApplication.instancesRespond(to: Selector("registerUserNotificationSettings:"))){
//            print("i'm asking the question!")
//
//
//            if #available(iOS 10.0, *) {
//                // For iOS 10 display notification (sent via APNS)
//                print("ios 10버전")
//                UNUserNotificationCenter.current().delegate = self
//
//                let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
//                UNUserNotificationCenter.current().requestAuthorization(
//                    options: authOptions,
//                    completionHandler: {_, _ in })
//            } else {
//                print("ios 기타버전")
//                UNUserNotificationCenter.current().delegate = self
//
//                let settings: UIUserNotificationSettings =
//                    UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
//                UIApplication.shared.registerUserNotificationSettings(settings)
//            }
//
//
//            UIApplication.shared.registerForRemoteNotifications()
//        }
//    }
    
    
    
    
   
    
    
    
}//클래스 종료


