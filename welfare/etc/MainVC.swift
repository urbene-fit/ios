//
//  MainVC.swift
//  welfare
//
//  Created by 김동현 on 2020/08/13.
//  Copyright © 2020 com. All rights reserved.
//

import UIKit
import Alamofire
import FirebaseMessaging


class MainVC: UIViewController, MessagingDelegate {
    
    
    
    
    //정책을 저장하는 배열
    //    struct item {
    //        var name: String
    //        var items = Array<String>()
    //
    //    }
    
    //네비게이션 바 변수
    //let navBar = UINavigationBar()
    
    //사용자가 선택한 변수를 저장
    //var choice : Array<String>
    var categorys = Array<String>()
    
    
    //사용자가 선택한 카테고리의 정책들을 저장한 변수
    
    
    //    //스크롤뷰 관련 변수
    let m_Scrollview = UIScrollView()
    //어그로문구를 보여줄 가로스크롤뷰(페이징)
    let s_Scrollview = UIScrollView()
    
    var count : Int = 0
    
    //반복문에서 사용할 k
    var k : Int = 0
    
    
    var page : Bool = true
    
    var screenWidth: Int = 0
    var  screenHeight : Int = 0
    
    //관심사의 버튼들
    
    
    //이미지뷰들을 담을 배열
    var ImgArr = [UIImageView]()
    //버튼들을 담을 배열
    var buttons = [UIButton]()
    
    //파일URL을 담을 배열
    var ImgFile = ["baby","youngman","oldman","pregnancy","disable","Cultural","multicultural","enterprise","Law","Dwelling","Employment","BasicLivelihood","MainImg2"]
    
    //라벨명을 담을 배열
    var LabelName = ["아기·어린이","학생·청년","중장년·노인","육아·임신","장애인","문화·생활","다문화","기업·자영업자","법률","주거","취업·창업",
                     "기초생활수급","기타"]
    
    
    struct Policy: Codable {
        
        
        let baby : [String]?
        let young: [String]?
        let old : [String]?
        let care : [String]? //육아 임신
        let disabled : [String]?
        let culture : [String]? //문화생활
        let multipleCultures : [String]? // 다문화
        let business : [String]?
        let law : [String]?
        let house : [String]? //주거
        let employment : [String]? //취업 창업
        let NBL : [String]? //기초생활보장
        let etc : [String]? //기타
        
        
        
        private enum CodingKeys: String, CodingKey {
            case baby = "아기·어린이"
            case young = "학생·청년"
            case old = "중장년·노인"
            case care = "육아·임신"
            case disabled = "장애인"
            case culture = "문화·생활"
            case multipleCultures = "다문화"
            case business = "기업·자영업자"
            case law = "법률"
            case house = "주거"
            case employment = "취업·창업"
            case NBL = "기초생활수급"
            case etc = "기타"
            
            
            
        }
    }
    
    
    
    //아기/청소년
    lazy var BabyButton: UIButton = {
        // Generate button.
        let button = UIButton(type: .system)
        
        // Tag a button.
        button.tag = 1
        // Set the button installation coordinates and size.
        //button.frame = CGRect(x: posX, y: posY, width: width, height: height)
        // Set the title (normal).
        button.setTitle("아기/어린이", for: .normal)
        // Add an event.
        button.addTarget(self, action: #selector(selected), for: .touchUpInside)
        return button }()
    
    //아기/청소년
    //        lazy var BabyButton: UIButton = {
    //            // Generate button.
    //            let button = UIButton(type: .system)
    //
    //            // Tag a button.
    //            button.tag = 1
    //            // Set the button installation coordinates and size.
    //            //button.frame = CGRect(x: posX, y: posY, width: width, height: height)
    //            // Set the title (normal).
    //            button.setTitle("아기/어린이", for: .normal)
    //            // Add an event.
    //            button.addTarget(self, action: #selector(selected), for: .touchUpInside)
    //            return button }()
    //
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //토큰값 전송
        sendToken()
        
        
        
        ///Messaging.messaging().delegate = self
        //화면 스크롤 크기
        screenWidth = Int(view.bounds.width)
        screenHeight = Int(view.bounds.height)
        
        
        //그라데이션
        let topColor = UIColor(red: 84/255.0, green: 183/255.0, blue: 211/255.0, alpha: 1).cgColor
        let bottomColor = UIColor(red: 119/255.0, green: 202/255.0, blue: 151/255.0, alpha: 1).cgColor
        let gradientColors = [topColor, bottomColor]
        
        let gradientLocations: [NSNumber] = [0.0, 1.0]
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = gradientColors
        gradientLayer.locations = gradientLocations
        //Set startPoint and endPoint property also
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0)
        gradientLayer.frame = CGRect(x:0, y:0, width: screenWidth, height: 400)
        
        let Image = UIImage(named: "privacy")
        
        var privacyBtn = UIButton(type: .custom)
        privacyBtn.frame = CGRect(x: 0, y: 0, width: 16, height: 16)
        privacyBtn.addTarget(self, action:#selector(self.moveInfo), for:.touchUpInside)
        
        privacyBtn.setImage(UIImage(named: "privacy.png"), for: .normal) // Image can be downloaded from here below link
        privacyBtn.widthAnchor.constraint(equalToConstant: 16.0).isActive = true
        privacyBtn.heightAnchor.constraint(equalToConstant: 16.0).isActive = true
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: privacyBtn)
        
        
        // let navItem = UINavigationItem()
        
        //화면 스크롤 크기
        var screenWidth = view.bounds.width
        var screenHeight = view.bounds.height
        
        
        
