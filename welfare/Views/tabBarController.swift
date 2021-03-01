//  tabBarController.swift
//  welfare
//
//  Created by 김동현 on 2020/11/30.
//  Copyright © 2020 com. All rights reserved.


import UIKit


class tabBarController: UITabBarController, UITabBarControllerDelegate {
    
    // NotificationCenter: 미리 등록된 observer 들에게 notification 을 전달하는 역할의 클래스
    // 참고: https://jinshine.github.io/2018/07/05/iOS/NotificationCenter/
    let notiCenter = NotificationCenter.default
    // NSObjectProtocol : addObserver에 반환값이 있는 메서드를 사용할때 해제 해주어야 할 프로퍼티
    private var observer: NSObjectProtocol?
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("텝바 로드")
        
        
        // Observer 등록
        observer = notiCenter.addObserver(forName: UIApplication.willEnterForegroundNotification,// UIApplication.willEnterForegroundNotification 가 나타나기 직전에 알려줘라
                                          object: nil,// object는 어떤객체를 전달할지
                                          queue: .main) {// queue는 스레드 using은 수행할 로직.
            
            // 캡처리스트
            // unowned self: 순환 참조를 해결할 수 있는 방법, unowned self는 옵셔널이 아니기 때문에 힙에 있지 않는다면 crash가 발생
            [unowned self] notification in
            print("개인정보 foreground로 돌아오는 경우 ")
            if(LoginManager.sharedInstance.push){
                print("푸쉬알람으로 진입")
                LoginManager.sharedInstance.push = false
                
                // ??
                self.dismiss(animated: true) {
                }
            }
        }
        
        // ??
        let width = tabBar.bounds.width
        let tabSize = CGSize(width: width/5, height: 50)
        UIGraphicsBeginImageContext(tabSize)
        
        // 추천 혜택 이미지 크기 조절?
        var selectionImage = UIImage(named:"star_on")
        selectionImage?.draw(in: CGRect(x: 0, y: 10, width: 30, height: 30))
        selectionImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        
        //탭바컨트롤의 하위뷰로 포함되는 뷰들에 네비게이션컨트롤러를 추가해준다.
        var vc1 = self.storyboard?.instantiateViewController(withIdentifier: "main") as! UINavigationController
        var vc2 = self.storyboard?.instantiateViewController(withIdentifier: "search") as! UINavigationController
        var vc3 =  self.storyboard?.instantiateViewController(withIdentifier: "alram") as! UINavigationController
        var vc4 =  self.storyboard?.instantiateViewController(withIdentifier: "info") as! UINavigationController
        let tabBarList = [vc1,vc2,vc3,vc4]
        viewControllers = tabBarList
        
        vc1 = tabSizeFit(imgname: "home",viewController: vc1)
        vc2 = tabSizeFit(imgname: "searchIcon",viewController: vc2)
        vc3 = tabSizeFit(imgname: "alramIcon",viewController: vc3)
        vc4 = tabSizeFit(imgname: "infoIcon",viewController: vc4)
    }
    
    
    // 탭바에 추가되는 이미지 크기를 조정해주는 메소드
    func tabSizeFit(imgname : String, viewController : UINavigationController) -> UINavigationController{
        //let width = tabBar.bounds.width
        var selectionImage = UIImage(named:imgname)
        let tabSize = CGSize(width: 25, height: 25)
        
        UIGraphicsBeginImageContext(tabSize)
        selectionImage?.draw(in: CGRect(x: 0, y: 0, width: 25, height: 25))
        selectionImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        viewController.tabBarItem.title = ""
        
        // Do any additional setup after loading the view.
        viewController.tabBarItem.image = selectionImage
        
        return viewController
    }
}
