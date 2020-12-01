//
//  SettingViewController.swift
//  welfare
//
//  Created by 김동현 on 2020/10/05.
//  Copyright © 2020 com. All rights reserved.
// 사용자의 선호 카테고리르 설정하여, 알림을 받게 도와주는 페이지




//

import UIKit
import Alamofire



class SettingViewController: UIViewController {
    
    
    //사용자가 사용한 카테고리들을 저장
    var categorys = Array<String>()
    
    
    //네비게이션 바 변수
    let navBar = UINavigationBar()
    
    //라벨명을 담을 배열
    var LabelName = ["아기·어린이","학생·청년","중장년·노인","육아·임신","장애인","문화·생활","다문화","기업·자영업자","법률","주거","취업·창업","기초생활수급","기타"]
    
    
    //버튼들을 담을 배열
    var buttons = [UIButton]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //화면 스크롤 크기
        var screenWidth = view.bounds.width
        var screenHeight = view.bounds.height
        
        
        //네비게이션 설정
        //페이지 이름과 뒤로가기 제공
        let navItem = UINavigationItem()
        
        
        navBar.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: 40)
        
        let Image = UIImage(named: "back")
        
        var backbutton = UIButton(type: .custom)
        backbutton.frame = CGRect(x: 0, y: 0, width: 16, height: 16)
        backbutton.setImage(UIImage(named: "BackButton.png"), for: .normal) // Image can be downloaded from here below link
        backbutton.widthAnchor.constraint(equalToConstant: 16.0).isActive = true
        backbutton.heightAnchor.constraint(equalToConstant: 16.0).isActive = true
        backbutton.setTitleColor(backbutton.tintColor, for: .normal)
        
        
        
        view.addSubview(navBar)
        
        
        //버튼 추가 부분
        //반복문을 통해서 이미지뷰를 그려준다.
        for i in 0..<13 {
            //print("i숫자 : " )
            //print(i)
            //홀짝을 구분한다.
            //홀수인경우 이미지를 앞에 배치
            //짝수인경우 뒤에 배치
            //짝수인 경우
            if(i != 0 && i%2==1){
                //if(i%2==0){
                //print("짝수")
                //K = i -1
                
                
                
                
                let button = UIButton(type: .system)
                button.tag = i
                button.addTarget(self, action: #selector(self.selected), for: .touchUpInside)
                button.frame = CGRect(x:screenWidth/2 + 10, y:CGFloat(35 * (i - 1) + 50), width: screenWidth/2 - 40, height: 30)
                
                button.setTitle(LabelName[i], for: .normal)
                button.setTitleColor(UIColor.black, for: .normal)
                button.backgroundColor = .clear
                button.layer.cornerRadius = 5
                button.layer.borderWidth = 1
                button.layer.borderColor = UIColor.black.cgColor
                self.view.addSubview(button)
                buttons.append(button)
                
                
                //홀수 인 경우
            }else{
                
                let button = UIButton(type: .system)
                button.tag = i
                button.addTarget(self, action: #selector(self.selected), for: .touchUpInside)
                button.frame = CGRect(x:20, y:35 * i + 50, width: Int(screenWidth)/2 - 40, height: 30)
                
                button.setTitle(LabelName[i], for: .normal)
                button.setTitleColor(UIColor.black, for: .normal)
                button.backgroundColor = .clear
                button.layer.cornerRadius = 5
                button.layer.borderWidth = 1
                button.layer.borderColor = UIColor.black.cgColor
                buttons.append(button)
                
                view.addSubview(button)
                
                
                
                
            }
            
            
            
            
            
            
        }
        
        
        
        //하단 선호 카테고리 설정 적용하기 버튼
        let button = UIButton(type: .system)
        button.addTarget(self, action: #selector(self.apply), for: .touchUpInside)
        button.frame = CGRect(x:0, y: Int(screenHeight) - 100, width: Int(screenWidth) , height: 100)
        
        button.setTitle("적용하기", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.backgroundColor = .clear
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.black.cgColor
        //buttons.append(button)
        
        view.addSubview(button)
        
        
        
        
        
    }
    
    
    @objc func selected(_ sender: UIButton) {
        // 원하는 대로 코드 구성
        print("버튼 클릭")
        //print(sender.tag)
        if(self.buttons[sender.tag].titleColor(for: .normal) == UIColor.systemIndigo){
            buttons[sender.tag].setTitleColor(UIColor.black, for: .normal)
            buttons[sender.tag].layer.borderColor = UIColor.black.cgColor
            
            categorys = categorys.filter(){$0 != LabelName[sender.tag]}
            
            
            //카테고리를 추가하는 경우
        }else{
            
            buttons[sender.tag].setTitleColor(UIColor.systemIndigo, for: .normal)
            buttons[sender.tag].layer.borderColor = UIColor.systemIndigo.cgColor
            // select = buttons[sender.tag].title(for: .normal)!
            print(LabelName[sender.tag])
            
            
            categorys.append(LabelName[sender.tag])
            
        }
        
        
        
        
    }
    
    
    //적용하기 버튼을 누르면 서버로 사용자의 선호 카테고리를 보낸다.
    //디바이스에 저장된 사용자의 이메일도 가져와서 같이 보낸다.
    @objc func apply(_ sender: UIButton) {
        print("버튼시랭")
        let string = categorys.joined(separator: " ")
        
        //디바이스에 저장된 사용자 이메일을 불러온다.
                var userEmail = UserDefaults.standard.string(forKey: "email")
        print(userEmail!)
        let parameters = ["like": string, "userEmail": userEmail!]
        
        
        Alamofire.request("http://3.34.4.196/backend/ios/ios_like.php", method: .post, parameters: parameters)
            .validate()
            .responseJSON { response in
                
                switch response.result {
                case .success(let value):
                    
                    
                    break
                    
                    
                    
                    
                    
                    
                    
                case .failure(let error):
                    print(error)
                }
                
                
                
        }
        
        
    }
}
