//
//  UiTestController.swift
//  welfare
//
//  Created by 김동현 on 2020/10/14.
//  Copyright © 2020 com. All rights reserved.
//


//메인화면 구성도(스크롤뷰)
//1.너의 혜택은(이미지뷰). 2.더 나은 삶을 위한(이미지뷰).  3.혜택 조회하러가기(이미지뷰) 4.조회하러가기 하단이동버튼(버튼)
//5.메인 이미지(이미지뷰) 6. 관심있는 혜택은(라벨뷰) 7.버튼들(각 카테고리들) 8. 조회하러가기(버튼) 9.하단설명뷰(텍스트 및 로고) 0.카테고리뷰

import UIKit
import Alamofire

class UiTestController: UIViewController {
    
    
    
    //푸쉬알람으로 앱이 켜진지 체크
    var pushAlram : Bool = false
    
    
    //    //메인을 구성하는 이미지 및 라벨 뷰
    let appLogo = UIImageView()
    let appDescription = UIImageView()
    let inquiryImg = UIImageView()
    let bottomBtn = UIButton()
    let MainImgView = UIImageView()
    let benefitLabel = UILabel()
    let categoryView = UIView()
    
    
    
    
    //카테고리 선택버튼들을 담을 배열
    var buttons = [UIButton]()
    //카테고리 이미지뷰드를 담을 배열
    var imgViews = [UIImageView]()
    
    //카테고리 라벨을 담을 배열
    var labels = [UILabel]()
    
    //최하단 조회하러가기 버튼
    let inquiryBtn = UIButton()
    
    //하단 앱 문의 및 설명뷰
    let footer = UIView()
    
    
    //카테고리 버튼들을 담을 UiView
    // let categoryView = UIView()
    
    // 메인 세로 스크롤
    let m_Scrollview = UIScrollView()
    
    
    //라벨명을 담을 배열
    var LabelName = ["취업·창업","학생·청년","주거","육아·임신","아기·어린이","문화·생활","기업·자영업자",
                     "저소득층","중장년·노인","더보기","장애인","다문화","법률","기타"]
    
    
    
    
    //더보기 버튼시 활성화 되는 추가라벨
    //라벨명을 담을 배열
    //var addLabelName = ["장애인","다문화","법률","기타"]
    
    //파일URL을 담을 배열
    
    
    //카테고리 선택결과를 파싱할 구조체
    
    struct item {
        var name: String
        var sd = Array<String>()
        
    }
    
    var items: [item] = []
    
    
    var ImgFile = ["Employment","youngman","Dwelling","pregnancy","baby","Cultural","enterprise","BasicLivelihood","oldman","add","Employment","Employment","Employment","Employment"]
    
    
    //사용자가 선택한 카테고리를 저장
    var categorys = Array<String>()
    
    
    //    override func viewWillDisappear(_ animated: Bool){
    //        super.viewWillDisappear(<#Bool#>)
    //
    //        print("viewWillDisappear 옴")
    //
    //    }
    //
    //    override func viewDidDisappear(_ animated: Bool){
    //        super.viewDidDisappear(<#Bool#>)
    //
    //        print("viewDidDisappear 옴")
    //    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("ViewController의 view가 Load됨")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("ViewController의 view가 화면에 나타남")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("ViewController의 view가 사라지기 전")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print("ViewController의 view가 사라짐")
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        print("ViewController의 SubView를 레이아웃 하려함")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        print("ViewController의 SubView를 레이아웃 함")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("viewDidLoad 함")
        self.view.backgroundColor = UIColor.white
        
        //푸쉬알람으로 온 경우
        if(pushAlram){
            print("푸쉬로 옴")
            guard let RVC = self.storyboard?.instantiateViewController(withIdentifier: "DuViewController") as? DuViewController         else{
                
                return
                
            }
            
            RVC.modalPresentationStyle = .fullScreen
            
            self.present(RVC, animated: true, completion: nil)
            
            
        }
        
        //화면 스크롤 크기
        var screenWidth = Int(view.bounds.width)
        var screenHeight = Int(view.bounds.height)
        
