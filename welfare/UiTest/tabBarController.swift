//
//  tabBarController.swift
//  welfare
//
//  Created by 김동현 on 2020/11/30.
//  Copyright © 2020 com. All rights reserved.
//

import UIKit

class tabBarController: UITabBarController, UITabBarControllerDelegate {
    
    
    

    override func viewWillAppear(_ animated: Bool) {
           super.viewWillAppear(animated)
           self.tabBar.backgroundColor = .white
       }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("텝바 로드")
        self.tabBar.backgroundColor = .white

        let width = tabBar.bounds.width
            var selectionImage = UIImage(named:"star_on")
            let tabSize = CGSize(width: width/5, height: 50)

            UIGraphicsBeginImageContext(tabSize)
            selectionImage?.draw(in: CGRect(x: 0, y: 10, width: 30, height: 30))
            selectionImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()

           // tabBar.selectionIndicatorImage = selectionImage
        
        // Do any additional setup after loading the view.
        let firstViewController = mapTestViewController()
        firstViewController.tabBarItem.image = selectionImage
      //  firstViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .contacts, tag: 0)
        var bookImg = UIImage()

        bookImg = UIImage(named: "star_on")!
     bookImg.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        
     //   firstViewController.tabBarItem.image =
//       // bookImg.drawInRect(CGRectMake(0, 0, 10, 10))
//        let transform = CGAffineTransform(scaleX: 10, y: 10)
//        let size = bookImg.size.applying(transform)
//        bookImg.draw(in: CGRect(origin: .zero, size: size))
//        firstViewController.tabBarItem.image = bookImg
//
//        firstViewController.tabBarItem.image = UIImage(named: "star_on")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
//        firstViewController.tabBarItem.selectedImage = UIImage(named: "star_on ")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
//        firstViewController.tabBarItem.title = ""
//        firstViewController.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
////
//        bookImg.widthAnchor.constraint(equalToConstant: 16.0).isActive = true
//
//        bookImg.heightAnchor.constraint(equalToConstant: 16.0).isActive = true

//        firstViewController.tabBarItem = UITabBarItem(title:"혜택지도", image: bookImg, selectedImage: bookImg)
//        //firstViewController.tabBarItem.withRenderingMode(.alwaysOriginal)
//        firstViewController.tabBarItem.imageInsets = UIEdgeInsets(top: 200, left: 200, bottom: 200, right: 200); mapResultViewController
//
        let secondViewController = UiTestController()
        
      let third = mapResultViewController()


        secondViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .more, tag: 1)

        //let tabBarList = [UINavigationController(rootViewController:firstViewController), UINavigationController(rootViewController:secondViewController)]

        //탭바컨트롤의 하위뷰로 포함되는 뷰들에 네비게이션컨트롤러를 추가해준다.
        //viewControllers = tabBarList.map { UINavigationController(rootViewController: $0)}
        
        //let vc1 = UINavigationController(rootViewController: mapTestViewController()) as!
        
        var vc1 = self.storyboard?.instantiateViewController(withIdentifier: "main") as! UINavigationController
        var vc2 = self.storyboard?.instantiateViewController(withIdentifier: "map") as! UINavigationController
        var vc3 =  self.storyboard?.instantiateViewController(withIdentifier: "snack") as! UINavigationController
        var vc4 =  self.storyboard?.instantiateViewController(withIdentifier: "info") as! UINavigationController
        let tabBarList = [vc1,vc2,vc3,vc4]
        viewControllers = tabBarList
        
        vc1 = tabSizeFit(imgname: "homeIcon",viewController: vc1)
        vc2 = tabSizeFit(imgname: "mapIcon",viewController: vc2)
        vc3 = tabSizeFit(imgname: "mbtiIcon",viewController: vc3)
        vc4 = tabSizeFit(imgname: "infoIcon",viewController: vc4)

//        vc1.tabBarItem = UITabBarItem(tabBarSystemItem: .contacts, tag: 0)
//        vc2.tabBarItem = UITabBarItem(tabBarSystemItem: .contacts, tag: 1)
//        vc3.tabBarItem = UITabBarItem(tabBarSystemItem: .contacts, tag: 2)
//        vc3.tabBarItem = UITabBarItem(tabBarSystemItem: .contacts, tag: 3)


    }
    

    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {

        let vc = self.storyboard?.instantiateViewController(withIdentifier: "cameraVC") as! mapSearchViewController
            present(vc, animated: true, completion: nil)


        return true
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    //탭바에 추가되는 이미지 크기를 조정해주는 메소드
    func tabSizeFit(imgname : String, viewController : UINavigationController) -> UINavigationController{
            
            let width = tabBar.bounds.width
            var selectionImage = UIImage(named:imgname)
            let tabSize = CGSize(width: 25, height: 25)

            UIGraphicsBeginImageContext(tabSize)
            selectionImage?.draw(in: CGRect(x: 0, y: 0, width: 25, height: 25))
            selectionImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            viewController.tabBarItem.title = ""
           // tabBar.selectionIndicatorImage = selectionImage
        
        // Do any additional setup after loading the view.
        viewController.tabBarItem.image = selectionImage
        
        return viewController
    }

}
