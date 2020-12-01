//
//  DetailViewController.swift
//  welfare
//
//  Created by 김동현 on 2020/08/25.
//  Copyright © 2020 com. All rights reserved.
//정책클릭시 상세페이지를 보여주는 뷰
//정책의 이미지
//정책 좋아요 혹은 공유하기 기능
//혜택내용,신청기간,커뮤니티등의 기능을 제공



//

import UIKit
import SwiftyJSON
import Alamofire
import Foundation
import SnapKit




class DetailViewController: UIViewController {
    
    
    
    //구분자처리 후 각 항목별 데이터를 저장할 변수
    var apply : String = ""
    var contact : String = ""
    var contents : String = ""
    var target : String = ""
    var period : String = ""
    
    
    //카테고리 결과페이지에서 선택한 정책을 저장하는 변수
    var selectedPolicy : String = ""
    
    // 메인 스크롤뷰
    var m_Scrollview = UIScrollView()
    
    
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
    
    
    //라벨 텍스트
    var myString:NSString = "당신이 받을 수 있는 금액은 5000,000원"
    var myMutableString = NSMutableAttributedString()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        print("디테일페이지 시작")
        print(selectedPolicy)
        
        //정책의 정보를 알려주는 뷰마다 구별을 해주기 위해 백그라운드의 칼러 설정을 회색으로 지정
        //self.view.backgroundColor = UIColor.lightGray
        
        
        //디바이스의 크기
        var screenWidth = Int(view.bounds.width)
        var screenHeight = Int(view.bounds.height)
        
