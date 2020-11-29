//
//  DetailUiViewController.swift
//  welfare
//
//  Created by 김동현 on 2020/10/20.
//  Copyright © 2020 com. All rights reserved.
//

import UIKit

class DetailUiViewController: UIViewController {
    
    //메인 세로 스크롤
    let m_Scrollview = UIScrollView()
    
    
    //메인을 구성하는 이미지 및 라벨 뷰
    let appLogo = UIImageView()
    let header = UIView()
    let headerLabel = UILabel()
    
    //라벨명을 담을 배열
    var LabelName = ["내용","신청방법","리뷰"]
    
    
    //즐겨찾기 추가이미지
    let addImg = UIImage()

    //즐겨찾기 해제이미지
    let deleteImg = UIImage()

    
    //카테고리 결과페이지에서 선택한 정책을 저장하는 변수
    var selectedPolicy : String = ""
    
    
    
    
       // json에서 key값 설정
    struct userlist: Decodable {
        var welf_apply : String
        var welf_contact : String
        var welf_contents : String
        var welf_target : String
        var welf_name : String
        var welf_period : String

        
    }
    
    
    struct parse : Decodable {
        
        var retBody = ""
            
        }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("화면 출력")
        //화면 스크롤 크기
        var screenWidth = Int(view.bounds.width)
        var screenHeight = Int(view.bounds.height)
  

        //로고 추가
        let LogoImg = UIImage(named: "appLogo")
        appLogo.image = LogoImg
        appLogo.frame = CGRect(x: 22.1, y: 26.7, width: 106, height: 14.3)
        //self.view.addSubview(appLogo)
        m_Scrollview.addSubview(appLogo)
        
        
        //헤더라벨
        headerLabel.frame = CGRect(x: 0, y: Int(52.3), width: screenWidth, height: 66)
        headerLabel.textAlignment = .center
        headerLabel.textColor = UIColor.white
        //폰트지정 추가
        headerLabel.text = "의료급여수급권자 영유아건강검진비 지원"
        headerLabel.font = UIFont(name: "Jalnan", size: 26)
        // inquiryLabel.font = UIFont(name: "NanumGothicBold", size: 13.7)
        // self.view.addSubview(inquiryLabel)
        header.addSubview(headerLabel)
        
        
        header.frame = CGRect(x: 0, y: Int(52.3), width: screenWidth, height: 66)
        
        //추후 그라데이션 적용
        header.backgroundColor = UIColor(displayP3Red: 111/255.0, green: 82/255.0, blue: 232/255.0, alpha: 1)
        
        //내용,신청방법,리뷰 버튼
        for i in 0..<3 {
            //버튼별 가로거리조정
            var distance : Double = 97.3
            let button = UIButton(type: .system)
            
            //폰트적용을 위한 버튼별 라벨 추가
            //라벨
            let label = UILabel()
            
            
            
            //글자가 긴 신청방법 버튼일 경우
            if(i == 1){
                distance += 157
                button.frame = CGRect(x:157, y:149, width: 61.3, height: 19.3)
                label.frame = CGRect(x: 0, y: 0, width: 61.3, height: 19.3)

            }else{
                button.frame = CGRect(x:distance, y:149, width: 31, height: 19.3)
                label.frame = CGRect(x: 0, y: 0, width: 31, height: 19.3)

            }
            
            
            label.textAlignment = .center
            
            //폰트지정 추가
            label.text = LabelName[i]
            label.textColor = .white
            label.font = UIFont(name: "NanumGothicBold", size: 16.7)
            button.addSubview(label)
            
            header.addSubview(button)
        }
        
        
        
        
        
        
        
        m_Scrollview.addSubview(header)
        m_Scrollview.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
        m_Scrollview.contentSize = CGSize(width:screenWidth, height: 1747)
        self.view.addSubview(m_Scrollview)

        
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
