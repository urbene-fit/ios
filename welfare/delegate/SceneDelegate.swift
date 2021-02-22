//
//  SceneDelegate.swift
//  welfare
//
//  Created by 김동현 on 2020/07/29.
//  Copyright © 2020 com. All rights reserved.
//

import UIKit
import Alamofire

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    //var policy : String = ""
    
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        
        //UITabBar.appearance().barTintColor = #colorLiteral(red: 0.9372549057, green: 0.1913873077, blue: 0.2772851493, alpha: 1) // your color

        
        print("scene 메소드")
        
        //        //로그인 여부를 통해 첫 뷰컨트롤 설정
        //        let SPREF_USERID = "token"
        //
        ////            UserDefaults.standard.removeObject(forKey: SPREF_USERID)
        ////        UserDefaults.standard.removeObject(forKey: "email")
        //
        //        //디바이스에 저장된 사용자 정보를 지우고
        //                            UserDefaults.standard.removeObject(forKey: "token")
        //                            UserDefaults.standard.removeObject(forKey: "email")
//        var fcmToken = UserDefaults.standard.string(forKey: "fcmToken")
//        print(fcmToken)
//        var check = UserDefaults.standard.string(forKey: "check")
//        var platform = UserDefaults.standard.string(forKey: "platform")
//        
//        //  var identifier = UserDefaults.standard.string(forKey: "identifier")
//        
//        print("재로그인")
//        print(check)
//        print(fcmToken)
//        
//        //
//        ////
//        ////
//        ////
//        //               //로그인한 상태면
//        if(fcmToken != nil && check != nil && platform != nil ){
//            print("자동 로그인함")
//            
//            print(check!)
//            print(fcmToken!)
//            print(platform!)
//            
//            //애플로그인인지 다른로그인지에 따라 구분해서 확인한다.
//            if(platform == "apple"){
//                
//                print("ios자동 로그인함")
//                
//                
//                
//                let PARAM:Parameters = [
//                    "platform":platform!,
//                    //  "email":"email",
//                    "identifier":check!,
//                    "fcm_token":fcmToken!,
//                    "osType": "ios"
//                ]
//                
//                print(PARAM["identifier"])
//                print(PARAM["platform"])
//                print(PARAM["osType"])
//                
//                //서버통신
//                Alamofire.request("https://www.urbene-fit.com/login", method: .post, parameters: PARAM)
//                    .validate()
//                    .responseJSON { response in
//                        
//                        //메인화면으로 이동한다
//                        
//                        switch response.result {
//                        case .success(let value):
//                            if let json = value as? [String: Any] {
//                                //print(json)
//                                for (key, value) in json {
//                                    print(key)
//                                    print(value)
//                                    if(key == "Token" && value != nil ){
//                                        //로그인 성공
//                                        print("로그인 성공")
//                                     print(value)
//                                        
//                                        
//                                        //토큰을 저장
//                                        UserDefaults.standard.set(value, forKey:"idToken")
//                                            if let windowScene = scene as? UIWindowScene {
//                                                let window = UIWindow(windowScene: windowScene)
//                                                
//                                                
//                                                let storyboard = UIStoryboard(name: "Main", bundle: nil)
//                                                
//                                                
////                                                let mainTabBar = storyboard.instantiateViewController(withIdentifier: "tabBarController") as! UITabBarController
//                                                
//                                                let testYoutubeViewController = storyboard.instantiateViewController(withIdentifier: "testYoutubeViewController") as! testYoutubeViewController
//                                                
//                                               
//                                                
//                                                testYoutubeViewController.modalPresentationStyle = .fullScreen
//                                                window.rootViewController = testYoutubeViewController
//                                                self.window = window
//                                                window.makeKeyAndVisible()
//                                            }
//                                            
//                                            //로그인실패 로그인 화면으로 이동
//                                        }else{
//                                            
//                                            if let windowScene = scene as? UIWindowScene {
//                                                let window = UIWindow(windowScene: windowScene)
//                                                
//                                                
//                                                let storyboard = UIStoryboard(name: "Main", bundle: nil)
//                                                
//                                                
//                                                let mainTabBar = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
//                                                mainTabBar.modalPresentationStyle = .fullScreen
//                                                window.rootViewController = mainTabBar
//                                                self.window = window
//                                                window.makeKeyAndVisible()
//                                            }
//                                        }
//                                    //}
//                                    
//                                }
//                            }
//                            
//                            
//                            
//                        case .failure(let error):
//                            print(error)
//                        }
//                        
//                    }//resoponse 종료괄호
//                
//                //애플로그인이 아닌 다른 SNS으로 로그인한 경우
//            }else{
//                print("다른 플랫폼 자동 로그인함")
//
//                let PARAM:Parameters = [
//                    "platform":platform!,
//                    "email":check!,
//                    "fcm_token":fcmToken!,
//                    "osType": "ios"
//                ]
//                
//                
//                
//                Alamofire.request("https://www.urbene-fit.com/login", method: .post, parameters: PARAM)
//                    .validate()
//                    .responseJSON { response in
//                        
//                        //메인화면으로 이동한다
//                        
//                        switch response.result {
//                        case .success(let value):
//                            if let json = value as? [String: Any] {
//                                //print(json)
//                                for (key, value) in json {
//                                    if(key == "Token" && value != nil){
//                                        //로그인 성공
//                                        print("로그인 성공")
//                                     print(value)
//                                        
//                                        
//                                        //토큰을 저장
//                                        UserDefaults.standard.set(value, forKey:"idToken")
//                                            if let windowScene = scene as? UIWindowScene {
//                                                let window = UIWindow(windowScene: windowScene)
//                                                
//                                                
//                                                let storyboard = UIStoryboard(name: "Main", bundle: nil)
//                                                
//                                                
//                                               let mainTabBar = storyboard.instantiateViewController(withIdentifier: "tabBarController") as! UITabBarController
//                                                
//                                               // let mainTabBar = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
//                                                mainTabBar.modalPresentationStyle = .fullScreen
//
//////                                                window.rootViewController = mainTabBar
////                                                let testYoutubeViewController = storyboard.instantiateViewController(withIdentifier: "testYoutubeViewController") as! testYoutubeViewController
//                                                
//                                                mainTabBar.modalPresentationStyle = .fullScreen
//                                                window.rootViewController = mainTabBar
//                                                self.window = window
//                                                window.makeKeyAndVisible()
//                                            }
//                                            
//                                            //로그인실패 로그인 화면으로 이동
////                                        }else{
////
////                                            if let windowScene = scene as? UIWindowScene {
////                                                let window = UIWindow(windowScene: windowScene)
////
////
////                                                let storyboard = UIStoryboard(name: "Main", bundle: nil)
////
////
////                                                let mainTabBar = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
////                                                mainTabBar.modalPresentationStyle = .fullScreen
////                                                window.rootViewController = mainTabBar
////                                                self.window = window
////                                                window.makeKeyAndVisible()
////                                            }
////                                        }
//                                  }
//                                    
//                                }
//                            }
//                            
//                            
//                        case .failure(let error):
//                            print(error)
//                        }
//                        
//                    }//resoponse 종료괄호
//                
//            }
//            
//            
//        }else{
//            print("로그인 안함")
//            if let windowScene = scene as? UIWindowScene {
//                let window = UIWindow(windowScene: windowScene)
//                
//                
//                let storyboard = UIStoryboard(name: "Main", bundle: nil)
//                
//                
//                let mainTabBar = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
//                mainTabBar.modalPresentationStyle = .fullScreen
//                window.rootViewController = mainTabBar
//                self.window = window
//                window.makeKeyAndVisible()
//            }
//            
//        }
        
        //
        //
        //               }else {
        //                   print("로그인 안함")
        //                if let windowScene = scene as? UIWindowScene {
        //                                let window = UIWindow(windowScene: windowScene)
        //
        //
        //                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
        //
        ////
        ////                    let mainTabBar = storyboard.instantiateViewController(withIdentifier: "tabBarController") as! UITabBarController
        ////                                       mainTabBar.modalPresentationStyle = .fullScreen
        ////                                      window.rootViewController = mainTabBar
        ////                                                    self.window = window
        ////                                                     window.makeKeyAndVisible()
        ////
        ////                }
        //
        //                 //   window.rootViewController = UINavigationController(rootViewController: tabBarController())
        //
        ////                    window.rootViewController = UITabBarController()
        ////
        ////                    let sd = mapTestViewController()
        ////                    let nc = mapResultViewController()
        ////
        ////                    let tabbar = UITabBarController()
        ////                    tabbar.viewControllers = [sd, nc]
        ////                       window.rootViewController = tabbar
        //                   // window.makeKeyAndVisible()
        //
        //                   // self.window = UIWindow(windowScene: windowScene)
        //                    // 루트 뷰 컨트롤러가 될 뷰컨트롤러 생성
        //                    // 위에서 생성한 뷰 컨트롤러로 네비게이션 컨트롤러를 생성
        //
        ////                    // 윈도우의 루트 뷰 컨트롤러로 네비게이션 컨트롤러를 설정
        ////
        ////                    let tbc = UITabBarController()
        ////                   window.rootViewController = tbc
        ////                    let initialViewController = storyboard.instantiateViewController(withIdentifier: "mapTestViewController") as! mapTestViewController
        ////
        ////                    tbc.setViewControllers([initialViewController, initialViewController, initialViewController], animated: false)
        ////                    window.windowScene = windowScene
        ////                                 window.makeKeyAndVisible()
        //
        //                   // var window: UIWindow?
        //
        //
        ////
        ////                    let myTabBar = storyboard.instantiateViewController(withIdentifier: "tabBar")
        ////                    window.rootViewController = myTabBar
        ////                    self.window?.rootViewController = myTabBar
        ////
        ////
        ////                    window.windowScene = windowScene
        ////                    window.makeKeyAndVisible()
        //
        ////                    let mainViewController =  storyboard.instantiateViewController(withIdentifier: "tabBar") as! UITabBarController
        ////
        ////                     window.rootViewController = mainViewController
        ////                     window.makeKeyAndVisible()
        ////
        ////
        ////
        //
        ////                    self.window = window
        ////                    window.makeKeyAndVisible()
        //
        //
        //
        //                    let initialViewController = storyboard.instantiateViewController(withIdentifier: "tabBarController") as! tabBarController
        //
        //
        //
        //                                window.rootViewController = initialViewController
        //                                self.window = window
        //                                window.makeKeyAndVisible()
        //                            }
        //
        //
        //               }
        //
        //        guard let _ = (scene as? UIWindowScene) else { return }
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        
        print("sceneDidDisconnect 메소드")
        
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }
    
    //    func sceneDidBecomeActive(_ scene: UIScene) {
    //
    //        print("sceneDidBecomeActive 메소드")
    //
    //        // Called when the scene has moved from an inactive state to an active state.
    //        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    //    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        
        print("sceneWillResignActive 메소드")
        
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
        print("포어그라운드 진입")
        
        
        if(LoginManager.sharedInstance.push){
            print("푸쉬 알람으로 진입")
            
            
                    let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                                     let presentViewController = storyBoard.instantiateViewController(withIdentifier: "SplashViewController") as! SplashViewController
            
                    presentViewController.modalPresentationStyle = .fullScreen
                    self.window?.rootViewController?.present(presentViewController, animated: true, completion: nil)
        }
        
        
        
        //        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        //                         let presentViewController = storyBoard.instantiateViewController(withIdentifier: "DuViewController") as! DuViewController
        //
        //        presentViewController.modalPresentationStyle = .fullScreen
        //        self.window?.rootViewController?.present(presentViewController, animated: true, completion: nil)
        
        //        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        //                 let DuViewController = storyboard.instantiateViewController(withIdentifier: "UiTestController") as! UiTestController
        //                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        //                        let presentViewController = storyBoard.instantiateViewController(withIdentifier: "DuViewController") as! DuViewController
        //
        //                        //presentViewController.yourDict = userInfo //pass userInfo data to viewController
        //                self.window?.rootViewController = presentViewController
        //                presentViewController.modalPresentationStyle = .fullScreen
        //                                presentViewController.present(presentViewController, animated: true, completion: nil)
        //
        
        
        //        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        //
        //            // instantiate the view controller we want to show from storyboard
        //            // root view controller is tab bar controller
        //            // the selected tab is a navigation controller
        //            // then we push the new view controller to it
        //            if  let conversationVC = storyboard.instantiateViewController(withIdentifier: "DuViewController") as? DuViewController,
        //                let tabBarController = self.window?.rootViewController as? UITabBarController,
        //                let navController = tabBarController.selectedViewController as? UINavigationController {
        //
        //                    // we can modify variable of the new view controller using notification data
        //                    // (eg: title of notification)
        //                    //conversationVC.senderDisplayName = response.notification.request.content.title
        //                    // you can access custom data of the push notification by using userInfo property
        //                    // response.notification.request.content.userInfo
        //                    navController.pushViewController(conversationVC, animated: true)
        //            }
        //        if let windowScene = scene as? UIWindowScene {
        //                        let window = UIWindow(windowScene: windowScene)
        //              let storyboard = UIStoryboard(name: "Main", bundle: nil)
        //
        //                        let initialViewController = storyboard.instantiateViewController(withIdentifier: "UiTestController") as! UiTestController
        //            //푸쉬알람으로 들어온 경우
        //            if(initialViewController.pushAlram){
        //                print("포어그라운드 진입2")
        //
        //                let DuViewController = storyboard.instantiateViewController(withIdentifier: "DuViewController") as! DuViewController
        //
        //                        window.rootViewController = DuViewController
        //                        self.window = window
        //                        window.makeKeyAndVisible()
        //            }
        //                    }
        
        
        
    }
    
    //    func sceneDidEnterBackground(_ scene: UIScene) {
    //        print("백그라운드 진입")
    //
    //
    //
    //        // Called as the scene transitions from the foreground to the background.
    //        // Use this method to save data, release shared resources, and store enough scene-specific state information
    //        // to restore the scene back to its current state.
    //    }
    
    //카카오 url
    // SceneDelegate.swift
    // import KakaoOpenSDK
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let url = URLContexts.first?.url else {return}
        KOSession.handleOpen(url)
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        KOSession.handleDidBecomeActive()
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        KOSession.handleDidEnterBackground()
        print("백그라운드 진입")

//                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//                                 let presentViewController = storyBoard.instantiateViewController(withIdentifier: "SplashViewController") as! SplashViewController
//
//                presentViewController.modalPresentationStyle = .fullScreen
//                self.window?.rootViewController?.present(presentViewController, animated: true, completion: nil)
    }
    
    
}

