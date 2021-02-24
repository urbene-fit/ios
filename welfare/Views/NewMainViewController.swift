//
//  NewMainViewController.swift
//  welfare
//
//  Created by 김동현 on 2020/12/22.
//  Copyright © 2020 com. All rights reserved.
//

import UIKit
import Alamofire
//uiimageview setimage 메소드를 상속받게함 
import SwiftyGif


class NewMainViewController: UIViewController, UIScrollViewDelegate, UISearchBarDelegate {
    
    // 메인 세로 스크롤
    let m_Scrollview = UIScrollView()
    
    //가로스크롤뷰
    //유튜브
    var ytb_scroll = UIScrollView()
    
    //맞춤 혜택
    var Personalized_scroll = UIScrollView()
    
    //임시 맞춤혜택 이미지
    //라벨명을 담을 배열
    var PersonalizedImg = ["Personalized0","Personalized1","Personalized2","Personalized3"]
    
    //기간제한 혜택
    var deadline_scroll = UIScrollView()
    
 
    //유튜브 파싱
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
    
    
    //맞춤정책 파싱
    struct Personalized: Decodable {
        var welf_name : String
        var welf_local : String
        var welf_category : String
        var tag : String
    }
    
    
    struct PersonalizedParse: Decodable {
        let Status : String
        //반환값이 없을떄 처리
        let Message : [Personalized]
    }
    
    var PersonalizedList = [Personalized]()
    
    
    
    
    //혜택상세내용 파싱
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
    
    var beginImage: CIImage!
    var context: CIContext!
    var filter: CIFilter!
    //검색창 바
    let searchBar = UISearchBar()
    var screenWidth : Int = 0
    var screenHeight : Int = 0
    
    //로그 보낼떄 화면을 알려주는 변수
    var type : String = "home"
    
    //인치별 높이비율 수치
    var heightRatio : CGFloat = 0

    //아이템 이미지 불러올때 사용할 자료구조
    var imgDic : [String : String] = ["일자리지원":"job", "공간지원":"house","교육지원":"traning","현금지원":"cash","사업화지원":"business","카드지원":"giftCard","취업지원":"job","활동지원":"activity","보험지원":"insurance","상담지원":"counseling","진료지원":"treat","임대지원":"rent","창업지원":"business","재활지원":"recover","인력지원":"support","물품지원":"goods","현물지원":"goods","숙식지원":"bedBoard","정보지원":"information","멘토링지원":"mentor","감면지원":"tax","대출지원":"loan","치료지원":"care","서비스지원":"service","홍보지원":"service","세탁서비스지원":"service","컨설팅지원":"Consulting"]
    
    //네비게이션 컨트롤러 변경
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        print("메인 : viewDidAppear")
        //        DuViewController의 view가 사라짐
        //        ReViewViewController의 view가 화면에 나타남
        setBarButton()
        
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("메인 : viewDidLoad")
        
        if DeviceManager.sharedInstance.isFiveIncheDevices() {
            print("5인치")
            heightRatio = DeviceManager.sharedInstance.widthRatio
            
            
        }else if DeviceManager.sharedInstance.isFourIncheDevices() {
            print("4인치")
        }else if DeviceManager.sharedInstance.isSixIncheDevices() {
            print("6인치")
            heightRatio = DeviceManager.sharedInstance.heightRatio

        
        }else{
            print("인치구분안됨")
            heightRatio = DeviceManager.sharedInstance.heightRatio


        }
        

        //로그기록으로 보낼 디바이스 정보
        var modelName = DeviceManager.sharedInstance.modelName
        var systemVersion = DeviceManager.sharedInstance.systemVersion
        
        //네비바 백버튼 설정
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        
        
        //화면 배경색 설정
        //self.view.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        
        
        print("기기 정보 : \(modelName)")
        print("ios버전정보 : \(systemVersion)")
        
        
        //로그 전송
        //DeviceManager.sharedInstance.sendLog(content: "메인접속")
        
        
        
        
        //화면 스크롤 크기
        var screenWidth = Int(view.bounds.width)
        var screenHeight = Int(view.bounds.height)
        
        print("토큰 : \(LoginManager.sharedInstance.token)")
        print("불린 : \(LoginManager.sharedInstance.checkInfo)")
        
