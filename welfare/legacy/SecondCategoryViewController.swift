//
//  SecondCategoryViewController.swift
//  welfare
//
//  Created by 김동현 on 2020/08/07.
//  Copyright © 2020 com. All rights reserved.
//

import UIKit
import Alamofire

class SecondCategoryViewController: UIViewController {
    
    
       // 전달받을 데이터 변수 정리
       var categoryArr = [String]()
    
    //버튼들 높이
    var  Height : Int = 100
    
    //디바이스의 크기
    var screenWidth : Int = 1
    var screenHeight : Int = 1
    var count_number : Int = 0
    
    //스크롤뷰 컨텐츠 사이즈
    var cotentSize : Int = 0
    
    // 메인 스크롤뷰
    var m_Scrollview = UIScrollView()
    
    //버튼들을 담을 배열
    var buttons = [UIButton]()
    
    //선택한 내용을 담을 변수
    var select : String = ""
    
    
    
    

    

    override func viewDidLoad() {
        super.viewDidLoad()

        print("세컨뷰 로드")
        
        //뷰크기 재지정
        //디바이스의 크기
        screenWidth = Int(view.bounds.width)
        screenHeight = Int(view.bounds.height)
        
        
        //컨텐츠 사이즈 재지정
        cotentSize = categoryArr.count * 50 + 400
        
        // Do any additional setup after loading the view.
        //반복문으로 버튼 생성
        for i in 0..<categoryArr.count {
         print(categoryArr[i])

            let button = UIButton(type: .system)
            button.tag = self.count_number
            button.addTarget(self, action: #selector(self.selected), for: .touchUpInside)
            button.frame = CGRect(x: self.screenWidth/4, y: self.Height, width: self.screenWidth/2, height: 50)
                                                      
            button.setTitle(categoryArr[i] as! String, for: .normal)
            button.setTitleColor(UIColor.black, for: .normal)
            button.backgroundColor = .clear
            button.layer.cornerRadius = 5
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor.black.cgColor
                                                   
            self.m_Scrollview.addSubview(button)
            self.buttons.append(button)
            self.count_number += 1
            self.Height += 100

            
            //UI작업
            //하단 버튼
                    let NextBtn = UIButton(type: .system)
                
                    // Tag a button.
                    // Set the button installation coordinates and size.
                    //button.frame = CGRect(x: posX, y: posY, width: width, height: height)
                    // Set the title (normal).
                    NextBtn.setTitle("다음", for: .normal)
                    // Add an event.
                    //NextBtn.addTarget(self, action: #selector(selected), for: .touchUpInside)
                NextBtn.addTarget(self, action: #selector(nexted), for: .touchUpInside)

                    NextBtn.frame = CGRect(x: 0, y: screenHeight-50, width: screenWidth, height: 50)

                   NextBtn.setTitle("다음", for: .normal)
                   NextBtn.setTitleColor(UIColor.white, for: .normal)
                NextBtn.backgroundColor = UIColor.systemIndigo
                self.view.addSubview(NextBtn)

            
              
                
             
                //스크롤뷰 프레임 설정
                m_Scrollview.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight-50)

                
                //질문라벨
                var MainLabel: UILabel = UILabel()
                MainLabel.frame = CGRect(x: 0, y: 10, width: screenWidth, height: 100)
                MainLabel.backgroundColor = .clear
                MainLabel.textColor = UIColor.black
                //MainLabel.textAlignment = NSTextAlignment.center
                            MainLabel.text = "당신의 \n  연령대는?"
                            MainLabel.numberOfLines = 2
                            MainLabel.font = UIFont(name: "HelveticaNeue", size: CGFloat(30))
                            MainLabel.tintColor = UIColor.black
            
                   // m_Scrollview.addSubview(MainLabel)
    
                    
                    
                    
                    m_Scrollview.contentSize = CGSize(width:screenWidth, height: cotentSize)
                    
                    self.view.addSubview(m_Scrollview)
            
            
            
        }
        
        
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    
    
   
     //카테고리 선택 버튼 클릭이벤트
             @objc private func selected(_ sender: UIButton) {
                     print("버튼선택")
                 print(sender.tag)
    //            buttons[sender.tag].setTitleColor(UIColor.systemBlue, for: .normal)
    //            buttons[sender.tag].layer.borderColor = UIColor.systemBlue.cgColor
                if(self.buttons[sender.tag].titleColor(for: .normal) == UIColor.systemBlue){
                    buttons[sender.tag].setTitleColor(UIColor.black, for: .normal)
                    buttons[sender.tag].layer.borderColor = UIColor.black.cgColor
                   
                }else{
                    
                    buttons[sender.tag].setTitleColor(UIColor.systemBlue, for: .normal)
                    buttons[sender.tag].layer.borderColor = UIColor.systemBlue.cgColor
                    select = buttons[sender.tag].title(for: .normal)!
                    print(select)
                }
                
    
        
        }
    
    
    
    
     //다음카테고리이동 버튼 클릭이벤트
                @objc private func nexted(_ sender: UIButton) {
                        print("버튼선택")
                        print(select)
                        
                let parameters = ["category2": select]
                 guard let uvc = self.storyboard?.instantiateViewController(withIdentifier: "SecondCategory") as? SecondCategoryViewController else{ return }
                    
                     Alamofire.request("http://3.34.4.196/backend/php/admin/3layer_request.php", method: .post, parameters: parameters)
                                                      .validate()
                                                      .responseJSON { response in
                                           
                                        switch response.result {
                                            case .success(let value):
                                                                    
                                                    if let json = value as? [String: Any] {
                                                                  print(json)
                                                    for (key, value) in json {
                                                //카테고리데이터를 집어넣는다.
                                                        uvc.categoryArr.append(value as! String)
                                                        //print(value as! String)
                                              
                                            }
                                            //데이터가 모두 실리면 데이터와함계 뷰컨트롤러를 이동한다.
                                                      self.navigationController?.pushViewController(uvc, animated: false)
    //
                                                        
                                                        
                                                        
                                                        
                }
                                    
                    case .failure(let error):
                                        print(error)
                                                }
                                                       
                                                       
                                                       
                                                       
                                           }
                    

                    
                    
            }
    
}
