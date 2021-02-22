//
//  TestPageController.swift
//  welfare
//
//  Created by 김동현 on 2020/08/03.
//  Copyright © 2020 com. All rights reserved.
//

import UIKit

class TestPageController: UIViewController, UIScrollViewDelegate {

        var images = ["welfare","welfare2","welfare3"]

    @IBOutlet weak var imgView: UIImageView!
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    
    let m_Scrollview = UIScrollView()
           let contentsView = UIView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
             
                pageControl.numberOfPages = images.count //페이지 컨트롤의 전체 수
                pageControl.currentPage = 0             //현재 페이지를 의미
                pageControl.pageIndicatorTintColor = UIColor.green  // 페이지 컨트롤의 페이지를 표시하는 부분의 색상
                pageControl.currentPageIndicatorTintColor = UIColor.red //선택된 페이지 컨트롤의 색
                imgView.image = UIImage(named: images[0])
        
                
        //        화면크기
        //               뷰 전체 폭 길이
                   let screenWidth = view.frame.width
                       // 뷰 전체 높이 길이
                let screenHeight  = view.frame.height

        //메인스크롤뷰 그리기
            let scrollView = UIScrollView(frame: view.bounds)
            
            scrollView.isScrollEnabled = true
            
            //스크롤뷰 콘텐츠사이즈 지정
            scrollView.contentSize = CGSize(width: screenWidth , height: screenHeight+1000)
        
        
            contentsView.addSubview(imgView)
       // contentsView.addSubview(pageControl)
        scrollView.addSubview(contentsView)
       // view.addSubview(pageControl)

        view.addSubview(scrollView)

        


        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
     //페이지 콘트롤러 눌렀을 때 작동하게 하는 함수
      

    @IBAction func changed(_ sender: Any) {
        
        
        
                imgView.image = UIImage(named: images[pageControl.currentPage])


    }
    
}
