//
//  privacyViewController.swift
//  welfare
//  개인정보를 다루는 페이지
//  1.개인선호도 확인 가능
//. 2.로그아웃 가능
//  Created by 김동현 on 2020/09/24.
//  Copyright © 2020 com. All rights reserved.
//

import UIKit
import Alamofire

class privacyViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        //화면 스크롤 크기
        var screenWidth = view.bounds.width
        var screenHeight = view.bounds.height
        
        
        //로그아웃 버튼
        let button = UIButton(type: .system)
        button.addTarget(self, action: #selector(self.logout), for: .touchUpInside)
        button.frame = CGRect(x:20, y:100, width: screenWidth - 40, height: 20)
        
        button.setTitle("로그 아웃", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.backgroundColor = .clear
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.black.cgColor
        self.view.addSubview(button)
        
        //설정버튼
        let setBtn = UIButton(type: .system)
        setBtn.addTarget(self, action: #selector(self.setting), for: .touchUpInside)
        setBtn.frame = CGRect(x:20, y:140, width: screenWidth - 40, height: 20)
        
        setBtn.setTitle("설정하기", for: .normal)
        setBtn.setTitleColor(UIColor.black, for: .normal)
        setBtn.backgroundColor = .clear
        setBtn.layer.cornerRadius = 5
        setBtn.layer.borderWidth = 1
        setBtn.layer.borderColor = UIColor.black.cgColor
        self.view.addSubview(setBtn)
        
        
        
    }
    
    
    
    
    //로그아웃 메소드
    @objc func logout(_ sender: UIButton) {
        
        //디바이스에 저장된 사용자 정보를 들고온다.
        var userToken = UserDefaults.standard.string(forKey: "token")
        //  print(userToken!)
        var userEmail = UserDefaults.standard.string(forKey: "email")
        
        print(userToken)
        
        
        let params = ["userEmail":userEmail!,"userToken":userToken!]
        Alamofire.request("http://3.34.4.196/backend/ios/ios_logout.php", method: .post, parameters: params)
            .validate()
            .responseJSON { response in
                
                switch response.result {
                case .success(let value):
                    //print(value)
                    if let json = value as? [String: Any] {
                        print(json)
                        for (key, value) in json {
                            //버튼들을 추가한다.
                            
                            if(key == "result"){
                                
                                //로그아웃이 정상적으로 되면
                                if(value as! String == "성공"){
                                    //디바이스에 저장된 사용자 정보를 지우고
                                    UserDefaults.standard.removeObject(forKey: "token")
                                    UserDefaults.standard.removeObject(forKey: "email")
                                    
                                    //로그인화면으로 이동한다.
                                    guard let uvc = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as? ViewController         else{
                                        
                                        return
                                        
                                    }
                                    
                                  
                                    
                                    //전환된 화면의 형태지정
                                    uvc.modalPresentationStyle = .fullScreen
                                    
                                    
                                    //self.navigationController?.pushViewController(uvc, animated: true)
                                    self.present(uvc, animated: true, completion: nil)
                                    
                                    
                                    //로그아웃이 안될경우
                                }else{
                                    print("로그아웃 실패")
                                }
                                
                                
                            }
                            
                            
                        }
                        
                        
                    }
                    
                    
                    
                case .failure(let error):
                    print(error)
                }
                
                
                
                
        }
        
        
    }
    
    
    
    @objc func setting (_ sender: UIButton) {

        //관심사 설정화면으로 이동한다..
                                           guard let uvc = self.storyboard?.instantiateViewController(withIdentifier: "SettingViewController") as? SettingViewController         else{
                                               
                                               return
                                               
                                           }
                                           
                                         
                                           
                                           //전환된 화면의 형태지정
                                           uvc.modalPresentationStyle = .fullScreen
                                           
                                           
                                           //self.navigationController?.pushViewController(uvc, animated: true)
                                           self.present(uvc, animated: true, completion: nil)
        
        
    }
}
