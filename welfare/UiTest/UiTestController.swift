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


class UiTestController: UIViewController, UIScrollViewDelegate {
    
    //
    var scrollView = UIScrollView()
    
    
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
    
    
    
    //데이터 파싱
    struct saerchList: Decodable {
        var welf_name : String
        var welf_local : String
        var parent_category : String
        var welf_category : String
        var tag : String
        
    }
    
    
    struct parse: Decodable {
        let Status : String
        //반환값이 없을떄 처리
        let Message : [saerchList]
    }
    
    
    struct ytb: Decodable {
        var videoId : String
        var title : String
        var thumbnail : String
        
    }
    
    
    struct ytbParse: Decodable {
        let Status : String
        //반환값이 없을떄 처리
        let Message : [ytb]
    }
    
    var ytbList = [ytb]()
    
    
    
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
        //메인 네비 타이틀 초기화
       // self.title = "메인"
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
    
    
    //뷰페이저 영상목록
    var pageControl = UIPageControl()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("viewDidLoad 함")
        self.view.backgroundColor = UIColor.white
        
       
        
        //유튜브 정보를 받아온다.
        Alamofire.request("https://www.urbene-fit.com/youtube", method: .get)
            .validate()
            .responseJSON { [self] response in
                
                switch response.result {
                case .success(let value):
                    do {
                        let data = try JSONSerialization.data(withJSONObject: value, options: .prettyPrinted)
                        let ytbList = try JSONDecoder().decode(ytbParse.self, from: data)
                        
                        //페이지 컨트롤 설정
                        self.pageControl.numberOfPages = ytbList.Message.count //페이지 컨트롤의 전체 수
                        self.pageControl.currentPage = 0             //현재 페이지를 의미
                        self.pageControl.pageIndicatorTintColor = UIColor.lightGray  // 페이지 컨트롤의 페이지를 표시하는 부분의 색상
                        self.pageControl.currentPageIndicatorTintColor = UIColor.black //선택된 페이지 컨트롤의 색
                
                        
                        //리뷰데이터를 테이블아이템에 추가해준다.
                        for i in 0..<ytbList.Message.count {
                            //                                        self.reviewItems.append(reviewItem.init(content: resultList.retBody[i].content,  email: resultList.retBody[i].email, like_count: resultList.retBody[i].like_count, bad_count: resultList.retBody[i].bad_count, star_count: resultList.retBody[i].star_count))
                            //
                            self.ytbList.append(ytb.init(videoId: ytbList.Message[i].videoId, title: ytbList.Message[i].title, thumbnail: ytbList.Message[i].thumbnail))
                            
                            
                            
                            
                            //                            let url2 = URL(string: ytbList.Message[i].thumbnail)
                            //let xPosition = (self.view.frame.width - 60) * CGFloat(i) + 10
                            let xPosition = (self.view.frame.width) * CGFloat(i) + 30 *  DeviceManager.sharedInstance.widthRatio
                            
                            let listView = UIView()
                            listView.frame = CGRect(x: xPosition, y: 0,
                                                    width: self.view.frame.width - 60 *  DeviceManager.sharedInstance.widthRatio,
                                                    height: 340 *  DeviceManager.sharedInstance.heightRatio)
                            
                            //listView.layer.cornerRadius = 16
                            listView.layer.borderColor = UIColor(displayP3Red: 224/255.0, green:224/255.0, blue: 224/255.0, alpha: 1).cgColor
                            //listView.layer.borderWidth = 1
                            let imageView = UIImageView()
                            let url = URL(string: ytbList.Message[i].thumbnail)
                            imageView.frame = CGRect(x: xPosition, y: 0,
                                                     width: self.view.frame.width - 60 *  DeviceManager.sharedInstance.widthRatio,
                                                     height: 300 *  DeviceManager.sharedInstance.heightRatio)
                            imageView.layer.borderWidth = 0.1
                            imageView.layer.cornerRadius = 33 *  DeviceManager.sharedInstance.heightRatio
                            imageView.layer.borderColor = UIColor.white.cgColor
                            imageView.clipsToBounds = true
                           imageView.kf.setImage(with: url)
                            
                            //imageView.setImage(crop(imgUrl: ytbList.Message[i].thumbnail)!)
                            
                            
                            //imageView.kf.setImage(with: url2)
                            //imageView.contentMode = .scaleAspectFit //  사진의 비율을 맞춤.
                            
                          
                            let cropView = UIView()
                            cropView.frame = CGRect(x: 0, y: 0, width: listView.frame.width, height: 100 *  DeviceManager.sharedInstance.heightRatio)
                            cropView.backgroundColor = UIColor.white
                            //imageView.addSubview(cropView)
                            self.scrollView.contentSize.width =
                                self.view.frame.width * CGFloat(1+i) *  DeviceManager.sharedInstance.widthRatio
                            
                            
                            //영상관련 태그 라벨
                            let tagLabel = UILabel()
                            tagLabel.frame = CGRect(x: 40 *  DeviceManager.sharedInstance.widthRatio, y: 315 *  DeviceManager.sharedInstance.heightRatio, width: 100 *  DeviceManager.sharedInstance.widthRatio, height: 30 *  DeviceManager.sharedInstance.heightRatio)
                            tagLabel.text = "주거"
                            tagLabel.textAlignment = .center
                            tagLabel.font = UIFont(name: "Jalnan", size: 12 *  DeviceManager.sharedInstance.heightRatio)
                            tagLabel.layer.cornerRadius = 8 *  DeviceManager.sharedInstance.heightRatio
                            tagLabel.layer.borderWidth = 1
                            tagLabel.layer.borderColor = UIColor(displayP3Red: 224/255.0, green:224/255.0, blue: 224/255.0, alpha: 1).cgColor
                            
                    
//                            listView.addSubview(tagLabel)
//                            listView.addSubview(imageView)
                            self.scrollView.addSubview(imageView)
                            self.scrollView.addSubview(tagLabel)

                            print("영상 제목 내용: \(self.ytbList[i].title)!")
                        }
                        
                        let singleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.MyTapMethod))
                        
                        singleTapGestureRecognizer.numberOfTapsRequired = 1
                        
                        singleTapGestureRecognizer.isEnabled = true
                        
                        singleTapGestureRecognizer.cancelsTouchesInView = false
                        
                        self.scrollView.addGestureRecognizer(singleTapGestureRecognizer)
                        
                        
                        
                        
                    }
                    catch let DecodingError.dataCorrupted(context) {
                        print(context)
                    } catch let DecodingError.keyNotFound(key, context) {
                        print("Key '\(key)' not found:", context.debugDescription)
                        print("codingPath:", context.codingPath)
                    } catch let DecodingError.valueNotFound(value, context) {
                        print("Value '\(value)' not found:", context.debugDescription)
                        print("codingPath:", context.codingPath)
                    } catch let DecodingError.typeMismatch(type, context)  {
                        print("Type '\(type)' mismatch:", context.debugDescription)
                        print("codingPath:", context.codingPath)
                    } catch {
                        print("error: ", error)
                    }
                    
                    
                    