        //로그인 여부와 개인정보 입력여부를 체크한다.
        //그에 따라 메인화면 구성을 변경한다.
        // if(LoginManager.sharedInstance.token != "" && LoginManager.sharedInstance.checkInfo){
        
     
        
        
        configureAutolayouts()

        
        
    
        
    }
    
    //메인 상단의 뷰를 로그인,키워드 입력여부에 따라 바꿔준다.
    func setTop(){
        
        //로그인도 되어있고, 키워드정보도 입력했을 경우
        if(LoginManager.sharedInstance.checkInfo && LoginManager.sharedInstance.token != ""){
            
         print("키워드 정보 입력되어있을경우")
            
            //맞춤정책받아오기
            let parameters = ["type":"customized", "login_token": LoginManager.sharedInstance.token]
            
            Alamofire.request("https://www.urbene-fit.com/welf", method: .get, parameters: parameters)
                .validate()
                .responseJSON { [self] response in
                    
                    switch response.result {
                    case .success(let value):
                        do {
                            let data = try JSONSerialization.data(withJSONObject: value, options: .prettyPrinted)
                            let result = try JSONDecoder().decode(PersonalizedParse.self, from: data)
                            
                            
                            //맞춤정책
                            for i in 0..<result.Message.count {
                                
                                self.PersonalizedList.append(Personalized.init(welf_name: result.Message[i].welf_name, welf_local: result.Message[i].welf_local, welf_category: result.Message[i].welf_category, tag : result.Message[i].tag))
                                
                                print("맞춤정책: '\(result.Message[i].welf_name)'")
                                
                       
                                let xPosition = (DeviceManager.sharedInstance.width - (40  *  DeviceManager.sharedInstance.widthRatio) + 30) * CGFloat(i) + 30
                                
  
                                
                                let listView = UIView()
                                listView.frame = CGRect(x: xPosition, y: 20 *  heightRatio,
                                                        width: DeviceManager.sharedInstance.width - (40  *  DeviceManager.sharedInstance.widthRatio),
                                                        height: 220 *  heightRatio)
                                
                                listView.backgroundColor = UIColor(displayP3Red:238/255,green : 47/255, blue : 67/255, alpha: 1)
                                
                                listView.layer.borderWidth = 1
                                listView.layer.borderColor = UIColor(displayP3Red:238/255,green : 47/255, blue : 67/255, alpha: 1).cgColor
                                listView.layer.cornerRadius = 33
                   
                                //정책명
                                let policyName = UILabel()
                                policyName.frame = CGRect(x: 20  *  DeviceManager.sharedInstance.widthRatio, y: 60  *  heightRatio,
                                                          width: 200  *  DeviceManager.sharedInstance.widthRatio,
                                                          height: 120  *  heightRatio)
                                policyName.font = UIFont(name: "Jalnan", size: 20  *  heightRatio)
                                policyName.textColor = UIColor.white
                                policyName.numberOfLines = 6
                                
                                var title = PersonalizedList[i].welf_name.replacingOccurrences(of: " ", with: "\n")
                                policyName.text = title

                                listView.addSubview(policyName)
                                
                                //혜택지역
                                let localName = UILabel()
                                localName.frame = CGRect(x: 20  *  DeviceManager.sharedInstance.widthRatio, y: 20  *  heightRatio,
                                                          width: 200  *  DeviceManager.sharedInstance.widthRatio,
                                                          height: 20  *  heightRatio)
                                localName.font = UIFont(name: "Jalnan", size: 15  *  heightRatio)
                                localName.textColor = UIColor.white
                                
                                
                                localName.text = "#\(PersonalizedList[i].welf_local)"

                                listView.addSubview(localName)
                                
                                
                                //혜택 일러스트
                                let categoryImg = UIImageView()
                                categoryImg.frame = CGRect(x: DeviceManager.sharedInstance.width - (40  *  DeviceManager.sharedInstance.widthRatio) - (200  *  DeviceManager.sharedInstance.widthRatio), y: 0,
                                                           width: 200  *  DeviceManager.sharedInstance.widthRatio,
                                                           height: 200  *  heightRatio)
                                //일러스트 추가
                                
                                var tag = PersonalizedList[i].welf_category.replacingOccurrences(of: " ", with: "")
                                //split
                                var arr = tag.components(separatedBy: ";;")
                                var imgName = arr[0]
                            
                                    print("이미지 : \(imgName)")
                                    if(imgDic[imgName] != nil){
                                    categoryImg.setImage(UIImage(named: imgDic[imgName]!)!)
                                    }else{
                                     categoryImg.setImage(UIImage(named: "AppIcon")!)

                                    }
                                
                                
                                listView.addSubview(categoryImg)
                                
                             
                                
                                //음영처리
                                listView.layer.shadowColor = UIColor.black.cgColor
                                listView.layer.shadowOffset = CGSize(width: 5, height: 5) // 반경에 대해서 너무 적용이 되어서 4point 정도 ㅐ림.
                                
                                listView.layer.shadowOpacity = 1
                                listView.layer.shadowRadius = 1 // 반경?
                                
                                listView.layer.shadowOpacity = 0.5 // alpha값입니다.
                                self.Personalized_scroll.addSubview(listView)
                                
                            }
                            Personalized_scroll.frame = CGRect(x: 0, y: 170 *  heightRatio, width: self.view.frame.width, height: 330 *  heightRatio)
                            Personalized_scroll.contentSize.width = (DeviceManager.sharedInstance.width - (40  *  DeviceManager.sharedInstance.widthRatio) + 30) * CGFloat(PersonalizedList.count) + 30
                            //각 스크롤의 터치 혹은 스크롤 이벤트를 구분하기 위해 태그값을 준다.
                            Personalized_scroll.tag = 2
                            
                            let singleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.selectPersonalized))
                            
                            singleTapGestureRecognizer.numberOfTapsRequired = 1
                            
                            singleTapGestureRecognizer.isEnabled = true
                            
                            singleTapGestureRecognizer.cancelsTouchesInView = false
                            
                            self.Personalized_scroll.addGestureRecognizer(singleTapGestureRecognizer)
                            
                            Personalized_scroll.backgroundColor = UIColor.white

                            m_Scrollview.addSubview(Personalized_scroll)
                            
                            Personalized_scroll.showsHorizontalScrollIndicator = false
                            
                            //추천 라벨
                            let recommendLabel = UILabel()
                            
                            recommendLabel.frame =  CGRect(x: 20, y: 80 *  heightRatio,
                                                           width: DeviceManager.sharedInstance.width,
                                                           height: 90 *  heightRatio)
                            
                            recommendLabel.backgroundColor = UIColor.white
                            var nickName : String = ""
                            if(UserDefaults.standard.string(forKey: "nickName") != nil){
                                nickName = UserDefaults.standard.string(forKey: "nickName")!
                            }
                            recommendLabel.text = "\(nickName) 님에게\n    복지혜택 \(PersonalizedList.count)개를 추천해요"
                            recommendLabel.numberOfLines = 2
                           // recommendLabel.font = UIFont(name: "NanumBarunGothicBold", size: 20  *  DeviceManager.sharedInstance.heightRatio)
                            recommendLabel.font = UIFont(name: "Jalnan", size: 26  *  heightRatio)
                            
                            //색상변경
                            let attributedStr = NSMutableAttributedString(string: recommendLabel.text!)
                            
                            attributedStr.addAttribute(.foregroundColor, value: UIColor(displayP3Red:238/255,green : 47/255, blue : 67/255, alpha: 1), range: (recommendLabel.text! as NSString).range(of: nickName))
                            
                            attributedStr.addAttribute(.foregroundColor, value: UIColor(displayP3Red:238/255,green : 47/255, blue : 67/255, alpha: 1), range: (recommendLabel.text! as NSString).range(of: "\(PersonalizedList.count)개"))
                            
                            
                            recommendLabel.attributedText = attributedStr
                            
                            m_Scrollview.addSubview(recommendLabel)
                         
                            
                            
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
            
            
            
            //아닌 경우
        }else{
            
            print("키워드 정보 입력 안되어있는 경우")

            //배너부분 뷰
            let bannerView = UIView()
            
            bannerView.frame =  CGRect(x: 0, y: 0 * heightRatio,
                                       width: DeviceManager.sharedInstance.width,
                                       height: 495 *  heightRatio)
            
            bannerView.backgroundColor = UIColor.white
            m_Scrollview.addSubview(bannerView)
            
            //배너 부분
            let bannerLabel = UILabel()
            // bannerLabel.frame = CGRect(x: 20, y: 20, width: 180 * DeviceManager.sharedInstance.widthRatio, height: 150 *  DeviceManager.sharedInstance.heightRatio)
            bannerLabel.frame = CGRect(x: 20  *  DeviceManager.sharedInstance.widthRatio, y: 60  *  heightRatio, width: 180 * DeviceManager.sharedInstance.widthRatio, height: 150 *  heightRatio)
            bannerLabel.backgroundColor = UIColor.clear
            bannerLabel.numberOfLines = 2
            bannerLabel.text = "당신만 놓치고\n 있는"
            bannerLabel.textColor = UIColor.white
            bannerLabel.font = UIFont(name: "Jalnan", size: 26  *  heightRatio)
            
            let attrString = NSMutableAttributedString(string: bannerLabel.text!)
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 20  *  heightRatio
            attrString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attrString.length))
            bannerLabel.attributedText = attrString
            bannerLabel.textAlignment = .left
            
            
            let MainUi = UIView()
 
            MainUi.frame = CGRect(x: 0, y: 40 * heightRatio, width: DeviceManager.sharedInstance.width, height: 440 *  heightRatio)
            

            MainUi.backgroundColor = UIColor(displayP3Red:238/255,green : 47/255, blue : 67/255, alpha: 1)
            

            let mainImg = UIImageView()
            
         
            mainImg.frame = CGRect(x: 100 * DeviceManager.sharedInstance.heightRatio, y: 100 *  heightRatio, width: 260 *  DeviceManager.sharedInstance.widthRatio, height: 300 *  heightRatio)

            mainImg.backgroundColor = UIColor.clear
            mainImg.setImage(flipImageLeftRight(UIImage(named: "main")!)!)
          
             MainUi.addSubview(mainImg)
            
            let moveBtn = UIButton(type: .system)
            
            moveBtn.setTitle("혜택 추천 받으러 가기", for: .normal)
           
            moveBtn.frame = CGRect(x: 110 * DeviceManager.sharedInstance.widthRatio , y: 130 *  heightRatio, width: 200 *  DeviceManager.sharedInstance.widthRatio, height:  50 *  heightRatio)
            
            moveBtn.titleLabel!.font = UIFont(name: "Jalnan", size:16.1 *  heightRatio)
            moveBtn.layer.cornerRadius = 13 *  heightRatio
            moveBtn.layer.borderWidth = 1.3
            moveBtn.layer.borderColor = UIColor.white.cgColor
            //            moveBtn.backgroundColor = UIColor.white
            //            moveBtn.tintColor = UIColor(displayP3Red:238/255,green : 47/255, blue : 67/255, alpha: 1)
            
            moveBtn.backgroundColor =  UIColor.white
            moveBtn.tintColor =  UIColor(displayP3Red:238/255,green : 47/255, blue : 67/255, alpha: 1)
            //선택결과 페이지로 이동하는 메소드
            moveBtn.addTarget(self, action: #selector(self.inputInfo), for: .touchUpInside)
            
            moveBtn.layer.shadowColor = UIColor.black.cgColor
            moveBtn.layer.shadowOffset = CGSize(width: 5 *  DeviceManager.sharedInstance.widthRatio, height: 5 *  heightRatio) // 반경에 대해서 너무 적용이 되어서 4point 정도 ㅐ림.
            
            moveBtn.layer.shadowOpacity = 1
            moveBtn.layer.shadowRadius = 1 // 반경?
            
            moveBtn.layer.shadowOpacity = 0.5 // alpha값입니다.
            
                        m_Scrollview.addSubview(MainUi)
            //            MainUi.addSubview(bannerLabel)
            //            //m_Scrollview.addSubview(bannerLabel)
            
            m_Scrollview.addSubview(bannerLabel)
            
            m_Scrollview.addSubview(moveBtn)
        }
        
    }
    
    
    // 혜택 소개영상을 클릭하면 영상을 보여주는 화면으로 이동
    @objc func MyTapMethod(sender: UITapGestureRecognizer) {
        
        print("사진 터치")
        
        //유튜브클릭일 경우
        guard let RVC = self.storyboard?.instantiateViewController(withIdentifier: "testYoutubeViewController") as? testYoutubeViewController         else{
            
            return
            
        }
        //뷰 이동
        RVC.modalPresentationStyle = .fullScreen
        
        
        //선택한 영상의 번호를 스크롤뷰의 x 좌표값을 통해 받아온다.
        var Index : Int = Int(ytb_scroll.contentOffset.x / ytb_scroll.frame.maxX)
        RVC.videoID = ytbList[Index].videoId
        RVC.videoTitle = ytbList[Index].title
        
        
        
      
        self.navigationController?.pushViewController(RVC, animated: true)
        
        
    }
    
    @objc func selectPersonalized(sender: UITapGestureRecognizer) {
        //var Index : Int = Int(Personalized_scroll.contentOffset.x / Personalized_scroll.frame.maxX)
        
        //스크롤뷰 상에서 터치한 x 죄표를 얻어온다.
        let tappedPoint: CGPoint = sender.location(in: Personalized_scroll)
        let x: CGFloat = tappedPoint.x
        
        //전체 스크롤길이로 나누어져서 어떤 아이템이 클릭됬는지 판별한다. 
        var Index : Int = Int(x / Personalized_scroll.frame.maxX)
        
        //상세페이지로 이동
        print(PersonalizedList[Index].welf_name)
        
        guard let RVC = self.storyboard?.instantiateViewController(withIdentifier: "NewDetailView") as? NewDetailView         else{
            
            return
            
        }
        
        RVC.selectedPolicy = "\(PersonalizedList[Index].welf_name)"
        RVC.selectedLocal = "\(PersonalizedList[Index].welf_local)"

        RVC.modalPresentationStyle = .fullScreen
        
        //혜택 상세보기 페이지로 이동
        //self.present(RVC, animated: true, completion: nil)
        self.navigationController?.pushViewController(RVC, animated: true)
        
        
        print("맞춤정책 클릭\(PersonalizedList[Index].welf_name)")
    }
    
    //이미지 자르는 메소드
    func crop(imgUrl : String) -> UIImage? {
        let imageUrl = URL(string: imgUrl)!
        let data = try! Data(contentsOf: imageUrl)
        let image = UIImage(data: data)!
        
        // Crop rectangle
        let width = min(image.size.width, image.size.height)
        let size = CGSize(width: width, height: image.size.height )
        
        // If you want to crop center of image
        //let startPoint = CGPoint(x: (image.size.width - width) / 2, y: (image.size.height - width) / 2)
        
        //뷰상에 이미지를 배치하는 위치
        let startPoint = CGPoint(x: 0, y: -45 * DeviceManager.sharedInstance.heightRatio)
        let endPoint = CGPoint(x: image.size.width , y: image.size.height  - (38 * DeviceManager.sharedInstance.heightRatio))
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        
        image.draw(in: CGRect(origin: startPoint, size: size))
        //image.draw(in: CGRect(origin: startPoint, size : endPoint))
        //image.draw(in: CGRect(x: 0, y: -45, width: image.size.width, height: image.size.height))
        
        let croppedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        
        
        
        return croppedImage
    }
    
    
    //개인정보 및 키워드 입력하는 페이지로 이동
    @objc func inputInfo(_ sender: UIButton) {
        print("기본정보 입력페이지로 이동")
        
        //로그인도 안되있을경우
        if(LoginManager.sharedInstance.token == ""){
            DeviceManager.sharedInstance.sendLog(content: "로그인 페이지로 이동",type: "home")
            
            guard let RVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController         else{
                
                return
                
            }
            
            
            RVC.moveView = "keyword"
            RVC.modalPresentationStyle = .fullScreen
            
            //혜택 상세보기 페이지로 이동
            //self.present(RVC, animated: true, completion: nil)
            self.navigationController?.pushViewController(RVC, animated: true)
            
            //로그인은 되있지만 키워드가 입력되어있지 않은 경우
        }else{
            
            DeviceManager.sharedInstance.sendLog(content: "기본정보 입력페이지로 이동", type: type)
            
            guard let RVC = self.storyboard?.instantiateViewController(withIdentifier: "newInfoViewController") as? newInfoViewController         else{
                
                return
                
            }
            
            RVC.modalPresentationStyle = .fullScreen
            
            //혜택 상세보기 페이지로 이동
            //self.present(RVC, animated: true, completion: nil)
            self.navigationController?.pushViewController(RVC, animated: true)
            
        }
        
    }
    
    //지도화면으로 이동
    @objc func mapPage(_ sender: UIButton) {
        print("혜택지도 페이지로 이동")
        DeviceManager.sharedInstance.sendLog(content: "혜택지도 페이지로 이동", type: type)
        
        
        guard let RVC = self.storyboard?.instantiateViewController(withIdentifier: "mapTestViewController") as? mapTestViewController         else{
            
            return
            
        }
        
        RVC.modalPresentationStyle = .fullScreen
        
        //혜택 상세보기 페이지로 이동
        //self.present(RVC, animated: true, completion: nil)
        self.navigationController?.pushViewController(RVC, animated: true)
        
        
        
    }
    
    
    
    
    
    //이미지 좌우반전
    func flipImageLeftRight(_ image: UIImage) -> UIImage? {
        
        
        
        UIGraphicsBeginImageContextWithOptions(image.size, false, image.scale)
        
        let context = UIGraphicsGetCurrentContext()!
        
        context.translateBy(x: image.size.width, y: image.size.height)
        
        context.scaleBy(x: -image.scale, y: -image.scale)
        
        
        
        context.draw(image.cgImage!, in: CGRect(origin:CGPoint.zero, size: image.size))
        
        
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        
        
        
        UIGraphicsEndImageContext()
        
        
        
        return newImage
        
    }
    
    
    
    
    
    //네비게이션 바 세팅
    private func setBarButton() {
        print("ReViewViewController의 setBarButton")
        
        
        self.navigationController?.navigationBar.topItem?.titleView = nil
        self.navigationController?.navigationBar.shadowImage = nil
        self.navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        
        
        let naviLabel = UILabel()
        naviLabel.frame = CGRect(x: 63.8, y: 235.4, width: 118, height: 17.3)
        naviLabel.textAlignment = .center
        naviLabel.textColor = UIColor(displayP3Red:238/255,green : 47/255, blue : 67/255, alpha: 1)
        
        naviLabel.text = "UrBene_Fit"
        naviLabel.font = UIFont(name: "Bowhouse-Black", size: 30  *  DeviceManager.sharedInstance.heightRatio)
        self.navigationController?.navigationBar.topItem?.titleView = naviLabel
        
    }
    
    func setMain(){
        
    }
    
    //fileprivate 는 하나의 스위프트 파일( .swift ) 내부에서만 접근이 가능한 접근제어 수준
    fileprivate func configureAutolayouts() {
        
  
        
        //유튜브 리스트를 보여주는 뷰
        let ytbView  = UIView()
        ytbView.frame =  CGRect(x: 0, y: 510  *  DeviceManager.sharedInstance.widthRatio,
                                width: DeviceManager.sharedInstance.width,
                                height: 300 *  heightRatio)
        
        ytbView.backgroundColor = UIColor.white
        //m_Scrollview.addSubview(ytbView)
        
        //유튜브 정보 받아오기
        Alamofire.request("https://www.urbene-fit.com/youtube", method: .get)
            .validate()
            .responseJSON { [self] response in
                
                switch response.result {
                case .success(let value):
                    do {
                        let data = try JSONSerialization.data(withJSONObject: value, options: .prettyPrinted)
                        let ytbList = try JSONDecoder().decode(ytbParse.self, from: data)
                        
                        
                        
                        //리뷰데이터를 테이블아이템에 추가해준다.
                        for i in 0..<ytbList.Message.count {
                            
                            self.ytbList.append(ytb.init(videoId: ytbList.Message[i].videoId, title: ytbList.Message[i].title, thumbnail: ytbList.Message[i].thumbnail))
                            
                            
                            print("썸네일 체크 \(ytbList.Message[i].thumbnail)")
                            let imageView = UIImageView()
                            let url = URL(string: ytbList.Message[i].thumbnail)
                      
                            imageView.frame = CGRect(x: 0, y: 0,
                                                     width: 280  *  DeviceManager.sharedInstance.widthRatio,
                                                     height: 200 *  heightRatio)
                          
                        
                            imageView.setImage(crop(imgUrl: ytbList.Message[i].thumbnail)!)
                            
                            let test = UIView()
                            
                            let xPosition = (300 * CGFloat(i) + 20) * DeviceManager.sharedInstance.widthRatio
                            
                            test.frame = CGRect(x: xPosition, y: 30  *  heightRatio, width: 280  *  DeviceManager.sharedInstance.widthRatio, height: 260 *  heightRatio)
                           
                            test.layer.borderColor = UIColor.white.cgColor
                            test.backgroundColor = UIColor.white
                            
                       
                            
                            
                            test.addSubview(imageView)
                            
                            var nameLabel = UILabel()
                            nameLabel.frame = CGRect(x: 0, y: 150  *  heightRatio, width: 280  *  DeviceManager.sharedInstance.widthRatio, height: 60 *  heightRatio)
                            nameLabel.backgroundColor = UIColor.white
                            nameLabel.text = ytbList.Message[i].title
                            nameLabel.font = UIFont(name: "NanumBarunGothicBold", size: 14 *  heightRatio)
                            nameLabel.textAlignment = .center
                            nameLabel.numberOfLines = 3
                            test.addSubview(nameLabel)
                            
                            
                            //재생버튼이미지 삽입
                            var playImg = UIImageView(image: UIImage(named: "playBtn")!)
                            playImg.frame =  CGRect(x: 120  *  DeviceManager.sharedInstance.widthRatio, y: 70  *  heightRatio , width: 30  *  DeviceManager.sharedInstance.widthRatio, height: 30  *  heightRatio)
                            playImg.tintColor = UIColor.white
                            playImg.image = playImg.image?.withRenderingMode(.alwaysTemplate)
                            
                            test.addSubview(playImg)
                            
                            
                            ytb_scroll.addSubview(test)
                            
                            
                            
                            
                            
                            
                        }
                        
                        let singleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.MyTapMethod))
                        
                        singleTapGestureRecognizer.numberOfTapsRequired = 1
                        
                        singleTapGestureRecognizer.isEnabled = true
                        
                        singleTapGestureRecognizer.cancelsTouchesInView = false
                        
                        self.ytb_scroll.addGestureRecognizer(singleTapGestureRecognizer)
                        //                            //                        ytb_scroll.frame =
                        ytb_scroll.frame = CGRect(x: 0, y: 550  *  heightRatio, width: DeviceManager.sharedInstance.width, height: 260 *  heightRatio)
                        ytb_scroll.contentSize.width =
                            320 * CGFloat(ytbList.Message.count ) *  DeviceManager.sharedInstance.widthRatio
                        //ytb_scroll.isPagingEnabled = true
                        ytb_scroll.showsHorizontalScrollIndicator = false
                        
                        
                        
                        //각 스크롤의 터치 혹은 스크롤 이벤트를 구분하기 위해 태그값을 준다.
                        ytb_scroll.tag = 1
                        m_Scrollview.addSubview(ytb_scroll)
                        
                        
                        
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
        
        setTop()
        
        
        //서치바
        searchBar.showsScopeBar = true
        
        searchBar.delegate = self
        
        searchBar.tintColor = UIColor(displayP3Red:238/255,green : 47/255, blue : 67/255, alpha: 1)
        searchBar.text = "어떤 혜택이 필요하세요?"
        //searchBar.placeholder = "어떤 혜택이 필요하세요?"
        
        //서치 바 추가
        searchBar.frame = CGRect(x: 20 * DeviceManager.sharedInstance.widthRatio, y: 20 * heightRatio, width: CGFloat(screenWidth) - (40 *  DeviceManager.sharedInstance.widthRatio), height: 50 * heightRatio)
        
        searchBar.layer.borderWidth = 1
        searchBar.layer.borderColor = UIColor.white.cgColor
        //searchBar.sizeToFit()
        //bannerLabel.addSubview(searchBar)
        
        
        
        
        
        
        
        
        
        //지도
        let mapUiView = UIView()
        mapUiView.frame = CGRect(x: 0, y: 830 *  heightRatio, width: CGFloat(DeviceManager.sharedInstance.width), height: 320 * heightRatio)
        
        //mapUiView.backgroundColor = #colorLiteral(red: 0.9568627477, green: 0.7125763441, blue: 0.7689008231, alpha: 1)
        mapUiView.backgroundColor = UIColor(displayP3Red:238/255,green : 47/255, blue : 67/255, alpha: 1)
        
        
        let mapLabel = UILabel()
        mapLabel.frame = CGRect(x: 20 *  DeviceManager.sharedInstance.widthRatio, y: 20 *  heightRatio, width: 260 *  DeviceManager.sharedInstance.widthRatio, height: 50 *  heightRatio)
        mapLabel.textAlignment = .left
        mapLabel.textColor = UIColor.white
        //mapLabel.backgroundColor = #colorLiteral(red: 0.9568627477, green: 0.7125763441, blue: 0.7689008231, alpha: 1)
        //mapLabel.backgroundColor = UIColor(displayP3Red:238/255,green : 47/255, blue : 67/255, alpha: 1)
        
        mapLabel.text = "내 주변 혜택찾기"
        mapLabel.font = UIFont(name: "Jalnan", size: 26  *  heightRatio)
        
        //동네 일러스트 이미지 추가
        let townImg = UIImageView()
        
        townImg.frame = CGRect(x: 230 *  DeviceManager.sharedInstance.widthRatio, y: 100 *  heightRatio, width: 200 *  DeviceManager.sharedInstance.widthRatio, height: 200 *  heightRatio)
        townImg.backgroundColor = UIColor.clear
        townImg.setImage(flipImageLeftRight(UIImage(named: "searchMap")!)!)
        //            mainImg.tintColor = #colorLiteral(red: 1, green: 0.6757187131, blue: 0.7413782814, alpha: 1)
        //            mainImg.image = mainImg.image?.withRenderingMode(.alwaysTemplate)
        mapUiView.addSubview(mapLabel)
        
        mapUiView.addSubview(townImg)
        
        
        m_Scrollview.addSubview(mapUiView)
        
        let mapBtn = UIButton(type: .system)
        
        mapBtn.setTitle("지도에서 혜택확인", for: .normal)
        mapBtn.frame = CGRect(x: 20 *  DeviceManager.sharedInstance.widthRatio, y: 1030 *  heightRatio, width: 180 *  DeviceManager.sharedInstance.widthRatio, height: 60 *  heightRatio)
        
        mapBtn.titleLabel!.font = UIFont(name: "Jalnan", size:16.1 *  heightRatio)
        mapBtn.layer.cornerRadius = 13 *  heightRatio
        mapBtn.layer.borderWidth = 1.3
        mapBtn.layer.borderColor = UIColor.white.cgColor
        mapBtn.backgroundColor = UIColor.white
        mapBtn.tintColor = UIColor(displayP3Red:238/255,green : 47/255, blue : 67/255, alpha: 1)
        mapBtn.addTarget(self, action: #selector(self.mapPage), for: .touchUpInside)
        mapBtn.layer.shadowColor = UIColor.black.cgColor
        mapBtn.layer.shadowOffset = CGSize(width: 5 *  DeviceManager.sharedInstance.widthRatio, height: 5 *  heightRatio) // 반경에 대해서 너무 적용이 되어서 4point 정도 ㅐ림.
        
        mapBtn.layer.shadowOpacity = 1
        mapBtn.layer.shadowRadius = 1 // 반경?
        
        mapBtn.layer.shadowOpacity = 0.5 // alpha값입니다.
        
        m_Scrollview.addSubview(mapBtn)
        
        
        
        //유튜브
        let YtbLabel = UILabel()
        //MainUi.frame = CGRect(x: 0, y: 20 *  DeviceManager.sharedInstance.heightRatio, width: CGFloat(screenWidth), height: 400 *  DeviceManager.sharedInstance.heightRatio)
        YtbLabel.frame = CGRect(x: 20 *  DeviceManager.sharedInstance.widthRatio, y: 520 *  heightRatio, width: DeviceManager.sharedInstance.width, height: 30 *  heightRatio)
        
        YtbLabel.textAlignment = .left
        YtbLabel.text = "유튜버들의 생생한 혜택 리뷰"
        //YtbLabel.font = UIFont(name: "NanumBarunGothicBold", size: 20  *  DeviceManager.sharedInstance.heightRatio)
        YtbLabel.font = UIFont(name: "Jalnan", size: 26  *  heightRatio)

        
        //YtbUi.backgroundColor = UIColor(displayP3Red:238/255,green : 47/255, blue : 67/255, alpha: 1)
        m_Scrollview.addSubview(YtbLabel)
        
        
        
        //이 혜택 어떄요
        
        var PersonalizedLabel = UILabel()
        
        PersonalizedLabel.frame = CGRect(x: 20 *  DeviceManager.sharedInstance.widthRatio, y: 420 *  heightRatio, width: DeviceManager.sharedInstance.width - (40 *  DeviceManager.sharedInstance.widthRatio), height: 50 *  heightRatio)
        PersonalizedLabel.textAlignment = .left
        
        //폰트지정 추가
        PersonalizedLabel.text = "이런 혜택은 어때요?"
        PersonalizedLabel.font = UIFont(name: "NanumBarunGothicBold", size: 20 *  heightRatio)
        
        //신청기한
        let deadlineLabel = UILabel()
        
        
        deadlineLabel.font = UIFont(name: "NanumBarunGothicBold", size: 18 *  heightRatio)
        deadlineLabel.text = "빨리 신청하세요"
        deadlineLabel.frame = CGRect(x: 20 *  DeviceManager.sharedInstance.widthRatio, y: 800 *  heightRatio, width: DeviceManager.sharedInstance.width - (40 *  DeviceManager.sharedInstance.widthRatio), height: 50 *  heightRatio)
        
        
        deadlineLabel.textAlignment = .left
        
        
        //m_Scrollview.addSubview(deadlineLabel)
        
        
        
        
        //신청 리스트
        
        for i in 0..<3 {
            
            
            
            let xPosition = 200 * CGFloat(i) * DeviceManager.sharedInstance.widthRatio
            
            
            //listView.layer.borderWidth = 1
            let imageView = UIImageView()
            //let url = URL(string: ytbList.Message[i].thumbnail)
            imageView.frame = CGRect(x: xPosition, y: 0,
                                     width: 180 *  DeviceManager.sharedInstance.widthRatio,
                                     height: 200 *  heightRatio)
            
            
            
            //imageView.kf.setImage(with: url)
            imageView.layer.borderWidth = 1
            imageView.layer.borderColor = UIColor.white.cgColor
            imageView.layer.cornerRadius = 33
            imageView.clipsToBounds = true
            imageView.setImage(UIImage(named: PersonalizedImg[i+1])!)
            
            self.deadline_scroll.addSubview(imageView)
            
        }
        deadline_scroll.frame = CGRect(x: 0, y: 850 *  heightRatio, width: DeviceManager.sharedInstance.width, height: 210 *  heightRatio)
        deadline_scroll.tag = 3
        deadline_scroll.contentSize.width =
            self.view.frame.width * CGFloat(3) *  DeviceManager.sharedInstance.widthRatio
        //m_Scrollview.addSubview(deadline_scroll)
        
        //
        //
        //
        //        //메인스크롤 뷰 추가
        
        
        
        //m_Scrollview.contentInsetAdjustmentBehavior = UIScrollView.ContentInsetAdjustmentBehavior.never
        if #available(iOS 11.0, *) {
            m_Scrollview.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        
        //safe area 문제가아닌ㄷ
        var x = view.safeAreaInsets.left
        var y = view.safeAreaInsets.top
        var width = view.bounds.width - view.safeAreaInsets.left - view.safeAreaInsets.right
        
        
        //safelayout 문제로 안됨
        m_Scrollview.frame = CGRect(x: 0, y: 20 *  heightRatio, width: DeviceManager.sharedInstance.width, height: DeviceManager.sharedInstance.height)
        //
        //            m_Scrollview.contentSize = CGSize(width:screenWidth, height: 1242 *  Int(DeviceManager.sharedInstance.heightRatio))
        
        //m_Scrollview.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
        //태그숫자에 따라 스크롤뷰 길이 변동되게 추후 수정
        var contentHeight : Int =  Int(1242 * heightRatio)
        m_Scrollview.contentSize = CGSize(width:screenWidth, height: contentHeight)
        self.view.addSubview(m_Scrollview)
        
        
        self.view.addSubview(m_Scrollview)
        
    }
    
}