        //네비게이션 바 설정
        //navBar.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: 40)
        //view.addSubview(navBar)
        
        //검색시 사용하는 네비게이션의 텍스트 필드
        //           let Image = UIImage(named: "back")
        //
        //                var backbutton = UIButton(type: .custom)
        //                backbutton.frame = CGRect(x: 0, y: 0, width: 16, height: 16)
        //                backbutton.setImage(UIImage(named: "BackButton.png"), for: .normal) // Image can be downloaded from here below link
        //                backbutton.widthAnchor.constraint(equalToConstant: 16.0).isActive = true
        //                backbutton.heightAnchor.constraint(equalToConstant: 16.0).isActive = true
        //                backbutton.setTitleColor(backbutton.tintColor, for: .normal)
        
        // You can change the TitleColor
        //backbutton.addTarget(self, action: "backAction", forControlEvents: .TouchUpInside)
        //        backbutton.sizeToFit()
        //navItem.leftBarButtonItem = UIBarButtonItem(customView: backbutton)
        
        
        //개인정보 이동버튼
        
        
        //        let infoBtn = UIButton(type: .system)
        //
        //                infoBtn.frame = CGRect(x: 0, y: 0, width: 16, height: 16)
        //        infoBtn.addTarget(self, action: #selector(self.moveInfo), for: .touchUpInside)
        //
        //                infoBtn.widthAnchor.constraint(equalToConstant: 16.0).isActive = true
        //                infoBtn.heightAnchor.constraint(equalToConstant: 16.0).isActive = true
        //                infoBtn.setTitle("개인정보", for: .normal)
        //                infoBtn.setTitleColor(UIColor.black, for: .normal)
        
        
        //navItem.rightBarButtonItem = UIBarButtonItem(customView: infoBtn)
        //        navItem.rightBarButtonItem = UIBarButtonItem(title: "개인정보", style: .plain, target: self, action: #selector(moveInfo))
        //        navBar.setItems([navItem], animated: true)
        
        
        //        let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(moveInfo))
        //        navItem.rightBarButtonItem = doneItem
        
        //        navItem.rightBarButtonItem = UIBarButtonItem(title: "Right",
        //        style: .plain,
        //        target: self,
        //        action: #selector(moveInfo))
        
        // navBar.setItems([navItem], animated: false)
        //네비게이션 바
        //navBar.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: 40)
        //m_Scrollview.addSubview(navBar)
        
        //메인 타이틀
        //        let nTitle = UILabel(frame: CGRect(x:0, y:0, width: screenWidth, height: 100))
        //
        //        nTitle.numberOfLines = 1 //줄 수
        //
        //        //nTitle.textAlignment = .center  // 정렬
        //
        //        nTitle.textColor = UIColor.gray
        //
        //        nTitle.font = UIFont.systemFont(ofSize: 50) //font 사이즈
        //
        //        nTitle.text = "너의 혜택은"
        //
        //        nTitle.backgroundColor = UIColor.systemIndigo
        //        nTitle.textColor = UIColor.white
        //        nTitle.tintColor = UIColor.white
        //        m_Scrollview.addSubview(nTitle)
        
        
        //              let backView = UIView()
        //        backView.frame = CGRect(x: 0, y: 0, width: nTitle.bounds.width, height: nTitle.bounds.height)
        //        backView.layer.insertSublayer(gradientLayer, at: 0)
        //        nTitle.layer.insertSublayer(backView, at: 0)
        
        //   self.view.addSubview(nTitle)
        
        //        nTitle.backgroundColor = [
        //          UIColor(red:1, green:0, blue:0, alpha:1).cgColor, // Top
        //          UIColor(red:0, green:1, blue:0, alpha:1).cgColor, // Middle
        //          UIColor(red:0, green:0, blue:1, alpha:1).cgColor // Bottom
        //        ]
        
        
        