                case .failure(let error):
                    print(error)
                }
                
                
                
            }
        
        
        
        
        
        
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
        
        
        let LogoImg = UIImage(named: "appLogo")
        appLogo.image = LogoImg
        appLogo.frame = CGRect(x: 24.3 *  DeviceManager.sharedInstance.widthRatio , y: 29.3 *  DeviceManager.sharedInstance.heightRatio, width: 116.6 *  DeviceManager.sharedInstance.widthRatio, height: 15.7 *  DeviceManager.sharedInstance.heightRatio)
        //self.view.addSubview(appLogo)
        m_Scrollview.addSubview(appLogo)
        
        
        let descriptionImg = UIImage(named: "descriptionImg")
        appDescription.image = descriptionImg
        appDescription.frame = CGRect(x: 64.1 *  DeviceManager.sharedInstance.widthRatio , y: 125 *  DeviceManager.sharedInstance.heightRatio, width: 284.1 *  DeviceManager.sharedInstance.widthRatio, height: 82.5 *  DeviceManager.sharedInstance.heightRatio)
        // self.view.addSubview(appDescription)
        m_Scrollview.addSubview(appDescription)
        
        let inquiryLabel = UILabel()
        inquiryLabel.frame = CGRect(x: 63.8 *  DeviceManager.sharedInstance.widthRatio, y: 235.4 *  DeviceManager.sharedInstance.heightRatio, width: 118 *  DeviceManager.sharedInstance.widthRatio, height: 17.3 *  DeviceManager.sharedInstance.heightRatio)
        inquiryLabel.textAlignment = .right
        inquiryLabel.textColor = UIColor(displayP3Red: 93/255.0, green: 33/255.0, blue: 210/255.0, alpha: 1)
        //폰트지정 추가
        
        inquiryLabel.text = "혜택 조회하러 가기"
        inquiryLabel.font = UIFont(name: "NanumGothicBold", size: 14.3 *  DeviceManager.sharedInstance.heightRatio)
        // inquiryLabel.font = UIFont(name: "NanumGothicBold", size: 13.7)
        // self.view.addSubview(inquiryLabel)
        m_Scrollview.addSubview(inquiryLabel)
        
        
        
        bottomBtn.setImage(UIImage(named: "bottomBtnImg"), for: .normal)
        bottomBtn.frame = CGRect(x: 192.5 *  DeviceManager.sharedInstance.widthRatio, y: 227.1 *  DeviceManager.sharedInstance.heightRatio, width: 18.7 *  DeviceManager.sharedInstance.widthRatio, height: 26 *  DeviceManager.sharedInstance.heightRatio)
        //self.view.addSubview(bottomBtn)
        m_Scrollview.addSubview(bottomBtn)
        
        
        bottomBtn.addTarget(self, action: #selector(self.moveBottom), for: .touchUpInside)
        
        //그라데이션으로 변경
        //카테고리 전체뷰
        
        //    categoryView.frame = CGRect(x: 0, y: 547.4, width: Double(screenWidth), height: 1144.3)
        
       // categoryView.frame = CGRect(x: 0, y: 1107.4 *  DeviceManager.sharedInstance.heightRatio, width: CGFloat(screenWidth), height: 1144.3 *  DeviceManager.sharedInstance.heightRatio)
        
        categoryView.frame = CGRect(x: 0, y: 600 *  DeviceManager.sharedInstance.heightRatio, width: CGFloat(screenWidth), height: 1144.3 *  DeviceManager.sharedInstance.heightRatio)
        
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
        benefitLabel.font = UIFont(name: "Jalnan", size: 23.1 *  DeviceManager.sharedInstance.heightRatio)
        benefitLabel.text = "당신이 관심있는 혜택은?"
        benefitLabel.frame = CGRect(x: 71.1 *  DeviceManager.sharedInstance.widthRatio, y: 630 *  DeviceManager.sharedInstance.heightRatio, width: 270.6 *  DeviceManager.sharedInstance.widthRatio, height: 24.2 *  DeviceManager.sharedInstance.heightRatio)
        benefitLabel.textAlignment = .center
        benefitLabel.textColor = UIColor(displayP3Red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 1)
        
        m_Scrollview.addSubview(benefitLabel)
        
        //메인 이미지
        
        
        let MainImg = UIImage(named: "MainImg")
        MainImgView.image = MainImg
        MainImgView.frame = CGRect(x: 0, y: 320.5 *  DeviceManager.sharedInstance.heightRatio, width: 411.4 *  DeviceManager.sharedInstance.widthRatio, height: 232.2 *  DeviceManager.sharedInstance.heightRatio)
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
                
                button.frame = CGRect(x:213, y:Double(Int(175.2) * (i - 1)/2)  + 700 , width: 177.4  , height: 161.7 )
                
                //button.setTitle(LabelName[i], for: .normal)
                
                //이미지 및 라벨 추가
                let img = UIImage(named: ImgFile[i])
                imgView.setImage(img!)
                imgView.frame = CGRect(x: 26.4 *  DeviceManager.sharedInstance.widthRatio, y: 38.1 *  DeviceManager.sharedInstance.heightRatio, width: 38.8 *  DeviceManager.sharedInstance.widthRatio, height: 38.8 *  DeviceManager.sharedInstance.heightRatio)
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
                // button.frame = CGRect(x:22, y:Double(Int(175.2) * i/2) + 679.4, width: 177.4, height: 158.4)
                button.frame = CGRect(x:22, y:Double(Int(175.2) * i/2)  + 700 , width: 177.4 , height: 158.4 )
                
                //button.setTitle(LabelName[i], for: .normal)
                
                
                //이미지 및 라벨 추가
                let img = UIImage(named: ImgFile[i])
                imgView.setImage(img!)
                imgView.frame = CGRect(x: 26.4 *  DeviceManager.sharedInstance.widthRatio, y: 38.1 *  DeviceManager.sharedInstance.heightRatio, width: 38.8 *  DeviceManager.sharedInstance.widthRatio, height: 38.8 *  DeviceManager.sharedInstance.heightRatio)
                imgView.image = imgView.image?.withRenderingMode(.alwaysOriginal)
                //라벨
                label.frame = CGRect(x: 26.7 *  DeviceManager.sharedInstance.widthRatio, y: 97.4 *  DeviceManager.sharedInstance.heightRatio, width: 110 *  DeviceManager.sharedInstance.widthRatio, height: 18.7 *  DeviceManager.sharedInstance.heightRatio)
                label.textAlignment = .left
                
                //폰트지정 추가
                label.text = LabelName[i]
                label.font = UIFont(name: "NanumGothicBold", size: 16.1 *  DeviceManager.sharedInstance.heightRatio)
                
                
                
                button.addSubview(imgView)
                button.addSubview(label)
                button.setTitleColor(UIColor.black, for: .normal)
                button.backgroundColor = .white
                button.layer.cornerRadius = 14 *  DeviceManager.sharedInstance.heightRatio
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
                button.frame = CGRect(x:213 *  DeviceManager.sharedInstance.widthRatio, y:CGFloat(Int(175.2) * (i - 1)/2) *  DeviceManager.sharedInstance.heightRatio + 700 *  DeviceManager.sharedInstance.heightRatio, width: 177.4 *  DeviceManager.sharedInstance.widthRatio, height: 161.7 *  DeviceManager.sharedInstance.heightRatio)
                //button.setTitle(LabelName[i], for: .normal)
                //이미지 및 라벨 추가
                let img = UIImage(named: ImgFile[i])
                imgView.setImage(img!)
                imgView.frame = CGRect(x: 26.4 *  DeviceManager.sharedInstance.widthRatio, y: 38.1 *  DeviceManager.sharedInstance.heightRatio, width: 38.8 *  DeviceManager.sharedInstance.widthRatio, height: 38.8 *  DeviceManager.sharedInstance.heightRatio)
                imgView.image = imgView.image?.withRenderingMode(.alwaysOriginal)
                
                
                //라벨
                label.frame = CGRect(x: 26.7 *  DeviceManager.sharedInstance.widthRatio, y: 97.4 *  DeviceManager.sharedInstance.heightRatio, width: 110 *  DeviceManager.sharedInstance.widthRatio, height: 18.7 *  DeviceManager.sharedInstance.heightRatio)
                label.textAlignment = .left
                
                //폰트지정 추가
                label.text = LabelName[i]
                label.font = UIFont(name: "NanumGothicBold", size: 16.1 *  DeviceManager.sharedInstance.heightRatio)
                
                
                
                button.addSubview(imgView)
                button.addSubview(label)
                
                
                button.setTitleColor(UIColor.black, for: .normal)
                button.backgroundColor = .white
                button.layer.cornerRadius = 14 *  DeviceManager.sharedInstance.heightRatio
                button.layer.borderWidth = 2.7
                button.layer.borderColor = UIColor.white.cgColor
                
                //카테고리 선택시 선택한 카테고리를 저장해주는 메소드
                button.addTarget(self, action: #selector(self.selected), for: .touchUpInside)
                
                
                m_Scrollview.addSubview(button)
                
            }
            
            //   }
            
            
            //조회하기 버튼
            
            //라벨
            let inquiryBtnLabel = UILabel()
            inquiryBtnLabel.frame = CGRect(x: 20.1 *  DeviceManager.sharedInstance.widthRatio, y: 153.2 *  DeviceManager.sharedInstance.heightRatio, width: 59.4 *  DeviceManager.sharedInstance.widthRatio, height: 18.7 *  DeviceManager.sharedInstance.heightRatio)
            inquiryBtnLabel.textAlignment = .center
            inquiryBtnLabel.textColor = UIColor(displayP3Red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 1)
            
            inquiryBtnLabel.text = "조회하기"
            inquiryBtnLabel.font = UIFont(name: "NanumGothic", size: 16.1 *  DeviceManager.sharedInstance.heightRatio)
            
            
            inquiryBtn.setTitle("조회하기", for: .normal)
            inquiryBtn.frame = CGRect(x: 22 *  DeviceManager.sharedInstance.widthRatio, y: 2126.7 *  DeviceManager.sharedInstance.heightRatio, width: 368.5 *  DeviceManager.sharedInstance.widthRatio, height: 59 *  DeviceManager.sharedInstance.heightRatio)
            
            inquiryBtn.titleLabel!.font = UIFont(name: "NanumGothic", size:16.1 *  DeviceManager.sharedInstance.heightRatio)
            inquiryBtn.layer.cornerRadius = 3.3 *  DeviceManager.sharedInstance.heightRatio
            inquiryBtn.layer.borderWidth = 1.3
            inquiryBtn.layer.borderColor = UIColor.white.cgColor
            //선택결과 페이지로 이동하는 메소드
            inquiryBtn.addTarget(self, action: #selector(self.move), for: .touchUpInside)
            
            //조회하기 버튼 삭제를 위한 태그값 설정
            inquiryBtn.tag = 44
            //self.view.addSubview(bottomBtn)
            m_Scrollview.addSubview(inquiryBtn)
            
            
            //최하단 설명뷰(고객센터,개인정보 취급방침,이용약관등)
            footer.frame = CGRect(x: 0, y: 1688.5 *  DeviceManager.sharedInstance.heightRatio, width: 412.5 *  DeviceManager.sharedInstance.widthRatio, height: 229.5 *  DeviceManager.sharedInstance.heightRatio)
            footer.backgroundColor = UIColor(displayP3Red: 251/255.0, green: 251/255.0, blue: 251/255.0, alpha: 1)
            
            //하단 뷰 너의 혜택은 이미지 뷰
            //이미지 및 라벨 추가
            let bottomImg = UIImage(named: "bottomImg")
            let bottomImgView = UIImageView(image: bottomImg)
            bottomImgView.frame = CGRect(x: 22.7 *  DeviceManager.sharedInstance.widthRatio, y: 34.8 *  DeviceManager.sharedInstance.heightRatio, width: 106.3 *  DeviceManager.sharedInstance.widthRatio, height: 18.7 *  DeviceManager.sharedInstance.heightRatio)
            footer.addSubview(bottomImgView)
            
            //하단 설명 라벨
            let bottomLabel = UILabel()
            //bottomLabel.frame = CGRect(x: 20.7, y: 58.3, width: 238.7, height: 12.7)
            bottomLabel.frame = CGRect(x: 22.7 *  DeviceManager.sharedInstance.widthRatio, y: 64.1 *  DeviceManager.sharedInstance.heightRatio, width: 330 *  DeviceManager.sharedInstance.widthRatio, height: 13.9 *  DeviceManager.sharedInstance.heightRatio)
            bottomLabel.textAlignment = .left
            bottomLabel.textColor = UIColor(displayP3Red: 125/255.0, green: 125/255.0, blue: 125/255.0, alpha: 1)
            
            bottomLabel.text = "당신에게 필요한 복지 지원과 혜택을 알려드립니다"
            bottomLabel.font = UIFont(name: "NanumGothic", size: 12.1 *  DeviceManager.sharedInstance.heightRatio)
            footer.addSubview(bottomLabel)
            
            
            
            //2번째 라벨
            let bottomSecLabel = UILabel()
            //bottomLabel.frame = CGRect(x: 20.7, y: 58.3, width: 238.7, height: 12.7)
            bottomSecLabel.frame = CGRect(x: 22.7 *  DeviceManager.sharedInstance.widthRatio, y: 119.1 *  DeviceManager.sharedInstance.heightRatio, width: 330 *  DeviceManager.sharedInstance.widthRatio, height: 16.5 *  DeviceManager.sharedInstance.heightRatio)
            bottomSecLabel.textAlignment = .left
            bottomSecLabel.textColor = UIColor(displayP3Red: 125/255.0, green: 125/255.0, blue: 125/255.0, alpha: 1)
            
            bottomSecLabel.text = "Copyright © All rights reserved"
            bottomSecLabel.font = UIFont(name: "OpenSans-Bold", size: 12.1 *  DeviceManager.sharedInstance.heightRatio)
            footer.addSubview(bottomSecLabel)
            
            //하단 페이스북 버튼
            let bottomFbBtn = UIButton(type: .system)
            bottomFbBtn.frame = CGRect(x:22.7 *  DeviceManager.sharedInstance.widthRatio, y:157.6 *  DeviceManager.sharedInstance.heightRatio, width: 38.8 *  DeviceManager.sharedInstance.widthRatio, height: 38.8 *  DeviceManager.sharedInstance.heightRatio)
            bottomFbBtn.backgroundColor = UIColor(displayP3Red: 233/255.0, green: 233/255.0, blue: 233/255.0, alpha: 1)
            
            bottomFbBtn.layer.cornerRadius = bottomFbBtn.frame.height/2
            bottomFbBtn.layer.borderWidth = 1
            bottomFbBtn.layer.borderColor = UIColor.clear.cgColor
            // 뷰의 경계에 맞춰준다
            bottomFbBtn.clipsToBounds = true
            
            
            //페이스북 로고이미지 추가
            let fbImg = UIImage(named:"fbImg")
            let fbImgView = UIImageView(image: fbImg)
            fbImgView.frame = CGRect(x: 15.8 *  DeviceManager.sharedInstance.widthRatio, y: 11.4 *  DeviceManager.sharedInstance.heightRatio, width: 7.6 *  DeviceManager.sharedInstance.widthRatio, height: 15.1 *  DeviceManager.sharedInstance.heightRatio)
            
            //각 상위뷰에 추가
            bottomFbBtn.addSubview(fbImgView)
            footer.addSubview(bottomFbBtn)
            
            
            //하단 구글 버튼
            let bottomGgBtn = UIButton(type: .system)
            bottomGgBtn.frame = CGRect(x:70.4 *  DeviceManager.sharedInstance.widthRatio, y:158.7 *  DeviceManager.sharedInstance.heightRatio, width: 38.8 *  DeviceManager.sharedInstance.widthRatio, height: 38.8 *  DeviceManager.sharedInstance.heightRatio)
            bottomGgBtn.backgroundColor = UIColor(displayP3Red: 233/255.0, green: 233/255.0, blue: 233/255.0, alpha: 1)
            
            bottomGgBtn.layer.cornerRadius = bottomFbBtn.frame.height/2
            bottomGgBtn.layer.borderWidth = 1
            bottomGgBtn.layer.borderColor = UIColor.clear.cgColor
            // 뷰의 경계에 맞춰준다
            bottomGgBtn.clipsToBounds = true
            
            
            //페이스북 로고이미지 추가
            let GgImg = UIImage(named:"GgImg")
            let GgImgView = UIImageView(image: GgImg)
            GgImgView.frame = CGRect(x: 11.8 *  DeviceManager.sharedInstance.widthRatio, y: 11.5 *  DeviceManager.sharedInstance.heightRatio, width: 10.2 *  DeviceManager.sharedInstance.widthRatio, height: 15.1 *  DeviceManager.sharedInstance.heightRatio)
            
            //각 상위뷰에 추가
            bottomGgBtn.addSubview(GgImgView)
            footer.addSubview(bottomGgBtn)
            
            //앱스토어 추가
            //애플
            //로고
            let appleImg = UIImage(named:"appleImg")
            let appleImgView = UIImageView(image: appleImg)
            appleImgView.frame = CGRect(x: 142 *  DeviceManager.sharedInstance.widthRatio, y: 169 *  DeviceManager.sharedInstance.heightRatio, width: 15.7 *  DeviceManager.sharedInstance.widthRatio, height: 19 *  DeviceManager.sharedInstance.heightRatio)
            
            footer.addSubview(appleImgView)
            
            //버튼
            let appleBtn = UIButton(type: .system)
            appleBtn.frame = CGRect(x:165.7 *  DeviceManager.sharedInstance.widthRatio, y:166.8 *  DeviceManager.sharedInstance.heightRatio, width: 77.3 *  DeviceManager.sharedInstance.widthRatio, height: 22.7 *  DeviceManager.sharedInstance.heightRatio)
            appleBtn.backgroundColor = .clear
            appleBtn.setTitle("App Store", for: .normal)
            appleBtn.setTitleColor(UIColor(displayP3Red: 125/255.0, green: 125/255.0, blue: 125/255.0, alpha: 1), for: .normal)
            appleBtn.titleLabel!.font = UIFont(name: "OpenSans-Semibold", size:15.7 *  DeviceManager.sharedInstance.heightRatio)
            footer.addSubview(appleBtn)
            
            
            
            //구글
            //로고
            let googleImg = UIImage(named:"googleImg")
            let googleImgView = UIImageView(image: googleImg)
            googleImgView.frame = CGRect(x: 258.5 *  DeviceManager.sharedInstance.widthRatio, y: 168.6 *  DeviceManager.sharedInstance.heightRatio, width: 18.3 *  DeviceManager.sharedInstance.widthRatio, height: 19.8 *  DeviceManager.sharedInstance.heightRatio)
            
            footer.addSubview(googleImgView)
            
            //버튼
            let googleBtn = UIButton(type: .system)
            googleBtn.frame = CGRect(x:284.5 *  DeviceManager.sharedInstance.widthRatio, y:166.4 *  DeviceManager.sharedInstance.heightRatio, width: 96.4 *  DeviceManager.sharedInstance.widthRatio, height: 22.7 *  DeviceManager.sharedInstance.heightRatio)
            googleBtn.backgroundColor = .clear
            googleBtn.setTitle("Google play", for: .normal)
            googleBtn.setTitleColor(UIColor(displayP3Red: 125/255.0, green: 125/255.0, blue: 125/255.0, alpha: 1), for: .normal)
            googleBtn.titleLabel!.font = UIFont(name: "OpenSans-Semibold", size:15.7 *  DeviceManager.sharedInstance.heightRatio)
            footer.addSubview(googleBtn)
            
            
            
            //하단 뷰 추가
            //  m_Scrollview.addSubview(footer)
            
            
            
            
            
            
            //혜택리뷰 영상목록
            
            //유튜브 목록 스크롤뷰 추가
            scrollView.frame = CGRect(x: 0, y: 680 *  DeviceManager.sharedInstance.heightRatio, width: self.view.frame.width, height: 360 *  DeviceManager.sharedInstance.heightRatio)
            scrollView.isPagingEnabled = true
            //유튜브 목록 페이지 컨트롤러 추가
            pageControl.frame = CGRect(x: 0, y: 1000 *  DeviceManager.sharedInstance.heightRatio, width: self.view.frame.width, height: 100 *  DeviceManager.sharedInstance.heightRatio)
            scrollView.showsHorizontalScrollIndicator = false
//            m_Scrollview.addSubview(pageControl)
//
//            m_Scrollview.addSubview(scrollView)

            //영상목록 페이저 스크롤뷰 대리자 설정
            scrollView.delegate = self
            
            
            //영상소개 라벨
            var youtubeLabel = UILabel()
            
            youtubeLabel.frame = CGRect(x: 20 *  DeviceManager.sharedInstance.widthRatio, y: 600 *  DeviceManager.sharedInstance.heightRatio, width: 400 *  DeviceManager.sharedInstance.widthRatio, height: 50 *  DeviceManager.sharedInstance.heightRatio)
            youtubeLabel.textAlignment = .left
            
            //폰트지정 추가
            youtubeLabel.text = "유튜버들의 혜택리뷰"
            youtubeLabel.font = UIFont(name: "Jalnan", size: 17 *  DeviceManager.sharedInstance.heightRatio)
            //m_Scrollview.addSubview(youtubeLabel)
            
            
            
            
            
            //메인스크롤 뷰 추가
            m_Scrollview.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
            m_Scrollview.contentSize = CGSize(width:screenWidth, height: 2271 *  Int(DeviceManager.sharedInstance.heightRatio))
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
            let string = categorys.joined(separator: "|")
            
            
            let parameters = ["type":"category_search", "keyword":string]
            
            Alamofire.request("https://www.urbene-fit.com/welf", method: .get, parameters: parameters)
                .validate()
                .responseJSON { response in
                    
                    switch response.result {
                    case .success(let value):
                        
                        //상세페이지로 카테고리선택결과 데이터를  전달하기 위해 상세페이지 객체를 선언
                        guard let RVC = self.storyboard?.instantiateViewController(withIdentifier: "ResultUIViewController") as? ResultUIViewController         else{
                            
                            return
                            
                        }
                        
                        
                        do {
                            let data = try JSONSerialization.data(withJSONObject: value, options: .prettyPrinted)
                            let parseResult = try JSONDecoder().decode(parse.self, from: data)
                            
                            guard let RVC = self.storyboard?.instantiateViewController(withIdentifier: "ResultUIViewController") as? ResultUIViewController         else{
                                
                                return
                                
                            }
                            
                            
                            
                            if(parseResult.Status == "200"){
                                print(parseResult.Status)
                                for i in 0..<parseResult.Message.count {
                                    
                                    print(parseResult.Message[i].welf_name)
                                    print(parseResult.Message[i].welf_local)
                                    print(parseResult.Message[i].parent_category)
                                    print(parseResult.Message[i].welf_category)
                                    print(parseResult.Message[i].tag)
                                    
                                    
//                                    RVC.items.append(ResultUIViewController.item.init(welf_name: parseResult.Message[i].welf_name, welf_local: parseResult.Message[i].welf_local, parent_category: parseResult.Message[i].parent_category, welf_category: parseResult.Message[i].welf_category, tag: parseResult.Message[i].tag))
//                                    
//                                    //
//                                    //                                RVC.items.append(                            ResultUIViewController.item.init(name: "전체", sd: test))
//                                    //검색결과의 카테고리들을 중복검사 후 추가
//                                    if(!RVC.categoryItems.contains(parseResult.Message[i].parent_category)){
//                                        RVC.categoryItems.append(parseResult.Message[i].parent_category)
//                                    }
                                    
                                    
                                    
                                    
                                }
                                //검색결과 페이지로 이동
                                
                                
                                
                                //뷰 이동
                                RVC.modalPresentationStyle = .fullScreen
                                
                                // 상세정보 뷰로 이동
                                //self.present(RVC, animated: true, completion: nil)
                                self.navigationController?.pushViewController(RVC, animated: true)
                                
                                
                                
                            }else{
                                print(parseResult.Status)
                                
                            }
                            
                            
                            
                            
                            
                            
                            
                            
                        }
                        catch let DecodingError.dataCorrupted(context) {
                            print(context)
                        } catch let DecodingError.keyNotFound(key, context) {
                            print("Key '\(key)' not found:", context.debugDescription)
                            print("codingPath:", context.codingPath)
                        } catch let DecodingError.valueNotFound(value, context) {
                            print("Value '\(value)' not found:", context.debugDescription)
                            print("codingPath:", context.codingPath)
                        } catch let DecodingError.typeMismatch(type, context)  {
                            print("Type '\(type)' mismatch:", context.debugDescription)
                            print("codingPath:", context.codingPath)
                        } catch {
                            print("error: ", error)
                        }
                        
                        
                        
                        
                        
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
    
    
    // 혜택 소개영상을 클릭하면 영상을 보여주는 화면으로 이동
    @objc func MyTapMethod(sender: UITapGestureRecognizer) {
        
        print("사진 터치")
        
        
        guard let RVC = self.storyboard?.instantiateViewController(withIdentifier: "tagSelectViewController") as? tagSelectViewController         else{
            
            return
            
        }
        //뷰 이동
        RVC.modalPresentationStyle = .fullScreen
        
        
        //선택한 영상의 번호를 스크롤뷰의 x 좌표값을 통해 받아온다.
        var Index : Int = Int(scrollView.contentOffset.x / scrollView.frame.maxX)
//        RVC.videoID = ytbList[Index].videoId
//        RVC.videoTitle = ytbList[Index].title
//

            
        
        //리뷰작성 페이지로 이동
        //네비게이션바의 타이틀과 이름을 설정 해준다.
        //네비바 설정
        let naviLabel = UILabel()
       // naviLabel.frame = CGRect(x: 63.8, y: 235.4, width: 118, height: 17.3)
        naviLabel.textAlignment = .center
        //naviLabel.textColor = UIColor(displayP3Red: 93/255.0, green: 33/255.0, blue: 210/255.0, alpha: 1)
        //폰트지정 추가
        
//        naviLabel.text = "유튜버 혜택리뷰"
//        naviLabel.font = UIFont(name: "Jalnan", size: 16)
//        
//        self.navigationController?.navigationBar.topItem?.titleView = naviLabel
        self.navigationController?.navigationBar.tintColor = UIColor.black
        
        self.navigationController?.pushViewController(RVC, animated: true)
        
        
    }
    
    
    
   
    
    
    //페이지 컨트롤
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        print("페이지 컨트롤러")
        pageControl.currentPage = Int(scrollView.contentOffset.x / scrollView.frame.maxX)

        if fmod(scrollView.contentOffset.x, scrollView.frame.minX) == 0 {
         
            pageControl.currentPage = Int(scrollView.contentOffset.x / scrollView.frame.maxX)
            print("페이지 fmod컨트롤러")
            print(Int(scrollView.contentOffset.x / scrollView.frame.maxX))
            
        }
    }
    
    //이미지 자르는 메소드
    func crop(imgUrl : String) -> UIImage? {
        let imageUrl = URL(string: imgUrl)!
        let data = try! Data(contentsOf: imageUrl)
        let image = UIImage(data: data)!

        // Crop rectangle
        let width = min(image.size.width, image.size.height)
        let size = CGSize(width: width, height: image.size.height - 40)

        // If you want to crop center of image
        //let startPoint = CGPoint(x: (image.size.width - width) / 2, y: (image.size.height - width) / 2)
        let startPoint = CGPoint(x: 0, y: 40)
        let endPoint = CGPoint(x: image.size.width, y: image.size.height - 38)

        
        UIGraphicsBeginImageContextWithOptions(size, false, 0)

        image.draw(in: CGRect(origin: startPoint, size: size))
        //image.draw(in: CGRect(origin: startPoint, size : endPoint))

        let croppedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        
        
        
        return croppedImage
    }
    
}
