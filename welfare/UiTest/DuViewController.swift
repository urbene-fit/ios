//
//  DuViewController.swift
//  welfare
//
//  Created by 김동현 on 2020/10/20.
//  Copyright © 2020 com. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import Kingfisher


class DuViewController: UIViewController, UNUserNotificationCenterDelegate, UITableViewDataSource, UITableViewDelegate , UIScrollViewDelegate {
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("DuViewController의 view가 Load됨")
        //메인 네비 타이틀 초기화
       // self.title = "메인"
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //print("DuViewController의 view가 화면에 나타남")
        self.navigationController?.navigationBar.topItem?.rightBarButtonItem = nil


    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("DuViewController의 view가 사라지기 전")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print("DuViewController의 view가 사라짐")
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        print("DuViewController의 SubView를 레이아웃 하려함")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        print("DuViewController의 SubView를 레이아웃 함")
    }
    
    //카테고리 결과페이지에서 선택한 정책을 저장하는 변수
    var selectedPolicy : String = ""
    var selectedLocal : String = ""

    
    static var policy : String = ""
    //혜택 아이디
    var welf_id : String = ""
    
    //메인 세로 스크롤
    let m_Scrollview = UIScrollView()
    let relationScrollview = UIScrollView()
    
    //메인을 구성하는 이미지 및 라벨 뷰
    let appLogo = UIImageView()
    let header = UIView()
    let headerLabel = UILabel()
    //하단 앱 문의 및 설명뷰
    let footer = UIView()
    
    //라벨명을 담을 배열
    var LabelName = ["내용","신청방법","리뷰"]
    
    //상위 메뉴라벨을 관리하는 배열
    var categoryLabels = [UILabel]()
    
    //클릭한 메뉴를 표시해주는 밑줄라벨을 관리하는 배열
    var underLines = [CALayer]()
    
    //연관 혜택
    var Items = ["근로자 생활안정자금 대부","출산비용 지원","치매검진 지원","어업인 안전보험","무공영예수당"]
    
    
    //즐겨찾기 여부를 보여주는 이미지 뷰
    let bookMarkImg = UIImageView()
    var bookMarkBtn = UIButton()
    
    
    //즐겨찾기 여부를 저장하는 변수
    var isFavorite = Bool()
    
    //이미지를 관리하는 배열
    var imgs = [UIImage]()
    
    
    // json에서 key값 설정
//    struct userlist: Decodable {
//        var id : String
//        var welf_contact : String
//        var welf_contents : String
//        var welf_target : String
//        var welf_name : String
//        var welf_period : String
//        var isBookmark : String
//
//
//    }
    
    
//    struct retBody: Decodable {
//        // var welf_apply : String
//        let retBody : [reviewItem]
//    }
    
    
    //데이터 파싱
    struct detail: Decodable {
        var id : Int
        var welf_name : String
        var welf_target : String
        var welf_contents : String
        var welf_apply : String
        var welf_contact : String
        var welf_period : String
        var welf_end : String
        var welf_local : String
        var isBookmark : String

    }

    
    struct parse: Decodable {
        let Status : String
        //반환값이 없을떄 처리
        let Message : [detail]
    }
    
    
    //    struct parse : Decodable {
    //
    //        var retBody = ""
    //
    //    }
    
    
    var apply : String = ""
    var contact : String = ""
    var contents : String = ""
    var target : String = ""
    var name : String = ""
    var period : String = ""
    //즐겨찾기 추가여부
    var isBook : String = ""
    
    //혜택 아이 
    
    //즐겨찾기 추가이미지
    var bookImg = UIImage()
    
    //즐겨찾기 해제이미지
    var nonBookImg = UIImage()
    
    //리뷰를 보여주는 스크롤 뷰
    private var reViewTbView: UITableView!
    
    //스크롤뷰 총 길이
    var scrollViewContentHeight = 1747
    var screenWidth  = 0
    var screenHeight = 0
    //    struct item {
    //        var name: String
    //        var sd = Array<String>()
    //
    //    }
    //
    //    var items: [item] = []
    //
    
    
    //리뷰를 받아와 파싱할 구조체
    struct  reviewItem : Decodable {
        let content: String
        let image_url: String
        let id : Int
        let writer : String
        //let welf_name : String
        //let writer :  String
        //        let email : String
        //        let like_count : Int
        //        let bad_count : Int
        //        let star_count : Int
        
    }
    
    var reviewItems : [reviewItem] = []
    struct reviewParse: Decodable {
        let Status : String
        //반환값이 없을떄 처리
        let Message : [reviewItem]
    }
    
    
    //구조체 배열
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //print("DuViewController 화면 출력")
        
        //        let Items: [String] = ["행복주택 공급","긴급 주거지원","영구임대주택 공급","국민임대주택 공급","맞춤형 기초생활보장제도","긴급복지 지원제도","가족역량강화 지원"]
        
        //화면 스크롤 크기
        
        //        let center = UNUserNotificationCenter.current()
        //        center.delegate = self
        //
        screenWidth = Int(view.bounds.width)
        screenHeight = Int(view.bounds.height)
        var userEmail = UserDefaults.standard.string(forKey: "email")
        
        
        //        bookImg = UIImage(named: "Book")!
        //        nonBookImg = UIImage(named: "nonBook")!
        
        bookImg = UIImage(named: "star_on")!
        nonBookImg = UIImage(named: "star_off")!
        
        //스크롤뷰와 테이블뷰가 동시에 스크롤 되는 문제를 제어하기 위한 대리자 선언
        m_Scrollview.delegate = self
        //reViewTbView.delegate = self
        
        //튀어오르는 것 방지
        m_Scrollview.bounces = false
        //reViewTbView.bounces = false
        
        