        //어그로 화면
        //        let subTitle = UILabel(frame: CGRect(x:0, y:0, width: screenWidth, height: 150))
        //
        //               subTitle.numberOfLines = 2 //줄 수
        //
        //               subTitle.textAlignment = .center  // 정렬
        //
        //               subTitle.textColor = UIColor.gray
        //
        //               subTitle.font = UIFont.systemFont(ofSize: 35) //font 사이즈
        //
        //               subTitle.text = "당신이 현재 놓치고 있는 \n기본소득은 총 237개"
        //        subTitle.backgroundColor = UIColor.systemIndigo
        //        subTitle.textColor = UIColor.white
        //        subTitle.tintColor = UIColor.white
        //
        //
        //
        //        let subTitle2 = UILabel(frame: CGRect(x:screenWidth, y:0, width: screenWidth, height: 150))
        //
        //                     subTitle2.numberOfLines = 2 //줄 수
        //
        //                     subTitle2.textAlignment = .center  // 정렬
        //
        //                     subTitle2.textColor = UIColor.gray
        //
        //                     subTitle2.font = UIFont.systemFont(ofSize: 35) //font 사이즈
        //
        //                     subTitle2.text = "당신이 현재 놓치고 있는 \n기업지원 정책은 총 230개"
        //
        //        subTitle2.backgroundColor = UIColor.systemIndigo
        //             subTitle2.textColor = UIColor.white
        //             subTitle2.tintColor = UIColor.white
        //
        //
        //
        //        let subTitle3 = UILabel(frame: CGRect(x:screenWidth * 2, y:0, width: screenWidth, height: 150))
        //
        //        subTitle3.numberOfLines = 2 //줄 수
        //
        //        subTitle3.textAlignment = .center  // 정렬
        //
        //        subTitle3.textColor = UIColor.gray
        //
        //        subTitle3.font = UIFont.systemFont(ofSize: 35) //font 사이즈
        //
        //        subTitle3.text = "당신이 현재 놓치고 있는 \n청년지원 정책은 총 430개"
        //        subTitle3.backgroundColor = UIColor.systemIndigo
        //             subTitle3.textColor = UIColor.white
        //             subTitle3.tintColor = UIColor.white
        //
        //        let subTitle4 = UILabel(frame: CGRect(x:screenWidth * 3, y:0, width: screenWidth, height: 150))
        //
        //            subTitle4.numberOfLines = 2 //줄 수
        //
        //            subTitle4.textAlignment = .center  // 정렬
        //
        //            subTitle4.textColor = UIColor.gray
        //
        //            subTitle4.font = UIFont.systemFont(ofSize: 35) //font 사이즈
        //
        //            subTitle4.text = "당신이 현재 놓치고 있는 \n기본소득은 총 237개"
        //            subTitle4.backgroundColor = UIColor.systemIndigo
        //                 subTitle4.textColor = UIColor.white
        //                 subTitle4.tintColor = UIColor.white
        //
        //
        //
        //        s_Scrollview.addSubview(subTitle)
        //        s_Scrollview.addSubview(subTitle2)
        //        s_Scrollview.addSubview(subTitle3)
        //        s_Scrollview.addSubview(subTitle4)
        //
        //
        //
        //
        //        s_Scrollview.frame = CGRect(x: 0, y: 0, width: screenWidth, height: 150)
        //        s_Scrollview.contentSize = CGSize(width:screenWidth * 4, height: 150)
        //
        //        s_Scrollview.isPagingEnabled = true
        //
        //        m_Scrollview.addSubview(s_Scrollview)
        
        
        //3초마다 배너변경
        //Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(self.getDataReload), userInfo: nil, repeats: true)
        
        
        
        //        while true {
        //
        //            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3), execute: {
        //                    // Put your code which should be executed with a delay here
        //                print("시간스레드")
        //                    if(self.count < 3){
        //                    self.count += 1
        //                        self.s_Scrollview.setContentOffset(CGPoint(x: Int(screenWidth) * self.count,y: 0), animated: true)
        //                    }else{
        //                        self.count = 0
        //                        self.s_Scrollview.setContentOffset(CGPoint(x: 0,y: 0), animated: true)
        //
        //                    }
        //
        //
        //
        //                })
        //        }
        
        
        
        //관심사 라벨
        let interestLabel = UILabel(frame: CGRect(x:10, y:180, width: screenWidth, height: 50))
        
        interestLabel.numberOfLines = 1 //줄 수
        
        interestLabel.textAlignment = .center  // 정렬
        
        interestLabel.textColor = UIColor.black
        
        interestLabel.font = UIFont.systemFont(ofSize: 25) //font 사이즈
        
        interestLabel.text = "관심있는 해택을 선택해주세요"
        
        m_Scrollview.addSubview(interestLabel)
        
        //        //관삼사  아기어린이 이미지뷰
        //        let BabyImgView = UIImageView(image:UIImage(named:"baby"))
        //                        BabyImgView.frame = CGRect(x: 10, y: 250, width: screenWidth/2-20, height: screenWidth/2-20)
        //
        //        //이미지뷰 원형으로 만들어주기
        //        BabyImgView.layer.cornerRadius = BabyImgView.frame.height/2
        //        BabyImgView.layer.borderWidth = 1
        //                   BabyImgView.layer.borderColor = UIColor.clear.cgColor
        //                   // 뷰의 경계에 맞춰준다
        //                   BabyImgView.clipsToBounds = true
        //
        //        //리스너
        ////        let BabyImgRecognizer = UITapGestureRecognizer(target: self, action: #selector(BabyImgTapped))
        ////        BabyImgView.addGestureRecognizer(BabyImgRecognizer)
        ////        BabyImgView.tag = 1
        //
        //
        //
        //
        //        m_Scrollview.addSubview(BabyImgView)
        //
        //        //아기라벨
        //        let babyLabel = UILabel(frame: CGRect(x:0, y:440, width: screenWidth/2, height: 20))
        //
        //             babyLabel.numberOfLines = 1 //줄 수
        //
        //            babyLabel.textAlignment = .center  // 정렬
        //
        //             babyLabel.textColor = UIColor.black
        //
        //             babyLabel.font = UIFont.systemFont(ofSize: 20) //font 사이즈
        //
        //             babyLabel.text = "아기/어린이"
        //
        //             m_Scrollview.addSubview(babyLabel)
        
        
        
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
                //이미지뷰 만들어준다.
                let ImgView = UIImageView(image:UIImage(named:ImgFile[i]))
                ImgView.frame = CGRect(x: screenWidth/2, y: CGFloat((i - 1) * 125 + 250), width: screenWidth/2-20, height: screenWidth/2-20)
                
                //이미지뷰 원형으로 만들어주기
                ImgView.layer.cornerRadius = ImgView.frame.height/2
                ImgView.layer.borderWidth = 1
                ImgView.layer.borderColor = UIColor.clear.cgColor
                // 뷰의 경계에 맞춰준다
                ImgView.clipsToBounds = true
                
                
                //리스너 등록
                //            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(selected))
                //                ImgView.addGestureRecognizer(tapGestureRecognizer)
                
                
                
                m_Scrollview.addSubview(ImgView)
                
