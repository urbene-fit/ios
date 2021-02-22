//
//  TestScrollViewController.swift
//  GatheredYourBenefits
//
//  Created by 김동현 on 2020/08/31.
//  Copyright © 2020 com. All rights reserved.
//


// 테이블뷰 + expandLABEL 라이브러리로도 가능
//우선 노가다 작업으로 구현



import UIKit
import SwiftyJSON
import Alamofire
import Foundation

class TestScrollViewController: UIViewController, UITextViewDelegate {

       // 혜택상세내용을 파싱할때 사용
    struct userlist: Decodable {
        var welf_apply : String
        var welf_contact : String
        var welf_contents : String
        var welf_target : String
        var welf_name : String
        var welf_period : String

        
    }
    
    
    
    // 메인 스크롤뷰
      var m_Scrollview = UIScrollView()
    //더 보여주기 뷰
    var testView = UIView()
    
    //대상정보를 담는 변수
    var TargetInfo : String = ""
    //혜택내용을 저장하는 변수
    var ContentsInfo : String = ""

    
    
    
    
    
    //각 상세혜택내용을 보여주는 뷰의 위치를 저장하는 변수들
    var TargetHeight : Int = 40
    var ContentHeight : Int = 40
    var DeadLineHeight  : Int = 40
    var InquiryHeight : Int = 40

    
    //더 보여주기 클릭여부를 저장하는 불린변수
    
    //혜택이름 일반적으로 위치 변동없음
    var NameY : Int = 360
    //지원대상 역시 혜택이름의 크기가 변화하지 않으니 위치 변화없음
    var TargetY : Int = 360
    //상세내용은 지원대상의 길이에 따라 변화 가능
    var ContentsY : Int = 360
    //d
    var DeadLineY : Int = 360
    var InquiryY : Int = 360
    

    
    //각 상세정보의 이름을 알려주는 라벨
     let NameLabel = UILabel()
    let ContentsLabel = UILabel()
     let DeadLineLabel = UILabel()
    let InquiryLabel = UILabel()
    let TargetLabel = UILabel()

    //대상정보를 보여주는 뷰
    
    let TargetText = UITextView()
    
    let ContentsText = UITextView()
    
    
    let DeadLineText = UITextView()
    
    let InquiryText = UITextView()

    
    //메인 이미지 뷰
    let imageView = UIImageView()
    
    //알림설정 하러가기 버튼
    let alarmBtn = UIButton()

    
    //더 보기 버튼들
    let  TargetReadMoreBtn = UIButton()
    let  ContentReadMoreBtn = UIButton()
    
    //더보기 줄이기 그븐
    var targetBool : Bool = true
    var ContentsBool : Bool = true

    
    
    //각 뷰의 길이값을 미리 선언 후 더보기 이후 변경된 사항을 저장해준다.
    
    
    //핸드폰 뷰 크기
    var screenWidth : Int = 0
    var screenHeight : Int = 0
             
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        print("테스트 뷰 시작 ")
        