        if(screenWidth == 375){
            
            
            print("넓이:\(screenWidth)")
            print("길이 태그:\(screenHeight)")
            
            
            // Do any additional setup after loading the view.
            
            let LogoImg = UIImage(named: "appLogo")
            appLogo.image = LogoImg
            appLogo.frame = CGRect(x: 22.1, y: 26.7, width: 106, height: 14.3)
            //self.view.addSubview(appLogo)
            m_Scrollview.addSubview(appLogo)
            
            
            let descriptionImg = UIImage(named: "descriptionImg")
            appDescription.image = descriptionImg
            appDescription.frame = CGRect(x: 58.3, y: 113.7, width: 258.3, height: 75)
            // self.view.addSubview(appDescription)
            m_Scrollview.addSubview(appDescription)
            
            let inquiryLabel = UILabel()
            inquiryLabel.frame = CGRect(x: 58, y: 214, width: 107.3, height: 15.7)
            inquiryLabel.textAlignment = .right
            inquiryLabel.textColor = UIColor(displayP3Red: 93/255.0, green: 33/255.0, blue: 210/255.0, alpha: 1)
            //폰트지정 추가
            
            inquiryLabel.text = "혜택 조회하러 가기"
            inquiryLabel.font = UIFont(name: "NanumGothicBold", size: 13)
            // inquiryLabel.font = UIFont(name: "NanumGothicBold", size: 13.7)
            // self.view.addSubview(inquiryLabel)
            m_Scrollview.addSubview(inquiryLabel)
            
            
            
            bottomBtn.setImage(UIImage(named: "bottomBtnImg"), for: .normal)
            bottomBtn.frame = CGRect(x: 175, y: 207, width: 17, height: 23.7)
            //self.view.addSubview(bottomBtn)
            m_Scrollview.addSubview(bottomBtn)
            
            
            bottomBtn.addTarget(self, action: #selector(self.moveBottom), for: .touchUpInside)
            
            //그라데이션으로 변경
            //카테고리 전체뷰
            
            categoryView.frame = CGRect(x: 0, y: 497.7, width: 375, height: 1040.3)
            //그라데이션으로 변경
            //        let gradientLayer = CAGradientLayer()
            //        gradientLayer.frame = CGRect(x: 0, y: 0, width: 375, height: 1040.3)
            //        gradientLayer.startPoint = CGPoint(x: 375, y: 0)
            //        gradientLayer.endPoint   = CGPoint(x: 375, y: 1040.3)
            //        //gradientLayer.locations  = [0, 520.1, 1040.3]
            //
            //        //그라데이션 색깔 입력
            //
            //        gradientLayer.colors =
            //        [UIColor(displayP3Red: 95/255.0, green: 116/255.0, blue: 251/255.0, alpha: 1),
            //         UIColor(displayP3Red: 111/255.0, green: 82/255.0, blue: 241/255.0, alpha: 1)]
            //
            //        gradientLayer.locations = [0.0 , 1040.3]
            //       gradientLayer.startPoint = CGPoint(x: 375, y: 0)
            //        gradientLayer.endPoint   = CGPoint(x: 375, y: 1040.3)
            //
            //        gradientLayer.shouldRasterize = true
            //
            //        categoryView.layer.addSublayer(gradientLayer)
            
            
            // categoryView.backgroundColor = UIColor(displayP3Red: 93/255.0, green: 116/255.0, blue: 251/255.0, alpha: 1)
            categoryView.backgroundColor = UIColor(displayP3Red: 111/255.0, green: 82/255.0, blue: 241/255.0, alpha: 1)
            
            m_Scrollview.addSubview(categoryView)
            
            //카테고리 전체뷰 위에 표시되어야 하기때문에 카테고리뷰를 스크롤뷰에 추가한 후에 다시 추가해준다.
            //카테고리뷰 라벨 추가
            benefitLabel.font = UIFont(name: "Jalnan", size: 21)
            benefitLabel.text = "당신이 관심있는 혜택은?"
            benefitLabel.frame = CGRect(x: 64.7, y: 564.3, width: 246, height: 22)
            benefitLabel.textAlignment = .center
            benefitLabel.textColor = UIColor(displayP3Red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 1)
            
            m_Scrollview.addSubview(benefitLabel)
            
            //메인 이미지
            
            
            let MainImg = UIImage(named: "MainImg")
            MainImgView.image = MainImg
            MainImgView.frame = CGRect(x: 0, y: 291.4, width: 374, height: 211.1)
            //self.view.addSubview(appLogo)
            m_Scrollview.addSubview(MainImgView)
            
            //카테고리 선택버튼 추가하는 부분
            for i in 0..<10 {
                
                var button = UIButton(type: .system)
                var imgView = UIImageView()
                var label = UILabel()
                button.tag = i
                
                //
                buttons.append(button)
                imgViews.append(imgView)
                labels.append(label)
                
                
                //그리드 배치를 위한 홀짝 구분
                
                
                
                //마지막 버튼은 더보기 버튼
                if(i == 9){
                    
                    button.frame = CGRect(x:193.7, y:Double(Int(159.3) * (i - 1)/2) + 617.7, width: 161.3, height: 147)
                    
                    //button.setTitle(LabelName[i], for: .normal)
                    
                    //이미지 및 라벨 추가
                    let img = UIImage(named: ImgFile[i])
                    imgView.setImage(img!)
                    imgView.frame = CGRect(x: 24, y: 34.7, width: 35.3, height: 35.3)
                    imgView.image = imgView.image?.withRenderingMode(.alwaysOriginal)
                    
                    
                    //라벨
                    label.frame = CGRect(x: 24.3, y: 88.6, width: 100, height: 17)
                    label.textAlignment = .left
                    
                    //폰트지정 추가
                    label.text = LabelName[i]
                    label.textColor = .white
                    label.font = UIFont(name: "NanumGothicBold", size: 14.7)
                    
                    
                    
                    button.addSubview(imgView)
                    button.addSubview(label)
                    
                    button.setTitleColor(UIColor.black, for: .normal)
                    button.layer.cornerRadius = 14
                    
                    button.layer.borderWidth = 2.7
                    button.layer.borderColor = UIColor.white.cgColor
                    
                    
                    //카테고리 선택시 선택한 카테고리를 저장해주는 메소드
                    button.addTarget(self, action: #selector(self.addBtn), for: .touchUpInside)
                    
                    
                    m_Scrollview.addSubview(button)
                    
                    //홀수번호
                }else if(i%2==0){
                    
                    button.addTarget(self, action: #selector(self.selected), for: .touchUpInside)
                    button.frame = CGRect(x:20, y:Double(Int(159.3) * i/2) + 617.7, width: 161.3, height: 147)
                    
                    //button.setTitle(LabelName[i], for: .normal)
                    
                    
                    //이미지 및 라벨 추가
                    let img = UIImage(named: ImgFile[i])
                    imgView.setImage(img!)
                    imgView.frame = CGRect(x: 24, y: 34.7, width: 35.3, height: 35.3)
                    imgView.image = imgView.image?.withRenderingMode(.alwaysOriginal)
                    //라벨
                    label.frame = CGRect(x: 24.3, y: 88.6, width: 100, height: 17)
                    label.textAlignment = .left
                    
                    //폰트지정 추가
                    label.text = LabelName[i]
                    label.font = UIFont(name: "NanumGothicBold", size: 14.7)
                    
                    
                    
                    button.addSubview(imgView)
                    button.addSubview(label)
                    button.setTitleColor(UIColor.black, for: .normal)
                    button.backgroundColor = .white
                    button.layer.cornerRadius = 14
                    button.layer.borderWidth = 2.7
                    button.layer.borderColor = UIColor.white.cgColor
                    
                    //카테고리 선택시 선택한 카테고리를 저장해주는 메소드
                    button.addTarget(self, action: #selector(self.selected), for: .touchUpInside)
                    
                    //카테고리에 사용되는 뷰들을 리스트로 관리해서 선택됫을경우 선탟된 카테고리의 뷰들
                    //에 대해 변형해준다.
                    
                    
                    m_Scrollview.addSubview(button)
                    
                    
                    
                    //짝수
                }else if(i != 0 && i%2==1){
                    
                    
                    button.addTarget(self, action: #selector(self.selected), for: .touchUpInside)
                    button.frame = CGRect(x:193.7, y:Double(Int(159.3) * (i - 1)/2) + 617.7, width: 161.3, height: 147)
                    //button.setTitle(LabelName[i], for: .normal)
                    //이미지 및 라벨 추가
                    let img = UIImage(named: ImgFile[i])
                    imgView.setImage(img!)
                    imgView.frame = CGRect(x: 24, y: 34.7, width: 35.3, height: 35.3)
                    imgView.image = imgView.image?.withRenderingMode(.alwaysOriginal)
                    
                    
                    //라벨
                    label.frame = CGRect(x: 24.3, y: 88.6, width: 100, height: 17)
                    label.textAlignment = .left
                    
                    //폰트지정 추가
                    label.text = LabelName[i]
                    label.font = UIFont(name: "NanumGothicBold", size: 14.7)
                    
                    
                    
                    button.addSubview(imgView)
                    button.addSubview(label)
                    
                    
                    button.setTitleColor(UIColor.black, for: .normal)
                    button.backgroundColor = .white
                    button.layer.cornerRadius = 14
                    button.layer.borderWidth = 2.7
                    button.layer.borderColor = UIColor.white.cgColor
                    
                    //카테고리 선택시 선택한 카테고리를 저장해주는 메소드
                    button.addTarget(self, action: #selector(self.selected), for: .touchUpInside)
                    
                    
                    m_Scrollview.addSubview(button)
                    
                }
                
            }
            
            
            //조회하기 버튼
            
            //라벨
            let inquiryBtnLabel = UILabel()
            inquiryBtnLabel.frame = CGRect(x: 18.3, y: 139.3, width: 54, height: 17)
            inquiryBtnLabel.textAlignment = .center
            inquiryBtnLabel.textColor = UIColor(displayP3Red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 1)
            
            inquiryBtnLabel.text = "조회하기"
            inquiryBtnLabel.font = UIFont(name: "NanumGothic", size: 14.7)
            
            
            inquiryBtn.setTitle("조회하기", for: .normal)
            inquiryBtn.frame = CGRect(x: 20, y: 1424.3, width: 335, height: 53.7)
            
            inquiryBtn.titleLabel!.font = UIFont(name: "NanumGothic", size:14.7)
            inquiryBtn.layer.cornerRadius = 3.3
            inquiryBtn.layer.borderWidth = 1.3
            inquiryBtn.layer.borderColor = UIColor.white.cgColor
            //선택결과 페이지로 이동하는 메소드
            inquiryBtn.addTarget(self, action: #selector(self.move), for: .touchUpInside)
            
            //조회하기 버튼 삭제를 위한 태그값 설정
            inquiryBtn.tag = 44
            //self.view.addSubview(bottomBtn)
            m_Scrollview.addSubview(inquiryBtn)
            
            
            //최하단 설명뷰(고객센터,개인정보 취급방침,이용약관등)
            footer.frame = CGRect(x: 0, y: 1538, width: 375, height: 208.7)
            footer.backgroundColor = UIColor(displayP3Red: 251/255.0, green: 251/255.0, blue: 251/255.0, alpha: 1)
            
            //하단 뷰 너의 혜택은 이미지 뷰
            //이미지 및 라벨 추가
            let bottomImg = UIImage(named: "bottomImg")
            let bottomImgView = UIImageView(image: bottomImg)
            bottomImgView.frame = CGRect(x: 20.7, y: 31.7, width: 96.7, height: 17)
            footer.addSubview(bottomImgView)
            
            //하단 설명 라벨
            let bottomLabel = UILabel()
            //bottomLabel.frame = CGRect(x: 20.7, y: 58.3, width: 238.7, height: 12.7)
            bottomLabel.frame = CGRect(x: 20.7, y: 58.3, width: 300, height: 12.7)
            bottomLabel.textAlignment = .left
            bottomLabel.textColor = UIColor(displayP3Red: 125/255.0, green: 125/255.0, blue: 125/255.0, alpha: 1)
            
            bottomLabel.text = "사용자에게 알 맞는 복지 지원과 혜택을 알려드립니다"
            bottomLabel.font = UIFont(name: "NanumGothic", size: 11)
            footer.addSubview(bottomLabel)
            
            
            
            //2번째 라벨
            let bottomSecLabel = UILabel()
            //bottomLabel.frame = CGRect(x: 20.7, y: 58.3, width: 238.7, height: 12.7)
            bottomSecLabel.frame = CGRect(x: 20.7, y: 108.3, width: 300, height: 15)
            bottomSecLabel.textAlignment = .left
            bottomSecLabel.textColor = UIColor(displayP3Red: 125/255.0, green: 125/255.0, blue: 125/255.0, alpha: 1)
            
            bottomSecLabel.text = "Copyright © All rights reserved"
            bottomSecLabel.font = UIFont(name: "OpenSans-Bold", size: 11)
            footer.addSubview(bottomSecLabel)
            
            //하단 페이스북 버튼
            let bottomFbBtn = UIButton(type: .system)
            bottomFbBtn.frame = CGRect(x:20.7, y:143.3, width: 35.3, height: 35.3)
            bottomFbBtn.backgroundColor = UIColor(displayP3Red: 233/255.0, green: 233/255.0, blue: 233/255.0, alpha: 1)
            bottomFbBtn.layer.cornerRadius = 100
            
            bottomFbBtn.layer.cornerRadius = bottomFbBtn.frame.height/2
            bottomFbBtn.layer.borderWidth = 1
            bottomFbBtn.layer.borderColor = UIColor.clear.cgColor
            // 뷰의 경계에 맞춰준다
            bottomFbBtn.clipsToBounds = true
            
            
            //페이스북 로고이미지 추가
            let fbImg = UIImage(named:"fbImg")
            let fbImgView = UIImageView(image: fbImg)
            fbImgView.frame = CGRect(x: 14.4, y: 10.5, width: 6.9, height: 13.8)
            
            //각 상위뷰에 추가
            bottomFbBtn.addSubview(fbImgView)
            footer.addSubview(bottomFbBtn)
            
            
            //하단 구글 버튼
            let bottomGgBtn = UIButton(type: .system)
            bottomGgBtn.frame = CGRect(x:64, y:143.3, width: 35.3, height: 35.3)
            bottomGgBtn.backgroundColor = UIColor(displayP3Red: 233/255.0, green: 233/255.0, blue: 233/255.0, alpha: 1)
            bottomGgBtn.layer.cornerRadius = 100
            
            bottomGgBtn.layer.cornerRadius = bottomFbBtn.frame.height/2
            bottomGgBtn.layer.borderWidth = 1
            bottomGgBtn.layer.borderColor = UIColor.clear.cgColor
            // 뷰의 경계에 맞춰준다
            bottomGgBtn.clipsToBounds = true
            
            
            //페이스북 로고이미지 추가
            let GgImg = UIImage(named:"GgImg")
            let GgImgView = UIImageView(image: GgImg)
            GgImgView.frame = CGRect(x: 10.8, y: 10.5, width: 9.3, height: 13.8)
            
            //각 상위뷰에 추가
            bottomGgBtn.addSubview(GgImgView)
            footer.addSubview(bottomGgBtn)
            
            //앱스토어 추가
            //애플
            //로고
            let appleImg = UIImage(named:"appleImg")
            let appleImgView = UIImageView(image: appleImg)
            appleImgView.frame = CGRect(x: 129, y: 153.7, width: 14.3, height: 17.3)
            
            footer.addSubview(appleImgView)
            
            //버튼
            let appleBtn = UIButton(type: .system)
            appleBtn.frame = CGRect(x:150.7, y:151.7, width: 70.3, height: 20.7)
            appleBtn.backgroundColor = .clear
            appleBtn.setTitle("App Store", for: .normal)
            appleBtn.setTitleColor(UIColor(displayP3Red: 125/255.0, green: 125/255.0, blue: 125/255.0, alpha: 1), for: .normal)
            appleBtn.titleLabel!.font = UIFont(name: "OpenSans-Semibold", size:14.3)
            footer.addSubview(appleBtn)
            
            
            
            //구글
            //로고
            let googleImg = UIImage(named:"googleImg")
            let googleImgView = UIImageView(image: googleImg)
            googleImgView.frame = CGRect(x: 235, y: 153.3, width: 16.7, height: 18)
            
            footer.addSubview(googleImgView)
            
            //버튼
            let googleBtn = UIButton(type: .system)
            googleBtn.frame = CGRect(x:258.7, y:151.3, width: 87.7, height: 20.7)
            googleBtn.backgroundColor = .clear
            googleBtn.setTitle("Google play", for: .normal)
            googleBtn.setTitleColor(UIColor(displayP3Red: 125/255.0, green: 125/255.0, blue: 125/255.0, alpha: 1), for: .normal)
            googleBtn.titleLabel!.font = UIFont(name: "OpenSans-Semibold", size:14.3)
            footer.addSubview(googleBtn)
            
            
            
            //하단 뷰 추가
            m_Scrollview.addSubview(footer)
            
            
            //메인스크롤 뷰 추가
            m_Scrollview.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
            m_Scrollview.contentSize = CGSize(width:screenWidth, height: 1747)
            self.view.addSubview(m_Scrollview)
            
            //디바이스 크기별 화면 조정
            //임시
        }else if(screenWidth == 414){
            let LogoImg = UIImage(named: "appLogo")
            appLogo.image = LogoImg
            appLogo.frame = CGRect(x: 24.3, y: 29.3, width: 116.6, height: 15.7)
            //self.view.addSubview(appLogo)
            m_Scrollview.addSubview(appLogo)
            
            
            let descriptionImg = UIImage(named: "descriptionImg")
            appDescription.image = descriptionImg
            appDescription.frame = CGRect(x: 64.1, y: 125, width: 284.1, height: 82.5)
            // self.view.addSubview(appDescription)
            m_Scrollview.addSubview(appDescription)
            
            let inquiryLabel = UILabel()
            inquiryLabel.frame = CGRect(x: 63.8, y: 235.4, width: 118, height: 17.3)
            inquiryLabel.textAlignment = .right
            inquiryLabel.textColor = UIColor(displayP3Red: 93/255.0, green: 33/255.0, blue: 210/255.0, alpha: 1)
            //폰트지정 추가
            
            inquiryLabel.text = "혜택 조회하러 가기"
            inquiryLabel.font = UIFont(name: "NanumGothicBold", size: 14.3)
            // inquiryLabel.font = UIFont(name: "NanumGothicBold", size: 13.7)
            // self.view.addSubview(inquiryLabel)
            m_Scrollview.addSubview(inquiryLabel)
            
            
            
            bottomBtn.setImage(UIImage(named: "bottomBtnImg"), for: .normal)
            bottomBtn.frame = CGRect(x: 192.5, y: 227.1, width: 18.7, height: 26)
            //self.view.addSubview(bottomBtn)
            m_Scrollview.addSubview(bottomBtn)
            
            
            bottomBtn.addTarget(self, action: #selector(self.moveBottom), for: .touchUpInside)
            
            //그라데이션으로 변경
            //카테고리 전체뷰
            
            categoryView.frame = CGRect(x: 0, y: 547.4, width: Double(screenWidth), height: 1144.3)
            //그라데이션으로 변경
            //        let gradientLayer = CAGradientLayer()
            //        gradientLayer.frame = CGRect(x: 0, y: 0, width: 375, height: 1040.3)
            //        gradientLayer.startPoint = CGPoint(x: 375, y: 0)
            //        gradientLayer.endPoint   = CGPoint(x: 375, y: 1040.3)
            //        //gradientLayer.locations  = [0, 520.1, 1040.3]
            //
            //        //그라데이션 색깔 입력
            //
            //        gradientLayer.colors =
            //        [UIColor(displayP3Red: 95/255.0, green: 116/255.0, blue: 251/255.0, alpha: 1),
            //         UIColor(displayP3Red: 111/255.0, green: 82/255.0, blue: 241/255.0, alpha: 1)]
            //
            //        gradientLayer.locations = [0.0 , 1040.3]
            //       gradientLayer.startPoint = CGPoint(x: 375, y: 0)
            //        gradientLayer.endPoint   = CGPoint(x: 375, y: 1040.3)
            //
            //        gradientLayer.shouldRasterize = true
            //
            //        categoryView.layer.addSublayer(gradientLayer)
            
            
            // categoryView.backgroundColor = UIColor(displayP3Red: 93/255.0, green: 116/255.0, blue: 251/255.0, alpha: 1)
            categoryView.backgroundColor = UIColor(displayP3Red: 111/255.0, green: 82/255.0, blue: 241/255.0, alpha: 1)
            
            m_Scrollview.addSubview(categoryView)
            
            //카테고리 전체뷰 위에 표시되어야 하기때문에 카테고리뷰를 스크롤뷰에 추가한 후에 다시 추가해준다.
            //카테고리뷰 라벨 추가
            benefitLabel.font = UIFont(name: "Jalnan", size: 23.1)
            benefitLabel.text = "당신이 관심있는 혜택은?"
            benefitLabel.frame = CGRect(x: 71.1, y: 620.7, width: 270.6, height: 24.2)
            benefitLabel.textAlignment = .center
            benefitLabel.textColor = UIColor(displayP3Red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 1)
            
            m_Scrollview.addSubview(benefitLabel)
            
            //메인 이미지
            
            
            let MainImg = UIImage(named: "MainImg")
            MainImgView.image = MainImg
            MainImgView.frame = CGRect(x: 0, y: 320.5, width: 411.4, height: 232.2)
            //self.view.addSubview(appLogo)
            m_Scrollview.addSubview(MainImgView)
            
            //카테고리 선택버튼 추가하는 부분
            for i in 0..<10 {
                
                var button = UIButton(type: .system)
                var imgView = UIImageView()
                var label = UILabel()
                button.tag = i
                
                //
                buttons.append(button)
                imgViews.append(imgView)
                labels.append(label)
                
                
                //그리드 배치를 위한 홀짝 구분
                
                
                
                //마지막 버튼은 더보기 버튼
                if(i == 9){
                    
                    button.frame = CGRect(x:213, y:Double(Int(175.2) * (i - 1)/2) + 679.4, width: 177.4, height: 161.7)
                    
                    //button.setTitle(LabelName[i], for: .normal)
                    
                    //이미지 및 라벨 추가
                    let img = UIImage(named: ImgFile[i])
                    imgView.setImage(img!)
                    imgView.frame = CGRect(x: 26.4, y: 38.1, width: 38.8, height: 38.8)
                    imgView.image = imgView.image?.withRenderingMode(.alwaysOriginal)
                    
                    
                    //라벨
                    label.frame = CGRect(x: 26.7, y: 97.4, width: 110, height: 18.7)
                    label.textAlignment = .left
                    
                    //폰트지정 추가
                    label.text = LabelName[i]
                    label.textColor = .white
                    label.font = UIFont(name: "NanumGothicBold", size: 16.1)
                    
                    
                    
                    button.addSubview(imgView)
                    button.addSubview(label)
                    
                    button.setTitleColor(UIColor.black, for: .normal)
                    button.layer.cornerRadius = 15.4
                    
                    button.layer.borderWidth = 3
                    button.layer.borderColor = UIColor.white.cgColor
                    
                    
                    //카테고리 선택시 선택한 카테고리를 저장해주는 메소드
                    button.addTarget(self, action: #selector(self.addBtn), for: .touchUpInside)
                    
                    
                    m_Scrollview.addSubview(button)
                    
                    //홀수번호
                }else if(i%2==0){
                    
                    button.addTarget(self, action: #selector(self.selected), for: .touchUpInside)
                    button.frame = CGRect(x:22, y:Double(Int(175.2) * i/2) + 679.4, width: 177.4, height: 158.4)
                    
                    //button.setTitle(LabelName[i], for: .normal)
                    
                    
                    //이미지 및 라벨 추가
                    let img = UIImage(named: ImgFile[i])
                    imgView.setImage(img!)
                    imgView.frame = CGRect(x: 26.4, y: 38.1, width: 38.8, height: 38.8)
                    imgView.image = imgView.image?.withRenderingMode(.alwaysOriginal)
                    //라벨
                    label.frame = CGRect(x: 26.7, y: 97.4, width: 110, height: 18.7)
                    label.textAlignment = .left
                    
                    //폰트지정 추가
                    label.text = LabelName[i]
                    label.font = UIFont(name: "NanumGothicBold", size: 16.1)
                    
                    
                    
                    button.addSubview(imgView)
                    button.addSubview(label)
                    button.setTitleColor(UIColor.black, for: .normal)
                    button.backgroundColor = .white
                    button.layer.cornerRadius = 14
                    button.layer.borderWidth = 2.7
                    button.layer.borderColor = UIColor.white.cgColor
                    
                    //카테고리 선택시 선택한 카테고리를 저장해주는 메소드
                    button.addTarget(self, action: #selector(self.selected), for: .touchUpInside)
                    
                    //카테고리에 사용되는 뷰들을 리스트로 관리해서 선택됫을경우 선탟된 카테고리의 뷰들
                    //에 대해 변형해준다.
                    
                    
                    m_Scrollview.addSubview(button)
                    
                    
                    
                    //짝수
                }else if(i != 0 && i%2==1){
                    
                    
                    button.addTarget(self, action: #selector(self.selected), for: .touchUpInside)
                    button.frame = CGRect(x:213, y:Double(Int(175.2) * (i - 1)/2) + 679.4, width: 177.4, height: 161.7)
                    //button.setTitle(LabelName[i], for: .normal)
                    //이미지 및 라벨 추가
                    let img = UIImage(named: ImgFile[i])
                    imgView.setImage(img!)
                    imgView.frame = CGRect(x: 26.4, y: 38.1, width: 38.8, height: 38.8)
                    imgView.image = imgView.image?.withRenderingMode(.alwaysOriginal)
                    
                    
                    //라벨
                    label.frame = CGRect(x: 26.7, y: 97.4, width: 110, height: 18.7)
                    label.textAlignment = .left
                    
                    //폰트지정 추가
                    label.text = LabelName[i]
                    label.font = UIFont(name: "NanumGothicBold", size: 16.1)
                    
                    
                    
                    button.addSubview(imgView)
                    button.addSubview(label)
                    
                    
                    button.setTitleColor(UIColor.black, for: .normal)
                    button.backgroundColor = .white
                    button.layer.cornerRadius = 14
                    button.layer.borderWidth = 2.7
                    button.layer.borderColor = UIColor.white.cgColor
                    
                    //카테고리 선택시 선택한 카테고리를 저장해주는 메소드
                    button.addTarget(self, action: #selector(self.selected), for: .touchUpInside)
                    
                    
                    m_Scrollview.addSubview(button)
                    
                }
                
            }
            
            
            //조회하기 버튼
            
            //라벨
            let inquiryBtnLabel = UILabel()
            inquiryBtnLabel.frame = CGRect(x: 20.1, y: 153.2, width: 59.4, height: 18.7)
            inquiryBtnLabel.textAlignment = .center
            inquiryBtnLabel.textColor = UIColor(displayP3Red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 1)
            
            inquiryBtnLabel.text = "조회하기"
            inquiryBtnLabel.font = UIFont(name: "NanumGothic", size: 16.1)
            
            
            inquiryBtn.setTitle("조회하기", for: .normal)
            inquiryBtn.frame = CGRect(x: 22, y: 1566.7, width: 368.5, height: 59)
            
            inquiryBtn.titleLabel!.font = UIFont(name: "NanumGothic", size:16.1)
            inquiryBtn.layer.cornerRadius = 3.3
            inquiryBtn.layer.borderWidth = 1.3
            inquiryBtn.layer.borderColor = UIColor.white.cgColor
            //선택결과 페이지로 이동하는 메소드
            inquiryBtn.addTarget(self, action: #selector(self.move), for: .touchUpInside)
            
            //조회하기 버튼 삭제를 위한 태그값 설정
            inquiryBtn.tag = 44
            //self.view.addSubview(bottomBtn)
            m_Scrollview.addSubview(inquiryBtn)
            
            
            //최하단 설명뷰(고객센터,개인정보 취급방침,이용약관등)
            footer.frame = CGRect(x: 0, y: 1688.5, width: 412.5, height: 229.5)
            footer.backgroundColor = UIColor(displayP3Red: 251/255.0, green: 251/255.0, blue: 251/255.0, alpha: 1)
            
            //하단 뷰 너의 혜택은 이미지 뷰
            //이미지 및 라벨 추가
            let bottomImg = UIImage(named: "bottomImg")
            let bottomImgView = UIImageView(image: bottomImg)
            bottomImgView.frame = CGRect(x: 22.7, y: 34.8, width: 106.3, height: 18.7)
            footer.addSubview(bottomImgView)
            
            //하단 설명 라벨
            let bottomLabel = UILabel()
            //bottomLabel.frame = CGRect(x: 20.7, y: 58.3, width: 238.7, height: 12.7)
            bottomLabel.frame = CGRect(x: 22.7, y: 64.1, width: 330, height: 13.9)
            bottomLabel.textAlignment = .left
            bottomLabel.textColor = UIColor(displayP3Red: 125/255.0, green: 125/255.0, blue: 125/255.0, alpha: 1)
            
            bottomLabel.text = "당신에게 필요한 복지 지원과 혜택을 알려드립니다"
            bottomLabel.font = UIFont(name: "NanumGothic", size: 12.1)
            footer.addSubview(bottomLabel)
            
            
            
            //2번째 라벨
            let bottomSecLabel = UILabel()
            //bottomLabel.frame = CGRect(x: 20.7, y: 58.3, width: 238.7, height: 12.7)
            bottomSecLabel.frame = CGRect(x: 22.7, y: 119.1, width: 330, height: 16.5)
            bottomSecLabel.textAlignment = .left
            bottomSecLabel.textColor = UIColor(displayP3Red: 125/255.0, green: 125/255.0, blue: 125/255.0, alpha: 1)
            
            bottomSecLabel.text = "Copyright © All rights reserved"
            bottomSecLabel.font = UIFont(name: "OpenSans-Bold", size: 12.1)
            footer.addSubview(bottomSecLabel)
            
            //하단 페이스북 버튼
            let bottomFbBtn = UIButton(type: .system)
            bottomFbBtn.frame = CGRect(x:22.7, y:157.6, width: 38.8, height: 38.8)
            bottomFbBtn.backgroundColor = UIColor(displayP3Red: 233/255.0, green: 233/255.0, blue: 233/255.0, alpha: 1)
            bottomFbBtn.layer.cornerRadius = 100
            
            bottomFbBtn.layer.cornerRadius = bottomFbBtn.frame.height/2
            bottomFbBtn.layer.borderWidth = 1
            bottomFbBtn.layer.borderColor = UIColor.clear.cgColor
            // 뷰의 경계에 맞춰준다
            bottomFbBtn.clipsToBounds = true
            
            
            //페이스북 로고이미지 추가
            let fbImg = UIImage(named:"fbImg")
            let fbImgView = UIImageView(image: fbImg)
            fbImgView.frame = CGRect(x: 15.8, y: 11.4, width: 7.6, height: 15.1)
            
            //각 상위뷰에 추가
            bottomFbBtn.addSubview(fbImgView)
            footer.addSubview(bottomFbBtn)
            
            
            //하단 구글 버튼
            let bottomGgBtn = UIButton(type: .system)
            bottomGgBtn.frame = CGRect(x:70.4, y:158.7, width: 38.8, height: 38.8)
            bottomGgBtn.backgroundColor = UIColor(displayP3Red: 233/255.0, green: 233/255.0, blue: 233/255.0, alpha: 1)
            bottomGgBtn.layer.cornerRadius = 100
            
            bottomGgBtn.layer.cornerRadius = bottomFbBtn.frame.height/2
            bottomGgBtn.layer.borderWidth = 1
            bottomGgBtn.layer.borderColor = UIColor.clear.cgColor
            // 뷰의 경계에 맞춰준다
            bottomGgBtn.clipsToBounds = true
            
            
            //페이스북 로고이미지 추가
            let GgImg = UIImage(named:"GgImg")
            let GgImgView = UIImageView(image: GgImg)
            GgImgView.frame = CGRect(x: 11.8, y: 11.5, width: 10.2, height: 15.1)
            
            //각 상위뷰에 추가
            bottomGgBtn.addSubview(GgImgView)
            footer.addSubview(bottomGgBtn)
            
            //앱스토어 추가
            //애플
            //로고
            let appleImg = UIImage(named:"appleImg")
            let appleImgView = UIImageView(image: appleImg)
            appleImgView.frame = CGRect(x: 142, y: 169, width: 15.7, height: 19)
            
            footer.addSubview(appleImgView)
            
            //버튼
            let appleBtn = UIButton(type: .system)
            appleBtn.frame = CGRect(x:165.7, y:166.8, width: 77.3, height: 22.7)
            appleBtn.backgroundColor = .clear
            appleBtn.setTitle("App Store", for: .normal)
            appleBtn.setTitleColor(UIColor(displayP3Red: 125/255.0, green: 125/255.0, blue: 125/255.0, alpha: 1), for: .normal)
            appleBtn.titleLabel!.font = UIFont(name: "OpenSans-Semibold", size:15.7)
            footer.addSubview(appleBtn)
            
            
            
            //구글
            //로고
            let googleImg = UIImage(named:"googleImg")
            let googleImgView = UIImageView(image: googleImg)
            googleImgView.frame = CGRect(x: 258.5, y: 168.6, width: 18.3, height: 19.8)
            
            footer.addSubview(googleImgView)
            
            //버튼
            let googleBtn = UIButton(type: .system)
            googleBtn.frame = CGRect(x:284.5, y:166.4, width: 96.4, height: 22.7)
            googleBtn.backgroundColor = .clear
            googleBtn.setTitle("Google play", for: .normal)
            googleBtn.setTitleColor(UIColor(displayP3Red: 125/255.0, green: 125/255.0, blue: 125/255.0, alpha: 1), for: .normal)
            googleBtn.titleLabel!.font = UIFont(name: "OpenSans-Semibold", size:15.7)
            footer.addSubview(googleBtn)
            
            
            
            //하단 뷰 추가
            m_Scrollview.addSubview(footer)
            
            
            //메인스크롤 뷰 추가
            m_Scrollview.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
            m_Scrollview.contentSize = CGSize(width:screenWidth, height: 1921)
            self.view.addSubview(m_Scrollview)
            
            
            
        }
        
        
    }
    
    //더 보기 버튼선택시
    @objc func addBtn(_ sender: UIButton) {
        print("더보기 버튼 클릭")
        
        
        for subview in m_Scrollview.subviews {
            //기존의 더보기 버튼을 삭제하고
            if subview is UIButton && subview.tag == sender.tag { subview.removeFromSuperview()
            }
            
            else if subview is UIButton && subview.tag == 44 { subview.removeFromSuperview()
            }
            
            
            
        }
        //기존 프레임을 변경해주고
        categoryView.frame = CGRect(x: 0, y: 497.7, width: 375, height: 1350.3)
        
        footer.frame = CGRect(x: 0, y: 1856.7, width: 375, height: 208.7)
        
        
        //스크롤뷰 컨텐츠 사이즈 변경
        var Width = view.bounds.width
        self.m_Scrollview.contentSize = CGSize(width: Width, height: 2065.3)
        
        
        //버튼들을 추가해준다.
        //카테고리 선택버튼 추가하는 부분
        for i in 9..<13 {
            
            var button = UIButton(type: .system)
            var imgView = UIImageView()
            var label = UILabel()
            button.tag = i+1
            
            //
            buttons.append(button)
            imgViews.append(imgView)
            labels.append(label)
            
            //홀수번호
            if(i%2==0){
                
                button.addTarget(self, action: #selector(self.selected), for: .touchUpInside)
                button.frame = CGRect(x:20, y:Double(Int(159.3) * i/2) + 617.7, width: 161.3, height: 147)
                
                //button.setTitle(LabelName[i], for: .normal)
                
                
                //이미지 및 라벨 추가
                let img = UIImage(named: ImgFile[1])
                imgView.setImage(img!)
                imgView.frame = CGRect(x: 24, y: 34.7, width: 35.3, height: 35.3)
                imgView.image = imgView.image?.withRenderingMode(.alwaysOriginal)
                //라벨
                label.frame = CGRect(x: 24.3, y: 88.6, width: 100, height: 17)
                label.textAlignment = .left
                
                //폰트지정 추가
                label.text = LabelName[i+1]
                label.font = UIFont(name: "NanumGothicBold", size: 14.7)
                
                
                
                button.addSubview(imgView)
                button.addSubview(label)
                button.setTitleColor(UIColor.black, for: .normal)
                button.backgroundColor = .white
                button.layer.cornerRadius = 14
                button.layer.borderWidth = 2.7
                button.layer.borderColor = UIColor.white.cgColor
                
                //카테고리 선택시 선택한 카테고리를 저장해주는 메소드
                button.addTarget(self, action: #selector(self.selected), for: .touchUpInside)
                
                //카테고리에 사용되는 뷰들을 리스트로 관리해서 선택됫을경우 선탟된 카테고리의 뷰들
                //에 대해 변형해준다.
                
                m_Scrollview.addSubview(button)
                
                
                
                //짝수
            }else if(i != 0 && i%2==1){
                
                
                button.addTarget(self, action: #selector(self.selected), for: .touchUpInside)
                button.frame = CGRect(x:193.7, y:Double(Int(159.3) * (i - 1)/2) + 617.7, width: 161.3, height: 147)
                //button.setTitle(LabelName[i], for: .normal)
                //이미지 및 라벨 추가
                let img = UIImage(named: ImgFile[1])
                imgView.setImage(img!)
                imgView.frame = CGRect(x: 24, y: 34.7, width: 35.3, height: 35.3)
                imgView.image = imgView.image?.withRenderingMode(.alwaysOriginal)
                
                
                //라벨
                label.frame = CGRect(x: 24.3, y: 88.6, width: 100, height: 17)
                label.textAlignment = .left
                
                //폰트지정 추가
                label.text = LabelName[i+1]
                label.font = UIFont(name: "NanumGothicBold", size: 14.7)
                
                
                
                button.addSubview(imgView)
                button.addSubview(label)
                
                
                button.setTitleColor(UIColor.black, for: .normal)
                button.backgroundColor = .white
                button.layer.cornerRadius = 14
                button.layer.borderWidth = 2.7
                button.layer.borderColor = UIColor.white.cgColor
                
                //카테고리 선택시 선택한 카테고리를 저장해주는 메소드
                button.addTarget(self, action: #selector(self.selected), for: .touchUpInside)
                
                
                m_Scrollview.addSubview(button)
                
            }
            
        }
        
        //다시 조회하기 버튼을 추가한다.
        //라벨
        let inquiryBtnLabel = UILabel()
        inquiryBtnLabel.frame = CGRect(x: 18.3, y: 139.3, width: 54, height: 17)
        inquiryBtnLabel.textAlignment = .center
        inquiryBtnLabel.textColor = UIColor(displayP3Red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 1)
        
        inquiryBtnLabel.text = "조회하기"
        inquiryBtnLabel.font = UIFont(name: "NanumGothic", size: 14.7)
        
        
        inquiryBtn.setTitle("조회하기", for: .normal)
        inquiryBtn.frame = CGRect(x: 20, y: 1761.3, width: 335, height: 53.7)
        
        inquiryBtn.titleLabel!.font = UIFont(name: "NanumGothic", size:14.7)
        inquiryBtn.layer.cornerRadius = 3.3
        inquiryBtn.layer.borderWidth = 1.3
        inquiryBtn.layer.borderColor = UIColor.white.cgColor
        //조회하기 버튼 삭제를 위한 태그값 설정
        inquiryBtn.tag = 44
        //self.view.addSubview(bottomBtn)
        m_Scrollview.addSubview(inquiryBtn)
        
        
        
    }
    
    
    //기존의 더보기 버튼을 삭제하고(바꿔주고)
    //        for subview in m_Scrollview.subviews{ // Loop thorough ScrollView view hierarchy
    //             if subview is UIVisualEffectView && subview.tag == sender.tag { // Check if view is type of VisualEffect and tag is equal to the view clicked
    //                 subview.removeFromSuperview()
    ////             }else if subview is UIVisualEffectView && subview.tag == 44 {
    ////                subview.removeFromSuperview()
    //
    //         }
    //
    //        }
    
    //새로 버튼들을 추가해준다.
    
    
    //스크롤뷰의 컨텐츠 사이즈를 늘려준다.
    
    
    
    
    
    //카테고리 선택시
    @objc func selected(_ sender: UIButton) {
        print("버튼 클릭")
        //        print(buttons.count)
        //        print(imgViews.count)
        
        
        //선택 해제하는 경우
        if(self.buttons[sender.tag].backgroundColor == UIColor(displayP3Red: 72/255.0, green:18/255.0, blue: 165/255.0, alpha: 1)){
            
            print("선택 해제")
            print(LabelName[sender.tag])
            //버튼의 백그라운드색상,버튼속 이미지 새상,버튼속 라벨 색상을 원래되로 돌린다.
            
            //두번선택하여 선택을 해제한 카테고리를 카테고리배열에서 삭제해준다.
            categorys = categorys.filter(){$0 != LabelName[sender.tag]}
            
            
            imgViews[sender.tag].image = imgViews[sender.tag].image?.withRenderingMode(.alwaysOriginal)
            
            labels[sender.tag].textColor = UIColor.black
            buttons[sender.tag].backgroundColor = UIColor.white
            buttons[sender.tag].setTitleColor(UIColor.black, for: .normal)
            buttons[sender.tag].layer.borderColor = UIColor.white.cgColor
            
            
            
            
            //선택하는 경우
        }else if(self.buttons[sender.tag].backgroundColor == UIColor.white){
            print("선택")
            print(LabelName[sender.tag])
            
            //버튼의 백그라운드색상,버튼속 이미지 새상,버튼속 라벨 색상을 변경해준다.
            
            //            imgViews[sender.tag].image = imgViews[sender.tag].image?.withRenderingMode(.alwaysTemplate)
            
            //선택한 카테고리를 카테고리배열에 담는다.
            categorys.append(LabelName[sender.tag])
            
            
            imgViews[sender.tag].tintColor = UIColor.white
            imgViews[sender.tag].image = imgViews[sender.tag].image?.withRenderingMode(.alwaysTemplate)
            
            labels[sender.tag].textColor = UIColor.white
            buttons[sender.tag].backgroundColor = UIColor(displayP3Red: 72/255.0, green:18/255.0, blue: 165/255.0, alpha: 1)
            buttons[sender.tag].layer.borderColor = UIColor(displayP3Red: 72/255.0, green:18/255.0, blue: 165/255.0, alpha: 1).cgColor
            //categorys = categorys.filter(){$0 != LabelName[sender.tag]}
            
            //categorys.append(LabelName[sender.tag])
        }
    }
    
    
    func pushMove() {
        print("pushMove")
    }
    
    //카테고리 선택영역으로 이동하는 메소드
    @IBAction func moveBottom(_ sender: UIButton) {
        m_Scrollview.setContentOffset(CGPoint(x: 1 ,y: 600), animated: true)
        
    }
    
    
    //최종확인 버튼
    @objc func move(_ sender: UIButton) {
        print("상세페이지로 이동하는 버튼 클릭")
        
        //선택한 카테고리의 갯수를 체크한다.
        //아무것도 체크하지 않은 경우
        if(categorys.count > 0 && categorys.count < 3){
            
            
            //선택한 카테고리를 전송할 데이터로 파싱하여 옮긴다.
            let string = categorys.joined(separator: " ")
            
            let parameters = ["reqBody": string]
            
            
            Alamofire.request("http://3.34.64.143/backend/ios/ios_category_result.php", method: .post, parameters: parameters)
                .validate()
                .responseJSON { response in
                    
                    switch response.result {
                    case .success(let value):
                        
                        //상세페이지로 카테고리선택결과 데이터를  전달하기 위해 상세페이지 객체를 선언
                        guard let RVC = self.storyboard?.instantiateViewController(withIdentifier: "ResultUIViewController") as? ResultUIViewController         else{
                            
                            return
                            
                        }
                        
                        if let json = value as? [String: Any] {
                            //print(json)
                            for (key, value) in json {
                                var test : [String]
                                test = value as! [String]
                                
                                
                                
                                
                                
                                
                                //카테고리명을 저장
                                //ResultViewController.item.init(name: key, sd: test)
                                RVC.items.append(                            ResultUIViewController.item.init(name: key, sd: test))
                                //                            for i in 0..<test.count {
                                //                                print(test[i])
                                //                            }
                                
                                
                                
                                
                            }
                            
                            
                            
                        }
                        
                        //뷰 이동
                        RVC.modalPresentationStyle = .fullScreen
                        
                        // 결과 페이지로 이동
                       // self.present(RVC, animated: true, completion: nil)
                        self.navigationController?.pushViewController(RVC, animated: true)
                    case .failure(let error):
                        print(error)
                    }
                    
                    
                    
                }
            //
            print(parameters)
            
            //카테고리 선택범위가 잘못됬을 경우 알림을 준다.
        }else{
            let alert = UIAlertController(title: "카테고리", message: "카테고리 선택을 확인해주세연", preferredStyle: UIAlertController.Style.alert)
            let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
                
            }
            alert.addAction(okAction)
            
            present(alert, animated: false, completion: nil)
            
            
        }
        
    }
    
    
    
    
    
}