                //라벨을 만들어준다.
                //                   let label = UILabel(frame: CGRect(x:screenWidth/2 - 10, y:125 * (i - 1) + 440, width: screenWidth/2, height: 20))
                //
                //                        label.numberOfLines = 1 //줄 수
                //
                //                       label.textAlignment = .center  // 정렬
                //
                //                        label.textColor = UIColor.black
                //
                //                        label.font = UIFont.systemFont(ofSize: 20) //font 사이즈
                //
                //                        label.text = LabelName[i]
                //
                //                        m_Scrollview.addSubview(label)
                
                let button = UIButton(type: .system)
                button.tag = i
                button.addTarget(self, action: #selector(self.selected), for: .touchUpInside)
                button.frame = CGRect(x:screenWidth/2 + 10, y:CGFloat(125 * (i - 1) + 440), width: screenWidth/2 - 40, height: 20)
                
                button.setTitle(LabelName[i], for: .normal)
                button.setTitleColor(UIColor.black, for: .normal)
                button.backgroundColor = .clear
                button.layer.cornerRadius = 5
                button.layer.borderWidth = 1
                button.layer.borderColor = UIColor.black.cgColor
                m_Scrollview.addSubview(button)
                buttons.append(button)
                
                
                //0이거나 홀수인경우
                //앞에 배치
                //}else if(i == 0 && i % 2 == 1){
            }else{
                // print("홀수")
                
                //이미지뷰 만들어준다.
                let ImgView = UIImageView(image:UIImage(named:ImgFile[i]))
                ImgView.frame = CGRect(x: 10, y: CGFloat(i * 125 + 250), width: screenWidth/2-20, height: screenWidth/2-20)
                
                //이미지뷰 원형으로 만들어주기
                ImgView.layer.cornerRadius = ImgView.frame.height/2
                ImgView.layer.borderWidth = 1
                ImgView.layer.borderColor = UIColor.clear.cgColor
                // 뷰의 경계에 맞춰준다
                ImgView.clipsToBounds = true
                m_Scrollview.addSubview(ImgView)
                
                //라벨을 만들어준다.
                //                                  let label = UILabel(frame: CGRect(x:0, y:125 * i + 440, width: screenWidth/2, height: 20))
                //
                //                                       label.numberOfLines = 1 //줄 수
                //
                //                                      label.textAlignment = .center  // 정렬
                //
                //                                       label.textColor = UIColor.black
                //
                //                                       label.font = UIFont.systemFont(ofSize: 20) //font 사이즈
                //
                //                                       label.text = LabelName[i]
                //
                //                                       m_Scrollview.addSubview(label)
                let button = UIButton(type: .system)
                button.tag = i
                button.addTarget(self, action: #selector(self.selected), for: .touchUpInside)
                button.frame = CGRect(x:20, y:125 * i + 440, width: Int(screenWidth)/2 - 40, height: 20)
                
                button.setTitle(LabelName[i], for: .normal)
                button.setTitleColor(UIColor.black, for: .normal)
                button.backgroundColor = .clear
                button.layer.cornerRadius = 5
                button.layer.borderWidth = 1
                button.layer.borderColor = UIColor.black.cgColor
                buttons.append(button)
                m_Scrollview.addSubview(button)
                
                
                
                
            }
            
            //메인하단 버튼
            let MainBtn = UIButton(type: .system)
            MainBtn.tag = i
            MainBtn.addTarget(self, action: #selector(self.move), for: .touchUpInside)
            MainBtn.frame = CGRect(x:20, y:2000, width: screenWidth - 40, height: 100)
            
            MainBtn.setTitle("혜택 보러가기", for: .normal)
            MainBtn.setTitleColor(UIColor.white, for: .normal)
            MainBtn.backgroundColor = UIColor.systemIndigo
            MainBtn.layer.cornerRadius = 5
            MainBtn.layer.borderWidth = 1
            MainBtn.layer.borderColor = UIColor.systemIndigo.cgColor
            m_Scrollview.addSubview(MainBtn)
            
            
            
            
            
        }
        
        
        
        //        //관삼사 청소년/청년
        //        let YoungImgView = UIImageView(image:UIImage(named:"youngman"))
        //                        YoungImgView.frame = CGRect(x: screenWidth/2, y: 250, width: screenWidth/2-20, height: screenWidth/2-20)
        //
        //        //이미지뷰 원형으로 만들어주기
        //        YoungImgView.layer.cornerRadius = YoungImgView.frame.height/2
        //        YoungImgView.layer.borderWidth = 1
        //                   YoungImgView.layer.borderColor = UIColor.clear.cgColor
        //                   // 뷰의 경계에 맞춰준다
        //                   YoungImgView.clipsToBounds = true
        //        m_Scrollview.addSubview(YoungImgView)
        //
        //        //청소년 라벨
        //               let YoungLabel = UILabel(frame: CGRect(x:screenWidth/2, y:440, width: screenWidth/2, height: 20))
        //
        //                    YoungLabel.numberOfLines = 1 //줄 수
        //
        //                   YoungLabel.textAlignment = .center  // 정렬
        //
        //                    YoungLabel.textColor = UIColor.black
        //
        //                    YoungLabel.font = UIFont.systemFont(ofSize: 20) //font 사이즈
        //
        //                    YoungLabel.text = "학생/청소년"
        //
        //                    m_Scrollview.addSubview(YoungLabel)
        //
        //
        //
        //        //중장년.노인
        //        let OldImgView = UIImageView(image:UIImage(named:"oldman"))
        //        OldImgView.frame = CGRect(x: 10, y: 500, width: screenWidth/2-20, height: screenWidth/2-20)
        //
        //        //이미지뷰 원형으로 만들어주기
        //        OldImgView.layer.cornerRadius = OldImgView.frame.height/2
        //        OldImgView.layer.borderWidth = 1
        //                   OldImgView.layer.borderColor = UIColor.clear.cgColor
        //                   // 뷰의 경계에 맞춰준다
        //                   OldImgView.clipsToBounds = true
        //        m_Scrollview.addSubview(OldImgView)
        //
        //        //중장년 라벨
        //                     let OldLabel = UILabel(frame: CGRect(x:screenWidth/2, y:690, width: screenWidth/2, height: 20))
        //
        //                          OldLabel.numberOfLines = 1 //줄 수
        //
        //                         OldLabel.textAlignment = .center  // 정렬
        //
        //                          OldLabel.textColor = UIColor.black
        //
        //                          OldLabel.font = UIFont.systemFont(ofSize: 20) //font 사이즈
        //
        //                          OldLabel.text = "중장년/노인"
        //
        //                          m_Scrollview.addSubview(OldLabel)
        //
        //
        //
        //        //임신,육아
        //        let PregnancyView = UIImageView(image:UIImage(named:"pregnancy"))
        //                        PregnancyView.frame = CGRect(x: screenWidth/2, y: 500, width: screenWidth/2-20, height: screenWidth/2-20)
        //
        //        //이미지뷰 원형으로 만들어주기
        //        PregnancyView.layer.cornerRadius = PregnancyView.frame.height/2
        //        PregnancyView.layer.borderWidth = 1
        //                   PregnancyView.layer.borderColor = UIColor.clear.cgColor
        //                   // 뷰의 경계에 맞춰준다
        //                   PregnancyView.clipsToBounds = true
        //
        //        m_Scrollview.addSubview(PregnancyView)
        //
        //
        //        //장애인
        //        let DisableView = UIImageView(image:UIImage(named:"disable"))
        //                        DisableView.frame = CGRect(x: 10, y: 750, width: screenWidth/2-20, height: screenWidth/2-20)
        //
        //        //이미지뷰 원형으로 만들어주기
        //        DisableView.layer.cornerRadius = DisableView.frame.height/2
        //        DisableView.layer.borderWidth = 1
        //                   DisableView.layer.borderColor = UIColor.clear.cgColor
        //                   // 뷰의 경계에 맞춰준다
        //                   DisableView.clipsToBounds = true
        //
        //        m_Scrollview.addSubview(DisableView)
        //
        //        //문화생활
        //        let CulturalView = UIImageView(image:UIImage(named:"Cultural"))
        //                        CulturalView.frame = CGRect(x: screenWidth/2, y: 750, width: screenWidth/2-20, height: screenWidth/2-20)
        //        //이미지뷰 원형으로 만들어주기
        //        CulturalView.layer.cornerRadius = CulturalView.frame.height/2
        //        CulturalView.layer.borderWidth = 1
        //                   CulturalView.layer.borderColor = UIColor.clear.cgColor
        //                   // 뷰의 경계에 맞춰준다
        //                   CulturalView.clipsToBounds = true
        //
        //        m_Scrollview.addSubview(CulturalView)
        //
        //
        //        //다문화
        //        let MulticulturalView = UIImageView(image:UIImage(named:"multicultural"))
        //                        MulticulturalView.frame = CGRect(x: 10, y: 1000, width: screenWidth/2-20, height: screenWidth/2-20)
        //
        //        //이미지뷰 원형으로 만들어주기
        //        MulticulturalView.layer.cornerRadius = MulticulturalView.frame.height/2
        //        MulticulturalView.layer.borderWidth = 1
        //                   MulticulturalView.layer.borderColor = UIColor.clear.cgColor
        //                   // 뷰의 경계에 맞춰준다
        //        MulticulturalView.clipsToBounds = true
        //        m_Scrollview.addSubview(MulticulturalView)
        //
        //
        //
        //        //자영업,기업
        //        let EnterpriseView = UIImageView(image:UIImage(named:"enterprise"))
        //                        EnterpriseView.frame = CGRect(x: screenWidth/2, y: 1000, width: screenWidth/2-20, height: screenWidth/2-20)
        //
        //        //이미지뷰 원형으로 만들어주기
        //        EnterpriseView.layer.cornerRadius = EnterpriseView.frame.height/2
        //        EnterpriseView.layer.borderWidth = 1
        //                   EnterpriseView.layer.borderColor = UIColor.clear.cgColor
        //                   // 뷰의 경계에 맞춰준다
        //        EnterpriseView.clipsToBounds = true
        //        m_Scrollview.addSubview(EnterpriseView)
        //
        //
        //        //법률
        //             let LawView = UIImageView(image:UIImage(named:"Law"))
        //                             LawView.frame = CGRect(x: 10, y: 1250, width: screenWidth/2-20, height: screenWidth/2-20)
        //
        //             //이미지뷰 원형으로 만들어주기
        //             LawView.layer.cornerRadius = LawView.frame.height/2
        //             LawView.layer.borderWidth = 1
        //                        LawView.layer.borderColor = UIColor.clear.cgColor
        //                        // 뷰의 경계에 맞춰준다
        //             LawView.clipsToBounds = true
        //        m_Scrollview.addSubview(LawView)
        //
        //
        //
        //
        //        //주거
        //             let DwellingView = UIImageView(image:UIImage(named:"Dwelling"))
        //                             DwellingView.frame = CGRect(x: screenWidth/2, y: 1250, width: screenWidth/2-20, height: screenWidth/2-20)
        //
        //             //이미지뷰 원형으로 만들어주기
        //             DwellingView.layer.cornerRadius = DwellingView.frame.height/2
        //             DwellingView.layer.borderWidth = 1
        //                        DwellingView.layer.borderColor = UIColor.clear.cgColor
        //                        // 뷰의 경계에 맞춰준다
        //             DwellingView.clipsToBounds = true
        //        m_Scrollview.addSubview(DwellingView)
        //
        //
        //
        //        //취업,창업
        //        let EmploymentView = UIImageView(image:UIImage(named:"Employment"))
        //                        EmploymentView.frame = CGRect(x: 10, y: 1500, width: screenWidth/2-20, height: screenWidth/2-20)
        //
        //        //이미지뷰 원형으로 만들어주기
        //        EmploymentView.layer.cornerRadius = EmploymentView.frame.height/2
        //        EmploymentView.layer.borderWidth = 1
        //                   EmploymentView.layer.borderColor = UIColor.clear.cgColor
        //                   // 뷰의 경계에 맞춰준다
        //        EmploymentView.clipsToBounds = true
        //        m_Scrollview.addSubview(EmploymentView)
        //
        //
        //
        //        //기초생활수급자
        //        let BasicLivelihoodView = UIImageView(image:UIImage(named:"BasicLivelihood"))
        //                        BasicLivelihoodView.frame = CGRect(x: screenWidth/2, y: 1500, width: screenWidth/2-20, height: screenWidth/2-20)
        //
        //        //이미지뷰 원형으로 만들어주기
        //        BasicLivelihoodView.layer.cornerRadius = BasicLivelihoodView.frame.height/2
        //        BasicLivelihoodView.layer.borderWidth = 1
        //                   BasicLivelihoodView.layer.borderColor = UIColor.clear.cgColor
        //                   // 뷰의 경계에 맞춰준다
        //        BasicLivelihoodView.clipsToBounds = true
        //        m_Scrollview.addSubview(BasicLivelihoodView)
        //
        //
        //        //기타등등
        //           let EtcView = UIImageView(image:UIImage(named:"MainImg2"))
        //                           EtcView.frame = CGRect(x: 10, y: 1750, width: screenWidth/2-20, height: screenWidth/2-20)
        //
        //           //이미지뷰 원형으로 만들어주기
        //           EtcView.layer.cornerRadius = EtcView.frame.height/2
        //           EtcView.layer.borderWidth = 1
        //                      EtcView.layer.borderColor = UIColor.clear.cgColor
        //                      // 뷰의 경계에 맞춰준다
        //           EtcView.clipsToBounds = true
        //        m_Scrollview.addSubview(EtcView)
        
        
        //메인스크롤 뷰 추가
        m_Scrollview.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
        m_Scrollview.contentSize = CGSize(width:screenWidth, height: 2100)
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
    
    @objc func getDataReload(){
        
        if(self.count == 3){
            self.s_Scrollview.setContentOffset(CGPoint(x: Int(screenWidth) * self.count,y: 0), animated: true)
            self.count = 0
            self.s_Scrollview.setContentOffset(CGPoint(x: 0,y: 0), animated: false)
        }else{
            
            self.count += 1
            self.s_Scrollview.setContentOffset(CGPoint(x: Int(screenWidth) * self.count,y: 0), animated: true)
            
        }
        
        
        
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
        
        
        
        //        if(sender.tag == 0){
        //
        //        }else if(sender.tag == 2){
        //
        //        }else if(sender.tag == 3){
        //
        //        }else if(sender.tag == 4){
        //
        //         }else if(sender.tag == 5){
        //
        //         }else if(sender.tag == 6){
        //
        //        }else if(sender.tag == 7){
        //
        //         }else if(sender.tag == 8){
        //
        //         }else if(sender.tag == 9){
        //
        //        }else if(sender.tag == 10){
        //
        //         }else if(sender.tag == 11){
        //
        //         }else if(sender.tag == 12){
        //
        //           }else if(sender.tag == 13){
        //    }
        
    }
    
    
    //개인정보 페이지 이동
    @objc func moveInfo() {
        print("개인정보 페이지로 이동")
        
        
        guard let RVC = self.storyboard?.instantiateViewController(withIdentifier: "privacyViewController") as? privacyViewController         else{
            
            return
            
        }
        RVC.modalPresentationStyle = .fullScreen
        // B 컨트롤러 뷰로 넘어간다.
        // self.navigationController?.pushViewController(RVC, animated: true)
        //self.navBar.pushViewController(RVC, animated: true)
        self.present(RVC, animated: true, completion: nil)
        
        
    }
    
    
    //최종확인 버튼
    @objc func move(_ sender: UIButton) {
        // 원하는 대로 코드 구성
        print("버튼 클릭")
        // print(categorys)
        
//        //네비게이션 통해서  이동
//        //      let webPage = self.storyboard?.instantiateViewController(withIdentifier: "resultViewController")
//        //
//        //        webPage?.modalPresentationStyle = .fullScreen
//        //
//        //         // B 컨트롤러 뷰로 넘어간다.
//        //        self.present(webPage!, animated: true, completion: nil)
//        //
//        //
//        
//        //선택한 카테고리를 전송할 데이터로 파싱하여 옮긴다.
//        let string = categorys.joined(separator: " ")
//        
//        let parameters = ["reqBody": string]
//        //                //디바이스의 크기
//        screenWidth = Int(view.bounds.width)
//        screenHeight = Int(view.bounds.height)
//        
//        Alamofire.request("http://3.34.4.196/backend/ios/ios_category_result.php", method: .post, parameters: parameters)
//            .validate()
//            .responseJSON { response in
//                
//                switch response.result {
//                case .success(let value):
//                    
//                    do {
//                        let data = try JSONSerialization.data(withJSONObject: value, options: .prettyPrinted)
//                        let policies = try JSONDecoder().decode(Policy.self, from: data)
//                        
//                        
//                        
//                        
//                        
//                        
//                        let webPage = self.storyboard?.instantiateViewController(withIdentifier: "ResultViewController")
//                        
//                        
//                        guard let RVC = self.storyboard?.instantiateViewController(withIdentifier: "ResultViewController") as? ResultViewController         else{
//                            
//                            return
//                            
//                        }
//                        
//                        //선택한 카테고리를 결과페이지로 전달
//                        RVC.category = string
//                        
//                        //카테고리 선택 후 받아온 카테고리의 혜택들을  다음 컨트롤러로 넘긴다.
//                        var count = 0
//                        for category in self.categorys {
//                            print(category)
//                            
//                            
//                            var person : ResultViewController.item =  ResultViewController.item(name: "아기·어린이", sd: policies.baby!)
//                            RVC.items.append(person)
//                            
//                            if(category == "아기·어린이"){
//                                
//                                var person : ResultViewController.item =  ResultViewController.item(name: "아기·어린이", sd: policies.baby!)
//                                RVC.items.append(person)
//                                //                    if(count == 0){
//                                //                        RVC.firstItems = policies.baby!
//                                //                    }else if(count == 1){
//                                //                        RVC.secItems = policies.baby!
//                                //
//                                //                    }else if(count == 2){
//                                //                        RVC.thirdItems = policies.baby!
//                                //
//                                //                    }else if(count == 3){
//                                //                        RVC.fourthItems = policies.baby!
//                                //
//                                //                    }else if(count == 4){
//                                //                        RVC.fifItems = policies.baby!
//                                //
//                                //                    }else if(count == 5){
//                                //                        RVC.sixItems = policies.baby!
//                                //
//                                //                    }
//                                
//                            }else if(category ==  "학생·청년"){
//                                if(count == 0){
//                                    RVC.firstItems = policies.young!
//                                }else if(count == 1){
//                                    RVC.secItems = policies.young!
//                                    
//                                }else if(count == 2){
//                                    RVC.thirdItems = policies.young!
//                                    
//                                }else if(count == 3){
//                                    RVC.fourthItems = policies.young!
//                                    
//                                }else if(count == 4){
//                                    RVC.fifItems = policies.young!
//                                    
//                                }else if(count == 5){
//                                    RVC.sixItems = policies.young!
//                                    
//                                }
//                                
//                                
//                            }else if(category == "중장년·노인"){
//                                if(count == 0){
//                                    RVC.firstItems = policies.old!
//                                }else if(count == 1){
//                                    RVC.secItems = policies.old!
//                                    
//                                }else if(count == 2){
//                                    RVC.thirdItems = policies.old!
//                                    
//                                }else if(count == 3){
//                                    RVC.fourthItems = policies.old!
//                                    
//                                }else if(count == 4){
//                                    RVC.fifItems = policies.old!
//                                    
//                                }else if(count == 5){
//                                    RVC.sixItems = policies.old!
//                                    
//                                }
//                                
//                            }else if(category == "육아·임신"){
//                                if(count == 0){
//                                    RVC.firstItems = policies.care!
//                                }else if(count == 1){
//                                    RVC.secItems = policies.care!
//                                    
//                                }else if(count == 2){
//                                    RVC.thirdItems = policies.care!
//                                    
//                                }else if(count == 3){
//                                    RVC.fourthItems = policies.care!
//                                    
//                                }else if(count == 4){
//                                    RVC.fifItems = policies.care!
//                                    
//                                }else if(count == 5){
//                                    RVC.sixItems = policies.care!
//                                    
//                                }
//                            }else if(category == "장애인"){
//                                if(count == 0){
//                                    RVC.firstItems = policies.disabled!
//                                }else if(count == 1){
//                                    RVC.secItems = policies.disabled!
//                                    
//                                }else if(count == 2){
//                                    RVC.thirdItems = policies.disabled!
//                                    
//                                }else if(count == 3){
//                                    RVC.fourthItems = policies.disabled!
//                                    
//                                }else if(count == 4){
//                                    RVC.fifItems = policies.disabled!
//                                    
//                                }else if(count == 5){
//                                    RVC.sixItems = policies.disabled!
//                                    
//                                }
//                            }else if(category == "문화·생활"){
//                                if(count == 0){
//                                    RVC.firstItems = policies.culture!
//                                }else if(count == 1){
//                                    RVC.secItems = policies.culture!
//                                    
//                                }else if(count == 2){
//                                    RVC.thirdItems = policies.culture!
//                                    
//                                }else if(count == 3){
//                                    RVC.fourthItems = policies.culture!
//                                    
//                                }else if(count == 4){
//                                    RVC.fifItems = policies.culture!
//                                    
//                                }else if(count == 5){
//                                    RVC.sixItems = policies.culture!
//                                    
//                                }
//                            }else if(category == "다문화"){
//                                if(count == 0){
//                                    RVC.firstItems = policies.multipleCultures!
//                                }else if(count == 1){
//                                    RVC.secItems = policies.multipleCultures!
//                                    
//                                }else if(count == 2){
//                                    RVC.thirdItems = policies.multipleCultures!
//                                    
//                                }else if(count == 3){
//                                    RVC.fourthItems = policies.multipleCultures!
//                                    
//                                }else if(count == 4){
//                                    RVC.fifItems = policies.multipleCultures!
//                                    
//                                }else if(count == 5){
//                                    RVC.sixItems = policies.multipleCultures!
//                                    
//                                }
//                            }else if(category == "기업·자영업자"){
//                                if(count == 0){
//                                    RVC.firstItems = policies.business!
//                                }else if(count == 1){
//                                    RVC.secItems = policies.business!
//                                    
//                                }else if(count == 2){
//                                    RVC.thirdItems = policies.business!
//                                    
//                                }else if(count == 3){
//                                    RVC.fourthItems = policies.business!
//                                    
//                                }else if(count == 4){
//                                    RVC.fifItems = policies.business!
//                                    
//                                }else if(count == 5){
//                                    RVC.sixItems = policies.business!
//                                    
//                                }
//                            }else if(category == "법률"){
//                                if(count == 0){
//                                    RVC.firstItems = policies.law!
//                                }else if(count == 1){
//                                    RVC.secItems = policies.law!
//                                    
//                                }else if(count == 2){
//                                    RVC.thirdItems = policies.law!
//                                    
//                                }else if(count == 3){
//                                    RVC.fourthItems = policies.law!
//                                    
//                                }else if(count == 4){
//                                    RVC.fifItems = policies.law!
//                                    
//                                }else if(count == 5){
//                                    RVC.sixItems = policies.law!
//                                    
//                                }
//                            }else if(category == "주거"){
//                                if(count == 0){
//                                    RVC.firstItems = policies.house!
//                                }else if(count == 1){
//                                    RVC.secItems = policies.house!
//                                    
//                                }else if(count == 2){
//                                    RVC.thirdItems = policies.house!
//                                    
//                                }else if(count == 3){
//                                    RVC.fourthItems = policies.house!
//                                    
//                                }else if(count == 4){
//                                    RVC.fifItems = policies.house!
//                                    
//                                    
//                                }else if(count == 5){
//                                    RVC.sixItems = policies.house!
//                                    
//                                }
//                            }else if(category == "취업·창업"){
//                                if(count == 0){
//                                    RVC.firstItems = policies.employment!
//                                }else if(count == 1){
//                                    RVC.secItems = policies.employment!
//                                    
//                                }else if(count == 2){
//                                    RVC.thirdItems = policies.employment!
//                                    
//                                }else if(count == 3){
//                                    RVC.fourthItems = policies.employment!
//                                    
//                                }else if(count == 4){
//                                    RVC.fifItems = policies.employment!
//                                    
//                                }else if(count == 5){
//                                    RVC.sixItems = policies.employment!
//                                    
//                                }
//                            }else if(category == "기초생활수급"){
//                                if(count == 0){
//                                    RVC.firstItems = policies.NBL!
//                                }else if(count == 1){
//                                    RVC.secItems = policies.NBL!
//                                    
//                                }else if(count == 2){
//                                    RVC.thirdItems = policies.NBL!
//                                    
//                                }else if(count == 3){
//                                    RVC.fourthItems = policies.NBL!
//                                    
//                                }else if(count == 4){
//                                    RVC.fifItems = policies.NBL!
//                                    
//                                }else if(count == 5){
//                                    RVC.sixItems = policies.NBL!
//                                    
//                                }
//                            }else if(category == "기타"){
//                                if(count == 0){
//                                    RVC.firstItems = policies.etc!
//                                }else if(count == 1){
//                                    RVC.secItems = policies.etc!
//                                    
//                                }else if(count == 2){
//                                    RVC.thirdItems = policies.etc!
//                                    
//                                }else if(count == 3){
//                                    RVC.fourthItems = policies.etc!
//                                    
//                                }else if(count == 4){
//                                    RVC.fifItems = policies.etc!
//                                    
//                                }else if(count == 5){
//                                    RVC.sixItems = policies.etc!
//                                    
//                                }
//                            }
//                            count += 1
//                        }
//                        //            RVC.firstItems = userlists.id
//                        //            RVC.secItems = userlists.name
//                        
//                        
//                        
//                        
//                        RVC.modalPresentationStyle = .fullScreen
//                        
//                        RVC.sections = self.categorys
//                        // B 컨트롤러 뷰로 넘어간다.
//                        //self.present(RVC, animated: true, completion: nil)
//                        
//                        self.navigationController?.pushViewController(RVC, animated: true)
//                        
//                        
//                        
//                        
//                        
//                    } catch let error as NSError {
//                        debugPrint("Error: \(error.description)")
//                    }
//                    
//                    
//                    
//                    
//                    
//                case .failure(let error):
//                    print(error)
//                }
//                
//                
//                
//        }
//        //
//        print(parameters)
    }
    
    
    func sendToken() {
        
        var userEmail = UserDefaults.standard.string(forKey: "email")
        var fcmToken = UserDefaults.standard.string(forKey: "fcmToken")
                let PARAM:Parameters = [
                    "userEmail":userEmail!,
                    "fcm_token": fcmToken!
                ]
        
        
                Alamofire.request("http://3.34.4.196/backend/ios/ios_fcm_token_save.php", method: .post, parameters: PARAM)
                              .validate()
                              .responseJSON { response in
        
                                  //메인화면으로 이동한다
        
                                  switch response.result {
                                  case .success(let value): //
                                  print("성공")
        
        
                                 case .failure(let error):
                                     print(error)
                                 }
        
                         }//resoponse 종료괄호
        
                
        
        
        
    }
}