        //상단 이미지
           //mageView = UIImageView(image:UIImage(named:"baby-1"))
        imageView.image = UIImage(named:"baby")
           imageView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 360)
        
               //디바이스의 크기
                screenWidth = Int(view.bounds.width)
                screenHeight = Int(view.bounds.height)
                
        //        //스크롤뷰 옵션 설정
                 m_Scrollview.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight-50)
        m_Scrollview.contentSize = CGSize(width:screenWidth, height: 956)
        self.m_Scrollview.addSubview(self.imageView)

        
            //서버로부터 카테고리 데이터를 바다온다.
                  let params = ["be_no":1]

                
                Alamofire.request("http://3.34.4.196/backend/php/common/ios/ios_detail.php", method: .post, parameters: params)
                            .validate()
                             .responseJSON { response in
                                           switch response.result {
                                           case .success(let value): //print(value)
                                            print("성공")
                                            //print(value)
                                            
                                            
                                            do { let data = try JSONSerialization.data(withJSONObject: value, options: .prettyPrinted)
                                                let userlists = try JSONDecoder().decode(userlist.self, from: data) //예){"email" : "hi", "result" : "성공"}
    
                                                                                  
                                                
                                                
                                //let NameLabelFrame = CGRect(x: 0, y: 0, width: screenWidth, height: 75)
                                
                                                self.NameLabel.frame = CGRect(x: 0, y: 360, width: self.screenWidth, height: 75)
                                self.NameLabel.text = userlists.welf_name
                            self.NameLabel.backgroundColor = UIColor.white
                                                
                                                
                                                             //라벨 텍스트 줄 차가
                        self.NameLabel.font = UIFont(name: "NanumBarunGothic", size: 28)
                        self.NameLabel.textColor = UIColor.black
                        self.NameLabel.textAlignment = NSTextAlignment.center
                                                        //NameLabel.layer.borderWidth = 1
                                                       // NameLabel.layer.borderColor = UIColor.lightGray as? CGColor
                                                    //NameLabel.contentEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 0)
                                                
                                                
                                                let TopViewFrame = CGRect(x: 0, y: 360, width: self.screenWidth, height: 80)
                                                               let TopView = UIView(frame: TopViewFrame)

                                                  // TopView.backgroundColor = UIColor(displayP3Red:192/255,green : 192/255, blue : 192/255, alpha: 1)

                                                
                                                           //TopView.addSubview(NameLabel)
                                    self.m_Scrollview.addSubview(self.NameLabel)
                                                //self.m_Scrollview.addSubview(NameLabel)
                                                
                                                
                                                //맞춤정책설정하러가기 버튼
                                                //        //좋아요,공유하기 버튼
                                                //let button = UIButton.init(type: .system)
                                                //alarmBtn
                                                        //set image for button
                                    self.alarmBtn.setTitle("알림 설정하기", for: .normal)
                                    self.alarmBtn.setTitleColor(UIColor.white, for: .normal)

                                                        //add function for button
                                    self.alarmBtn.addTarget(self, action: #selector(self.targetTapped), for: .touchUpInside)
                                                        //set frame
                                                self.alarmBtn.frame = CGRect(x: 10, y: 440, width: self.screenWidth-20, height: 40)

                                                //버튼 터두리 설정
                                    self.alarmBtn.backgroundColor = UIColor(displayP3Red:86/255,green : 86/255, blue : 86/255, alpha: 1)

                                self.alarmBtn.layer.cornerRadius = 5
                                self.m_Scrollview.addSubview(self.alarmBtn)

      
                                                
                                                        //지원대상
                                                //let TargetFrame = CGRect(x: 0, y: 496, width: screenWidth, height: self.TargetHeight)
                        //let TargetLabel = UILabel(frame: TargetFrame)
                            self.TargetLabel.frame = CGRect(x: 0, y: 496, width: self.screenWidth, height: 40)
                            self.TargetLabel.text="지원대상"
                            self.TargetLabel.backgroundColor = UIColor.white
                                                                    //라벨 텍스트 줄 차가
                            self.TargetLabel.font = UIFont(name: "NanumBarunGothic", size: 32)
                            self.TargetLabel.textColor = UIColor(displayP3Red:86/255,green : 86/255, blue : 86/255, alpha: 1)
                            //self.TargetLabel.textAlignment = NSTextAlignment.center

                                                    
                                                //대상 설명을 텍스트뷰에 담는다.
                                               // let TargetTextFrame = CGRect(x: 0, y: 536, width: screenWidth, height:100)
                                                
                        //지원대상의 위치값은 위의 뷰들이 더보기 기능이 없기때문에 변동이 없다.
                        //let TargetText = UITextView(frame: TargetTextFrame)
                                                
                                                //텍스트뷰의 수정을 제한한다.
                                                self.TargetText.isEditable = false
                                                self.TargetText.textContainer.maximumNumberOfLines = 1
                                                self.TargetInfo = userlists.welf_target
                                                let splitArr = self.TargetInfo.split(separator: ".")
                                                
                                      
                                                
                                                
                                                
                                                
//                                                print("문자열 자르기")
//                                                print(splitArr[0])
//
////                                                splitArr.map { str in
////                                                    return print(str)
////                                                }
//                                                let str = "기저귀(월 6만 4,000원) 및 조제분유(월 8만 6,000원) 구매비용 국민행복카드 바우처 제공. "
//                                                print("문자열 길이:")
//                                                print(str.count)
//
                                                //self.TargetText.text = self.TargetInfo
                                                self.TargetText.text = String(splitArr[0])
                                                
                                                self.TargetText.frame = CGRect(x: 0, y: 536, width: self.screenWidth, height:self.TargetHeight)
                        //self.TargetText.textColor = UIColor(displayP3Red:86/255,green : 86/255, blue : 86/255, alpha: 1)
                        self.TargetText.font = UIFont(name: "NanumBarunGothic", size: 20)
                        //대상에 대한 정보 변수에 저장
                        print("대상내용")
                                                print(self.TargetInfo)
                        //self.ContentsInfo = userlists.welf_contents

                                                
                        self.m_Scrollview.addSubview(self.TargetLabel)
                            self.m_Scrollview.addSubview(self.TargetText)

                        //print("글자수")

                        //TargetText.delegate = self
//                                                self.TargetText.textContainer.heightTracksTextView = true
//                                                self.TargetText.isScrollEnabled = false
//
//
//                                                self.TargetText.textContainer.maximumNumberOfLines = 1
//                                              // print(TargetText.text.count)
//
//                                                self.TargetInfo = userlists.welf_target
//                                                self.TargetText.text = self.TargetInfo
                                                //TargetText.text = "userlists.welf_target"
                                              
                                             //   print("글자사이즈")
                                                //print(TargetText.font?.withSize(1))
                                    //더 들어가기 버튼
                            //let  TargetReadMoreBtn = UIButton(type: .system)
                                                                    // Specify the position of the button.
                        self.TargetReadMoreBtn.frame = CGRect(x: 10, y: 536+self.TargetHeight, width: self.screenWidth-20, height: 50)
                                      
                        self.TargetReadMoreBtn.setTitle("더 보기", for: .normal)
    
                        self.TargetReadMoreBtn.setTitleColor(UIColor(displayP3Red:86/255,green : 86/255, blue : 86/255, alpha: 1), for: .normal)
                                                    // footerView.setTitleColor = UIColor(displayP3Red:86/255,green : 86/255, blue : 86/255, alpha: 1)
                                      
                                      
                                //add function for button
                            self.TargetReadMoreBtn.addTarget(self, action: #selector(self.readMore), for: .touchUpInside)
                                                                         //set frame
                                      
                                                                 //버튼 터두리 설정
                            self.TargetReadMoreBtn.backgroundColor = .clear
                        
                            self.TargetReadMoreBtn.tag = 1
                            self.m_Scrollview.addSubview(self.TargetReadMoreBtn)

                                                
                                                
                                                
                                                
                                                //TargetText.sizeToFit();
                                                
//                                                let range = TargetText.selectedRange
//                                                print("범위")
//                                                print(range)
                                                    
                        //텍스트가 담길 수 있는 뷰 공간
                                                
                   // let lines = (textView.text as NSString).replacingCharacters(in: range, with: userlists.welf_target).components(separatedBy: .newlines)
//                        for line in lines {
//                        if line.characters.count > maxAllowedCharactersPerLine {
//                                                              return false
//                                                          }
//                                                }
                        //TargetText.textContainer.lineBreakMode = .byTruncatingTail
                                                
                            //TargetText.text = userlists.welf_target


                        //TargetText.textContainer.lineBreakMode = .byTruncatingTail

                                                


                                               
                                                //추가해줄 UiVIew
//                        let TargetViewFrame = CGRect(x: 0, y: 496, width: screenWidth, height: 160)
//                                let TargetView = UIView(frame: TargetViewFrame)
//                                                                                     //DeadLineView.backgroundColor = UIColor.gray.cgColor
//                                                TargetView.backgroundColor = UIColor(displayP3Red:192/255,green : 192/255, blue : 192/255, alpha: 1)
//
//                                                //TargetView.backgroundColor = UIColor.black
//
//                                                TargetView.addSubview(TargetLabel)
//                                                TargetView.addSubview(TargetText)
                                                
                   

                                                
                                                
                                                
                                                
                //혜택라벨
                //Y위치값: 타겟내용 시작위치 + 버튼 + 타겟내용의 길이
                    //let ContentsFrame = CGRect(x: 0, y: 586 + self.TargetHeight, width: screenWidth, height: 40)
                //let ContentsLabel = UILabel(frame: ContentsFrame)
                    self.ContentsLabel.frame = CGRect(x: 0, y: 586 + self.TargetHeight, width: self.screenWidth, height: 40)
                self.ContentsLabel.text="혜택내용"

                self.ContentsLabel.backgroundColor = UIColor.white
                    //라벨 텍스트 줄 차가
                self.ContentsLabel.font = UIFont(name: "NanumBarunGothic", size: 32)
                self.ContentsLabel.textColor = UIColor(displayP3Red:86/255,green : 86/255, blue : 86/255, alpha: 1)
                //self.ContentsLabel.textAlignment = NSTextAlignment.center
                                           
                                                
                    //혜택내용을 보여주는 텍스트뷰
                    //Y위치값: 타겟내용 시작위치 + 버튼길이 + 라벨길이+ 타겟내용의 길이

//                    let ContentsTextFrame = CGRect(x: 0, y: 586+self.TargetHeight, width: screenWidth, height: self.ContentHeight)
//                    ContentsText = UITextView(frame: ContentsTextFrame)
//
//
                        self.ContentsText.frame = CGRect(x: 0, y: 626+self.TargetHeight, width: self.screenWidth, height: self.ContentHeight)
                        self.ContentsInfo = userlists.welf_contents
                        self.ContentsText.textContainer.maximumNumberOfLines = 1
                        self.ContentsText.isEditable = false

                    self.ContentsText.text = self.ContentsInfo
                    //                 self.ContentsText.text =  self.TargetInfo
                     //self.ContentsText.textColor = UIColor(displayP3Red:86/255,green : 86/255, blue : 86/255, alpha: 1)
                    self.ContentsText.font = UIFont(name: "NanumBarunGothic", size: 20)

                                                
                                                
                                                //혜택내용을 담을 뷰
//                                                let ContentsViewFrame = CGRect(x: 0, y: 656, width: screenWidth, height: 120)
//                                                    let ContentsView = UIView(frame: ContentsViewFrame)
//
//                                                    ContentsView.backgroundColor = UIColor(displayP3Red:192/255,green : 192/255, blue : 192/255, alpha: 1)
//                                                    //TargetView.backgroundColor = UIColor.black
//
//                                                    ContentsView.addSubview(ContentsLabel)
//                                                    ContentsView.addSubview(ContentsText)
                                                
                    //더 들어가기 버튼
                    //기존위치값 + 유동위치(대상,내용뷰)
                    //let  ContentReadMoreBtn = UIButton(type: .system)
                
                    self.ContentReadMoreBtn.frame = CGRect(x: 10, y: 626+self.TargetHeight+self.ContentHeight, width: self.screenWidth-20, height: 50)
                                                          
                    self.ContentReadMoreBtn.setTitle("더 보기", for: .normal)
                        
                    self.ContentReadMoreBtn.setTitleColor(UIColor(displayP3Red:86/255,green : 86/255, blue : 86/255, alpha: 1), for: .normal)
                                   
                            //add function for button
                            self.ContentReadMoreBtn.addTarget(self, action: #selector(self.readMore), for: .touchUpInside)
         
                        //버튼 터두리 설정
                        self.ContentReadMoreBtn.backgroundColor = .clear
                                                
                            self.ContentReadMoreBtn.tag = 2
                            //스크롤뷰에 추가
                                self.m_Scrollview.addSubview(self.ContentReadMoreBtn)
                        self.m_Scrollview.addSubview(self.ContentsLabel)
                    self.m_Scrollview.addSubview(self.ContentsText)


                                                
                                //기간
                                                
                            //let DeadLineFrame = CGRect(x: 0, y: 676+self.TargetHeight+self.ContentHeight, width: screenWidth, height: 40)
                            //let DeadLineLabel = UILabel(frame: DeadLineFrame)
                            self.DeadLineLabel.frame = CGRect(x: 0, y: 676+self.TargetHeight+self.ContentHeight, width: self.screenWidth, height: 40)
                                                //let DeadLineLabel = UILabel(frame: DeadLineFrame)
                            self.DeadLineLabel.text="기간"
                            self.DeadLineLabel.backgroundColor = UIColor.white
                                //라벨 텍스트 줄 차가
                            self.DeadLineLabel.font = UIFont(name: "NanumBarunGothic", size: 32)
                            self.DeadLineLabel.textColor = UIColor(displayP3Red:86/255,green : 86/255, blue : 86/255, alpha: 1)
                            //self.DeadLineLabel.textAlignment = NSTextAlignment.center
                                                                  
                            //기간을 보여주는 텍스트뷰
                            //기간을 보여주는 텍스트뷰도 지원대상과 혜택내용의 더보기에 따라 위치가 변경된다.
                            //기간뷰의 스크롤상의 위치 이전Y위치값 +기간라벨 + 지원대상(변경가능)+ 혜택내용(변경가능)
                            //기간을 보여주는 뷰는 기간의 내용이 길지 않기때문에 더보기가 필요없다.
                            //let DeadLineTextFrame = CGRect(x: 0, y: 626+self.TargetHeight+self.ContentHeight, width: screenWidth, height: 40)
                                self.DeadLineText.frame = CGRect(x: 0, y: 716+self.TargetHeight+self.ContentHeight, width: self.screenWidth, height: 80)
                                                
                            self.DeadLineText.text = userlists.welf_period
                            //self.DeadLineText.textColor = UIColor(displayP3Red:86/255,green : 86/255, blue : 86/255, alpha: 1)
                            self.DeadLineText.font = UIFont(name: "NanumBarunGothic", size: 20)
                                                self.DeadLineText.isEditable = false

                                                
                                                                //추가해줄 UiVIew
//                            let DeadLineViewFrame = CGRect(x: 0, y: 776, width: screenWidth, height: 84)
//                        let DeadLineView = UIView(frame: DeadLineViewFrame)
//                                                //DeadLineView.backgroundColor = UIColor.gray.cgColor
//                        DeadLineView.backgroundColor = UIColor(displayP3Red:192/255,green : 192/255, blue : 192/255, alpha: 1)

//                            DeadLineView.addSubview(DeadLineLabel)
//                            DeadLineView.addSubview(DeadLineText)

                            self.m_Scrollview.addSubview(self.DeadLineLabel)
                            self.m_Scrollview.addSubview(self.DeadLineText)
                                                
                                                
                                                
                                //문의방법을 보여주는 뷰로써 위치는 기존Y 위치값 + 지원대상+혜택내용의 변경되는 길이값
                    
                                //let InquiryFrame = CGRect(x: 0, y: 796+self.TargetHeight+self.ContentHeight, width: screenWidth, height: 40)
                                //let InquiryLabel = UILabel(frame: InquiryFrame)
                            self.InquiryLabel.frame = CGRect(x: 0, y: 796+self.TargetHeight+self.ContentHeight, width: self.screenWidth, height: 40)
                            self.InquiryLabel.text="문의방법"
                        self.InquiryLabel.backgroundColor = UIColor.white
                          
                        
                            //라벨 텍스트 줄 차가
                        self.InquiryLabel.font = UIFont(name: "NanumBarunGothic", size: 32)
                        self.InquiryLabel.textColor = UIColor(displayP3Red:86/255,green : 86/255, blue : 86/255, alpha: 1)
                        self.InquiryLabel.textAlignment = NSTextAlignment.center

                            self.m_Scrollview.addSubview(self.InquiryLabel)
                                                
                            //문의방법을 보여주는 텍스트뷰
                            //let InquiryTextFrame = CGRect(x: 0, y: 900, width: screenWidth, height: 80)
                            self.InquiryText.frame = CGRect(x: 0, y: 836+self.TargetHeight+self.ContentHeight, width: self.screenWidth, height: self.InquiryHeight)
                                                                                
                            self.InquiryText.text = userlists.welf_contact
                            //self.InquiryText.textColor = UIColor(displayP3Red:86/255,green : 86/255, blue : 86/255, alpha: 1)
                            self.InquiryText.font = UIFont(name: "NanumBarunGothic", size: 20)
                            self.InquiryText.isEditable = false

                            
                                                
                                                
                                                
                                                
                                                
                                                
                            self.m_Scrollview.addSubview(self.InquiryText)

                                                
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
                                                applyBtn.frame = CGRect(x: 10, y: 996, width: self.screenWidth-20, height: 40)

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
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
         //디바이스의 크기
//                var screenWidth = Int(view.bounds.width)
//                var screenHeight = Int(view.bounds.height)
//
//        //        //스크롤뷰 옵션 설정
//                 m_Scrollview.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight-50)
//                m_Scrollview.contentSize = CGSize(width:screenWidth, height: 1044)
//
//        testView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 360)
//        testView.backgroundColor  = UIColor(displayP3Red:86/255,green : 86/255, blue : 86/255, alpha: 1)
//
//           //더 보기버튼
//                let button = UIButton.init(type: .system)
//                        //set image for button
//                button.setTitle("더 보기", for: .normal)
//                button.setTitleColor(UIColor.black, for: .normal)
//
//                        //add function for button
//                        button.addTarget(self, action: #selector(targetTapped), for: .touchUpInside)
//                        //set frame
//                        button.frame = CGRect(x: screenWidth-50, y: 0, width: 50, height: 50)
//
//                //버튼 터두리 설정
//                button.backgroundColor = .clear
//                button.layer.cornerRadius = 5
//                button.layer.borderWidth = 1
//                button.layer.borderColor = UIColor.black.cgColor
//
//        testView.addSubview(button)
//
//
//        //
//        //
//        m_Scrollview.addSubview(testView)
//        self.view.addSubview(m_Scrollview)
//
        
        
    
        // Do any additional setup after loading the view.
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
              
            
              print("뷰 더 보여주기")
           //m_Scrollview.contentSize = CGSize(width:500, height: 2000)
        m_Scrollview.subviews.forEach({ $0.removeFromSuperview() })
        
        testView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 500)
        testView.backgroundColor  =  UIColor(displayP3Red:86/255,green : 86/255, blue : 86/255, alpha: 1)
        let border = CALayer()
        border.backgroundColor =  UIColor.lightGray.cgColor
        
        //testView.addSublayer(border)
        border.frame = CGRect(x: testView.frame.minX, y: testView.frame.maxY, width: testView.frame.width, height: 10);
        testView.layer.addSublayer(border)
        
        m_Scrollview.addSubview(testView)
        self.view.subviews.forEach({ $0.removeFromSuperview() })
        self.view.addSubview(m_Scrollview)
        
        
        //SuperView의 bounds가 변경 될 때, receiver의 size를 조정하는 방법을 결정하는 정수 비트 마스크

//        m_Scrollview.translatesAutoresizingMaskIntoConstraints = false
//
//           m_Scrollview.heightAnchor.constraint(lessThanOrEqualToConstant: UIScreen.main.bounds.height / 2).isActive = true
//
//        self.TargetText.text = self.TargetInfo

        
  



        
          }
    
    
    
    func sizeOfString (string: String, constrainedToWidth width: Double, font: UIFont) -> CGSize {
        return (string as NSString).boundingRect(with: CGSize(width: width, height: DBL_MAX),
                                                 options: NSStringDrawingOptions.usesLineFragmentOrigin,
                                                 attributes: [NSAttributedString.Key.font: font],
            context: nil).size
    }

    
  func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
    print("텍스트뷰 메소드")
         
           return true
       }
    
    //더 보러가기 메소드,
    @objc func readMore(_ sender: UIButton) {
    // 원하는 대로 코드 구성
    print("버튼 클릭")
    //print(sender.tag)
        //1.스크롤뷰의 모든 서브뷰를 삭제
             m_Scrollview.subviews.forEach({ $0.removeFromSuperview() })
        //대상 더보기
        if(sender.tag == 1){
        
            if(targetBool){
            print("대상 더보기 클릭")
                
                //더보기 버튼을 감추기로 바꿔준다
                targetBool = false
                self.TargetReadMoreBtn.setTitle("감추기", for: .normal)

                
                
        //나중에 더 효율적인 방법으로 바꾸자
        //더보기를 클릭하면 스크롤뷰 상의 모든 뷰를 재배치해준다.
        //1.스크롤뷰의 모든 서브뷰를 삭제
       // m_Scrollview.subviews.forEach({ $0.removeFromSuperview() })
        //2.프레임변경 다시 저장
        //메인 이미지, 정책이름(라벨), 알림설정 버튼, 	지원대상(라벨), 지원대상(텍스트 뷰), 지원대상 더보기 버튼
        //혜택 라벨, 혜택내용 뷰, 혜택내용 더보기 버튼, 기간라벨, 기간내용 뷰, 문의라벨, 문의내용 뷰, 정책신청하기 버튼
        
            
        //더 보기버튼을 클릭했을 경우
    
        //대상내용의 길이값 변경
          self.TargetHeight = 320
         //self.TargetText.frame = CGRect(x: 0, y: 536, width: screenWidth, height:self.TargetHeight)

      
            
            //대상내용뷰의 줄 제한 변경
            self.TargetText.textContainer.maximumNumberOfLines = -1
            //내용 뷰에 반영
            //self.TargetText.text = self.TargetInfo
                
                //텍스트 간격 조절
//            let font = UIFont(name: "Avenir-Roman", size: 17.0)
//            let paragraphStyle = NSMutableParagraphStyle()
//            //paragraphStyle.paragraphSpacing = 10 * (font?.lineHeight)!
//                paragraphStyle.paragraphSpacing = 200
//            let attributes = [NSAttributedString.Key.font: font as Any, NSAttributedString.Key.paragraphStyle: paragraphStyle]
//
//            let attrText = NSAttributedString(string: self.TargetInfo, attributes: attributes)
//        self.TargetText.attributedText = attrText
                
                //내용간격 띄우기
                let style = NSMutableParagraphStyle()
                style.lineSpacing = 8
                let attributes = [NSAttributedString.Key.paragraphStyle: style]
                self.TargetText.attributedText = NSAttributedString(string: self.TargetInfo, attributes: attributes)
                self.TargetText.font = UIFont(name: "NanumBarunGothic", size: 20)

                //텍스트뷰 스크롤 제한
                self.TargetText.isScrollEnabled = false
                 //프레임 변경후 스크롤뷰에 child뷰들 추가
                      changeFrame()
                      addScrollsubViews()
                        m_Scrollview.contentSize = CGSize(width:screenWidth, height: 1324)

                //감추기를 클릭했을 경우
            }else{
                print("대상 감추기를 선택")
                //더보기 버튼을 감추기로 바꿔준다
                       targetBool = true
                       self.TargetReadMoreBtn.setTitle("더 보기", for: .normal)
                //대상내용의 길이값 변경
                      self.TargetHeight = 40
                     //self.TargetText.frame = CGRect(x: 0, y: 536, width: screenWidth, height:self.TargetHeight)

                  
                        //대상내용뷰의 줄 제한 변경
                                   self.TargetText.textContainer.maximumNumberOfLines = 1
                                   //내용 뷰에 반영
                //한줄로 자른 후 반영 
                let splitArr = self.TargetInfo.split(separator: ".")
                    
                    self.TargetText.text = String(splitArr[0])
                                   //self.TargetText.text = self.ContentsInfo
                        
                             //프레임 변경후 스크롤뷰에 child뷰들 추가
                                  changeFrame()
                                  addScrollsubViews()
           

                m_Scrollview.contentSize = CGSize(width:screenWidth, height: 956)

                
                
            }
            //self.m_Scrollview.addSubview(self.)

                            
            //메인스크롤뷰 뷰에 추가
           // self.view.addSubview(self.m_Scrollview)
                                
            
//
//        self.TargetText.textContainer.maximumNumberOfLines = 10
//        self.TargetText.text = TargetInfo

        }else if(sender.tag == 2){
            
            if(ContentsBool){
                    print("대상 더보기 클릭")
                        
                        //더보기 버튼을 감추기로 바꿔준다
                        ContentsBool = false
                        self.ContentReadMoreBtn.setTitle("감추기", for: .normal)
            print("혜택내용 더보기 클릭")
            
            //대상내용의 길이값 변경
            self.ContentHeight = 120
            //대상내용뷰의 줄 제한 변경
            self.ContentsText.textContainer.maximumNumberOfLines = -1
            //내용 뷰에 반영
            //self.ContentsText.text = self.ContentsInfo
            
                //내용간격 띄우기
                           let style = NSMutableParagraphStyle()
                           style.lineSpacing = 8
                           let attributes = [NSAttributedString.Key.paragraphStyle: style]
                           self.ContentsText.attributedText = NSAttributedString(string: self.ContentsInfo, attributes: attributes)
                self.ContentsText.font = UIFont(name: "NanumBarunGothic", size: 20)

                           //텍스트뷰 스크롤 제한
                           self.ContentsText.isScrollEnabled = false
                
                
            //프레임 변경후 스크롤뷰에 child뷰들 추가
                     changeFrame()
                     addScrollsubViews()
                m_Scrollview.contentSize = CGSize(width:screenWidth, height: 1324)

            }else{
                
                print("대상 감추기를 선택")
                //더보기 버튼을 감추기로 바꿔준다
                       ContentsBool = true
                       self.ContentReadMoreBtn.setTitle("더 보기", for: .normal)
                //대상내용의 길이값 변경
                      self.ContentHeight = 40
                     //self.TargetText.frame = CGRect(x: 0, y: 536, width: screenWidth, height:self.TargetHeight)

                  
                        
                        //대상내용뷰의 줄 제한 변경
                        self.ContentsText.textContainer.maximumNumberOfLines = 1
                        //내용 뷰에 반영
                        self.ContentsText.text = self.ContentsInfo
                

                             //프레임 변경후 스크롤뷰에 child뷰들 추가
                                  changeFrame()
                                  addScrollsubViews()
                m_Scrollview.contentSize = CGSize(width:screenWidth, height: 1224)

                
                
            }
            
        }
        

               
            }
    
    
    //더 보기할때마다 스크롤뷰 상의 콘텐츠뷰들의 프레임을 변경해주는 메소드
    func changeFrame() {
        self.TargetText.frame = CGRect(x: 0, y: 536, width: screenWidth, height:self.TargetHeight)
        self.TargetReadMoreBtn.frame = CGRect(x: 10, y: 536+self.TargetHeight, width: self.screenWidth-20, height: 50)
                self.ContentsLabel.frame = CGRect(x: 0, y: 586 + self.TargetHeight, width: self.screenWidth, height: 40)
                self.ContentsText.frame = CGRect(x: 0, y: 626+self.TargetHeight, width: self.screenWidth, height: self.ContentHeight)
                self.ContentReadMoreBtn.frame = CGRect(x: 10, y: 626+self.TargetHeight+self.ContentHeight, width: self.screenWidth-20, height: 50)
                
                self.DeadLineLabel.frame = CGRect(x: 0, y: 676+self.TargetHeight+self.ContentHeight, width: self.screenWidth, height: 40)
                
                self.DeadLineText.frame = CGRect(x: 0, y: 716+self.TargetHeight+self.ContentHeight, width: self.screenWidth, height: 80)
                
                
                self.InquiryLabel.frame = CGRect(x: 0, y: 796+self.TargetHeight+self.ContentHeight, width: self.screenWidth, height: 40)
                

                self.InquiryText.frame = CGRect(x: 0, y: 836+self.TargetHeight+self.ContentHeight, width: self.screenWidth, height: self.InquiryHeight)
        
    }

    
    //스크롤뷰에 뷰들을 추가해주는 메소드
    func addScrollsubViews(){
        
        //위치변경이 없는 뷰들 추가
                 self.m_Scrollview.addSubview(self.imageView)
                 self.m_Scrollview.addSubview(self.NameLabel)
                 self.m_Scrollview.addSubview(self.alarmBtn)
                 self.m_Scrollview.addSubview(self.TargetLabel)


                 //위치변경이 있는 뷰들 추가
                 self.m_Scrollview.addSubview(self.TargetText)
                 self.m_Scrollview.addSubview(self.TargetReadMoreBtn)
                 self.m_Scrollview.addSubview(self.ContentsLabel)
                 self.m_Scrollview.addSubview(self.ContentsText)
                 self.m_Scrollview.addSubview(self.ContentReadMoreBtn)
                 self.m_Scrollview.addSubview(self.DeadLineLabel)
                 self.m_Scrollview.addSubview(self.DeadLineText)
                 self.m_Scrollview.addSubview(self.InquiryLabel)
                 self.m_Scrollview.addSubview(self.InquiryText)
        
    }


}
