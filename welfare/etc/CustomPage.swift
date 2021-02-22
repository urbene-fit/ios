//
//  CustomPage.swift
//  welfare
//
//  Created by 김동현 on 2020/08/02.
//  Copyright © 2020 com. All rights reserved.
//

import UIKit




class CustomPage: UIViewController {

    //@IBOutlet weak var pageControl: UIPageControl!
    
    let imageView = UIImageView()
    //페이지컨트롤 생성
    
    @IBOutlet weak var pageCTR: UIPageControl!
    // 화면에 보여줄 이미지 파일 이름을 images 배열에 저장
    var images = [ "welfare", "welfare2", "welfare3"]

    // The custom UIPageControl
         //let pageControl = UIPageControl()
            let imgView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //페이지 컨트롤의 전체 페이지를 images 배열의 전체 개수 값으로 설정
             pageCTR.numberOfPages = 3
             // 페이지 컨트롤의 현재 페이지를 0으로 설정
             pageCTR.currentPage = 0
             // 페이지 표시 색상을 밝은 회색 설정
             pageCTR.pageIndicatorTintColor = UIColor.lightGray
             // 현재 페이지 표시 색상을 검정색으로 설정
             pageCTR.currentPageIndicatorTintColor = UIColor.black
        
            //페이지컨트롤 위치 설정
        //self.view.addSubview(self.pageControl)
         
//         self.pageControl.translatesAutoresizingMaskIntoConstraints = false
//         self.pageControl.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -90).isActive = true
//         self.pageControl.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: -20).isActive = true
//         self.pageControl.heightAnchor.constraint(equalToConstant: 20).isActive = true
//         self.pageControl.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        
        
//            let imgFrame = CGRect(x: 0, y: 100, width: view.frame.width, height: 100)
//        imgView.image = UIImage(named: images[0])
//        imgView.frame = imgFrame
        imageView.image = UIImage(named: "welfare")
        //imageView = UIImageView(image:UIImage(named:"welfare"))
               imageView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 400)
        self.view.addSubview(self.imageView)

    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    // 페이지가 변하면 호출됨
       @IBAction func pageChanged(_ sender: UIPageControl) {
           
        print("페이지컨트롤 이벤트")
           // images라는 배열에서 pageControl이 가르키는 현재 페이지에 해당하는 이미지를 imgView에 할당
           imageView.image = UIImage(named: images[pageCTR.currentPage])
        imageView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 400)
        self.view.addSubview(self.imageView)

       }
    
}
