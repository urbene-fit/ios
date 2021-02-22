//
//  Test2ViewController.swift
//  welfare
//
//  Created by 김동현 on 2020/08/03.
//  Copyright © 2020 com. All rights reserved.
//

import UIKit
import Foundation

class Test2ViewController: UIViewController {
    
    
    
   //이미지
    var images = ["welfare","welfare2","welfare3"]

    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    var sec : Int!
    var page : Bool!
    override func viewDidLoad() {
        super.viewDidLoad()
        
    page = true
        
        //스크롤뷰 설정
        //        화면크기
            //               뷰 전체 폭 길이
                       let screenWidth = view.frame.width
                           // 뷰 전체 높이 길이
                    let screenHeight  = view.frame.height
                    
            pageControl.numberOfPages = images.count //페이지 컨트롤의 전체 수
            pageControl.currentPage = 0             //현재 페이지를 의미
            pageControl.pageIndicatorTintColor = UIColor.green  // 페이지 컨트롤의 페이지를 표시하는 부분의 색상
            pageControl.currentPageIndicatorTintColor = UIColor.red //선택된 페이지 컨트롤의 색
            imageView.image = UIImage(named: images[0])
                
         
            //페이지컨트롤 이동
        while page == true{

              DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3), execute: {
                  // Put your code which should be executed with a delay here
                if self.pageControl.currentPage < 3{
                self.imageView.image = UIImage(named: self.images[self.pageControl.currentPage+1])
                }else{
                    self.imageView.image = UIImage(named: self.images[0])
                }
                
              })
        }

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    
    @IBAction func changed(_ sender: Any) {
        
        imageView.image = UIImage(named: images[pageControl.currentPage])

        
        
    }
  
    
    
}
