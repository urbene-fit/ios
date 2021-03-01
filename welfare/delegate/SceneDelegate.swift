//  SceneDelegate.swift
//  welfare
//
//  Created by 김동현 on 2020/07/29.
//  Copyright © 2020 com. All rights reserved.


import UIKit
import Alamofire

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    //var policy : String = ""
    
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        print("scene 메소드")
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        
        print("sceneDidDisconnect 메소드")
        
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }
    
    
    func sceneWillResignActive(_ scene: UIScene) {
        
        print("sceneWillResignActive 메소드")
        
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
        print("포어그라운드 진입")
        
        // 알림을 누르고 들어올 경우에만 실행
        if(LoginManager.sharedInstance.push){
            print("푸쉬 알람으로 진입")
            
            
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let presentViewController = storyBoard.instantiateViewController(withIdentifier: "SplashViewController") as! SplashViewController
            
            presentViewController.modalPresentationStyle = .fullScreen
            self.window?.rootViewController?.present(presentViewController, animated: true, completion: nil)
        }
    }
    
    
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
    }
}