//        //임시 디바이스 크기별 레이아웃 조정
//        if(screenWidth == 375){
//
//            //서버로부터 카테고리 데이터를 바다온다.
//            //            let params = ["be_name":selectedPolicy, "email" : userEmail]
//            //            Coffee.barista
//            let params = ["type":"detail", "local" : selectedLocal , "welf_name" : selectedPolicy,  "login_token" : "eyJhbGciOiJzaGEyNTYiLCJ0eXAiOiJKd3QifS57ImlkZW50aWZpZXIiOiIwMDAxMzEuNWZkZmEwNjEzODE0NDgyNmJlNmJlZjdkNzhiZTg0ZWUuMDIyMiIsInRva2VuX21ha2UiOiIyMDIwLTEyLTA4IDE1OjQ0OjA0In0uMWJlNjBlZDBiMjFlNjBiNzIzMWFkNzg2MTg4Njk2ODBhNDU4YWI0N2Q4MDk0NTE5OTA2ZTc5MGU5YWEyMTVlNA=="]
//            Alamofire.request("https://www.urbene-fit.com/user", method: .post, parameters: params)
//                .validate()
//                .responseJSON { [self] response in
//                    switch response.result {
//                    case .success(let value): ////print(value)
//                        //                           //print("성공")
//                        //                           //print("디리리리")
//
//
//                        do {
//                            let data = try JSONSerialization.data(withJSONObject: value, options: .prettyPrinted)
//                            let userlists = try JSONDecoder().decode(userlist.self, from: data)
//
//
//                            //즐겨찾기 여부를 저장
//                            isBook = userlists.isBookmark
//
//                            //헤더라벨
//                            self.headerLabel.frame = CGRect(x: 0, y: Int(52.3), width: screenWidth, height: 66)
//                            self.headerLabel.textColor = UIColor.white
//                            //폰트지정 추가
//
//                            self.headerLabel.text = userlists.welf_name
//                            self.headerLabel.numberOfLines = 2
//
//                            //라벨 줄간격 조절
//                            let attrString = NSMutableAttributedString(string: self.headerLabel.text!)
//                            let paragraphStyle = NSMutableParagraphStyle()
//                            paragraphStyle.lineSpacing = 8
//                            attrString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attrString.length))
//                            self.headerLabel.attributedText = attrString
//                            self.headerLabel.textAlignment = .center
//
//
//                            self.headerLabel.font = UIFont(name: "Jalnan", size: 26)
//                            // inquiryLabel.font = UIFont(name: "NanumGothicBold", size: 13.7)
//                            // self.view.addSubview(inquiryLabel)
//                            self.header.addSubview(self.headerLabel)
//
//
//                            //즐겨찾기 추가
//                            //self.bookMarkBtn.frame = CGRect(x:screenWidth - 30, y: 0, width: 30, height: 30)
//
//                            self.bookMarkBtn.frame = CGRect(x:screenWidth - 80, y: 0, width: 50, height: 50)
//
//                            //button.setTitle(LabelName[i], for: .normal)
//                            //이미지 및 라벨 추가
//
//                            //즐겨찾기 여부에 따라 이미지 바꿔준다.
//                            //var Img = UIImage()
//
//                            //즐겨찾기가 안되어 있을때
//                            if(isBook == "false"){
//                                //print("즐겨찾기 안되어있음")
//                                //Img = UIImage(named: "nonBook")!
//                                self.bookMarkImg.setImage(self.nonBookImg)
//                                //즐겨찾기가 되어있을때
//                            }else{
//                                //print("즐겨찾기 되어있음")
//
//                                //Img = UIImage(named: "Book")!
//                                self.bookMarkImg.setImage(self.bookImg)
//                            }
//                            // self.bookMarkImg.setImage(Img)
//                            //self.bookMarkImg.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
//
//                            self.bookMarkImg.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
//
//                            self.bookMarkImg.image = //self.bookMarkImg.image?.withRenderingMode(.alwaysTemplate)
//                                self.bookMarkImg.image?.withRenderingMode(.alwaysOriginal)
//
//                            //self.bookMarkImg.tintColor = UIColor.white
//                            //self.bookMarkBtn.backgroundColor = UIColor.white
//                            self.bookMarkBtn.addSubview(self.bookMarkImg)
//
//                            //즐겨찾기 추가혹은 해제 버튼
//                            self.bookMarkBtn.addTarget(self, action: #selector(self.booked), for: .touchUpInside)
//
//
//                            self.header.addSubview(self.bookMarkBtn)
//
//
//
//
//
//                            self.header.frame = CGRect(x: 0, y: Int(67.7), width: screenWidth, height: 224)
//
//                            //추후 그라데이션 적용
//                            self.header.backgroundColor = UIColor(displayP3Red: 111/255.0, green: 82/255.0, blue: 232/255.0, alpha: 1)
//
//                            //내용,신청방법,리뷰 버튼
//                            for i in 0..<3 {
//                                //버튼별 가로거리조정
//                                var distance : Double = 97.3
//                                let button = UIButton(type: .system)
//                                //어떤 버튼이 클릭됬는지 구분하기 위해 각 메뉴별 태그를 설정해준다.
//                                button.tag = i
//
//                                //폰트적용을 위한 버튼별 라벨 추가
//                                //라벨
//                                let label = UILabel()
//                                //각 카테고리 선택 라벨들을 배열에 저장한다
//                                self.categoryLabels.append(label)
//
//                                //밑줄용 추가레이어
//                                let bottomBorder = CALayer()
//
//                                label.layer.addSublayer(bottomBorder)
//                                self.underLines.append(bottomBorder)
//
//                                //글자가 긴 신청방법 버튼일 경우
//                                if(i == 1){
//                                    button.frame = CGRect(x:157, y:149, width: 61.3, height: 19.3)
//                                    label.frame = CGRect(x: 0, y: 0, width: 61.3, height: 19.3)
//                                    label.textAlignment = .center
//
//                                    //폰트지정 추가
//                                    label.text = self.LabelName[i]
//                                    label.textColor = .white
//                                    label.font = UIFont(name: "NanumGothicBold", size: 14.7)
//
//
//
//                                    button.addSubview(label)
//
//                                }else if(i == 0){
//                                    //정책내용을 보여주는 부분이 첫화면에 나온다.
//                                    //정책내용을
//                                    button.frame = CGRect(x:distance, y:149, width: 31, height: 19.3)
//                                    label.frame = CGRect(x: 0, y: 0, width: 31, height: 19.3)
//
//                                    label.textAlignment = .center
//
//                                    //폰트지정 추가
//                                    label.text = self.LabelName[i]
//                                    label.textColor = UIColor(displayP3Red: 255/255.0, green:236/255.0, blue: 188/255.0, alpha: 1)
//                                    label.font = UIFont(name: "NanumGothicBold", size: 14.7)
//                                    //
//                                    //                      let spacing = 2 // will be added as negative bottom margin for more spacing between label and line
//                                    //                let line = UIView()
//
//                                    //                //밑줄라벨
//                                    //                let underLabel = UILabel()
//                                    //
//                                    //                underLabel.frame = CGRect(x: 0, y: 6, width: 61.3, height: 19.3)
//                                    //                underLabel.text = "---"
//                                    //                              underLabel.textColor = .white
//
//                                    //                let attributedString = NSMutableAttributedString.init(string: LabelName[i])
//                                    //                attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: 1, range: NSRange.init(location: 0, length: attributedString.length))
//                                    //
//                                    //                underLabel.attributedText = attributedString
//                                    //
//
//
//                                    bottomBorder.borderColor = UIColor(displayP3Red: 255/255.0, green:236/255.0, blue: 188/255.0, alpha: 1).cgColor
//                                    bottomBorder.borderWidth = 0.5;
//                                    bottomBorder.frame = CGRect(x: 0, y: label.frame.height, width: label.frame.width, height: 1)
//                                    //label.layer.addSublayer(bottomBorder)
//
//                                    button.addSubview(label)
//
//                                }else{
//                                    ////print(distance)
//                                    button.frame = CGRect(x:247 , y:149, width: 61.3, height: 19.3)
//
//                                    label.frame = CGRect(x: 0, y: 0, width: 31, height: 19.3)
//
//                                    label.textAlignment = .center
//
//                                    //폰트지정 추가
//                                    label.text = self.LabelName[i]
//                                    label.textColor = .white
//                                    label.font = UIFont(name: "NanumGothicBold", size: 14.7)
//
//                                    button.addSubview(label)
//                                }
//
//
//                                //버튼 클릭이벤트 추가
//                                button.addTarget(self, action: #selector(self.selectMenu), for: .touchUpInside)
//                                self.header.addSubview(button)
//                                ////print(categoryLabels[i].text!)
//                            }
//
//                            self.m_Scrollview.addSubview(self.header)
//
//
//
//
//                            // //print(self.name)
//                            //지원대상
//                            let targetView = UIView()
//                            targetView.frame = CGRect(x: 20, y: 338.3, width: 335, height: 207.7)
//                            targetView.layer.cornerRadius = 16
//                            targetView.layer.borderWidth = 1
//                            targetView.layer.borderColor = UIColor(displayP3Red: 227/255.0, green:227/255.0, blue: 227/255.0, alpha: 1).cgColor
//
//                            //이미지뷰 추가
//                            let targetImgView = UIImageView()
//                            //        targetImgView.image = UIImage(named: "myImage")!.aspectFitImage(inRect:CGRect(x: 23.7, y: 23.3, width: 22, height: 22))
//                            //targetImgView.contentMode = .top
//                            targetImgView.image = UIImage(named: "target")
//                            targetImgView.contentMode = .center
//                            targetImgView.frame = CGRect(x: 26, y: 26, width: 69, height: 68.7)
//                            targetImgView.backgroundColor = UIColor(displayP3Red: 245/255.0, green:243/255.0, blue: 255/255.0, alpha: 1)
//                            targetImgView.layer.cornerRadius = targetImgView.frame.height/2
//                            targetImgView.layer.borderWidth = 1
//                            targetImgView.layer.borderColor = UIColor(displayP3Red: 245/255.0, green:243/255.0, blue: 255/255.0, alpha: 1).cgColor
//                            targetImgView.clipsToBounds = true
//                            targetView.addSubview(targetImgView)
//
//                            //라벨 추가
//                            let targetLabel = UILabel()
//                            targetLabel.frame = CGRect(x: 127.3, y: 49, width: 73.7, height: 23)
//                            targetLabel.text = "지원대상"
//                            targetLabel.textAlignment = .left
//                            targetLabel.font = UIFont(name: "NanumGothic", size: 18)
//                            targetView.addSubview(targetLabel)
//
//                            //지원대상 내용
//                            let TargetTextFrame = CGRect(x: 27.7, y: 112, width: 301.3, height: 47.7)
//                            let TargetText = UITextView(frame: TargetTextFrame)
//                            TargetText.isScrollEnabled = false
//
//                            //              let targetContent = UILabel()
//                            //        targetContent.frame = CGRect(x: 27.7, y: 112, width: 301.3, height: 47.7)
//                            TargetText.text = userlists.welf_target
//                            TargetText.font = UIFont(name: "NanumGothic", size: 16)
//                            targetView.addSubview(TargetText)
//
//
//                            self.m_Scrollview.addSubview(targetView)
//
//                            //지원내용
//                            let ContentsView = UIView()
//                            ContentsView.frame = CGRect(x: 20, y: 562.7, width: 335, height: 242.3)
//                            ContentsView.layer.cornerRadius = 16
//                            ContentsView.layer.borderWidth = 1
//                            ContentsView.layer.borderColor = UIColor(displayP3Red: 227/255.0, green:227/255.0, blue: 227/255.0, alpha: 1).cgColor
//
//                            //이미지뷰 추가
//                            let ContentsImgView = UIImageView()
//
//                            ContentsImgView.image = UIImage(named: "Contents")
//                            ContentsImgView.contentMode = .center
//                            ContentsImgView.frame = CGRect(x: 26, y: 26, width: 69, height: 68.7)
//                            ContentsImgView.backgroundColor = UIColor(displayP3Red: 245/255.0, green:243/255.0, blue: 255/255.0, alpha: 1)
//                            ContentsImgView.layer.cornerRadius = targetImgView.frame.height/2
//                            ContentsImgView.layer.borderWidth = 1
//                            ContentsImgView.layer.borderColor = UIColor(displayP3Red: 245/255.0, green:243/255.0, blue: 255/255.0, alpha: 1).cgColor
//                            ContentsImgView.clipsToBounds = true
//                            ContentsView.addSubview(ContentsImgView)
//
//                            //라벨 추가
//                            let ContentsLabel = UILabel()
//                            ContentsLabel.frame = CGRect(x: 127.3, y: 49, width: 73.7, height: 23)
//                            ContentsLabel.text = "지원내용"
//                            ContentsLabel.textAlignment = .left
//                            ContentsLabel.font = UIFont(name: "NanumGothic", size: 18)
//                            ContentsView.addSubview(ContentsLabel)
//
//                            //지원내용
//                            let ContentsTextFrame = CGRect(x: 27.7, y: 112, width: 301.3, height: 113)
//                            let ContentsText = UITextView(frame: ContentsTextFrame)
//                            ContentsText.isScrollEnabled = false
//
//                            //ContentsText.textContainer.lineBreakMode = .byTruncatingTail
//                            ContentsText.font = UIFont(name: "NanumGothic", size: 15)
//                            ContentsText.text = userlists.welf_contents
//                            //       ContentsText.textContainer.maximumNumberOfLines = 3
//                            //              ContentsText.textContainer.lineBreakMode = .byTruncatingTail
//                            //              ContentsText.layoutManager.textContainerChangedGeometry(ContentsText.textContainer)
//                            ContentsView.addSubview(ContentsText)
//                            //
//
//                            self.m_Scrollview.addSubview(ContentsView)
//
//                            //기간
//                            let DeadLineView = UIView()
//                            DeadLineView.frame = CGRect(x: 20, y: 821.7, width: 335, height: 156.3)
//                            DeadLineView.layer.cornerRadius = 16
//                            DeadLineView.layer.borderWidth = 1
//                            DeadLineView.layer.borderColor = UIColor(displayP3Red: 227/255.0, green:227/255.0, blue: 227/255.0, alpha: 1).cgColor
//
//                            //이미지뷰 추가
//                            let DeadLineImgView = UIImageView()
//
//                            DeadLineImgView.image = UIImage(named: "DeadLine")
//                            DeadLineImgView.contentMode = .center
//                            DeadLineImgView.frame = CGRect(x: 26, y: 26, width: 69, height: 68.7)
//                            DeadLineImgView.backgroundColor = UIColor(displayP3Red: 245/255.0, green:243/255.0, blue: 255/255.0, alpha: 1)
//                            DeadLineImgView.layer.cornerRadius = DeadLineImgView.frame.height/2
//                            DeadLineImgView.layer.borderWidth = 1
//                            DeadLineImgView.layer.borderColor = UIColor(displayP3Red: 245/255.0, green:243/255.0, blue: 255/255.0, alpha: 1).cgColor
//                            DeadLineImgView.clipsToBounds = true
//                            DeadLineView.addSubview(DeadLineImgView)
//
//                            //라벨 추가
//                            let DeadLineLabel = UILabel()
//                            DeadLineLabel.frame = CGRect(x: 127.3, y: 49, width: 73.7, height: 23)
//                            DeadLineLabel.text = "기간"
//                            DeadLineLabel.textAlignment = .left
//                            DeadLineLabel.font = UIFont(name: "NanumGothic", size: 18)
//                            DeadLineView.addSubview(DeadLineLabel)
//
//                            //지원대상 내용
//                            let DeadLineTextFrame = CGRect(x: 27.7, y: 112, width: 301.3, height: 47.7)
//                            let DeadLineText = UITextView(frame: DeadLineTextFrame)
//                            DeadLineText.isScrollEnabled = false
//
//                            DeadLineText.text = userlists.welf_period
//                            DeadLineText.font = UIFont(name: "NanumGothic", size: 16)
//                            DeadLineView.addSubview(DeadLineText)
//
//
//                            self.m_Scrollview.addSubview(DeadLineView)
//
//
//                            //문의
//                            let InquiryView = UIView()
//                            InquiryView.frame = CGRect(x: 20, y: 994.7, width: 335, height: 156.3)
//                            InquiryView.layer.cornerRadius = 16
//                            InquiryView.layer.borderWidth = 1
//                            InquiryView.layer.borderColor = UIColor(displayP3Red: 227/255.0, green:227/255.0, blue: 227/255.0, alpha: 1).cgColor
//
//                            //이미지뷰 추가
//                            let InquiryImgView = UIImageView()
//
//                            InquiryImgView.image = UIImage(named: "Inquiry")
//                            InquiryImgView.contentMode = .center
//                            InquiryImgView.frame = CGRect(x: 26, y: 26, width: 69, height: 68.7)
//                            InquiryImgView.backgroundColor = UIColor(displayP3Red: 245/255.0, green:243/255.0, blue: 255/255.0, alpha: 1)
//                            InquiryImgView.layer.cornerRadius = InquiryImgView.frame.height/2
//                            InquiryImgView.layer.borderWidth = 1
//                            InquiryImgView.layer.borderColor = UIColor(displayP3Red: 245/255.0, green:243/255.0, blue: 255/255.0, alpha: 1).cgColor
//                            InquiryImgView.clipsToBounds = true
//                            InquiryView.addSubview(InquiryImgView)
//
//                            //라벨 추가
//                            let InquiryLabel = UILabel()
//                            InquiryLabel.frame = CGRect(x: 127.3, y: 49, width: 73.7, height: 23)
//                            InquiryLabel.text = "문의"
//                            InquiryLabel.textAlignment = .left
//                            InquiryLabel.font = UIFont(name: "NanumGothic", size: 18)
//                            InquiryView.addSubview(InquiryLabel)
//
//                            //지원대상 내용
//                            let InquiryTextFrame = CGRect(x: 27.7, y: 112, width: 301.3, height: 47.7)
//                            let InquiryText = UITextView(frame: InquiryTextFrame)
//
//                            InquiryText.isScrollEnabled = false
//
//                            InquiryText.text = userlists.welf_contact
//                            InquiryText.font = UIFont(name: "NanumGothic", size: 16)
//                            InquiryView.addSubview(InquiryText)
//
//
//                            self.m_Scrollview.addSubview(InquiryView)
//
//
//
//
//                        }
//                        catch let DecodingError.dataCorrupted(context) {
//                            //print(context)
//                        } catch let DecodingError.keyNotFound(key, context) {
//                            //print("Key '\(key)' not found:", context.debugDescription)
//                            //print("codingPath:", context.codingPath)
//                        } catch let DecodingError.valueNotFound(value, context) {
//                            //print("Value '\(value)' not found:", context.debugDescription)
//                            //print("codingPath:", context.codingPath)
//                        } catch let DecodingError.typeMismatch(type, context)  {
//                            //print("Type '\(type)' mismatch:", context.debugDescription)
//                            //print("codingPath:", context.codingPath)
//                        } catch {
//                            //print("error: ", error)
//                        }
//
//                    case .failure(let error):
//                        //print("Error: \(error)")
//                        break
//
//
//                    }
//                }
//            //로고 추가
//            let LogoImg = UIImage(named: "appLogo")
//            appLogo.image = LogoImg
//            appLogo.frame = CGRect(x: 22.1, y: 26.7, width: 106, height: 14.3)
//            //self.view.addSubview(appLogo)
//            m_Scrollview.addSubview(appLogo)
//
//
//            //        //헤더라벨
//            //        headerLabel.frame = CGRect(x: 0, y: Int(52.3), width: screenWidth, height: 66)
//            //        headerLabel.textColor = UIColor.white
//            //        //폰트지정 추가
//            //
//            //        headerLabel.text = self.name
//            //        headerLabel.numberOfLines = 2
//            //
//            //        //라벨 줄간격 조절
//            //        let attrString = NSMutableAttributedString(string: headerLabel.text!)
//            //        let paragraphStyle = NSMutableParagraphStyle()
//            //        paragraphStyle.lineSpacing = 8
//            //        attrString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attrString.length))
//            //        headerLabel.attributedText = attrString
//            //        headerLabel.textAlignment = .center
//            //
//            //
//            //        headerLabel.font = UIFont(name: "Jalnan", size: 26)
//            //        // inquiryLabel.font = UIFont(name: "NanumGothicBold", size: 13.7)
//            //        // self.view.addSubview(inquiryLabel)
//            //        header.addSubview(headerLabel)
//            //
//            //
//            //        header.frame = CGRect(x: 0, y: Int(67.7), width: screenWidth, height: 224)
//            //
//            //        //추후 그라데이션 적용
//            //        header.backgroundColor = UIColor(displayP3Red: 111/255.0, green: 82/255.0, blue: 232/255.0, alpha: 1)
//            //
//            //        //내용,신청방법,리뷰 버튼
//            //        for i in 0..<3 {
//            //            //버튼별 가로거리조정
//            //            var distance : Double = 97.3
//            //            let button = UIButton(type: .system)
//            //            //어떤 버튼이 클릭됬는지 구분하기 위해 각 메뉴별 태그를 설정해준다.
//            //            button.tag = i
//            //
//            //            //폰트적용을 위한 버튼별 라벨 추가
//            //            //라벨
//            //            let label = UILabel()
//            //            //각 카테고리 선택 라벨들을 배열에 저장한다
//            //            categoryLabels.append(label)
//            //
//            //            //밑줄용 추가레이어
//            //            let bottomBorder = CALayer()
//            //
//            //            label.layer.addSublayer(bottomBorder)
//            //            underLines.append(bottomBorder)
//            //
//            //            //글자가 긴 신청방법 버튼일 경우
//            //            if(i == 1){
//            //                button.frame = CGRect(x:157, y:149, width: 61.3, height: 19.3)
//            //                label.frame = CGRect(x: 0, y: 0, width: 61.3, height: 19.3)
//            //                label.textAlignment = .center
//            //
//            //                //폰트지정 추가
//            //                label.text = LabelName[i]
//            //                label.textColor = .white
//            //                label.font = UIFont(name: "NanumGothicBold", size: 14.7)
//            //
//            //
//            //
//            //                button.addSubview(label)
//            //
//            //            }else if(i == 0){
//            //                //정책내용을 보여주는 부분이 첫화면에 나온다.
//            //                //정책내용을
//            //                button.frame = CGRect(x:distance, y:149, width: 31, height: 19.3)
//            //                label.frame = CGRect(x: 0, y: 0, width: 31, height: 19.3)
//            //
//            //                label.textAlignment = .center
//            //
//            //                //폰트지정 추가
//            //                label.text = LabelName[i]
//            //                label.textColor = UIColor(displayP3Red: 255/255.0, green:236/255.0, blue: 188/255.0, alpha: 1)
//            //                label.font = UIFont(name: "NanumGothicBold", size: 14.7)
//            //                //
//            //                //                      let spacing = 2 // will be added as negative bottom margin for more spacing between label and line
//            //                //                let line = UIView()
//            //
//            //                //                //밑줄라벨
//            //                //                let underLabel = UILabel()
//            //                //
//            //                //                underLabel.frame = CGRect(x: 0, y: 6, width: 61.3, height: 19.3)
//            //                //                underLabel.text = "---"
//            //                //                              underLabel.textColor = .white
//            //
//            //                //                let attributedString = NSMutableAttributedString.init(string: LabelName[i])
//            //                //                attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: 1, range: NSRange.init(location: 0, length: attributedString.length))
//            //                //
//            //                //                underLabel.attributedText = attributedString
//            //                //
//            //
//            //
//            //                bottomBorder.borderColor = UIColor(displayP3Red: 255/255.0, green:236/255.0, blue: 188/255.0, alpha: 1).cgColor
//            //                bottomBorder.borderWidth = 0.5;
//            //                bottomBorder.frame = CGRect(x: 0, y: label.frame.height, width: label.frame.width, height: 1)
//            //                //label.layer.addSublayer(bottomBorder)
//            //
//            //                button.addSubview(label)
//            //
//            //            }else{
//            //                ////print(distance)
//            //                button.frame = CGRect(x:247 , y:149, width: 61.3, height: 19.3)
//            //
//            //                label.frame = CGRect(x: 0, y: 0, width: 31, height: 19.3)
//            //
//            //                label.textAlignment = .center
//            //
//            //                //폰트지정 추가
//            //                label.text = LabelName[i]
//            //                label.textColor = .white
//            //                label.font = UIFont(name: "NanumGothicBold", size: 14.7)
//            //
//            //                button.addSubview(label)
//            //            }
//            //
//            //
//            //            //버튼 클릭이벤트 추가
//            //            button.addTarget(self, action: #selector(self.selectMenu), for: .touchUpInside)
//            //            header.addSubview(button)
//            //             ////print(categoryLabels[i].text!)
//            //        }
//            //
//            //        m_Scrollview.addSubview(header)
//
//
//            //지원대상등등 추가
//            //이미지뷰,라벨,내용,부가설명
//
//            //        //지원대상
//            //        let targetView = UIView()
//            //        targetView.frame = CGRect(x: 20, y: 338.3, width: 335, height: 207.7)
//            //        targetView.layer.cornerRadius = 16
//            //        targetView.layer.borderWidth = 1
//            //        targetView.layer.borderColor = UIColor(displayP3Red: 227/255.0, green:227/255.0, blue: 227/255.0, alpha: 1).cgColor
//            //
//            //        //이미지뷰 추가
//            //        let targetImgView = UIImageView()
//            //        //        targetImgView.image = UIImage(named: "myImage")!.aspectFitImage(inRect:CGRect(x: 23.7, y: 23.3, width: 22, height: 22))
//            //        //targetImgView.contentMode = .top
//            //        targetImgView.image = UIImage(named: "target")
//            //        targetImgView.contentMode = .center
//            //        targetImgView.frame = CGRect(x: 26, y: 26, width: 69, height: 68.7)
//            //        targetImgView.backgroundColor = UIColor(displayP3Red: 245/255.0, green:243/255.0, blue: 255/255.0, alpha: 1)
//            //        targetImgView.layer.cornerRadius = targetImgView.frame.height/2
//            //        targetImgView.layer.borderWidth = 1
//            //        targetImgView.layer.borderColor = UIColor(displayP3Red: 245/255.0, green:243/255.0, blue: 255/255.0, alpha: 1).cgColor
//            //        targetImgView.clipsToBounds = true
//            //        targetView.addSubview(targetImgView)
//            //
//            //        //라벨 추가
//            //        let targetLabel = UILabel()
//            //        targetLabel.frame = CGRect(x: 127.3, y: 49, width: 73.7, height: 23)
//            //        targetLabel.text = "지원대상"
//            //        targetLabel.textAlignment = .left
//            //        targetLabel.font = UIFont(name: "NanumGothic", size: 18)
//            //        targetView.addSubview(targetLabel)
//            //
//            //        //지원대상 내용
//            //        let TargetTextFrame = CGRect(x: 27.7, y: 112, width: 301.3, height: 47.7)
//            //        let TargetText = UITextView(frame: TargetTextFrame)
//            //        TargetText.isScrollEnabled = false
//            //
//            //        //              let targetContent = UILabel()
//            //        //        targetContent.frame = CGRect(x: 27.7, y: 112, width: 301.3, height: 47.7)
//            //        TargetText.text = self.target
//            //        TargetText.font = UIFont(name: "NanumGothic", size: 16)
//            //        targetView.addSubview(TargetText)
//            //
//            //
//            //        m_Scrollview.addSubview(targetView)
//            //
//            //        //지원내용
//            //        let ContentsView = UIView()
//            //        ContentsView.frame = CGRect(x: 20, y: 562.7, width: 335, height: 242.3)
//            //        ContentsView.layer.cornerRadius = 16
//            //        ContentsView.layer.borderWidth = 1
//            //        ContentsView.layer.borderColor = UIColor(displayP3Red: 227/255.0, green:227/255.0, blue: 227/255.0, alpha: 1).cgColor
//            //
//            //        //이미지뷰 추가
//            //        let ContentsImgView = UIImageView()
//            //
//            //        ContentsImgView.image = UIImage(named: "Contents")
//            //        ContentsImgView.contentMode = .center
//            //        ContentsImgView.frame = CGRect(x: 26, y: 26, width: 69, height: 68.7)
//            //        ContentsImgView.backgroundColor = UIColor(displayP3Red: 245/255.0, green:243/255.0, blue: 255/255.0, alpha: 1)
//            //        ContentsImgView.layer.cornerRadius = targetImgView.frame.height/2
//            //        ContentsImgView.layer.borderWidth = 1
//            //        ContentsImgView.layer.borderColor = UIColor(displayP3Red: 245/255.0, green:243/255.0, blue: 255/255.0, alpha: 1).cgColor
//            //        ContentsImgView.clipsToBounds = true
//            //        ContentsView.addSubview(ContentsImgView)
//            //
//            //        //라벨 추가
//            //        let ContentsLabel = UILabel()
//            //        ContentsLabel.frame = CGRect(x: 127.3, y: 49, width: 73.7, height: 23)
//            //        ContentsLabel.text = "지원내용"
//            //        ContentsLabel.textAlignment = .left
//            //        ContentsLabel.font = UIFont(name: "NanumGothic", size: 18)
//            //        ContentsView.addSubview(ContentsLabel)
//            //
//            //        //지원내용
//            //        let ContentsTextFrame = CGRect(x: 27.7, y: 112, width: 301.3, height: 113)
//            //        let ContentsText = UITextView(frame: ContentsTextFrame)
//            //        ContentsText.isScrollEnabled = false
//            //
//            //        //ContentsText.textContainer.lineBreakMode = .byTruncatingTail
//            //        ContentsText.font = UIFont(name: "NanumGothic", size: 15)
//            //        ContentsText.text = self.contents
//            //        //       ContentsText.textContainer.maximumNumberOfLines = 3
//            //        //              ContentsText.textContainer.lineBreakMode = .byTruncatingTail
//            //        //              ContentsText.layoutManager.textContainerChangedGeometry(ContentsText.textContainer)
//            //        ContentsView.addSubview(ContentsText)
//            //        //
//            //
//            //        m_Scrollview.addSubview(ContentsView)
//            //
//            //        //기간
//            //        let DeadLineView = UIView()
//            //        DeadLineView.frame = CGRect(x: 20, y: 821.7, width: 335, height: 156.3)
//            //        DeadLineView.layer.cornerRadius = 16
//            //        DeadLineView.layer.borderWidth = 1
//            //        DeadLineView.layer.borderColor = UIColor(displayP3Red: 227/255.0, green:227/255.0, blue: 227/255.0, alpha: 1).cgColor
//            //
//            //        //이미지뷰 추가
//            //        let DeadLineImgView = UIImageView()
//            //
//            //        DeadLineImgView.image = UIImage(named: "DeadLine")
//            //        DeadLineImgView.contentMode = .center
//            //        DeadLineImgView.frame = CGRect(x: 26, y: 26, width: 69, height: 68.7)
//            //        DeadLineImgView.backgroundColor = UIColor(displayP3Red: 245/255.0, green:243/255.0, blue: 255/255.0, alpha: 1)
//            //        DeadLineImgView.layer.cornerRadius = DeadLineImgView.frame.height/2
//            //        DeadLineImgView.layer.borderWidth = 1
//            //        DeadLineImgView.layer.borderColor = UIColor(displayP3Red: 245/255.0, green:243/255.0, blue: 255/255.0, alpha: 1).cgColor
//            //        DeadLineImgView.clipsToBounds = true
//            //        DeadLineView.addSubview(DeadLineImgView)
//            //
//            //        //라벨 추가
//            //        let DeadLineLabel = UILabel()
//            //        DeadLineLabel.frame = CGRect(x: 127.3, y: 49, width: 73.7, height: 23)
//            //        DeadLineLabel.text = "기간"
//            //        DeadLineLabel.textAlignment = .left
//            //        DeadLineLabel.font = UIFont(name: "NanumGothic", size: 18)
//            //        DeadLineView.addSubview(DeadLineLabel)
//            //
//            //        //지원대상 내용
//            //        let DeadLineTextFrame = CGRect(x: 27.7, y: 112, width: 301.3, height: 47.7)
//            //        let DeadLineText = UITextView(frame: DeadLineTextFrame)
//            //        DeadLineText.isScrollEnabled = false
//            //
//            //        DeadLineText.text = self.period
//            //        DeadLineText.font = UIFont(name: "NanumGothic", size: 16)
//            //        DeadLineView.addSubview(DeadLineText)
//            //
//            //
//            //        m_Scrollview.addSubview(DeadLineView)
//            //
//            //
//            //        //문의
//            //        let InquiryView = UIView()
//            //        InquiryView.frame = CGRect(x: 20, y: 994.7, width: 335, height: 156.3)
//            //        InquiryView.layer.cornerRadius = 16
//            //        InquiryView.layer.borderWidth = 1
//            //        InquiryView.layer.borderColor = UIColor(displayP3Red: 227/255.0, green:227/255.0, blue: 227/255.0, alpha: 1).cgColor
//            //
//            //        //이미지뷰 추가
//            //        let InquiryImgView = UIImageView()
//            //
//            //        InquiryImgView.image = UIImage(named: "Inquiry")
//            //        InquiryImgView.contentMode = .center
//            //        InquiryImgView.frame = CGRect(x: 26, y: 26, width: 69, height: 68.7)
//            //        InquiryImgView.backgroundColor = UIColor(displayP3Red: 245/255.0, green:243/255.0, blue: 255/255.0, alpha: 1)
//            //        InquiryImgView.layer.cornerRadius = InquiryImgView.frame.height/2
//            //        InquiryImgView.layer.borderWidth = 1
//            //        InquiryImgView.layer.borderColor = UIColor(displayP3Red: 245/255.0, green:243/255.0, blue: 255/255.0, alpha: 1).cgColor
//            //        InquiryImgView.clipsToBounds = true
//            //        InquiryView.addSubview(InquiryImgView)
//            //
//            //        //라벨 추가
//            //        let InquiryLabel = UILabel()
//            //        InquiryLabel.frame = CGRect(x: 127.3, y: 49, width: 73.7, height: 23)
//            //        InquiryLabel.text = "문의"
//            //        InquiryLabel.textAlignment = .left
//            //        InquiryLabel.font = UIFont(name: "NanumGothic", size: 18)
//            //        InquiryView.addSubview(InquiryLabel)
//            //
//            //        //지원대상 내용
//            //        let InquiryTextFrame = CGRect(x: 27.7, y: 112, width: 301.3, height: 47.7)
//            //        let InquiryText = UITextView(frame: InquiryTextFrame)
//            //
//            //        InquiryText.isScrollEnabled = false
//            //
//            //        InquiryText.text = self.contact
//            //        InquiryText.font = UIFont(name: "NanumGothic", size: 16)
//            //        InquiryView.addSubview(InquiryText)
//            //
//            //
//            //        m_Scrollview.addSubview(InquiryView)
//
//
//
//
//            for i in 0..<LabelName.count {
//
//                let button = UIButton(type: .system)
//                button.frame = CGRect(x:Double(20 + (313 * i)), y: 94.3, width: 293, height: 185)
//                button.backgroundColor = UIColor.white
//                //대분류 라벨
//                let categoryLbl = UILabel()
//                categoryLbl.frame = CGRect(x: 29.3, y: 26.7, width: 52.7, height: 29.3)
//                categoryLbl.textAlignment = .center
//                categoryLbl.backgroundColor =  UIColor(displayP3Red: 102/255.0, green:111/255.0, blue: 239/255.0, alpha: 1)
//                //폰트지정 추가
//                categoryLbl.text = "의료"
//                categoryLbl.textColor = UIColor.white
//                categoryLbl.layer.cornerRadius = 30
//
//                categoryLbl.font = UIFont(name: "NanumGothicBold", size: 14)
//
//                //정책명 라벨
//                let label = UILabel()
//                label.frame = CGRect(x: 29.3, y: 101, width: 163.3, height: 49)
//                label.textAlignment = .left
//                label.numberOfLines = 2
//                //폰트지정 추가
//                label.text = "\(Items[i])"
//                label.font = UIFont(name: "NanumGothic", size: 16.3)
//
//                //이미지
//                let img = UIImage(named: "addBtn")
//                let imgView = UIImageView(image: img)
//                imgView.frame = CGRect(x: 236.7, y: 26.7, width: 29.7, height: 29.3)
//
//                button.addSubview(categoryLbl)
//
//                button.addSubview(imgView)
//                button.addSubview(label)
//
//
//                button.layer.cornerRadius = 20
//
//                button.layer.borderWidth = 1.3
//                button.layer.borderColor = UIColor(displayP3Red: 227/255.0, green:227/255.0, blue: 227/255.0, alpha: 1).cgColor
//
//
//                relationScrollview.addSubview(button)
//
//
//            }
//            relationScrollview.backgroundColor = UIColor(displayP3Red: 241/255.0, green:243/255.0, blue: 252/255.0, alpha: 1)
//            relationScrollview.frame = CGRect( x: 0, y: Int(1197.7), width: screenWidth, height: 326)
//            relationScrollview.contentSize = CGSize(width:1000, height: 326)
//            relationScrollview.showsHorizontalScrollIndicator = false
//
//            m_Scrollview.addSubview(relationScrollview)
//
//
//            //스크롤 뷰. 추가
//            //m_Scrollview.showsHorizontalScrollIndicator = false
//            m_Scrollview.showsVerticalScrollIndicator = false
//            m_Scrollview.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
//            m_Scrollview.contentSize = CGSize(width:screenWidth, height: 1747)
//
//            self.view.addSubview(m_Scrollview)
//
//
//            //연관된 혜택 라벨
//            let relationLabel = UILabel()
//            relationLabel.frame = CGRect(x: 20, y: 1244.3, width: 102, height: 24.3)
//            relationLabel.textAlignment = .left
//            //폰트지정 추가
//            relationLabel.text = "연관된 혜택"
//            relationLabel.font = UIFont(name: "NanumGothic", size: 16.3)
//            m_Scrollview.addSubview(relationLabel)
//
//
//
//            //최하단 설명뷰(고객센터,개인정보 취급방침,이용약관등)
//            footer.frame = CGRect(x: 0, y: 1523.7, width: 375, height: 208.7)
//            footer.backgroundColor = UIColor(displayP3Red: 251/255.0, green: 251/255.0, blue: 251/255.0, alpha: 1)
//
//            //하단 뷰 너의 혜택은 이미지 뷰
//            //이미지 및 라벨 추가
//            let bottomImg = UIImage(named: "bottomImg")
//            let bottomImgView = UIImageView(image: bottomImg)
//            bottomImgView.frame = CGRect(x: 20.7, y: 31.7, width: 96.7, height: 17)
//            footer.addSubview(bottomImgView)
//
//            //하단 설명 라벨
//            let bottomLabel = UILabel()
//            //bottomLabel.frame = CGRect(x: 20.7, y: 58.3, width: 238.7, height: 12.7)
//            bottomLabel.frame = CGRect(x: 20.7, y: 58.3, width: 300, height: 12.7)
//            bottomLabel.textAlignment = .left
//            bottomLabel.textColor = UIColor(displayP3Red: 125/255.0, green: 125/255.0, blue: 125/255.0, alpha: 1)
//
//            bottomLabel.text = "사용자에게 알 맞는 복지 지원과 혜택을 알려드립니다"
//            bottomLabel.font = UIFont(name: "NanumGothic", size: 11)
//            footer.addSubview(bottomLabel)
//
//
//
//            //2번째 라벨
//            let bottomSecLabel = UILabel()
//            //bottomLabel.frame = CGRect(x: 20.7, y: 58.3, width: 238.7, height: 12.7)
//            bottomSecLabel.frame = CGRect(x: 20.7, y: 108.3, width: 300, height: 15)
//            bottomSecLabel.textAlignment = .left
//            bottomSecLabel.textColor = UIColor(displayP3Red: 125/255.0, green: 125/255.0, blue: 125/255.0, alpha: 1)
//
//            bottomSecLabel.text = "Copyright © All rights reserved"
//            bottomSecLabel.font = UIFont(name: "OpenSans-Bold", size: 11)
//            footer.addSubview(bottomSecLabel)
//
//            //하단 페이스북 버튼
//            let bottomFbBtn = UIButton(type: .system)
//            bottomFbBtn.frame = CGRect(x:20.7, y:143.3, width: 35.3, height: 35.3)
//            bottomFbBtn.backgroundColor = UIColor(displayP3Red: 233/255.0, green: 233/255.0, blue: 233/255.0, alpha: 1)
//            bottomFbBtn.layer.cornerRadius = 100
//
//            bottomFbBtn.layer.cornerRadius = bottomFbBtn.frame.height/2
//            bottomFbBtn.layer.borderWidth = 1
//            bottomFbBtn.layer.borderColor = UIColor.clear.cgColor
//            // 뷰의 경계에 맞춰준다
//            bottomFbBtn.clipsToBounds = true
//
//
//            //페이스북 로고이미지 추가
//            let fbImg = UIImage(named:"fbImg")
//            let fbImgView = UIImageView(image: fbImg)
//            fbImgView.frame = CGRect(x: 14.4, y: 10.5, width: 6.9, height: 13.8)
//
//            //각 상위뷰에 추가
//            bottomFbBtn.addSubview(fbImgView)
//            footer.addSubview(bottomFbBtn)
//
//
//            //하단 구글 버튼
//            let bottomGgBtn = UIButton(type: .system)
//            bottomGgBtn.frame = CGRect(x:64, y:143.3, width: 35.3, height: 35.3)
//            bottomGgBtn.backgroundColor = UIColor(displayP3Red: 233/255.0, green: 233/255.0, blue: 233/255.0, alpha: 1)
//            bottomGgBtn.layer.cornerRadius = 100
//
//            bottomGgBtn.layer.cornerRadius = bottomFbBtn.frame.height/2
//            bottomGgBtn.layer.borderWidth = 1
//            bottomGgBtn.layer.borderColor = UIColor.clear.cgColor
//            // 뷰의 경계에 맞춰준다
//            bottomGgBtn.clipsToBounds = true
//
//
//            //페이스북 로고이미지 추가
//            let GgImg = UIImage(named:"GgImg")
//            let GgImgView = UIImageView(image: GgImg)
//            GgImgView.frame = CGRect(x: 10.8, y: 10.5, width: 9.3, height: 13.8)
//
//            //각 상위뷰에 추가
//            bottomGgBtn.addSubview(GgImgView)
//            footer.addSubview(bottomGgBtn)
//
//            //앱스토어 추가
//            //애플
//            //로고
//            let appleImg = UIImage(named:"appleImg")
//            let appleImgView = UIImageView(image: appleImg)
//            appleImgView.frame = CGRect(x: 129, y: 153.7, width: 14.3, height: 17.3)
//
//            footer.addSubview(appleImgView)
//
//            //버튼
//            let appleBtn = UIButton(type: .system)
//            appleBtn.frame = CGRect(x:150.7, y:151.7, width: 70.3, height: 20.7)
//            appleBtn.backgroundColor = .clear
//            appleBtn.setTitle("App Store", for: .normal)
//            appleBtn.setTitleColor(UIColor(displayP3Red: 125/255.0, green: 125/255.0, blue: 125/255.0, alpha: 1), for: .normal)
//            appleBtn.titleLabel!.font = UIFont(name: "OpenSans-Semibold", size:14.3)
//            footer.addSubview(appleBtn)
//
//
//
//            //구글
//            //로고
//            let googleImg = UIImage(named:"googleImg")
//            let googleImgView = UIImageView(image: googleImg)
//            googleImgView.frame = CGRect(x: 235, y: 153.3, width: 16.7, height: 18)
//
//            footer.addSubview(googleImgView)
//
//            //버튼
//            let googleBtn = UIButton(type: .system)
//            googleBtn.frame = CGRect(x:258.7, y:151.3, width: 87.7, height: 20.7)
//            googleBtn.backgroundColor = .clear
//            googleBtn.setTitle("Google play", for: .normal)
//            googleBtn.setTitleColor(UIColor(displayP3Red: 125/255.0, green: 125/255.0, blue: 125/255.0, alpha: 1), for: .normal)
//            googleBtn.titleLabel!.font = UIFont(name: "OpenSans-Semibold", size:14.3)
//            footer.addSubview(googleBtn)
//
//
//
//            //하단 뷰 추가
//            m_Scrollview.addSubview(footer)
//
//
//            //임시 실제디바이스 크기별 레이아웃 조정
//        }else{
            
            //print("디바이스별 레이아웃 조정")
            //            var userEmail = UserDefaults.standard.string(forKey: "email")
            //            ////print("정책명:\(selectedPolicy)")
            //            //서버로부터 카테고리 데이터를 바다온다.
            //                let params = ["be_name":selectedPolicy, "email" : userEmail!]
            
            // var userEmail = UserDefaults.standard.string(forKey: "email")
            ////print("정책명:\(selectedPolicy)")qhrrlfsl12@gmail.com
            
            //서버로부터 카테고리 데이터를 바다온다.
            let params = ["type":"detail", "local" : selectedLocal , "welf_name" : selectedPolicy,  "login_token" : "eyJhbGciOiJzaGEyNTYiLCJ0eXAiOiJKd3QifS57ImlkZW50aWZpZXIiOiIwMDAxMzEuNWZkZmEwNjEzODE0NDgyNmJlNmJlZjdkNzhiZTg0ZWUuMDIyMiIsInRva2VuX21ha2UiOiIyMDIwLTEyLTA4IDE1OjQ0OjA0In0uMWJlNjBlZDBiMjFlNjBiNzIzMWFkNzg2MTg4Njk2ODBhNDU4YWI0N2Q4MDk0NTE5OTA2ZTc5MGU5YWEyMTVlNA=="]
            Alamofire.request("https://www.urbene-fit.com/welf", method: .get, parameters: params)
                                   .validate()
                                .responseJSON { [self] response in
                                       switch response.result {
                                       case .success(let value): ////print(value)
                                           ////print("정책 성공")
                                           ////print(value)
            
            
                                           do {
                                               let data = try JSONSerialization.data(withJSONObject: value, options: .prettyPrinted)
                                               let parseResult = try JSONDecoder().decode(parse.self, from: data)
                                            if(parseResult.Status == "200"){

                                                //혜택 id 저장
                                                welf_id = String(parseResult.Message[0].id)

                                            //즐겨찾기 여부를 저장
                                                isBook = parseResult.Message[0].isBookmark
                                            ////print(isBook)
                                            //print("즐겨찾기 여부:\(isBook)")
            
            
            //헤더라벨
            self.headerLabel.frame = CGRect(x: 0, y: Int(57.5), width: screenWidth, height: Int(72.6))
            self.headerLabel.textColor = UIColor.white
            //폰트지정 추가
            
           self.headerLabel.text = parseResult.Message[0].welf_name
            self.headerLabel.numberOfLines = 2
            
            //라벨 줄간격 조절
               let attrString = NSMutableAttributedString(string: self.headerLabel.text!)
                                            let paragraphStyle = NSMutableParagraphStyle()
                                            paragraphStyle.lineSpacing = 8
                                            attrString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attrString.length))
                                            self.headerLabel.attributedText = attrString
                                            self.headerLabel.textAlignment = .center
            
            
            self.headerLabel.font = UIFont(name: "Jalnan", size: 28.6)
//             inquiryLabel.font = UIFont(name: "NanumGothicBold", size: 13.7)
//             self.view.addSubview(inquiryLabel)
            self.header.addSubview(self.headerLabel)
            
            
            //즐겨찾기 추가
            //self.bookMarkBtn.frame = CGRect(x:screenWidth - 33, y: 0, width: 33, height: 33)
            
            self.bookMarkBtn.frame = CGRect(x:screenWidth - 54, y: 10, width: 44, height: 44)
            
            //button.setTitle(LabelName[i], for: .normal)
            //이미지 및 라벨 추가
            
            //즐겨찾기 여부에 따라 이미지 바꿔준다.
            
            //즐겨찾기가 안되어 있을때
            if(isBook == "false"){
                //print("즐겨찾기 안되어있음")
                //Img = UIImage(named: "nonBook")!
                self.bookMarkImg.setImage(self.nonBookImg)
                
                //즐겨찾기가 되어있을때
            }else{
                //print("즐겨찾기 되어있음")
                
                //Img = UIImage(named: "Book")!
                self.bookMarkImg.setImage(self.bookImg)
                
            }
            
            //  self.bookMarkImg.frame = CGRect(x: 0, y: 0, width: 33, height: 33)
            
            self.bookMarkImg.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
            
            
            
            self.bookMarkImg.image = self.bookMarkImg.image?.withRenderingMode(.alwaysOriginal)
            
            //self.bookMarkImg.tintColor = UIColor.white
            //self.bookMarkBtn.backgroundColor = UIColor.white
            self.bookMarkBtn.addSubview(self.bookMarkImg)
            
            //즐겨찾기 추가혹은 해제 버튼
            self.bookMarkBtn.addTarget(self, action: #selector(self.booked), for: .touchUpInside)
            
            
            self.header.addSubview(self.bookMarkBtn)
            
            // self.appLogo.addSubview(self.bookMarkBtn)
            
            
            
            self.header.frame = CGRect(x: 0, y: Int(74.4), width: screenWidth, height: Int(246.4))
            
            //추후 그라데이션 적용
            self.header.backgroundColor = UIColor(displayP3Red: 111/255.0, green: 82/255.0, blue: 232/255.0, alpha: 1)
            
            //내용,신청방법,리뷰 버튼
            for i in 0..<3 {
                //버튼별 가로거리조정
                var distance : Double = 107
                let button = UIButton(type: .system)
                //어떤 버튼이 클릭됬는지 구분하기 위해 각 메뉴별 태그를 설정해준다.
                button.tag = i
                
                //폰트적용을 위한 버튼별 라벨 추가
                //라벨
                let label = UILabel()
                //각 카테고리 선택 라벨들을 배열에 저장한다
                self.categoryLabels.append(label)
                
                //밑줄용 추가레이어
                let bottomBorder = CALayer()
                
                label.layer.addSublayer(bottomBorder)
                self.underLines.append(bottomBorder)
                
                //글자가 긴 신청방법 버튼일 경우
                if(i == 1){
                    button.frame = CGRect(x:172.7, y:163.9, width: 67.4, height: 21.2)
                    label.frame = CGRect(x: 0, y: 0, width: 67.4, height: 21.2)
                    label.textAlignment = .center
                    
                    //폰트지정 추가
                    label.text = self.LabelName[i]
                    label.textColor = .white
                    label.font = UIFont(name: "NanumGothicBold", size: 16.1)
                    
                    
                    
                    button.addSubview(label)
                    
                }else if(i == 0){
                    //정책내용을 보여주는 부분이 첫화면에 나온다.
                    //정책내용을
                    button.frame = CGRect(x:distance, y:163.9, width: 34.1, height: 21.2)
                    label.frame = CGRect(x: 0, y: 0, width: 34.1, height: 21.2)
                    
                    label.textAlignment = .center
                    
                    //폰트지정 추가
                    label.text = self.LabelName[i]
                    label.textColor = UIColor(displayP3Red: 255/255.0, green:236/255.0, blue: 188/255.0, alpha: 1)
                    label.font = UIFont(name: "NanumGothicBold", size: 16.1)
                    //
                    //                      let spacing = 2 // will be added as negative bottom margin for more spacing between label and line
                    //                let line = UIView()
                    
                    //                //밑줄라벨
                    //                let underLabel = UILabel()
                    //
                    //                underLabel.frame = CGRect(x: 0, y: 6, width: 61.3, height: 19.3)
                    //                underLabel.text = "---"
                    //                              underLabel.textColor = .white
                    
                    //                let attributedString = NSMutableAttributedString.init(string: LabelName[i])
                    //                attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: 1, range: NSRange.init(location: 0, length: attributedString.length))
                    //
                    //                underLabel.attributedText = attributedString
                    //
                    
                    
                    bottomBorder.borderColor = UIColor(displayP3Red: 255/255.0, green:236/255.0, blue: 188/255.0, alpha: 1).cgColor
                    bottomBorder.borderWidth = 0.5;
                    bottomBorder.frame = CGRect(x: 0, y: label.frame.height, width: label.frame.width, height: 1.1)
                    //label.layer.addSublayer(bottomBorder)
                    
                    button.addSubview(label)
                    
                }else{
                    ////print(distance)
                    button.frame = CGRect(x:271.7 , y:163.9, width: 67.4, height: 21.2)
                    
                    label.frame = CGRect(x: 0, y: 0, width: 34.1, height: 21.2)
                    
                    label.textAlignment = .center
                    
                    //폰트지정 추가
                    label.text = self.LabelName[i]
                    label.textColor = .white
                    label.font = UIFont(name: "NanumGothicBold", size: 16.1)
                    
                    button.addSubview(label)
                }
                
                
                //버튼 클릭이벤트 추가
                button.addTarget(self, action: #selector(self.selectMenu), for: .touchUpInside)
                self.header.addSubview(button)
                ////print(categoryLabels[i].text!)
            }
            
            self.m_Scrollview.addSubview(self.header)
            
            
            
            
            // //print(self.name)
            //지원대상
            let targetView = UIView()
            targetView.frame = CGRect(x: 22, y: 372.1, width: 368.5, height: 227.7)
            targetView.layer.cornerRadius = 16
            targetView.layer.borderWidth = 1
            targetView.layer.borderColor = UIColor(displayP3Red: 227/255.0, green:227/255.0, blue: 227/255.0, alpha: 1).cgColor
            
            //이미지뷰 추가
            let targetImgView = UIImageView()
            //        targetImgView.image = UIImage(named: "myImage")!.aspectFitImage(inRect:CGRect(x: 23.7, y: 23.3, width: 22, height: 22))
            //targetImgView.contentMode = .top
            targetImgView.image = UIImage(named: "target")
            targetImgView.contentMode = .center
            targetImgView.frame = CGRect(x: 28.6, y: 28.6, width: 75.9, height: 75.5)
            targetImgView.backgroundColor = UIColor(displayP3Red: 245/255.0, green:243/255.0, blue: 255/255.0, alpha: 1)
            targetImgView.layer.cornerRadius = targetImgView.frame.height/2
            targetImgView.layer.borderWidth = 1
            targetImgView.layer.borderColor = UIColor(displayP3Red: 245/255.0, green:243/255.0, blue: 255/255.0, alpha: 1).cgColor
            targetImgView.clipsToBounds = true
            targetView.addSubview(targetImgView)
            
            //라벨 추가
            let targetLabel = UILabel()
            targetLabel.frame = CGRect(x: 140, y: 53.9, width: 81, height: 25.3)
            targetLabel.text = "지원대상"
            targetLabel.textAlignment = .left
            targetLabel.font = UIFont(name: "NanumGothic", size: 19.8)
            targetView.addSubview(targetLabel)
            
            //지원대상 내용
            let TargetTextFrame = CGRect(x: 30.4, y: 123.2, width: 331.4, height: 52.4)
            let TargetText = UITextView(frame: TargetTextFrame)
            TargetText.isScrollEnabled = false
            
            //              let targetContent = UILabel()
            //        targetContent.frame = CGRect(x: 27.7, y: 112, width: 301.3, height: 47.7)
             TargetText.text = parseResult.Message[0].welf_target
            TargetText.font = UIFont(name: "NanumGothic", size: 17.6)
            targetView.addSubview(TargetText)
            
            
            //스크롤뷰에서 추가삭제를 위해  태그 추가
            targetView.tag = 31
            
            self.m_Scrollview.addSubview(targetView)
            
            //지원내용
            let ContentsView = UIView()
            ContentsView.frame = CGRect(x: 22, y: 619, width: 368.5, height: 266.5)
            ContentsView.layer.cornerRadius = 16
            ContentsView.layer.borderWidth = 1
            ContentsView.layer.borderColor = UIColor(displayP3Red: 227/255.0, green:227/255.0, blue: 227/255.0, alpha: 1).cgColor
            
            //이미지뷰 추가
            let ContentsImgView = UIImageView()
            
            ContentsImgView.image = UIImage(named: "Contents")
            ContentsImgView.contentMode = .center
            ContentsImgView.frame = CGRect(x: 28.6, y: 28.6, width: 76, height: 75.5)
            ContentsImgView.backgroundColor = UIColor(displayP3Red: 245/255.0, green:243/255.0, blue: 255/255.0, alpha: 1)
            ContentsImgView.layer.cornerRadius = targetImgView.frame.height/2
            ContentsImgView.layer.borderWidth = 1
            ContentsImgView.layer.borderColor = UIColor(displayP3Red: 245/255.0, green:243/255.0, blue: 255/255.0, alpha: 1).cgColor
            ContentsImgView.clipsToBounds = true
            ContentsView.addSubview(ContentsImgView)
            
            //라벨 추가
            let ContentsLabel = UILabel()
            ContentsLabel.frame = CGRect(x: 140, y: 54, width: 81, height: 25.3)
            ContentsLabel.text = "지원내용"
            ContentsLabel.textAlignment = .left
            ContentsLabel.font = UIFont(name: "NanumGothic", size: 18)
            ContentsView.addSubview(ContentsLabel)
            
            //지원내용
            let ContentsTextFrame = CGRect(x: 30.4, y: 123.2, width: 331.4, height: 124.3)
            let ContentsText = UITextView(frame: ContentsTextFrame)
            ContentsText.isScrollEnabled = false
            
            //ContentsText.textContainer.lineBreakMode = .byTruncatingTail
            ContentsText.font = UIFont(name: "NanumGothic", size: 16.5)
                 ContentsText.text = parseResult.Message[0].welf_contents
                   ContentsText.textContainer.maximumNumberOfLines = 3
                          ContentsText.textContainer.lineBreakMode = .byTruncatingTail
                          ContentsText.layoutManager.textContainerChangedGeometry(ContentsText.textContainer)
            ContentsView.addSubview(ContentsText)
            //
            
            
            //스크롤뷰에서 추가삭제를 위해  태그 추가
            ContentsView.tag = 32
            self.m_Scrollview.addSubview(ContentsView)
            
            //기간
            let DeadLineView = UIView()
            DeadLineView.frame = CGRect(x: 22, y: 903.8, width: 368.5, height: 171.9)
            DeadLineView.layer.cornerRadius = 16
            DeadLineView.layer.borderWidth = 1
            DeadLineView.layer.borderColor = UIColor(displayP3Red: 227/255.0, green:227/255.0, blue: 227/255.0, alpha: 1).cgColor
            
            //이미지뷰 추가
            let DeadLineImgView = UIImageView()
            
            DeadLineImgView.image = UIImage(named: "DeadLine")
            DeadLineImgView.contentMode = .center
            DeadLineImgView.frame = CGRect(x: 28.6, y: 28.6, width: 75.9, height: 75.5)
            DeadLineImgView.backgroundColor = UIColor(displayP3Red: 245/255.0, green:243/255.0, blue: 255/255.0, alpha: 1)
            DeadLineImgView.layer.cornerRadius = DeadLineImgView.frame.height/2
            DeadLineImgView.layer.borderWidth = 1
            DeadLineImgView.layer.borderColor = UIColor(displayP3Red: 245/255.0, green:243/255.0, blue: 255/255.0, alpha: 1).cgColor
            DeadLineImgView.clipsToBounds = true
            DeadLineView.addSubview(DeadLineImgView)
            
            //라벨 추가
            let DeadLineLabel = UILabel()
            DeadLineLabel.frame = CGRect(x: 140, y: 53.9, width: 81, height: 25.3)
            DeadLineLabel.text = "기간"
            DeadLineLabel.textAlignment = .left
            DeadLineLabel.font = UIFont(name: "NanumGothic", size: 19.8)
            DeadLineView.addSubview(DeadLineLabel)
            
            //지원대상 내용
            let DeadLineTextFrame = CGRect(x: 30.4, y: 123.2, width: 331.4, height: 52.4)
            let DeadLineText = UITextView(frame: DeadLineTextFrame)
            DeadLineText.isScrollEnabled = false
            
                 DeadLineText.text = parseResult.Message[0].welf_period
            DeadLineText.font = UIFont(name: "NanumGothic", size: 17.6)
            DeadLineView.addSubview(DeadLineText)
            
            //스크롤뷰에서 추가삭제를 위해  태그 추가
            DeadLineView.tag = 33
            self.m_Scrollview.addSubview(DeadLineView)
            
            
            //문의
            let InquiryView = UIView()
            InquiryView.frame = CGRect(x: 22, y: 1094.1, width: 368.5, height: 171.9)
            InquiryView.layer.cornerRadius = 16
            InquiryView.layer.borderWidth = 1
            InquiryView.layer.borderColor = UIColor(displayP3Red: 227/255.0, green:227/255.0, blue: 227/255.0, alpha: 1).cgColor
            
            //이미지뷰 추가
            let InquiryImgView = UIImageView()
            
            InquiryImgView.image = UIImage(named: "Inquiry")
            InquiryImgView.contentMode = .center
            InquiryImgView.frame = CGRect(x: 28.6, y: 28.6, width: 75.9, height: 75.5)
            InquiryImgView.backgroundColor = UIColor(displayP3Red: 245/255.0, green:243/255.0, blue: 255/255.0, alpha: 1)
            InquiryImgView.layer.cornerRadius = InquiryImgView.frame.height/2
            InquiryImgView.layer.borderWidth = 1
            InquiryImgView.layer.borderColor = UIColor(displayP3Red: 245/255.0, green:243/255.0, blue: 255/255.0, alpha: 1).cgColor
            InquiryImgView.clipsToBounds = true
            InquiryView.addSubview(InquiryImgView)
            
            //라벨 추가
            let InquiryLabel = UILabel()
            InquiryLabel.frame = CGRect(x: 140, y: 53.9, width: 80.3, height: 25.3)
            InquiryLabel.text = "문의"
            InquiryLabel.textAlignment = .left
            InquiryLabel.font = UIFont(name: "NanumGothic", size: 19.8)
            InquiryView.addSubview(InquiryLabel)
            
            //지원대상 내용
            let InquiryTextFrame = CGRect(x: 30.4, y: 123.2, width: 331.4, height: 52.4)
            let InquiryText = UITextView(frame: InquiryTextFrame)
            
            InquiryText.isScrollEnabled = false
            
                                                InquiryText.text = parseResult.Message[0].welf_contact
            InquiryText.font = UIFont(name: "NanumGothic", size: 17.6)
            InquiryView.addSubview(InquiryText)
            
            
            
            //스크롤뷰에서 추가삭제를 위해  태그 추가
            InquiryView.tag = 34
            self.m_Scrollview.addSubview(InquiryView)
            
            
            
                                           }
                        }
                                       catch let DecodingError.dataCorrupted(context) {
                                           //print(context)
                                       } catch let DecodingError.keyNotFound(key, context) {
                                           //print("Key '\(key)' not found:", context.debugDescription)
                                           //print("codingPath:", context.codingPath)
                                       } catch let DecodingError.valueNotFound(value, context) {
                                           //print("Value '\(value)' not found:", context.debugDescription)
                                           //print("codingPath:", context.codingPath)
                                       } catch let DecodingError.typeMismatch(type, context)  {
                                           //print("Type '\(type)' mismatch:", context.debugDescription)
                                           //print("codingPath:", context.codingPath)
                                       } catch {
                                           //print("error: ", error)
                                       }
            
                        case .failure(let error):
                                         //print("Error: \(error)")
                                         break
            
            
                                     }
                        }
            //로고 추가
