//
//  FirstCategoryViewController.swift
//  welfare
//
//  Created by 김동현 on 2020/08/06.
//  Copyright © 2020 com. All rights reserved.
//



/// 앱은 카테고리 선택내용을 받아 버튼을 만든다.
//. 사용자는 내용에 따라 배치된 버튼을 눌러 개인정보를 선택한다.

//화면구성
//0.네비게이션 바 and 스크롤뷰
//1.질문 라벨(예:가족구성원이 어떻게 되세요?)
//2.서버에서 받은 선택지로 만든 버튼
//3.진행도를 알려주는 프로그레스바
//4.다음으로 이동하는 하단 탭바

import UIKit
import SwiftyJSON
import Alamofire



class FirstCategoryViewController: UIViewController {
    
    
    
    //버튼들 높이
    var  Height : Int = 30
    
    //디바이스의 크기
    var screenWidth : Int = 1
    var screenHeight : Int = 1
    var count_number : Int = 0
    
    struct test: Codable {
        var count_number : Int
        var number_1: String
        var number_2: String
        var number_3: String
        var number_4: String
        var number_5: String
//        var number_6: String
//        var number_7: String
//        var number_8: String
//        var number_9: String
//        var number_10: String
        
    }
    
    struct StatusObject: Decodable {
        let credit_count: Int?
        let elapsed: Int?
        let error_code: Int?
        let timestamp: String?
    }
    
    // 메인 스크롤뷰
        var m_Scrollview = UIScrollView()
        
    
    
    //let FirstBtn = UIButton()
    
       // 버튼클릭여부를 구분할 불린 변수
    var firClick : Bool = true
    var secClick : Bool = true
    var thirdClick : Bool = true
    var fourthClick : Bool = true
    var fifthClick : Bool = true
    var sixthClick : Bool = true
    var seventhClick : Bool = true
    var eighthClick : Bool = true
    var ninthClick : Bool = true
    var tenthClick : Bool = true

        
    //버튼들을 담을 배열
    var buttons = [UIButton]()
    
    //선택한 내용을 담을 변수 
    var select : String = ""
    
    
    //카테고리값을 담을 배열
    //var categoryArr : [String]
        
