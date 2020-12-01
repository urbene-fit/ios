//
//  MainViewController.swift
//  welfare
//
//  Created by 김동현 on 2020/07/30.
//  Copyright © 2020 com. All rights reserved.
//  로그인을 통해 이동하는 메인 UI이다.
//네비게이션뷰에 포함되며
//스크롤뷰를 통해서 다양환 아이템들을 보여준다.
//(맞춤,추천,인기등)

import UIKit
import SnapKit

class MainViewController: UIViewController {
    
    
   let scrollView = UIScrollView()
        
        ///////////// 1번째
        let contentsView = UIView()
        //////////////////////////
    
    //데이터 전달받을 변수
       var paramTF: String = ""

        
    
    //자식뷰 -> 컨텐츠뷰 -> 스크롤뷰
    //자식뷰 목록
    /*
    1.페이지뷰(메인정책 이미지+텍스트로 소개)
    2.각 뷰별 라벨
    3.맞춤정책(정보입력전은 버튼,입력후는 정보에 따른 정책소개)
    4.인기정책

     
     
     
    
    
    */
    //스크롤뷰 안에 사용할 뷰 선언
        let imageView1: UIImageView = {
            let imageView = UIImageView()
            
            imageView.contentMode = .scaleAspectFit
            imageView.image = UIImage.init(named: "main")
            return imageView
        }()
    //뷰페이지에 나올 데이터를 설정
    //private let ladningimages = ["","",""]
    
        
    override func viewDidLoad() {
    super.viewDidLoad()
    
//        contentsView.addSubview(imageView2)
//        scrollView.addSubview(contentsView)
//        self.addSubview(scrollView)
//       
//        
//        //스크롤뷰 컨스트레인트 만들어주기
//        scrollView
    
    }
    
    }