//            let LogoImg = UIImage(named: "appLogo")
//            appLogo.image = LogoImg
//            appLogo.frame = CGRect(x: 24.3, y: 29.3, width: 116.6, height: 15.7)
//            //self.view.addSubview(appLogo)
//            m_Scrollview.addSubview(appLogo)
            
            
            
            
            
            for i in 0..<LabelName.count {
                
                let button = UIButton(type: .system)
                button.frame = CGRect(x:Double(22 + (Int(344.3) * i)), y: 103.7, width: 322.3, height: 230.5)
                button.backgroundColor = UIColor.white
                //대분류 라벨
                let categoryLbl = UILabel()
                categoryLbl.frame = CGRect(x: 32.2, y: 29.3, width: 57.9, height: 32.2)
                categoryLbl.textAlignment = .center
                categoryLbl.backgroundColor =  UIColor(displayP3Red: 102/255.0, green:111/255.0, blue: 239/255.0, alpha: 1)
                //폰트지정 추가
                categoryLbl.text = "의료"
                categoryLbl.textColor = UIColor.white
                categoryLbl.layer.cornerRadius = 33
                
                categoryLbl.font = UIFont(name: "NanumGothicBold", size: 15.4)
                
                //정책명 라벨
                let label = UILabel()
                label.frame = CGRect(x: 32.2, y: 111.1, width: 179.6, height: 53.9)
                label.textAlignment = .left
                label.numberOfLines = 2
                //폰트지정 추가
                label.text = "\(Items[i])"
                label.font = UIFont(name: "NanumGothic", size: 17.9)
                
                //이미지
                let img = UIImage(named: "addBtn")
                let imgView = UIImageView(image: img)
                imgView.frame = CGRect(x: 259.6, y: 29.3, width: 32.6, height: 32.2)
                
                button.addSubview(categoryLbl)
                
                button.addSubview(imgView)
                button.addSubview(label)
                
                
                button.layer.cornerRadius = 20
                
                button.layer.borderWidth = 1.3
                button.layer.borderColor = UIColor(displayP3Red: 227/255.0, green:227/255.0, blue: 227/255.0, alpha: 1).cgColor
                
                
                relationScrollview.addSubview(button)
                
                
                
                
                
                
            }
            
            
           
          
            relationScrollview.backgroundColor = UIColor(displayP3Red: 241/255.0, green:243/255.0, blue: 252/255.0, alpha: 1)
            relationScrollview.frame = CGRect( x: 0, y: Int(1317.4), width: screenWidth, height: Int(358.6))
            relationScrollview.contentSize = CGSize(width:1100, height: 358.6)
            relationScrollview.showsHorizontalScrollIndicator = false
            
            m_Scrollview.addSubview(relationScrollview)
            
            
            //스크롤 뷰. 추가
            m_Scrollview.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
            m_Scrollview.contentSize = CGSize(width:screenWidth, height: 1922)
            self.view.addSubview(m_Scrollview)
            
            
            //연관된 혜택 라벨
            let relationLabel = UILabel()
            relationLabel.frame = CGRect(x: 22, y: 1368.7, width: 112.2, height: 26.7)
            relationLabel.textAlignment = .left
            //폰트지정 추가
            relationLabel.text = "연관된 혜택"
            relationLabel.font = UIFont(name: "NanumGothic", size: 17.9)
            m_Scrollview.addSubview(relationLabel)
            
            
            
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
            
            bottomLabel.text = "사용자에게 알 맞는 복지 지원과 혜택을 알려드립니다"
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
            
            
            
       // }
        
        
    }
    
    //즐겨찾기 버튼을 눌렀을 때
    @objc func booked(_ sender: UIButton) {
        //  //print("즐겨찾기bv")
        
        //즐겨찾기를 추가하는 경우 isBook == "false"
        //if(!isFavorite){
        if(isBook == "false"){
            //print("즐겨찾기 추가")
            //즐겨찾기 추가했다는 정보를 서버로 보낸다.
            
            var userEmail = UserDefaults.standard.string(forKey: "email")
            //print("정책이름")
            //print(selectedPolicy)
            
            let parameters = ["email": userEmail!,"welf_name": selectedPolicy]
            
            Alamofire.request("http://3.34.4.196/backend/android/and_bookmark.php", method: .post, parameters: parameters)
                .validate()
                .responseString()
                //.responseJSON
                { response in
                    
                    switch response.result {
                    case .success(let value):
                        
                        
                        print(value)
                        
                        
                        
                    case .failure(let error):
                        print(error)
                    }
                }
            
            
            
            isFavorite =  true
            isBook = "true"
            //이미지를 변경한다.
            //let Img = UIImage(named: "Book")
            // self.bookMarkImg.setImage(Img!)
            self.bookMarkImg.setImage(self.bookImg)
            
            self.bookMarkImg.image = self.bookMarkImg.image?.withRenderingMode(.alwaysOriginal)
            
            //self.bookMarkImg.tintColor = UIColor.white
            
            //즐겨찾기 해제하는 경우isBook == "false"
            //}else if(isFavorite){
        }else if(isBook == "true"){
            //즐겨찾기 해제했다는 정보를 서버로 보낸다.
            //print("즐겨찾기 해제")
            
            var userEmail = UserDefaults.standard.string(forKey: "email")
            //print("정책이름")
            //print(selectedPolicy)
            
            let parameters = ["email": userEmail!,"welf_name": selectedPolicy]
            
            Alamofire.request("http://3.34.4.196/backend/android/and_bookmark.php", method: .post, parameters: parameters)
                .validate()
                .responseString()
                //.responseJSON
                { response in
                    
                    switch response.result {
                    case .success(let value):
                        
                        
                        print(value)
                        
                        
                        
                    case .failure(let error):
                        print(error)
                    }
                }
            isFavorite =  false
            isBook = "false"
            //이미지를 변경한다.
            //                let Img = UIImage(named: "nonBook")
            //                self.bookMarkImg.setImage(Img!)
            self.bookMarkImg.setImage(self.nonBookImg)
            
            
            self.bookMarkImg.image = self.bookMarkImg.image?.withRenderingMode(.alwaysOriginal)
            
            //self.bookMarkImg.tintColor = UIColor.white
            
        }
        
        
        
        
        
        
    }
    
    
    //상단메뉴를 선택했을때 이벤트 처리
    @IBAction func selectMenu(_ sender: UIButton) {
        //print("버튼선택")
        // //print(categoryLabels[sender.tag].text!)
        //상단 메뉴를 선택하면
        //어떤 메뉴를 선택했는지 표시해주는 부분에 변화를 준다.
        //각 카테고리 선택 라벨들을 배열에 저장한다
        //선택한 카테고리를 제외한 나머지는 다 기본색으로 처리해준다.
        for i in 0..<3 {
            ////print(categoryLabels[sender.tag].text!)
            
            //선택한 카테고리를 제외한 나머지는 다 기본색으로 처리해준다.
            if(i == sender.tag){
                ////print(categoryLabels[sender.tag].text!)
                
                categoryLabels[i].textColor =  UIColor(displayP3Red: 255/255.0, green:236/255.0, blue: 188/255.0, alpha: 1)
                //let bottomBorder = CALayer()
                underLines[i].borderWidth = 0.5
                underLines[i].frame = CGRect(x: 0, y: categoryLabels[i].frame.height, width: categoryLabels[i].frame.width, height: 1)
                underLines[i].borderColor = UIColor(displayP3Red: 255/255.0, green:236/255.0, blue: 188/255.0, alpha: 1).cgColor
                //categoryLabels[i].layer.addSublayer(bottomBorder)
                
                
            }else if(i != sender.tag){
                //선택한 카테고리를 선택되었음을 표시해준다.
                // //print(categoryLabels[sender.tag].text!)
                
                categoryLabels[i].textColor = .white
                
                //let bottomBorder = CALayer()
                underLines[i].borderWidth = 0
                underLines[i].frame = CGRect(x: 0, y: categoryLabels[i].frame.height, width: categoryLabels[i].frame.width, height: 0)
                
                // categoryLabels[i].layer.addSublayer(bottomBorder)
                
                
            }
            
            
        }
        
        //선택된 메뉴의 밑줄역할을 해주는 뷰의 테두리 처리
        
        //선택한 메뉴에 따라 하단의 내용도 바꿔준다.
        
        
        
        ////print("맞춤선택 선택!")
        //m_Scrollview.contentSize = CGSize(width:500, height: 2000)
        
        //리뷰버튼을 클릭하면 리뷰를 혜택에 등록된 리뷰를 보여준다.
        for subview in m_Scrollview.subviews {
            //기존의 더보기 버튼을 삭제하고
            if subview is UIView && subview.tag == 32 || subview is UIView && subview.tag == 31  || subview is UIView && subview.tag == 33 || subview is UIView && subview.tag == 34 {
                //print("삭제")
                subview.removeFromSuperview()
            }
            
            
            
        }
        
        //리뷰 클릭시 구조 변경(스크롤뷰 사용X)
        // self.view.subviews.forEach({ $0.removeFromSuperview() })
        
        
        
        
        
        
        //리뷰를 추가한다.
        //InquiryView   targetView.frame = CGRect(x: 22, y: 372.1, width: 368.5, height: 722)
        
        
        //리뷰작성하러 가기 버튼 추가
        var btnView = UIView()
        btnView.frame = CGRect(x:0, y: Int(372.1), width: screenWidth, height: 272)
        let writeBtn = UIButton(type: .system)
        
        
        writeBtn.frame = CGRect(x: screenWidth - 130, y: 65, width: 120, height: 50)
        
        writeBtn.layer.borderWidth = 1
        //        writeBtn.layer.borderColor =  UIColor(displayP3Red: 243/255.0, green: 243/255.0, blue: 243/255.0, alpha: 1).cgColor
        writeBtn.addTarget(self, action: #selector(self.write), for: .touchUpInside)
        
        writeBtn.setTitle("리뷰 쓰기", for: .normal)
        writeBtn.layer.cornerRadius = 13
        writeBtn.setTitleColor(UIColor.black, for: .normal)
        writeBtn.titleLabel!.font = UIFont(name: "Jalnan", size:16.1)
        
       btnView.addSubview(writeBtn)
        
        //리뷰 갯수 라벨
        var reviewCountLabel = UILabel()
        
        reviewCountLabel.frame = CGRect(x: 60, y: 10, width: 136, height: 30)
        reviewCountLabel.textAlignment = .center
        
        //폰트지정 추가
        reviewCountLabel.text = "총 231건"
        reviewCountLabel.font = UIFont(name: "Jalnan", size: 16.1)
        
        
        
        btnView.addSubview(reviewCountLabel)
        
        //별점라벨
        var gradeLabel = UILabel()
        
        gradeLabel.frame = CGRect(x: 60, y: 50, width: 136, height: 50)
        gradeLabel.textAlignment = .center
        
        //폰트지정 추가
        gradeLabel.text = "4.5점"
        gradeLabel.font = UIFont(name: "Jalnan", size: 37.1)
        
        
        
        
        
        
        
        btnView.addSubview(gradeLabel)
        
        //별점 이미지on
        for i in 0..<5 {

        let starImg = UIImage(named: "star_on")
        var starImgView = UIImageView()

        starImgView.setImage(starImg!)
        starImgView.frame = CGRect(x:(i * 50) + 10, y: 130, width: 40, height: 40)
        starImgView.image = starImgView.image?.withRenderingMode(.alwaysOriginal)
            btnView.addSubview(starImgView)

        }

        //혜택에 대한 의견들을 보여준다.

        //의견 라벨
        var opinionLabel = UILabel()
        
        opinionLabel.frame = CGRect(x:20, y: 230, width: 136, height: 20)
        opinionLabel.textAlignment = .left
        
        //폰트지정 추가
        opinionLabel.text = "신청이 어려웠어요"
        opinionLabel.font = UIFont(name: "Jalnan", size: 14.1)

        //하단 진행바

        let pv: UIProgressView = UIProgressView(frame: CGRect(x:0, y:230, width:150, height:20))
        pv.progressTintColor = UIColor.systemPink
        pv.trackTintColor = UIColor.white
        // Set the coordinates.
        pv.layer.position = CGPoint(x: self.view.frame.width/2 + 20, y: 240)
        // Set the height of the bar (1.0 times horizontally, 2.0 times vertically).
        pv.transform = CGAffineTransform(scaleX: 1.0, y: 2.0)
        // Set the progress degree (0.0 to 1.0).
        pv.progress = 0.0 // Add an animation.
        pv.setProgress(0.7, animated: true)
        
        //의견 퍼센트
        var perLabel = UILabel()
        
        perLabel.frame = CGRect(x: 330, y: 230, width: 50, height: 20)
        perLabel.textAlignment = .left
        
        //폰트지정 추가
        perLabel.text = "70%"
        perLabel.font = UIFont(name: "Jalnan", size: 14.1)

        btnView.addSubview(perLabel)

       btnView.addSubview(pv)
        btnView.addSubview(opinionLabel)

        
        
        
        
        self.m_Scrollview.addSubview(btnView)
        
        
        
        
        
        setReview()
        
        
        //        //이중 스크롤 문제 기존 스크롤뷰를 중지
        //        reViewTbView = UITableView(frame: CGRect(x: 22, y: 572.1, width: 368.5, height: 522))
        //
        //
        //
        //
        //        //푸터 설정resultTbView.tableFooterView = footer
        //
        //        //검색결과(필터링된) 정책들을 보여주는 테이블 뷰
        //        //        resultTbView = UITableView(frame: CGRect(x: 0, y: 150, width: 375, height: 400))
        //
        //
        //        //테이블뷰 레이아웃을 설정하기 위해서  Constraints을 풀어놓는다.
        //        reViewTbView.translatesAutoresizingMaskIntoConstraints = false
        //
        //        //테이블 셀간의 줄 없애기
        //        reViewTbView.separatorStyle = UITableViewCell.SeparatorStyle.none
        //        //커스텀 테이블뷰를 등록
        //        //myTableView.register(UITableViewCell.self, forCellReuseIdentifier: "MyCell")
        //
        //
        //        reViewTbView.register(ResultTableViewCell.self, forCellReuseIdentifier: ResultTableViewCell.identifier)
        //
        //        reViewTbView.dataSource = self
        //        reViewTbView.delegate = self
        //
        //        reViewTbView.rowHeight = 186
        //        //myTableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        //
        //        //self.view.addSubview(reViewTbView)
        //        self.m_Scrollview.addSubview(reViewTbView)
        //
        //
        //        //테이블 뷰 Constraints설정
        //
        //        let guide = view.safeAreaLayoutGuide
        //        NSLayoutConstraint.activate([
        //            reViewTbView.topAnchor.constraint(equalTo: guide.topAnchor),
        //            reViewTbView.leadingAnchor.constraint(equalTo: guide.leadingAnchor),
        //            reViewTbView.trailingAnchor.constraint(equalTo: guide.trailingAnchor),
        //            reViewTbView.bottomAnchor.constraint(equalTo: guide.bottomAnchor),
        //        ])
        //
        //        //테이블뷰 레이아웃을 설정하기 위해서  Constraints을 다시 고정
        //        reViewTbView.translatesAutoresizingMaskIntoConstraints = true
        
        
    }
    
    
    
    //테이블뷰 총 섹션 숫자
    func numberOfSections(in tableView: UITableView) -> Int { return 1 }
    
//    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
//         return UITableView.automaticDimension
//     }
//
//     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//         return UITableView.automaticDimension
//     }
//
//     func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//         cell.layoutIfNeeded()
//     }
//
//    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
//
//
//
//        return 500
//
//
//
//    }
    
    //셀 클릭이벤트
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print("리뷰 선택")
        
        //상세페이지로 이동한다.
//        //print("\(Items[indexPath.row])")
        
//        guard let RVC = self.storyboard?.instantiateViewController(withIdentifier: "DuViewController") as? DuViewController         else{
//
//            return
//
//        }
//        //RVC.selectedPolicy = "\(reviewItems[indexPath.row].content)"
//        //뷰 이동
//        RVC.modalPresentationStyle = .fullScreen
//
//        // 정책상세보기 페이지로 이동
//        //self.present(RVC, animated: true, completion: nil)
//        self.navigationController?.pushViewController(RVC, animated: true)
//
        
        //        tableView.deselectRow(at: indexPath, animated: false)
        //       // //print(indexPath)
        //        let p = tableView.cellForRow(at: indexPath) as! ResultTableViewCell
        //        //let cell = tableView.cellForRow(at: indexPath) as! ResultTableViewCell
        //
        ////
        ////        let cell = tableView.dequeueReusableCell(withIdentifier: "ResultTableViewCell", for: indexPath) as! ResultTableViewCell
        ////
        ////                    cell.policyName.textColor = UIColor.white
        //
        //
        //     //  if(p.policyName.text == "\(items[indexPath.section].sd[indexPath.row])"){
        //      if (p.backgroundColor == UIColor(red: 111/255.0, green: 82/255.0, blue: 232/255.0, alpha: 1.0)){
        ////        //클릭여부 판단
        //     //   if (){
        //            //let cell = tableView.cellForRow(at: indexPath) as! ResultTableViewCell
        //
        //            p.backgroundColor = UIColor.white
        //               p.policyName.textColor = UIColor.black
        //               p.plusImg.tintColor = UIColor.black
        //               p.plusImg.image = p.plusImg.image?.withRenderingMode(.alwaysTemplate)
        //
        //       }else{
        //            //let cell = tableView.cellForRow(at: indexPath) as! ResultTableViewCell
        //
        //            p.backgroundColor = UIColor(red: 111/255.0, green: 82/255.0, blue: 232/255.0, alpha: 1.0)
        //               p.policyName.textColor = UIColor.white
        //               p.plusImg.tintColor = UIColor.white
        //               p.plusImg.image = p.plusImg.image?.withRenderingMode(.alwaysTemplate)
        //        }
        
        
        //
        //   NSLog("You selected cell number: \(indexPath.row)!")
        
        
        //var (testName) = tasks[indexPath.row]
        //cell.textLabel?.text=testName
        
    }
    
    
    //테이블 셀 크기 조정
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        
        let imgurl = reviewItems[indexPath.row].image_url
         let url2 = URL(string: imgurl)

        var testBool : Bool
        if(imgurl != "없음"){
            testBool = true
        }else{
            
            
            
            testBool = false
            
        }
        
        switch testBool {
        case true:
            ////print("이미지 있는 경우")
          
            return 500
            
        case false:
           // //print("이미지 없는 경우")

            
            return 400
        }
        
    }
    
    //섹션별 로우 숫자
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //        for i in 0..<items.count {
        //
        //            return items[i].sd.count
        //            //firstItems.count
        //
        //        }
        
        //tableView.rowHeight = 200
        
        //print("테이블뷰 숫자: \(reviewItems.count)!")
        return reviewItems.count
        
        //    } else if section == 1 {
        //        return 0
        
        //} else { return 0 }
        
    }
    
    
    
    
    //테이블뷰의 셀을 만드는 메소드
    //테이블뷰의 셀이 어떤 커스텀셀을 참조하는지 지정해준다.
    //셀 만드는
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //print("셀 생성")
        //let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath)
        //        let cell = tableView.dequeueReusableCell(withIdentifier: "ReViewTableViewCell") as! ReViewTableViewCell
        //        cell.backgroundColor = UIColor.white
        //                     cell.clipsToBounds = true
        //
        //        //cell.plusImg.image = UIImage(named:"addBtn")
        //        let imgurl = reviewItems[indexPath.row].image_url
        //        if(imgurl != "없음"){
        //            //print("이미지 있음")
        //            let url = URL(string: imgurl)
        //            Alamofire.request(url!).responseImage { response in
        //
        //                  if response.data == nil {
        //
        //                        Alamofire.request("basic_image_URL").responseImage { response in
        //
        //                            cell.plusImg.image = UIImage(data: response.data!, scale:1)
        //                          }
        //                  } else {
        //                    cell.plusImg.image = UIImage(data: response.data!, scale:1)
        //                  }
        //
        //            }
        //
        //
        //        }
        
        
        
        //        let imgurl = reviewItems[indexPath.row].image_url
        //        var testBool : Bool
        //        if(imgurl != "없음"){
        //            testBool = true
        //
        //                            let url = URL(string: imgurl)
        //                        Alamofire.request(url!).responseImage { response in
        //
        //                              if response.data == nil {
        //
        //                                    Alamofire.request("basic_image_URL").responseImage { response in
        //
        //
        //
        //                                        cell.plusImg.image = UIImage(data: response.data!, scale:1)
        //                                        cell.plusImg.sizeToFit()
        //                                      }
        //                              } else {
        //
        //
        //
        //
        //                                cell.plusImg.image = UIImage(data: response.data!, scale:1)
        //
        //                                cell.plusImg.sizeToFit()
        //
        //                              }
        //                            cell.content.text = self.reviewItems[indexPath.row].content
        //
        //
        //                        }
        //
        //        }else{
        //
        //            cell.content.text = self.reviewItems[indexPath.row].content
        //
        //
        //            testBool = false
        //
        //        }
        //
        let imgurl = reviewItems[indexPath.row].image_url
        let writer = reviewItems[indexPath.row].writer
        let cellCase = (reviewItems[indexPath.row].image_url,reviewItems[indexPath.row].writer)

         let url2 = URL(string: imgurl)
        if let encoded = imgurl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let myURL = URL(string: encoded) {


               //print(myURL)


        }
        
        //4가지 경우에 따라 리뷰아이템을 구분한다.
    
        
        switch cellCase {
        //1.이미지가 있고, 작성자인경우
        case (let img,"17번학생") where img != "없음":
            //print("이미지가 있고, 작성자인경우")
            let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewBtnImgCell") as! ReviewBtnImgCell
                        if let encoded = imgurl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let myURL = URL(string: encoded) {
            
                            cell.plusImg.kf.setImage(with: myURL)
            
                               //print(myURL)
            
            
                        }
            
          
                        cell.content.text = self.reviewItems[indexPath.row].content
                       
            
                        cell.modifyBtn.tag = indexPath.row
            
                        // call the subscribeTapped method when tapped
                        cell.modifyBtn.addTarget(self, action: #selector(modify(_:)), for: .touchUpInside)
                        cell.deleteBtn.tag = indexPath.row
            
                        // call the subscribeTapped method when tapped
                        cell.deleteBtn.addTarget(self, action: #selector(deleteR(_:)), for: .touchUpInside)
            
            
            return cell
            
        //2,이미지가 없고, 작성자인 경우
        case (let img,"17번학생") where img == "없음":
            let cell = tableView.dequeueReusableCell(withIdentifier: "nonImgReViewTableViewCell") as! nonImgReViewTableViewCell
            
      


            cell.content.text = self.reviewItems[indexPath.row].content
           

            cell.modifyBtn.tag = indexPath.row

            // call the subscribeTapped method when tapped
            cell.modifyBtn.addTarget(self, action: #selector(modify(_:)), for: .touchUpInside)
            cell.deleteBtn.tag = indexPath.row

            // call the subscribeTapped method when tapped
            cell.deleteBtn.addTarget(self, action: #selector(deleteR(_:)), for: .touchUpInside)
            
            

            return cell
            
   
        //3.이미지가 있고, 작성자가 아닌 경우
        case (let img,let writer) where img != "없음" && writer != "17번학생":
            let cell = tableView.dequeueReusableCell(withIdentifier: "ReViewTableViewCell") as! ReViewTableViewCell

            if let encoded = imgurl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let myURL = URL(string: encoded) {

                cell.plusImg.kf.setImage(with: myURL)

                   //print(myURL)


            }


            cell.content.text = self.reviewItems[indexPath.row].content
           

            return cell
            
  
        //4.이미지가 없고, 작성자가 아닌경우
        case (let img,let writer) where img == "없음" && writer != "17번학생":

            let cell = tableView.dequeueReusableCell(withIdentifier: "Review_nonImg_nonBtn_Cell") as! Review_nonImg_nonBtn_Cell

        


            cell.content.text = self.reviewItems[indexPath.row].content
           

            
            return cell
        
       
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ReViewTableViewCell") as! ReViewTableViewCell

            return cell
        }
        
        var testBool : Bool = true
        
        //사용할 셀을 지정
        var selectCell : String
        
//        if(imgurl != "없음"){
//            //testBool.append(true)
//        }else{
//            //testBool.append(false)
//
//
//
//            //testBool = false
//
//        }
//
//        switch testBool {
//        case true:
//            //print("이미지 있는 경우")
//            let cell = tableView.dequeueReusableCell(withIdentifier: "ReViewTableViewCell") as! ReViewTableViewCell
//            cell.selectionStyle = .none
//            cell.backgroundColor = UIColor.white
////                        cell.layer.borderColor = UIColor(red: 227/255.0, green: 227/255.0, blue: 227/255.0, alpha: 1.0).cgColor
//                      // cell.layer.borderWidth = 1.3
//
//            //cell.clipsToBounds = true
//            //print(imgurl)
////
////            let url2 = URL(string : imgurl)
////            if url2 != nil {
////                DispatchQueue.global().async {
////                    let data = try? Data(contentsOf: url2!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
////                    DispatchQueue.main.async {
////                        if data != nil {
////                            cell.plusImg.image = UIImage(data:data!)
////                        }else{
////                            cell.plusImg.image = UIImage(named: "star_on")
////                        }
////                    }
////                }
////            }
//
//
//
//
//           // cell.plusImg.image = UIImage(named: "star_on")
//            if let encoded = imgurl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let myURL = URL(string: encoded) {
//
//                cell.plusImg.kf.setImage(with: myURL)
//
//                   //print(myURL)
//
//
//            }
//
//
//           // cell.plusImg.kf.setImage(with: imgurl)
//            // 기본 : imageView.kf.setImage(with: url)
//            //cell.plusImg.image = self.imgs[indexPath.row]
//           // cell.plusImg.sizeToFit()
//            cell.content.text = self.reviewItems[indexPath.row].content
//            //cell.content.text = "이 혜택 너무 좋았어요. 다들 꼭 써보세연 짱이에연 꼭 써보세요. 이 혜택 너무 좋았어요. 다들 꼭 써보세연 짱이에연 꼭 써보세요"
//
//            cell.modifyBtn.tag = indexPath.row
//
//            // call the subscribeTapped method when tapped
//            cell.modifyBtn.addTarget(self, action: #selector(modify(_:)), for: .touchUpInside)
//            cell.deleteBtn.tag = indexPath.row
//
//            // call the subscribeTapped method when tapped
//            cell.deleteBtn.addTarget(self, action: #selector(deleteR(_:)), for: .touchUpInside)
//
////            //작성자 확인
////            cell.modifyBtn.isHidden = false
////            cell.deleteBtn.isHidden = false
//
//
//            return cell
//
//        case false:
//            //let cell = tableView.dequeueReusableCell(withIdentifier: "nonImgReViewTableViewCell") as! nonImgReViewTableViewCell
//
//           // let cell = tableView.dequeueReusableCell(withIdentifier: "nonImgReViewTableViewCell") as! nonImgReViewTableViewCell
//           let cell = tableView.dequeueReusableCell(withIdentifier: "ReViewTableViewCell") as! ReViewTableViewCell
////            cell.layer.borderColor = UIColor.red.cgColor
////
//          //  cell.layer.borderWidth = 1.3
//            cell.selectionStyle = .none
//
//            //print("이미지 없는 경우")
//
//            cell.backgroundColor = UIColor.white
//
//            cell.clipsToBounds = true
//            cell.content.text = reviewItems[indexPath.row].content
//
//
//
//
//            //작성자 확인
//            if(self.reviewItems[indexPath.row].writer == "17번학생"){
//                //print("작성자 일치")
//
//
////                cell.addButton()
////                cell.btnLayout()
//
//
//                cell.modifyBtn.tag = indexPath.row
//
//                // call the subscribeTapped method when tapped
//                cell.modifyBtn.addTarget(self, action: #selector(modify(_:)), for: .touchUpInside)
//                cell.deleteBtn.tag = indexPath.row
//
//                // call the subscribeTapped method when tapped
//                cell.deleteBtn.addTarget(self, action: #selector(deleteR(_:)), for: .touchUpInside)
//
//            }
//
//
//
////            cell.modifyBtn.isHidden = true
////                     cell.deleteBtn.isHidden = true
//
//
//            return cell
//        }
        
        // return cell
        
        
        //cell.textLabel?.text = "\(firstItems[indexPath.row])"
        //cell.policyLank.text = String(indexPath.row)
        //        let imgurl = reviewItems[indexPath.row].image_url
        //        //print(imgurl)
        //        if(true){
        //        let cell = tableView.dequeueReusableCell(withIdentifier: ReViewTableViewCell.identifier, for: indexPath) as! ReViewTableViewCell
        //        }else{
        //            let cell = tableView.dequeueReusableCell(withIdentifier: ReViewTableViewCell.identifier, for: indexPath) as! ReViewTableViewCell
        //
        //        }
        //        cell.backgroundColor = UIColor.white
        //
        //        cell.clipsToBounds = true
        //        //사진있는지 여부 확인후
        //        if(imgurl != "없음"){
        //
        //            //cell = tableView.dequeueReusableCell(withIdentifier: ReViewTableViewCell.identifier, for: indexPath) as! ReViewTableViewCell
        //
        //
        //            let url = URL(string: imgurl)
        //        Alamofire.request(url!).responseImage { response in
        //
        //              if response.data == nil {
        //
        //                    Alamofire.request("basic_image_URL").responseImage { response in
        //
        ////
        ////                        cell.addContentView()
        ////
        ////                        cell.autoLayout(true)
        //
        //                        cell.plusImg.image = UIImage(data: response.data!, scale:1)
        //                        cell.plusImg.sizeToFit()
        //                      }
        //              } else {
        //
        //               let cell = tableView.dequeueReusableCell(withIdentifier: ReViewTableViewCell.identifier, for: indexPath) as! ReViewTableViewCell
        //
        //
        //                cell.backgroundColor = UIColor.white
        //
        //                cell.clipsToBounds = true
        //
        //
        ////                cell.addContentView()
        ////
        ////                cell.autoLayout(true)
        //                cell.plusImg.image = UIImage(data: response.data!, scale:1)
        //
        //                cell.plusImg.sizeToFit()
        //
        //              }
        //            cell.content.text = self.reviewItems[indexPath.row].content
        //
        //
        //        }
        //        }else{
        //
        //
        //
        //
        //            cell2.backgroundColor = UIColor.white
        //
        //            cell2.clipsToBounds = true
        //            cell.content.text = reviewItems[indexPath.row].content
        //
        ////            cell.addContentView()
        ////
        ////            cell.autoLayout(false)
        //
        //        }
        //
        //        //print("테이블뷰 내용: \(reviewItems[indexPath.row].content)!")
        //        return cell
        
        
    }
    
    
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        // Print message ID.
        
        
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        
        // Print full message.
        //print("백그라운드 메시지 수신")
        //viewcontrol 이동
        let userInfo2 = response.notification.request.content.userInfo
        let title = response.notification.request.content.title
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SecondTypeNotification"),
                                        object: title, userInfo: userInfo2)
        
        
        completionHandler()
        
    }
    
    
    //
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let yOffset = scrollView.contentOffset.y
        
        if scrollView == self.m_Scrollview {
            
            //테이블뷰에 도달했을떄
            if yOffset >= 572 {
                m_Scrollview.isScrollEnabled = false
                reViewTbView.isScrollEnabled = true
            }
        }
        
        if scrollView == self.reViewTbView {
            if yOffset <= 0 {
                self.m_Scrollview.isScrollEnabled = true
                self.reViewTbView.isScrollEnabled = false
            }
        }
    }
    
    
    //리뷰 테이블 세팅
    func setReview(){
        //이중 스크롤 문제 기존 스크롤뷰를 중지
        //리뷰 파싱
        //리뷰데이터를 받아온다.
        //결과페이지에 사용할 데이터를 서버로부터 받아온다.
    let parameters = ["type": "list","welf_id": "1019"]
        
        Alamofire.request("https://www.urbene-fit.com/review", method: .get, parameters: parameters)
            .validate()
            .responseJSON { [self] response in
                
                switch response.result {
                case .success(let value):
                    //print("리뷰 성공")
                    //print(value)
                    do {
                        let data = try JSONSerialization.data(withJSONObject: value, options: .prettyPrinted)
                        let resultList = try JSONDecoder().decode(reviewParse.self, from: data)
                        
                        //리뷰데이터를 테이블아이템에 추가해준다.
                        for i in 0..<resultList.Message.count {
                            //print(resultList.Message[i].image_url)
                            //                                        self.reviewItems.append(reviewItem.init(content: resultList.retBody[i].content,  email: resultList.retBody[i].email, like_count: resultList.retBody[i].like_count, bad_count: resultList.retBody[i].bad_count, star_count: resultList.retBody[i].star_count))
                            //
                            self.reviewItems.append(reviewItem.init(content: resultList.Message[i].content,image_url : resultList.Message[i].image_url, id: resultList.Message[i].id, writer : resultList.Message[i].writer))
                            
                            
                            //print("리뷰 내용: \(self.reviewItems[i].content)!")
                            
                            ////print(resultList.retBody[0].content)
                            ////print("Key '\(resultList.retBody[0].content)' not found:")
                            
                            //경로상의 이미지를 미리 다운받아 만들어놓는다.
                          //속도를 못따라감

//                                if(i == resultList.retBody.count - 1 ){
//                                    self.urlPhoto()
//                                }
                        }
                        
                        reViewTbView = UITableView(frame: CGRect(x: 0, y: 644 , width: screenWidth, height: 522))
                        
                      
                        reViewTbView.separatorStyle = UITableViewCell.SeparatorStyle.none
                        //커스텀 테이블뷰를 등록
                        //myTableView.register(UITableViewCell.self, forCellReuseIdentifier: "MyCell")
                        
                        
                        reViewTbView.register(ReViewTableViewCell.self, forCellReuseIdentifier: ReViewTableViewCell.identifier)
                        reViewTbView.register(nonImgReViewTableViewCell.self, forCellReuseIdentifier: nonImgReViewTableViewCell.identifier)
                        reViewTbView.register(ReviewBtnImgCell.self, forCellReuseIdentifier: ReviewBtnImgCell.identifier)
                        reViewTbView.register(Review_nonImg_nonBtn_Cell.self, forCellReuseIdentifier: Review_nonImg_nonBtn_Cell.identifier)
                        
                        reViewTbView.dataSource = self
                        reViewTbView.delegate = self
                        
                     
                        self.m_Scrollview.addSubview(reViewTbView)
                        
                        
                        
                    }
                    catch let DecodingError.dataCorrupted(context) {
                        //print(context)
                    } catch let DecodingError.keyNotFound(key, context) {
                        //print("Key '\(key)' not found:", context.debugDescription)
                        //print("codingPath:", context.codingPath)
                    } catch let DecodingError.valueNotFound(value, context) {
                        //print("Value '\(value)' not found:", context.debugDescription)
                        //print("codingPath:", context.codingPath)
                    } catch let DecodingError.typeMismatch(type, context)  {
                        //print("Type '\(type)' mismatch:", context.debugDescription)
                        //print("codingPath:", context.codingPath)
                    } catch {
                        //print("error: ", error)
                    }
                case .failure(let error):
                    print(error)
                }
            }
        
        
     
        
        
        //테이블 뷰 Constraints설정
        
//        let guide = view.safeAreaLayoutGuide
//        NSLayoutConstraint.activate([
//            reViewTbView.topAnchor.constraint(equalTo: guide.topAnchor),
//            reViewTbView.leadingAnchor.constraint(equalTo: guide.leadingAnchor),
//            reViewTbView.trailingAnchor.constraint(equalTo: guide.trailingAnchor),
//            reViewTbView.bottomAnchor.constraint(equalTo: guide.bottomAnchor),
//        ])
//
//        //테이블뷰 레이아웃을 설정하기 위해서  Constraints을 다시 고정
//        reViewTbView.translatesAutoresizingMaskIntoConstraints = true
        
    }
    
    //셀 수정 버튼
    @objc func modify(_ sender: UIButton) {
        //print("수정")
        
        
        guard let RVC = self.storyboard?.instantiateViewController(withIdentifier: "ReViewViewController") as? ReViewViewController         else{
            
            return
            
        }
        //뷰 이동
        RVC.modalPresentationStyle = .fullScreen
        
        //수정
        RVC.modify = true
        RVC.modifyContent = reviewItems[sender.tag].content
        RVC.review_id = reviewItems[sender.tag].id

        
        
        //리뷰작성 페이지로 이동
       // self.present(RVC, animated: true, completion: nil)
        self.navigationController?.pushViewController(RVC, animated: true)
        
        
        
    }
    
    //리뷰 삭제
    @objc func deleteR(_ sender: UIButton) {
        //print("삭제")
        
        
        
        var id : Int = reviewItems[sender.tag].id
        //print("삭제id: \(id)")
        
        let parameters  : Parameters = ["login_token": "eyJhbGciOiJzaGEyNTYiLCJ0eXAiOiJKd3QifS57InVzZXJuYW1lIjoiZW1haWwiLCJ0b2tlbl9tYWtlIjoiMjAyMC0xMi0wNiAxNToxMDoyMSJ9Ljk5N2VhNGE5YzMxMTc4NTdjMjZlZWNmNmE3ODg4NDExZGYyM2EwZGI3MWU4NzM3Mjg2ZGNkNDU0OWFkM2ZmZTA=","review_id": id, "type" : "delete"]

        Alamofire.request("https://www.urbene-fit.com/review", method: .post, parameters: parameters)
            .validate()
            .responseJSON { response in
                
                switch response.result {
                case .success(let value):
                    ////print(value)
//                    if let data = response.data, let responseString = String(data: data, encoding: .utf8) {
//                                          //print(responseString)
//                                      }
//
                    if let json = value as? [String: Any] {
                                  //print(json)
                    for (key, value) in json {
             
                        //리뷰가 삭제되면,테이블뷰롤 갱신해준다.
                        if(key == "Status" && value as! String == "200"){
                            
                            //테이블뷰 데이터 아이템에서 삭제해준다.
                            self.reviewItems.remove(at: id)
                            
                            self.reViewTbView.reloadData()

                        }
                        
                        
              
            }
            //데이터가 모두 실리면 데이터와함계 뷰컨트롤러를 이동한다.
//
                        
                        
                        
                        
}
                    
                    
                 case .failure(let error):
                     print(error)
                 }
                 
                 
                 
             }
        
        
        
        
//        let parameterDict = NSMutableDictionary()
//        parameterDict.setValue("eyJhbGciOiJzaGEyNTYiLCJ0eXAiOiJKd3QifS57ImlkZW50aWZpZXIiOiIwMDAxMzEuNWZkZmEwNjEzODE0NDgyNmJlNmJlZjdkNzhiZTg0ZWUuMDIyMiIsInRva2VuX21ha2UiOiIyMDIwLTEyLTA4IDE1OjQ0OjA0In0uMWJlNjBlZDBiMjFlNjBiNzIzMWFkNzg2MTg4Njk2ODBhNDU4YWI0N2Q4MDk0NTE5OTA2ZTc5MGU5YWEyMTVlNA==", forKey: "login_token")
//            parameterDict.setValue(id, forKey: "review_id")
        //encoding: URLEncoding.httpBody
        
      //  let parameters : Parameters = ["login_token": "eyJhbGciOiJzaGEyNTYiLCJ0eXAiOiJKd3QifS57InVzZXJuYW1lIjoiZW1haWwiLCJ0b2tlbl9tYWtlIjoiMjAyMC0xMi0wNiAxNToxMDoyMSJ9Ljk5N2VhNGE5YzMxMTc4NTdjMjZlZWNmNmE3ODg4NDExZGYyM2EwZGI3MWU4NzM3Mjg2ZGNkNDU0OWFkM2ZmZTA=","review_id": 5]
//        let data : Data = "login_token=eyJhbGciOiJzaGEyNTYiLCJ0eXAiOiJKd3QifS57InVzZXJuYW1lIjoiZW1haWwiLCJ0b2tlbl9tYWtlIjoiMjAyMC0xMi0wNiAxNToxMDoyMSJ9Ljk5N2VhNGE5YzMxMTc4NTdjMjZlZWNmNmE3ODg4NDExZGYyM2EwZGI3MWU4NzM3Mjg2ZGNkNDU0OWFkM2ZmZTA=&review_id=\(5)".data(using: .utf8)!

       // let parameters : Parameters = ["login_token": "eyJhbGciOiJzaGEyNTYiLCJ0eXAiOiJKd3QifS57InVzZXJuYW1lIjoiZW1haWwiLCJ0b2tlbl9tYWtlIjoiMjAyMC0xMi0wNiAxNToxMDoyMSJ9Ljk5N2VhNGE5YzMxMTc4NTdjMjZlZWNmNmE3ODg4NDExZGYyM2EwZGI3MWU4NzM3Mjg2ZGNkNDU0OWFkM2ZmZTA=","review_id": 6]
//        let headers = [
//            "Content-Type": "application/x-www-form-urlencoded;charset=utf-8"
//        ]
//        Alamofire.request("https://www.urbene-fit.com/review", method: .delete,parameters: parameters, encoding: JSONEncoding.self as! ParameterEncoding, headers: headers)
//                .validate()
//                .responseJSON { response in
//
//                    switch response.result {
//                    case .success(let value):
//                        //print("리뷰 삭제성공")
//                        //print(value)
//
//                    case .failure(let error):
//                                     //print("Error: \(error)")
//                                     break
//
//
//                                 }
//                    }
    
//        Alamofire.request("https://www.urbene-fit.com/review",method: .delete, parameters: ["login_token": "eyJhbGciOiJzaGEyNTYiLCJ0eXAiOiJKd3QifS57InVzZXJuYW1lIjoiZW1haWwiLCJ0b2tlbl9tYWtlIjoiMjAyMC0xMi0wNiAxNToxMDoyMSJ9Ljk5N2VhNGE5YzMxMTc4NTdjMjZlZWNmNmE3ODg4NDExZGYyM2EwZGI3MWU4NzM3Mjg2ZGNkNDU0OWFkM2ZmZTA=","review_id": 6])
//                .validate(contentType: ["application/x-www-form-urlencoded"])
//                .responseJSON { (response) in
//
//                    switch response.result {
//                                   case .success(let value):
//                                       //print("리뷰 삭제성공")
//                                       //print(value)
//
//                                   case .failure(let error):
//                                                    //print("Error: \(error)")
//                                                    break
//
//
//                                                }
//            }
        
        
        
//        let url = URL(string: "https://www.urbene-fit.com/review")!
//
//        var request = URLRequest(url: url)
//        request.httpMethod = "delete"
//        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
//
//
//
//        let myParams = "login_token=eyJhbGciOiJzaGEyNTYiLCJ0eXAiOiJKd3QifS57InVzZXJuYW1lIjoiZW1haWwiLCJ0b2tlbl9tYWtlIjoiMjAyMC0xMi0wNiAxNToxMDoyMSJ9Ljk5N2VhNGE5YzMxMTc4NTdjMjZlZWNmNmE3ODg4NDExZGYyM2EwZGI3MWU4NzM3Mjg2ZGNkNDU0OWFkM2ZmZTA=&review_id=\(6)"
//      //  let postData = myParams.data(using: String.Encoding.utf8, allowLossyConversion: true)
//        let postData = myParams.data(using: String.Encoding.utf8)
//        let postLength = String(format: "%d", postData!.count)
//
//      //  request.httpBody = try! JSONSerialization.data(withJSONObject: values)
//        request.httpBody = postData
//
//
//        Alamofire.request(request)
//        .responseJSON { response in
//               // do whatever you want here
//               switch response.result {
//               case .failure(let error):
//                   //print(error)
//                    //print("에러")
//                   if let data = response.data, let responseString = String(data: data, encoding: .utf8) {
//                       //print(responseString)
//                   }
//               case .success(let responseObject):
//                   //print(responseObject)
//                //print("성공")
//
//               }
//        }
        
        
        
        
//
//       let parameters : Parameters = ["login_token": "eyJhbGciOiJzaGEyNTYiLCJ0eXAiOiJKd3QifS57InVzZXJuYW1lIjoiZW1haWwiLCJ0b2tlbl9tYWtlIjoiMjAyMC0xMi0wNiAxNToxMDoyMSJ9Ljk5N2VhNGE5YzMxMTc4NTdjMjZlZWNmNmE3ODg4NDExZGYyM2EwZGI3MWU4NzM3Mjg2ZGNkNDU0OWFkM2ZmZTA=","review_id": 6]
////
//        Alamofire.request("https://www.urbene-fit.com/review", method: .delete, parameters: parameters, encoding:  URLEncoding.httpBody, headers: headers).responseJSON { (response:DataResponse<Any>) in
//
//            switch(response.result) {
//            case.success(let data):
//                //print("success",data)
//            case.failure(let error):
//                //print("Not Success",error)
//            }
//
//        }
        
        
//        var request = URLRequest(url: URL(string: "https://www.urbene-fit.com/review")!)
//        request.httpMethod = HTTPMethod.delete.rawValue
//        request.setValue("application/x-www-form-urlencodedn", forHTTPHeaderField: "Content-Type")
//
//        let postData
//                   = try! JSONSerialization.data(withJSONObject: parameters, options: JSONSerialization.WritingOptions.prettyPrinted)
//                   //param is NSDictionary
//          let jsonString = NSString(data: postData, encoding: String.Encoding.utf8.rawValue)! as String
//          let post = jsonString.data(using: String.Encoding.utf8, allowLossyConversion: true)
//
////        let pjson = attendences.toJSONString(prettyPrint: false)
////        let data = (parameters?.data(using: .utf8))! as Data
//
//        request.httpBody = post
//
//        Alamofire.request(request).responseJSON { (response) in
//
//
//            //print(response)
//
//        }
        
        
    }
    
        
    //리뷰작성
    @objc func write(_ sender: UIButton) {
        
       
        
        guard let RVC = self.storyboard?.instantiateViewController(withIdentifier: "ReViewViewController") as? ReViewViewController         else{

            return

        }

//        guard let RVC = self.storyboard?.instantiateViewController(withIdentifier: "Review") as? UINavigationController         else{
//
//                  return
//
//              }
        //뷰 이동
        RVC.modalPresentationStyle = .fullScreen
        
        //리뷰작성 페이지로 이동
       // self.present(RVC, animated: true, completion: nil)
        self.navigationController?.pushViewController(RVC, animated: true)
        
    }
    
    
    func urlPhoto(){
        for i in 0..<reviewItems.count {

        if(reviewItems[i].image_url != "없음"){
            let url = URL(string: reviewItems[i].image_url)
            Alamofire.request(url!).responseImage { response in
                
                if response.data == nil {
                    
                    Alamofire.request("basic_image_URL").responseImage { [self] response in
                        
                        
                        
                        let image = UIImage(data: response.data!, scale:1)
                        
                        self.imgs.append(image!)
                        
                    }
                } else {
                    
                    
                    
                    
                    let image = UIImage(data: response.data!, scale:1)
                    
                    self.imgs.append(image!)
                    
                    
                }
                
                
            }
        }else{
            //let image = UIImage(named: "star_on")
            
            //self.imgs.append(image!)
            
        }
//        //print("이미지 아이템 수: \(self.imgs.count)!")
//        //print("리뷰 아이템 수 : \(self.reviewItems.count)!")
        }
    }
    
}
extension UIImageView {

    func setCustomImage(_ imgURLString: String?) {
        guard let imageURLString = imgURLString else {
            self.image = UIImage(named: "default.png")
            return
        }
        DispatchQueue.global().async { [weak self] in
            let data = try? Data(contentsOf: URL(string: imageURLString)!)
            DispatchQueue.main.async {
                self?.image = data != nil ? UIImage(data: data!) : UIImage(named: "star_on")
            }
        }
    }
}