    var categoryArr = [String]()
    
    
  //사용할 버튼들을 전역변수 선언
    lazy var firstButton: UIButton = {
        // Generate button.
        let button = UIButton(type: .system)
    
        // Tag a button.
        button.tag = 1
        // Set the button installation coordinates and size.
        //button.frame = CGRect(x: posX, y: posY, width: width, height: height)
        // Set the title (normal).
        button.setTitle("systemButton", for: .normal)
        // Add an event.
        button.addTarget(self, action: #selector(selected), for: .touchUpInside)
        return button }()
    
    lazy var secBtn: UIButton = {
         // Generate button.
         let button = UIButton(type: .system)
     
         // Tag a button.
         button.tag = 2
         // Set the button installation coordinates and size.
         //button.frame = CGRect(x: posX, y: posY, width: width, height: height)
         // Set the title (normal).
         // Add an event.
         button.addTarget(self, action: #selector(selected), for: .touchUpInside)
         return button }()

    lazy var thirdBtn: UIButton = {
        // Generate button.
        let button = UIButton(type: .system)
    
        // Tag a button.
        button.tag = 3
        // Set the button installation coordinates and size.
        //button.frame = CGRect(x: posX, y: posY, width: width, height: height)
        // Set the title (normal).
        // Add an event.
        button.addTarget(self, action: #selector(selected), for: .touchUpInside)
        return button }()
    
    
    lazy var fourthBtn: UIButton = {
        // Generate button.
        let button = UIButton(type: .system)
    
        // Tag a button.
        button.tag = 4
        // Set the button installation coordinates and size.
        //button.frame = CGRect(x: posX, y: posY, width: width, height: height)
        // Set the title (normal).
        // Add an event.
        button.addTarget(self, action: #selector(selected), for: .touchUpInside)
        return button }()
    
    
    lazy var fifthBtn: UIButton = {
        // Generate button.
        let button = UIButton(type: .system)
    
        // Tag a button.
        button.tag = 5
        // Set the button installation coordinates and size.
        //button.frame = CGRect(x: posX, y: posY, width: width, height: height)
        // Set the title (normal).
        // Add an event.
        button.addTarget(self, action: #selector(selected), for: .touchUpInside)
        return button }()
    
    
    lazy var sixthBtn: UIButton = {
         // Generate button.
         let button = UIButton(type: .system)
     
         // Tag a button.
         button.tag = 5
         // Set the button installation coordinates and size.
         //button.frame = CGRect(x: posX, y: posY, width: width, height: height)
         // Set the title (normal).
         // Add an event.
         button.addTarget(self, action: #selector(selected), for: .touchUpInside)
         return button }()
    
    lazy var seventhBtn: UIButton = {
         // Generate button.
         let button = UIButton(type: .system)
     
         // Tag a button.
         button.tag = 5
         // Set the button installation coordinates and size.
         //button.frame = CGRect(x: posX, y: posY, width: width, height: height)
         // Set the title (normal).
         // Add an event.
         button.addTarget(self, action: #selector(selected), for: .touchUpInside)
         return button }()
    
    lazy var eighthBtn: UIButton = {
         // Generate button.
         let button = UIButton(type: .system)
     
         // Tag a button.
         button.tag = 5
         // Set the button installation coordinates and size.
         //button.frame = CGRect(x: posX, y: posY, width: width, height: height)
         // Set the title (normal).
         // Add an event.
         button.addTarget(self, action: #selector(selected), for: .touchUpInside)
         return button }()
    
    lazy var ninthBtn: UIButton = {
         // Generate button.
         let button = UIButton(type: .system)
     
         // Tag a button.
         button.tag = 5
         // Set the button installation coordinates and size.
         //button.frame = CGRect(x: posX, y: posY, width: width, height: height)
         // Set the title (normal).
         // Add an event.
         button.addTarget(self, action: #selector(selected), for: .touchUpInside)
         return button }()
   
    
    
    
    //하단 탭바
    //let bar = UITabBar()
    
    let members = ["JS", "MS", "JH", "HD", "DH", "HC"]

    var count : Int = 5
    
 

    override func viewDidLoad() {
        super.viewDidLoad()
        
      //서버로부터 카테고리 데이터를 바다온다.
        let parameters = ["category0": "category0"]
        //디바이스의 크기
        screenWidth = Int(view.bounds.width)
        screenHeight = Int(view.bounds.height)

                       Alamofire.request("http://3.34.4.196/backend/php/admin/1layer_request.php", method: .post, parameters: parameters)
                                  .validate()
                                  .responseJSON { response in
                       
                                   switch response.result {
                                              case .success(let value):
                                                
                                        if let json = value as? [String: Any] {
                                              //print(json)
                                            for (key, value) in json {
                                            //버튼들을 추가한다.
                                                
                                                    let button = UIButton(type: .system)
                                                    button.tag = self.count_number
                                                button.addTarget(self, action: #selector(self.selected), for: .touchUpInside)
                                                button.frame = CGRect(x: self.screenWidth/4, y: self.Height, width: self.screenWidth/2, height: 50)
                                                
                                                button.setTitle(value as! String, for: .normal)
                                                    button.setTitleColor(UIColor.black, for: .normal)
                                                    button.backgroundColor = .clear
                                                    button.layer.cornerRadius = 5
                                                    button.layer.borderWidth = 1
                                                    button.layer.borderColor = UIColor.black.cgColor
                                             
                                                self.m_Scrollview.addSubview(button)
                                                self.buttons.append(button)
                                                self.count_number += 1
                                                self.Height += 100

                                                
                                                                                 }
                                            }
                                            
                                 

                                    
                                      // print(value)
                                       //let decoder = JSONDecoder()
                                       
                                       
//                                       do {
//                                           let product = try decoder.decode(GroceryProduct.self, from: response.data as! Data)
                                           
                                        //print(response.data?.count)
                                          // print(product.number_1)
                                           //print(product.count_number)
                                           
//                                        //반복문으로 파싱한다.
//                                        for i in 0..<product.count_number {
//                                            if(i==0){
//                                            self.categoryArr.append(product.number_1)
//                                                print(self.categoryArr[i])
//                                            }else if(i == 1){
//                                                self.categoryArr.append(product.number_2)
//                                                print(self.categoryArr[i])
//
//                                            }else if(i == 2){
//                                                self.categoryArr.append(product.number_3)
//                                                print(self.categoryArr[i])
//
//                                            }else if(i == 3){
//                                                self.categoryArr.append(product.number_4)
//                                                print(self.categoryArr[i])
//
//                                            }else if(i == 4){
//                                                self.categoryArr.append(product.number_5)
//                                                print(self.categoryArr[i])
//
//                                            }
//                                        }
                                           
                                           
//                                       } catch {
//                                           print(error)
//                                       }

                                        //뷰를 세팅하는 메슈ㅗ드
                                       //self.setUp()
                                              case .failure(let error):
                                                  print(error)
                                              }
                                   
                                   
                                   
                                   
                       }

        
     

        

//        print("어레이숫자")
//        print(self.categoryArr.count)
        
        
        
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
        
       //반복문으로 버튼 생성
//        for i in 0..<count {
//
//
//            if(i==0){
//                firstButton.frame = CGRect(x: screenWidth/4, y: 130, width: screenWidth/2, height: 50)
//
//                firstButton.setTitle(self.categoryArr[i], for: .normal)
//                firstButton.setTitleColor(UIColor.black, for: .normal)
//                firstButton.backgroundColor = .clear
//                firstButton.layer.cornerRadius = 5
//                firstButton.layer.borderWidth = 1
//                firstButton.layer.borderColor = UIColor.black.cgColor
//                //FirstBtn.tag = 1
//                firstButton.tag = 1
//                m_Scrollview.addSubview(firstButton)
//
//
//            }else if(i==1){
//                //var Width = i * 100 + 30
//                secBtn.frame = CGRect(x: screenWidth/4, y: 230, width: screenWidth/2, height: 50)
//
//                secBtn.setTitle(self.categoryArr[i], for: .normal)
//                secBtn.setTitleColor(UIColor.black, for: .normal)
//                secBtn.backgroundColor = .clear
//                secBtn.layer.cornerRadius = 5
//                secBtn.layer.borderWidth = 1
//                secBtn.layer.borderColor = UIColor.black.cgColor
//                //FirstBtn.tag = 1
//                secBtn.tag = i
//                m_Scrollview.addSubview(secBtn)
//
//        }else if(i==2){
//
//                thirdBtn.frame = CGRect(x: screenWidth/4, y: 330, width: screenWidth/2, height: 50)
//
//                thirdBtn.setTitle(self.categoryArr[i], for: .normal)
//                thirdBtn.setTitleColor(UIColor.black, for: .normal)
//                thirdBtn.backgroundColor = .clear
//                thirdBtn.layer.cornerRadius = 5
//                thirdBtn.layer.borderWidth = 1
//                thirdBtn.layer.borderColor = UIColor.black.cgColor
//                            //FirstBtn.tag = 1
//                thirdBtn.tag = i
//                m_Scrollview.addSubview(thirdBtn)
//
//        }else if(i==3){
//                fourthBtn.frame = CGRect(x: screenWidth/4, y: 330, width: screenWidth/2, height: 50)
//
//                fourthBtn.setTitle(self.categoryArr[i], for: .normal)
//                fourthBtn.setTitleColor(UIColor.black, for: .normal)
//                fourthBtn.backgroundColor = .clear
//                fourthBtn.layer.cornerRadius = 5
//                fourthBtn.layer.borderWidth = 1
//                fourthBtn.layer.borderColor = UIColor.black.cgColor
//                            //FirstBtn.tag = 1
//                fourthBtn.tag = i
//                m_Scrollview.addSubview(fourthBtn)
//
//        }else if(i==4){
//                fifthBtn.frame = CGRect(x: screenWidth/4, y: 330, width: screenWidth/2, height: 50)
//
//                fifthBtn.setTitle(self.categoryArr[i], for: .normal)
//                fifthBtn.setTitleColor(UIColor.black, for: .normal)
//                fifthBtn.backgroundColor = .clear
//                fifthBtn.layer.cornerRadius = 5
//                fifthBtn.layer.borderWidth = 1
//                fifthBtn.layer.borderColor = UIColor.black.cgColor
//                                          //FirstBtn.tag = 1
//                fifthBtn.tag = i
//                m_Scrollview.addSubview(fifthBtn)
//
//
//        }
//        }

        
    //대답지 버튼 
        //FirstBtn = UIButton(type: .system)
            
        
//        // Specify the position of the button.
//        firstButton.frame = CGRect(x: screenWidth/4, y: 130, width: screenWidth/2, height: 50)
//
//        firstButton.setTitle("영유아", for: .normal)
//        firstButton.setTitleColor(UIColor.black, for: .normal)
//        firstButton.backgroundColor = .clear
//        firstButton.layer.cornerRadius = 5
//        firstButton.layer.borderWidth = 1
//        firstButton.layer.borderColor = UIColor.black.cgColor
//        //FirstBtn.tag = 1
//        firstButton.tag = 1
//
//
//
//        secBtn.frame = CGRect(x: screenWidth/4, y: 230, width: screenWidth/2, height: 50)
//
//        secBtn.setTitle("아동·청소년", for: .normal)
//        secBtn.setTitleColor(UIColor.black, for: .normal)
//        secBtn.backgroundColor = .clear
//        secBtn.layer.cornerRadius = 5
//        secBtn.layer.borderWidth = 1
//        secBtn.layer.borderColor = UIColor.black.cgColor
//        secBtn.tag = 2
//
//
//        //3번째
//        thirdBtn.frame = CGRect(x: screenWidth/4, y: 330, width: screenWidth/2, height: 50)
//
//        thirdBtn.setTitle("청년", for: .normal)
//        thirdBtn.setTitleColor(UIColor.black, for: .normal)
//        thirdBtn.backgroundColor = .clear
//        thirdBtn.layer.cornerRadius = 5
//        thirdBtn.layer.borderWidth = 1
//        thirdBtn.layer.borderColor = UIColor.black.cgColor
//        thirdBtn.tag = 3
//
//        //4번째
//          fourthBtn.frame = CGRect(x: screenWidth/4, y: 430, width: screenWidth/2, height: 50)
//
//          fourthBtn.setTitle("중·장년", for: .normal)
//          fourthBtn.setTitleColor(UIColor.black, for: .normal)
//          fourthBtn.backgroundColor = .clear
//          fourthBtn.layer.cornerRadius = 5
//          fourthBtn.layer.borderWidth = 1
//          fourthBtn.layer.borderColor = UIColor.black.cgColor
//          fourthBtn.tag = 4
//
//        //다섯번째
//              fifthBtn.frame = CGRect(x: screenWidth/4, y: 530, width: screenWidth/2, height: 50)
//
//              fifthBtn.setTitle("노인", for: .normal)
//              fifthBtn.setTitleColor(UIColor.black, for: .normal)
//              fifthBtn.backgroundColor = .clear
//              fifthBtn.layer.cornerRadius = 5
//              fifthBtn.layer.borderWidth = 1
//              fifthBtn.layer.borderColor = UIColor.black.cgColor
//              fifthBtn.tag = 5
//
        
        
        
//        m_Scrollview.addSubview(MainLabel)
//        m_Scrollview.addSubview(firstButton)
//        m_Scrollview.addSubview(secBtn)
//        m_Scrollview.addSubview(thirdBtn)
//        m_Scrollview.addSubview(fourthBtn)
//        m_Scrollview.addSubview(fifthBtn)


        
        
        
        m_Scrollview.contentSize = CGSize(width:screenWidth, height: screenHeight * 2)
        
        self.view.addSubview(m_Scrollview)
    


    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, yo    u will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    func setUp(){
        
        
               //반복문으로 버튼 생성
                for i in 0..<count {
        
        
                    if(i==0){
                        firstButton.frame = CGRect(x: screenWidth/4, y: 130, width: screenWidth/2, height: 50)
        
                        firstButton.setTitle(self.categoryArr[i], for: .normal)
                        firstButton.setTitleColor(UIColor.black, for: .normal)
                        firstButton.backgroundColor = .clear
                        firstButton.layer.cornerRadius = 5
                        firstButton.layer.borderWidth = 1
                        firstButton.layer.borderColor = UIColor.black.cgColor
                        //FirstBtn.tag = 1
                        firstButton.tag = 1
                        m_Scrollview.addSubview(firstButton)
        
        
                    }else if(i==1){
                        //var Width = i * 100 + 30
                        secBtn.frame = CGRect(x: screenWidth/4, y: 230, width: screenWidth/2, height: 50)
        
                        secBtn.setTitle(self.categoryArr[i], for: .normal)
                        secBtn.setTitleColor(UIColor.black, for: .normal)
                        secBtn.backgroundColor = .clear
                        secBtn.layer.cornerRadius = 5
                        secBtn.layer.borderWidth = 1
                        secBtn.layer.borderColor = UIColor.black.cgColor
                        //FirstBtn.tag = 1
                        secBtn.tag = i
                        m_Scrollview.addSubview(secBtn)
        
                }else if(i==2){
        
                        thirdBtn.frame = CGRect(x: screenWidth/4, y: 330, width: screenWidth/2, height: 50)
        
                        thirdBtn.setTitle(self.categoryArr[i], for: .normal)
                        thirdBtn.setTitleColor(UIColor.black, for: .normal)
                        thirdBtn.backgroundColor = .clear
                        thirdBtn.layer.cornerRadius = 5
                        thirdBtn.layer.borderWidth = 1
                        thirdBtn.layer.borderColor = UIColor.black.cgColor
                                    //FirstBtn.tag = 1
                        thirdBtn.tag = i
                        m_Scrollview.addSubview(thirdBtn)
        
                }else if(i==3){
                        fourthBtn.frame = CGRect(x: screenWidth/4, y: 430, width: screenWidth/2, height: 50)
        
                        fourthBtn.setTitle(self.categoryArr[i], for: .normal)
                        fourthBtn.setTitleColor(UIColor.black, for: .normal)
                        fourthBtn.backgroundColor = .clear
                        fourthBtn.layer.cornerRadius = 5
                        fourthBtn.layer.borderWidth = 1
                        fourthBtn.layer.borderColor = UIColor.black.cgColor
                                    //FirstBtn.tag = 1
                        fourthBtn.tag = i
                        m_Scrollview.addSubview(fourthBtn)
        
                }else if(i==4){
                        fifthBtn.frame = CGRect(x: screenWidth/4, y: 530, width: screenWidth/2, height: 50)
        
                        fifthBtn.setTitle(self.categoryArr[i], for: .normal)
                        fifthBtn.setTitleColor(UIColor.black, for: .normal)
                        fifthBtn.backgroundColor = .clear
                        fifthBtn.layer.cornerRadius = 5
                        fifthBtn.layer.borderWidth = 1
                        fifthBtn.layer.borderColor = UIColor.black.cgColor
                                                  //FirstBtn.tag = 1
                        fifthBtn.tag = i
                        m_Scrollview.addSubview(fifthBtn)
        
        
                }
                }
        
    }
    
    
    
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
            
                    //버튼클릭여부를 구분할 불린 변수
            //    let firClick : Bool
            //    let secClick : Bool
            //    let thirdClick : Bool
            //    let fourthClick : Bool
            
            
            //태그등으로 클릭한 버튼 구분
//                 if(sender.tag == 0){
//
//                    //처음클릭시
//                    if(firClick){
//                        firClick = false
////                    firstButton.setTitleColor(UIColor.systemBlue, for: .normal)
////                    firstButton.layer.borderColor = UIColor.systemBlue.cgColor
//                     select = "영유아"
//                        buttons[0].setTitleColor(UIColor.systemBlue, for: .normal)
//                        buttons[0].layer.borderColor = UIColor.systemBlue.cgColor
//                        //두번클릭시
//                    }else{
//                    firClick = true
//                    buttons[0].setTitleColor(UIColor.black, for: .normal)
//                    buttons[0].layer.borderColor = UIColor.black.cgColor
//                    }
//
//
//
//                 }else if(sender.tag == 1){
//
//                    //처음클릭시
//                    if(secClick){
//                        secClick = false
//
//                    buttons[1].setTitleColor(UIColor.systemBlue, for: .normal)
//                    buttons[1].layer.borderColor = UIColor.systemBlue.cgColor
//
//                        select = "아동·청소년"
//
//                        //두번클릭시
//                    }else{
//                        secClick = true
//
//                        buttons[1].setTitleColor(UIColor.black, for: .normal)
//                        buttons[1].layer.borderColor = UIColor.black.cgColor
//                     }
//                    }else if(sender.tag == 2){
//
//
//                //처음클릭시
//                if(thirdClick){
//                    thirdClick = false
//
//                buttons[2].setTitleColor(UIColor.systemBlue, for: .normal)
//                buttons[2].layer.borderColor = UIColor.systemBlue.cgColor
//                    select = "청년"
//
//                //두번클릭시
//                }else{
//                    thirdClick = true
//
//                buttons[2].setTitleColor(UIColor.black, for: .normal)
//                buttons[2].layer.borderColor = UIColor.black.cgColor
//                }
//
//
//
//
//                 }else if(sender.tag == 3){                //처음클릭시
//
//
//                    if(fourthClick){
//                        fourthClick = false
//
//                     buttons[3].setTitleColor(UIColor.systemBlue, for: .normal)
//                     buttons[3].layer.borderColor = UIColor.systemBlue.cgColor
//                        select = "중장년"
//
//                     //두번클릭시
//                     }else{
//                        fourthClick = true
//
//                     buttons[3].setTitleColor(UIColor.black, for: .normal)
//                     buttons[3].layer.borderColor = UIColor.black.cgColor
//                     }
//
//                  }else if(sender.tag == 4){                //처음클릭시
//
//                    if(fifthClick){
//                        fifthClick = false
//
//                            buttons[4].setTitleColor(UIColor.systemBlue, for: .normal)
//                            buttons[4].layer.borderColor = UIColor.systemBlue.cgColor
//                        select = "노인"
//
//                                //두번클릭시
//                            }else{
//                            fifthClick = true
//
//                            buttons[4].setTitleColor(UIColor.black, for: .normal)
//                            buttons[4].layer.borderColor = UIColor.black.cgColor
//                                      }
//
//
//                        }
//
            
    
    }
    
    
    //다음카테고리이동 버튼 클릭이벤트
            @objc private func nexted(_ sender: UIButton) {
                    print("버튼선택")
                    print(select)
                    
            let parameters = ["category1": select]
             guard let uvc = self.storyboard?.instantiateViewController(withIdentifier: "SecondCategory") as? SecondCategoryViewController else{ return }
                
                 Alamofire.request("http://3.34.4.196/backend/php/admin/2layer_request.php", method: .post, parameters: parameters)
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
    
    
    