        //        //스크롤뷰 옵션 설정
        m_Scrollview.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight-50)
        m_Scrollview.contentSize = CGSize(width:screenWidth, height: 1044)
        //
        //        //상단 이미지
        let imageView = UIImageView(image:UIImage(named:"baby-1"))
        imageView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 360)
        //
        //
        //        //좋아요,공유하기 버튼
        let button = UIButton.init(type: .system)
        //set image for button
        button.setTitle("공유하기", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        
        //add function for button
        button.addTarget(self, action: #selector(targetTapped), for: .touchUpInside)
        //set frame
        button.frame = CGRect(x: screenWidth-50, y: 0, width: 50, height: 50)
        
        //버튼 터두리 설정
        button.backgroundColor = .clear
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.black.cgColor
        
        //
        //
        m_Scrollview.addSubview(imageView)
        //m_Scrollview.addSubview(button)
        //
        //
        //
        //        //정책정보에 대한 뷰
        //        //정책명 라벨
        //        //인기정책 라벨
        //        let TopViewFrame = CGRect(x: 0, y: 200, width: screenWidth, height: 200)
        //        let TopView = UIView(frame: TopViewFrame)
        //
        //
        //        let NameLabelFrame = CGRect(x: 0, y: 200, width: screenWidth, height: 100)
        //        let NameLabel = UILabel(frame: NameLabelFrame)
        //        NameLabel.text="재해보상금 \n"
        //        NameLabel.backgroundColor = UIColor.white
        //             //라벨 텍스트 줄 차가
        //        NameLabel.font = UIFont(name: "System", size: 20)
        //        NameLabel.textColor = UIColor.black
        //        NameLabel.layer.borderWidth = 1
        //       // NameLabel.layer.borderColor = UIColor.lightGray as? CGColor
        //
        //
        //       // TopView.addSubview(NameLabel)
        //
        //
        //       m_Scrollview.addSubview(NameLabel)
        //
        //
        //        //그다음 라벨
        //        let DescripFrame = CGRect(x: 0, y: 300, width: screenWidth, height: 100)
        //           let DescripLabel = UILabel(frame: NameLabelFrame)
        ////           DescripLabel.text="재해보상금 \n"
        ////           DescripLabel.backgroundColor = UIColor.white
        ////                //라벨 텍스트 줄 차가
        ////           DescripLabel.font = UIFont(name: "System", size: 20)
        //           //DescripLabel.textColor = UIColor.black
        //        DescripLabel.backgroundColor = UIColor.white
        //
        //
        //        myMutableString = NSMutableAttributedString(string: myString as String, attributes: [NSAttributedString.Key.font:UIFont(name: "Georgia", size: 18.0)!])
        //        myMutableString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.red, range: NSRange(location:2,length:4))
        //            // set label Attribute
        //            DescripLabel.attributedText = myMutableString
        //
        //
        //        m_Scrollview.addSubview(DescripLabel)
        //
        //
        //        //지원대상
        //        let TargetFrame = CGRect(x: 0, y: 400, width: screenWidth, height: 100)
        //               let TargetLabel = UILabel(frame: TargetFrame)
        //               TargetLabel.text="지원대상 \n"
        //               TargetLabel.backgroundColor = UIColor.white
        //                    //라벨 텍스트 줄 차가
        //               TargetLabel.font = UIFont(name: "System", size: 20)
        //               TargetLabel.textColor = UIColor.black
        //               TargetLabel.layer.borderWidth = 1
        //               //TargetLabel.layer.borderColor = UIColor.lightGray as! CGColor
        //
        //               m_Scrollview.addSubview(TargetLabel)
        //
        //
        //
        //
        //        //혜택내용
        //        let ContentsFrame = CGRect(x: 0, y: 500, width: screenWidth, height: 100)
        //               let ContentsLabel = UILabel(frame: ContentsFrame)
        //               ContentsLabel.text="혜택내용 \n"
        //               ContentsLabel.backgroundColor = UIColor.white
        //                    //라벨 텍스트 줄 차가
        //               ContentsLabel.font = UIFont(name: "System", size: 20)
        //               ContentsLabel.textColor = UIColor.black
        //               ContentsLabel.layer.borderWidth = 1
        //               //ContentsLabel.layer.borderColor = UIColor.lightGray as! CGColor
        //
        //               m_Scrollview.addSubview(ContentsLabel)
        //
        //
        //        //기간
        //
        //        let DeadLineFrame = CGRect(x: 0, y: 600, width: screenWidth, height: 100)
        //                    let DeadLineLabel = UILabel(frame: DeadLineFrame)
        //                    DeadLineLabel.text="기간 \n"
        //                    DeadLineLabel.backgroundColor = UIColor.white
        //                         //라벨 텍스트 줄 차가
        //                    DeadLineLabel.font = UIFont(name: "System", size: 20)
        //                    DeadLineLabel.textColor = UIColor.black
        //                    DeadLineLabel.layer.borderWidth = 1
        //                   // DeadLineLabel.layer.borderColor = UIColor.lightGray as! CGColor
        //
        //                    m_Scrollview.addSubview(DeadLineLabel)
        //
        //
        //
        //        //문의
        //
        //        let InquiryFrame = CGRect(x: 0, y: 600, width: screenWidth, height: 100)
        //                          let InquiryLabel = UILabel(frame: InquiryFrame)
        //                          InquiryLabel.text="문의 \n"
        //                          InquiryLabel.backgroundColor = UIColor.white
        //                               //라벨 텍스트 줄 차가
        //                          InquiryLabel.font = UIFont(name: "System", size: 20)
        //                          InquiryLabel.textColor = UIColor.black
        //                          InquiryLabel.layer.borderWidth = 1
        //                          //InquiryLabel.layer.borderColor = UIColor.lightGray as! CGColor
        //
        //                          m_Scrollview.addSubview(InquiryLabel)
        //
        //
        //
        //
        //
        //        //메인스크롤뷰 뷰에 추가
        //        self.view.addSubview(m_Scrollview)
        
        
        
        
        
        
        
        
        
        
        // Do any additional setup after loading the view.
        //서버로부터 카테고리 데이터를 바다온다.
        let params = ["be_name":selectedPolicy]
        
        
        Alamofire.request("http://3.34.4.196/backend/ios/ios_detail.php", method: .post, parameters: params)
            .validate()
            .responseJSON { response in
                switch response.result {
                case .success(let value): //print(value)
                    print("성공")
                    //print(value)
                    
                    
                    do {
                        let data = try JSONSerialization.data(withJSONObject: value, options: .prettyPrinted)
                        let userlists = try JSONDecoder().decode(userlist.self, from: data) //예){"email" : "hi", "result" : "성공"}
                        // print("email : \(userlists.welf_apply)")
                        //print("result : \(userlists.retBody)")
                        
                        
                        //서버에서 데이터를 받아오면 뷰에 반영한다.
                        //        //정책정보에 대한 뷰
                        //        //정책명 라벨
                        //        //인기정책 라벨
                        
                        
                        
                        
                        let NameLabelFrame = CGRect(x: 0, y: 0, width: screenWidth, height: 75)
                        let NameLabel = UILabel(frame: NameLabelFrame)
                        NameLabel.text = userlists.welf_name
                        NameLabel.backgroundColor = UIColor.white
                        
                        
                        //라벨 텍스트 줄 차가
                        NameLabel.font = UIFont(name: "NanumBarunGothic", size: 24)
                        NameLabel.textColor = UIColor.black
                        NameLabel.textAlignment = NSTextAlignment.center
                        //NameLabel.layer.borderWidth = 1
                        // NameLabel.layer.borderColor = UIColor.lightGray as? CGColor
                        //NameLabel.contentEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 0)
                        
                        
                        let TopViewFrame = CGRect(x: 0, y: 360, width: screenWidth, height: 80)
                        let TopView = UIView(frame: TopViewFrame)
                        
                        // TopView.backgroundColor = UIColor(displayP3Red:192/255,green : 192/255, blue : 192/255, alpha: 1)
                        
                        
                        TopView.addSubview(NameLabel)
                        self.m_Scrollview.addSubview(TopView)
                        //self.m_Scrollview.addSubview(NameLabel)
                        
                        
                        //맞춤정책설정하러가기 버튼
                        //        //좋아요,공유하기 버튼
                        let button = UIButton.init(type: .system)
                        //set image for button
                        button.setTitle("알림 설정하기", for: .normal)
                        button.setTitleColor(UIColor.white, for: .normal)
                        
                        //add function for button
                        button.addTarget(self, action: #selector(self.targetTapped), for: .touchUpInside)
                        //set frame
                        button.frame = CGRect(x: 10, y: 440, width: screenWidth-20, height: 40)
                        
                        //버튼 터두리 설정
                        button.backgroundColor = UIColor(displayP3Red:86/255,green : 86/255, blue : 86/255, alpha: 1)
                        
                        button.layer.cornerRadius = 5
                        self.m_Scrollview.addSubview(button)
                        
                        //                                        button.layer.borderWidth = 1
                        //                                        button.layer.borderColor = UIColor.black.cgColor
                        //
                        
                        
                        
                        
                        
                        
                        
                        
                        //                                                //그다음 라벨
                        //                                                let DescripFrame = CGRect(x: 0, y: 300, width: screenWidth, height: 105)
                        //                                                   let DescripLabel = UILabel(frame: DescripFrame)
                        //                                                   DescripLabel.text="재해보상금 \n"
                        //                                                   DescripLabel.backgroundColor = UIColor.white
                        //                                                        //라벨 텍스트 줄 차가
                        //                                                   DescripLabel.font = UIFont(name: "System", size: 20)
                        //                                                   DescripLabel.textColor = UIColor.black
                        //                                                DescripLabel.backgroundColor = UIColor.white
                        //
                        //
                        //                                                self.myMutableString = NSMutableAttributedString(string: self.myString as String, attributes: [NSAttributedString.Key.font:UIFont(name: "Georgia", size: 18.0)!])
                        //                                                self.myMutableString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.red, range: NSRange(location:2,length:4))
                        //                                                    // set label Attribute
                        //                                                    DescripLabel.attributedText = self.myMutableString
                        //
                        //
                        //                                                self.m_Scrollview.addSubview(DescripLabel)
                        
                        
                        //지원대상
                        let TargetFrame = CGRect(x: 0, y: 0, width: screenWidth, height: 40)
                        let TargetLabel = UILabel(frame: TargetFrame)
                        TargetLabel.text="지원대상"
                        TargetLabel.backgroundColor = UIColor.white
                        //라벨 텍스트 줄 차가
                        TargetLabel.font = UIFont(name: "NanumBarunGothic", size: 24)
                        TargetLabel.textColor = UIColor.black
                        TargetLabel.textAlignment = NSTextAlignment.center
                        
                        //TargetLabel.layer.borderWidth = 1
                        //TargetLabel.layer.borderColor = UIColor.lightGray as! CGColor
                        //TargetLabel.layoutMargins = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
                        
                        //self.m_Scrollview.addSubview(TargetLabel)
                        
                        //대상 설명을 텍스트뷰에 담는다.
                        let TargetTextFrame = CGRect(x: 0, y: 40, width: screenWidth, height: 116)
                        let TargetText = UITextView(frame: TargetTextFrame)
                        
                        self.target = userlists.welf_target.replacingOccurrences(of: ";;", with: ",")
                        self.target = self.target.replacingOccurrences(of: "^;", with: "\n")
                        TargetText.text = self.target
                        //let newString = aString.replacingOccurrences(of: " ", with: "+")
                        
                        TargetText.textColor = UIColor(displayP3Red:86/255,green : 86/255, blue : 86/255, alpha: 1)
                        TargetText.font = UIFont(name: "NanumBarunGothic", size: 12)
                        
                        //                                        TargetText.layer.borderWidth = 1
                        //                                        TargetText.layer.borderColor = UIColor.white.cgColor
                        //TargetText.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
                        
                        //추가해줄 UiVIew
                        let TargetViewFrame = CGRect(x: 0, y: 496, width: screenWidth, height: 160)
                        let TargetView = UIView(frame: TargetViewFrame)
                        //DeadLineView.backgroundColor = UIColor.gray.cgColor
                        TargetView.backgroundColor = UIColor(displayP3Red:192/255,green : 192/255, blue : 192/255, alpha: 1)
                        
                        //TargetView.backgroundColor = UIColor.black
                        
                        TargetView.addSubview(TargetLabel)
                        TargetView.addSubview(TargetText)
                        
                        self.m_Scrollview.addSubview(TargetView)
                        
                        
                        
                        
                        
                        //혜택라벨
                        let ContentsFrame = CGRect(x: 0, y: 0, width: screenWidth, height: 40)
                        let ContentsLabel = UILabel(frame: ContentsFrame)
                        ContentsLabel.text="혜택내용"
                        ContentsLabel.backgroundColor = UIColor.white
                        //라벨 텍스트 줄 차가
                        ContentsLabel.font = UIFont(name: "NanumBarunGothic", size: 24)
                        ContentsLabel.textColor = UIColor.black
                        ContentsLabel.textAlignment = NSTextAlignment.center
                        //ContentsLabel.layer.borderWidth = 1
                        //ContentsLabel.layer.borderColor = UIColor.lightGray as! CGColor
                        //ContentsLabel.padding = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
                        // ContentsLabel.layoutMargins = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
                        // self.m_Scrollview.addSubview(ContentsLabel)
                        
                        
                        //혜택내용을 보여주는 텍스트뷰
                        let ContentsTextFrame = CGRect(x: 0, y: 40, width: screenWidth, height: 76)
                        let ContentsText = UITextView(frame: ContentsTextFrame)
                        
                        //구분자 처리
                        self.contents = userlists.welf_contents.replacingOccurrences(of: ";;", with: ",")
                        self.contents = self.contents.replacingOccurrences(of: "^;", with: "\n")
                        ContentsText.text = self.contents
                        ContentsText.textColor = UIColor(displayP3Red:86/255,green : 86/255, blue : 86/255, alpha: 1)
                        ContentsText.font = UIFont(name: "NanumBarunGothic", size: 12)
                        
                        
                        
                        //혜택내용을 담을 뷰
                        let ContentsViewFrame = CGRect(x: 0, y: 656, width: screenWidth, height: 120)
                        let ContentsView = UIView(frame: ContentsViewFrame)
                        
                        ContentsView.backgroundColor = UIColor(displayP3Red:192/255,green : 192/255, blue : 192/255, alpha: 1)
                        //TargetView.backgroundColor = UIColor.black
                        
                        ContentsView.addSubview(ContentsLabel)
                        ContentsView.addSubview(ContentsText)
                        self.m_Scrollview.addSubview(ContentsView)
                        
                        
                        
                        //기간
                        
                        let DeadLineFrame = CGRect(x: 0, y: 0, width: screenWidth, height: 40)
                        let DeadLineLabel = UILabel(frame: DeadLineFrame)
                        DeadLineLabel.text="기간"
                        DeadLineLabel.backgroundColor = UIColor.white
                        //라벨 텍스트 줄 차가
                        DeadLineLabel.font = UIFont(name: "NanumBarunGothic", size: 24)
                        DeadLineLabel.textColor = UIColor.black
                        DeadLineLabel.textAlignment = NSTextAlignment.center
                        
                        //기간을 보여주는 텍스트뷰
                        let DeadLineTextFrame = CGRect(x: 0, y: 40, width: screenWidth, height: 40)
                        let DeadLineText = UITextView(frame: DeadLineTextFrame)
                        
                        //구분자 처리
                        self.period = userlists.welf_period.replacingOccurrences(of: ";;", with: ",")
                        self.period = self.period.replacingOccurrences(of: "^;", with: "\n")
                        
                        DeadLineText.text = self.period
                        DeadLineText.textColor = UIColor(displayP3Red:86/255,green : 86/255, blue : 86/255, alpha: 1)
                        DeadLineText.font = UIFont(name: "NanumBarunGothic", size: 12)
                        
                        
                        //추가해줄 UiVIew
                        let DeadLineViewFrame = CGRect(x: 0, y: 776, width: screenWidth, height: 84)
                        let DeadLineView = UIView(frame: DeadLineViewFrame)
                        //DeadLineView.backgroundColor = UIColor.gray.cgColor
                        DeadLineView.backgroundColor = UIColor(displayP3Red:192/255,green : 192/255, blue : 192/255, alpha: 1)
                        
                        DeadLineView.addSubview(DeadLineLabel)
                        DeadLineView.addSubview(DeadLineText)
                        
                        
                        self.m_Scrollview.addSubview(DeadLineView)
                        
                        
                        
                        //문의
                        
                        let InquiryFrame = CGRect(x: 0, y: 860, width: screenWidth, height: 40)
                        let InquiryLabel = UILabel(frame: InquiryFrame)
                        InquiryLabel.text="문의방법"
                        InquiryLabel.backgroundColor = UIColor.white
                        //라벨 텍스트 줄 차가
                        InquiryLabel.backgroundColor = UIColor.white
                        //라벨 텍스트 줄 차가
                        InquiryLabel.font = UIFont(name: "NanumBarunGothic", size: 24)
                        InquiryLabel.textColor = UIColor.black
                        InquiryLabel.textAlignment = NSTextAlignment.center
                        
                        self.m_Scrollview.addSubview(InquiryLabel)
                        
                        //문의방법을 보여주는 텍스트뷰
                        let InquiryTextFrame = CGRect(x: 0, y: 900, width: screenWidth, height: 80)
                        let InquiryText = UITextView(frame: InquiryTextFrame)
                        
                        //구분자처리
                        self.contact = userlists.welf_contact.replacingOccurrences(of: ";;", with: ",")
                        self.contact = self.contact.replacingOccurrences(of: "^;", with: "\n")
                        
                        
                        InquiryText.text = self.contact
                        InquiryText.textColor = UIColor(displayP3Red:86/255,green : 86/255, blue : 86/255, alpha: 1)
                        InquiryText.font = UIFont(name: "NanumBarunGothic", size: 12)
                        
                        self.m_Scrollview.addSubview(InquiryText)
                        
                        
                        
                        //메인스크롤뷰 뷰에 추가
                        self.view.addSubview(self.m_Scrollview)
                        
                        
                        //        //좋아요,공유하기 버튼
                        let applyBtn = UIButton.init(type: .system)
                        //set image for button
                        applyBtn.setTitle("정책 신청하기", for: .normal)
                        applyBtn.setTitleColor(UIColor.white, for: .normal)
                        
                        //add function for button
                        applyBtn.addTarget(self, action: #selector(self.targetTapped), for: .touchUpInside)
                        //set frame
                        applyBtn.frame = CGRect(x: 10, y: 996, width: screenWidth-20, height: 40)
                        
                        //버튼 터두리 설정
                        applyBtn.backgroundColor = UIColor(displayP3Red:86/255,green : 86/255, blue : 86/255, alpha: 1)
                        
                        applyBtn.layer.cornerRadius = 5
                        self.m_Scrollview.addSubview(applyBtn)
                        
                        
                        
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
                    
                    
                    
                    
                    
                    
                    //                  do {
                    //                                    let users = try JSONDecoder().decode(userlist.self, from: response.data!)
                    //                                    print(users)
                    //
                    //                                } catch let DecodingError.dataCorrupted(context) {
                    //                                        print(context)
                    //                                    } catch let DecodingError.keyNotFound(key, context) {
                    //                                        print("Key '\(key)' not found:", context.debugDescription)
                    //                                        print("codingPath:", context.codingPath)
                    //                                    } catch let DecodingError.valueNotFound(value, context) {
                    //                                        print("Value '\(value)' not found:", context.debugDescription)
                    //                                        print("codingPath:", context.codingPath)
                    //                                    } catch let DecodingError.typeMismatch(type, context)  {
                    //                                        print("Type '\(type)' mismatch:", context.debugDescription)
                    //                                        print("codingPath:", context.codingPath)
                    //                                    } catch {
                    //                                        print("error: ", error)
                    //                                    }
                    
                    
                    
                    
                    
                    //                                    if let json = value as? [String:Any]{
                    //                                    print(json)
                    //                                    }
                    //                                        , // <- Swift Dictionary
                    //                                         let results = json["results"] as? [[String:Any]]  { // <- Swift Array
                    //
                    //                                         for result in results {
                    //                                             print(result["welf_apply"] as! String)
                    //                                         }
                    //}
                    
                    
                    
                    
                    //                                    let decoder = JSONDecoder()
                    //                                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    //                                    decoder.dateDecodingStrategy = .secondsSince1970
                    //                                    guard let launch = try? decoder.decode(userlist.self, from: value as! Data) else {
                    //                                        return
                    //                                    }
                    //                                    print(launch.welf_apply)
                    
                    
                    
                    
                case .failure(let error):
                    print("Error: \(error)")
                    break
                    
                    
                }
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
    
    //맞춤선택라러가기 버튼클릭 이벤트
    @IBAction func targetTapped(sender: UIBarButtonItem) {
        
        
        print("맞춤선택 선택!")
        //m_Scrollview.contentSize = CGSize(width:500, height: 2000)
        
    }
    
    
}


