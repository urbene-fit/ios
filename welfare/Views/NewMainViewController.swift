//  NewMainViewController.swift
//  welfare
//
//  Created by 김동현 on 2020/12/22.
//  Copyright © 2020 com. All rights reserved.

import UIKit
import Alamofire
//uiimageview setimage 메소드를 상속받게함
import SwiftyGif
import Lottie
import Gemini


class NewMainViewController: UIViewController, UIScrollViewDelegate, UISearchBarDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    
    

    
    
    // 메인 세로 스크롤
    let m_Scrollview = UIScrollView()
    
    //유튜브, 가로스크롤뷰
    var ytb_scroll = UIScrollView()
    
    //맞춤 혜택
    var Personalized_scroll = UIScrollView()
    
    //임시 맞춤혜택 이미지, 라벨명을 담을 배열
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
    
    // 유튜브 영상 목록 정보
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
    
    //  컨텐츠 뷰컨트롤러들이 사용할 배경색 어레이입니다
    private let backgroundColors: [UIColor] = [.green, .blue, .brown, .yellow, .lightGray]
    
    //  컨텐츠 뷰컨들이 올라갈 페이지 뷰컨이에요
    //  transitionStyle은 화면 전환 애니메이션
    //  navigationOrientation은 상하, 좌우 어디로 넘길건지
    private let pageViewController = UIPageViewController(transitionStyle: .pageCurl,
                                                          navigationOrientation: .horizontal)
    
    
    
    
    //추천리스트를 보여줄 콜렉션 뷰
//    var bannerView = UICollectionView()
//    var collectionview = UICollectionView()
      var cellId = "recommendCell"
    
    var collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    //추천아이템

    var itemCount : Int = 0

    
    
    //자동이동을 위한 타이머
    var timer = Timer()
    
    
    // 현재페이지 체크 변수 (자동 스크롤할 때 필요)
    var nowPage: Int = 0
    
    //페이지컨트롤러
    
    var pageControl = UIPageControl()
    
    //추천 리스트
    var recommendList: [Personalized] = []
    struct item {
                var welf_name : String
                var welf_local : String
                var welf_category : [String]
                var tag : String

    }
    

    



    var items: [item] = []

    
    override func viewDidLoad() {
        super.viewDidLoad()
        debugPrint("메인 : viewDidLoad")
        
        
        // 디바이스 크기 계산
        if DeviceManager.sharedInstance.isFiveIncheDevices() {
            debugPrint("5인치")
            heightRatio = DeviceManager.sharedInstance.widthRatio
        } else if DeviceManager.sharedInstance.isFourIncheDevices() {
            debugPrint("4인치")
        } else if DeviceManager.sharedInstance.isSixIncheDevices() {
            debugPrint("6인치")
            heightRatio = DeviceManager.sharedInstance.heightRatio
        } else {
            debugPrint("인치구분안됨")
            heightRatio = DeviceManager.sharedInstance.heightRatio
        }
        
        
        // 로그기록으로 보낼 디바이스 정보
        let modelName = DeviceManager.sharedInstance.modelName
        let systemVersion = DeviceManager.sharedInstance.systemVersion
        debugPrint("기기 정보 : \(modelName)","ios버전정보 : \(systemVersion)")
        //debugPrint("토큰 : \(LoginManager.sharedInstance.token)", "불린 : \(LoginManager.sharedInstance.checkInfo)")
        
        // 네비바 백버튼 설정
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        
        //로그 전송
        //DeviceManager.sharedInstance.sendLog(content: "메인접속")
        
        // 홈화면 UI 생성
        configureAutolayouts()
        

    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        debugPrint("메인 : viewDidAppear")
        
        // 네비게이션 컨트롤러 변경, DuViewController의 view가 사라짐, ReViewViewController의 view가 화면에 나타남
        setBarButton()
    }
    
    
    // 홈 화면 네비게이션 바 생성
    private func setBarButton() {
        debugPrint("ReViewViewController의 setBarButton")
        
        self.navigationController?.navigationBar.topItem?.titleView = nil
        self.navigationController?.navigationBar.shadowImage = nil
        self.navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        
        
        let naviLabel = UILabel()
        naviLabel.frame = CGRect(x: 63.8, y: 235.4, width: 118, height: 17.3)
        naviLabel.textAlignment = .center
//
//        naviLabel.textColor = UIColor(displayP3Red:238/255,green : 47/255, blue : 67/255, alpha: 1)
//        naviLabel.text = "UrBene_Fit"
        
        
        naviLabel.textColor = UIColor(displayP3Red:242/255,green : 182/255, blue : 157/255, alpha: 1)
        naviLabel.text = "혜택 모아"
        
        naviLabel.font = UIFont(name: "Jalnan", size: 20  *  DeviceManager.sharedInstance.heightRatio)
        self.navigationController?.navigationBar.topItem?.titleView = naviLabel
    }
    
    
    // fileprivate 는 하나의 스위프트 파일( .swift ) 내부에서만 접근이 가능한 접근제어 수준
    fileprivate func configureAutolayouts() {
        
        // 맨 위쪽 화면 뷰 UI 화면 - 로그인 안했을 경우: 로그인 요청 화면, 로그인 했을 경우: 맞춤 혜택 정보 출력
        setTop()
        
        
        //유튜브 리스트를 보여주는 뷰, 유튜브 정보 받아오기
        Alamofire.request("https://www.hyemo.com/youtube", method: .get)
            .validate()
            .responseJSON { [self] response in
                switch response.result {
                case .success(let value):
                    do {
                        let data = try JSONSerialization.data(withJSONObject: value, options: .prettyPrinted)
                        let ytbList = try JSONDecoder().decode(ytbParse.self, from: data)
                        
                        
                        // 유튜브 영상 리뷰 정보를 테이블아이템에 추가해준다.
                        for i in 0..<ytbList.Message.count {
                            
                            
                            // 영상 보여줄 리스트 공간
                            let test = UIView()
                            let xPosition = (300 * CGFloat(i) + 20) * DeviceManager.sharedInstance.widthRatio
                            test.frame = CGRect(x: xPosition, y: 30  *  heightRatio, width: 280 * DeviceManager.sharedInstance.widthRatio, height: 260 * heightRatio)
                            test.layer.borderColor = UIColor.white.cgColor
                            test.backgroundColor = UIColor.white
                            
                            
                            // 영상 썸네일
                            let imageView = UIImageView()
                            imageView.frame = CGRect(x: 0, y: 0, width: 280 * DeviceManager.sharedInstance.widthRatio, height: 200 * heightRatio)
                            imageView.setImage(crop(imgUrl: ytbList.Message[i].thumbnail)!)
                            test.addSubview(imageView)
                            
                            
                            // 영상 제목 이름
                            let nameLabel = UILabel()
                            nameLabel.frame = CGRect(x: 0, y: 150  *  heightRatio, width: 280  *  DeviceManager.sharedInstance.widthRatio, height: 60 * heightRatio)
                            nameLabel.backgroundColor = UIColor.white
                            nameLabel.text = ytbList.Message[i].title
                            nameLabel.font = UIFont(name: "NanumBarunGothicBold", size: 14 *  heightRatio)
                            nameLabel.textAlignment = .center
                            nameLabel.numberOfLines = 3
                            test.addSubview(nameLabel)
                            
                            
                            // 영상 재생 버튼 이미지
                            let playImg = UIImageView(image: UIImage(named: "playBtn")!)
                            playImg.frame =  CGRect(x: 120  *  DeviceManager.sharedInstance.widthRatio, y: 70  *  heightRatio , width: 30  *  DeviceManager.sharedInstance.widthRatio, height: 30  *  heightRatio)
                            playImg.tintColor = UIColor.white
                            playImg.image = playImg.image?.withRenderingMode(.alwaysTemplate)
                            test.addSubview(playImg)
                            
                            
                            // 영상 클릭 이벤트 추가, UITapGestureRecognizer: 싱글탭 또는 멀티탭 제스처 인식
                            let contentListener = ClickListener(target: self, action: #selector(self.onViewClicked(sender:)))
                            contentListener.videoId = ytbList.Message[i].videoId
                            contentListener.title =  ytbList.Message[i].title
                            test.addGestureRecognizer(contentListener)
                            
                            ytb_scroll.addSubview(test)
                        }
                        
                        
                        // 리뷰 영상 목록 화면 틀 생성 후 추가
                        ytb_scroll.frame = CGRect(x: 0, y: 480  *  heightRatio, width: DeviceManager.sharedInstance.width, height: 260 *  heightRatio)
                        ytb_scroll.contentSize.width = 320 * CGFloat(ytbList.Message.count ) *  DeviceManager.sharedInstance.widthRatio
                        ytb_scroll.showsHorizontalScrollIndicator = false
                        
                        m_Scrollview.addSubview(ytb_scroll)
                    } catch let DecodingError.dataCorrupted(context) {
                        debugPrint(context)
                    } catch let DecodingError.keyNotFound(key, context) {
                        debugPrint("Key '\(key)' not found:", context.debugDescription)
                        debugPrint("codingPath:", context.codingPath)
                    } catch let DecodingError.valueNotFound(value, context) {
                        debugPrint("Value '\(value)' not found:", context.debugDescription)
                        debugPrint("codingPath:", context.codingPath)
                    } catch let DecodingError.typeMismatch(type, context)  {
                        debugPrint("Type '\(type)' mismatch:", context.debugDescription)
                        debugPrint("codingPath:", context.codingPath)
                    } catch {
                        debugPrint("error: ", error)
                    }
                case .failure(let error):
                    debugPrint(error)
                }
            }
        
        
        
        
        
        // 유튜브
        let YtbLabel = UILabel()
        YtbLabel.frame = CGRect(x: 20 *  DeviceManager.sharedInstance.widthRatio, y: 460 *  heightRatio, width: DeviceManager.sharedInstance.width, height: 30 *  heightRatio)
        YtbLabel.textAlignment = .left
        YtbLabel.text = "유튜버들의 생생한 혜택 리뷰"
        YtbLabel.font = UIFont(name: "NanumBarunGothicBold", size: 18  *  heightRatio)
        m_Scrollview.addSubview(YtbLabel)
        
        
        //신청 리스트
        for i in 0..<3 {
            let xPosition = 200 * CGFloat(i) * DeviceManager.sharedInstance.widthRatio
            
            let imageView = UIImageView()
            imageView.frame = CGRect(x: xPosition, y: 0,
                                     width: 180 *  DeviceManager.sharedInstance.widthRatio,
                                     height: 200 *  heightRatio)
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
        
        
        //메인스크롤 뷰 추가
        if #available(iOS 11.0, *) {
            m_Scrollview.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        
        
        //safelayout 문제로 안됨
        m_Scrollview.frame = CGRect(x: 0, y: 20 *  heightRatio, width: DeviceManager.sharedInstance.width, height: DeviceManager.sharedInstance.height)
        
        
        //태그숫자에 따라 스크롤뷰 길이 변동되게 추후 수정
        let contentHeight : Int =  Int(1242 * heightRatio)
        //m_Scrollview.contentSize = CGSize(width:screenWidth, height: contentHeight)
        self.view.addSubview(m_Scrollview)
    }
    
    
    //메인 상단의 뷰를 로그인,키워드 입력여부에 따라 바꿔준다.
    func setTop(){
        
        //로그인도 되어있고, 키워드정보도 입력했을 경우
        //debugPrint("로그인도 되어있고, 키워드정보도 입력했을 경우 - checkInfo:",LoginManager.sharedInstance.checkInfo,"token.isEmpty:",LoginManager.sharedInstance.token.isEmpty)
        if(LoginManager.sharedInstance.checkInfo && LoginManager.sharedInstance.token != ""){
            debugPrint("키워드 정보 입력되어있을경우")
            
           //  맞춤 혜택 정보 요청
                        let parameters = ["type":"customized", "login_token": LoginManager.sharedInstance.token]
                        Alamofire.request("https://www.hyemo.com/welf", method: .get, parameters: parameters)
                            .validate()
                            .responseJSON { [self] response in
                                switch response.result {
                                case .success(let value):
                                    do {
                                        let data = try JSONSerialization.data(withJSONObject: value, options: .prettyPrinted)
                                        let result = try JSONDecoder().decode(PersonalizedParse.self, from: data)
            
            
                                        //맞춤정책
                                        for i in 0..<result.Message.count {
                                            
                                            var tag = result.Message[i].welf_category.replacingOccurrences(of: " ", with: "")
                                            //split
                                            var arr = tag.components(separatedBy: ";;")
                                            
                                            
                                            
                                            items.append(NewMainViewController.item.init(welf_name: result.Message[i].welf_name, welf_local: result.Message[i].welf_local, welf_category: arr, tag: result.Message[i].tag))
                                            
                                            
                                            
                                            
                                            
//                                            // Personalized.init() : ?
//                                            self.PersonalizedList.append(Personalized.init(welf_name: result.Message[i].welf_name, welf_local: result.Message[i].welf_local,
//                                                                                           welf_category: result.Message[i].welf_category, tag : result.Message[i].tag))
//
//                                            let xPosition = (DeviceManager.sharedInstance.width - (40  *  DeviceManager.sharedInstance.widthRatio) + 30) * CGFloat(i) + 30
//
//
//                                            // 맞춤 혜택 UI
//                                            let listView = UIView()
//                                            listView.frame = CGRect(x: xPosition, y: 20 *  heightRatio,
//                                                                    width: DeviceManager.sharedInstance.width - (40  *  DeviceManager.sharedInstance.widthRatio),
//                                                                    height: 220 *  heightRatio)
//                                            listView.backgroundColor = UIColor(displayP3Red:238/255,green : 47/255, blue : 67/255, alpha: 1)
//                                            listView.layer.borderWidth = 1
//                                            listView.layer.borderColor = UIColor(displayP3Red:238/255,green : 47/255, blue : 67/255, alpha: 1).cgColor
//                                            listView.layer.cornerRadius = 33
//
//
//                                            //정책명
//                                            let policyName = UILabel()
//                                            policyName.frame = CGRect(x: 20  *  DeviceManager.sharedInstance.widthRatio, y: 60  *  heightRatio,
//                                                                      width: 200  *  DeviceManager.sharedInstance.widthRatio,
//                                                                      height: 120  *  heightRatio)
//                                            policyName.font = UIFont(name: "Jalnan", size: 20  *  heightRatio)
//                                            policyName.textColor = UIColor.white
//                                            policyName.numberOfLines = 6
//
//                                            let title = PersonalizedList[i].welf_name.replacingOccurrences(of: " ", with: "\n")
//                                            policyName.text = title
//                                            listView.addSubview(policyName)
//
//
//                                            //혜택지역
//                                            let localName = UILabel()
//                                            localName.frame = CGRect(x: 20  *  DeviceManager.sharedInstance.widthRatio, y: 20  *  heightRatio,
//                                                                     width: 200  *  DeviceManager.sharedInstance.widthRatio,
//                                                                     height: 20  *  heightRatio)
//                                            localName.font = UIFont(name: "Jalnan", size: 15  *  heightRatio)
//                                            localName.textColor = UIColor.white
//                                            localName.text = "#\(PersonalizedList[i].welf_local)"
//                                            listView.addSubview(localName)
//
//
//                                            //혜택 일러스트
//                                            let categoryImg = UIImageView()
//                                            categoryImg.frame = CGRect(x: DeviceManager.sharedInstance.width - (40  *  DeviceManager.sharedInstance.widthRatio) - (200  *  DeviceManager.sharedInstance.widthRatio), y: 0,
//                                                                       width: 200  *  DeviceManager.sharedInstance.widthRatio,
//                                                                       height: 200  *  heightRatio)
//
//
//                                            //일러스트 추가
//                                            let tag = PersonalizedList[i].welf_category.replacingOccurrences(of: " ", with: "")
//                                            let arr = tag.components(separatedBy: ";;")
//                                            let imgName = arr[0]
//
//                                            debugPrint("이미지 : \(imgName)")
//                                            if(imgDic[imgName] != nil){
//                                                categoryImg.setImage(UIImage(named: imgDic[imgName]!)!)
//                                            }else{
//                                                categoryImg.setImage(UIImage(named: "AppIcon")!)
//                                            }
//                                            listView.addSubview(categoryImg)
//
//
//                                            //각 스크롤의 터치 혹은 스크롤 이벤트를 구분하기 위해 태그값을 준다.
//                                            // 영상 클릭 이벤트 추가, UITapGestureRecognizer: 싱글탭 또는 멀티탭 제스처 인식
//                                            let contentListener = PersonalizedClickListener(target: self, action: #selector(self.onCustomizedClicked(sender:)))
//                                            contentListener.welfName = result.Message[i].welf_name
//                                            contentListener.welfLocal =  result.Message[i].welf_local
//                                            listView.addGestureRecognizer(contentListener)
//
//
//                                            //음영처리
//                                            listView.layer.shadowColor = UIColor.black.cgColor
//                                            listView.layer.shadowOffset = CGSize(width: 5, height: 5) // 반경에 대해서 너무 적용이 되어서 4point 정도 ㅐ림.
//                                            listView.layer.shadowOpacity = 1
//                                            listView.layer.shadowRadius = 1 // 반경?
//                                            listView.layer.shadowOpacity = 0.5 // alpha값입니다.
//                                            self.Personalized_scroll.addSubview(listView)
                                        }
                                        
                                        itemCount = items.count
                                        let layout = CarouselLayout()
                                            layout.itemSize = CGSize(width: 200, height: 300)
                            //            //콜렉션뷰 스크롤 방향
                            //            layout.scrollDirection = .horizontal
                            //            layout.minimumInteritemSpacing = 40
                            //
                            //            //셀 가운데 위치시키기
                            //            let totalCellWidth = 200
                            //            let totalSpacingWidth = 40
                            //            let leftInset = (DeviceManager.sharedInstance.width - CGFloat(totalCellWidth + totalSpacingWidth)) / 2
                            //            let rightInset = leftInset
                            //            layout.sectionInset = UIEdgeInsets(top: 0, left: leftInset, bottom: 0, right: rightInset)
                                        

                                            collectionView = UICollectionView(frame: CGRect(x: 0, y: 100 * heightRatio, width: DeviceManager.sharedInstance.width, height: 360 *  heightRatio), collectionViewLayout: layout)
                                        
                                        
                                            self.view.addSubview(collectionView)
                                            collectionView.delegate   = self
                                            collectionView.dataSource = self
                                        collectionView.register(recommendCell.self, forCellWithReuseIdentifier: "recommendCell")
                                        //collectionView.isPagingEnabled = true
                                        collectionView.backgroundColor = UIColor.white
                                        // 스크롤 시 빠르게 감속 되도록 설정
                                        collectionView.decelerationRate = .fast
                                        collectionView.showsHorizontalScrollIndicator = false

                                        

                                        m_Scrollview.addSubview(collectionView)
                                        bannerTimer()
            
            
//                                        // 맞춤 혜택 정보 배경 UI 설정 값
//                                        Personalized_scroll.frame = CGRect(x: 0, y: 170 *  heightRatio, width: self.view.frame.width, height: 330 *  heightRatio)
//                                        Personalized_scroll.contentSize.width = (DeviceManager.sharedInstance.width - (40  *  DeviceManager.sharedInstance.widthRatio) + 30) * CGFloat(PersonalizedList.count) + 30
//                                        Personalized_scroll.backgroundColor = UIColor.white
//
//                                        //페이징
//                                        Personalized_scroll.isPagingEnabled = true
//                                        self.Personalized_scroll.delegate = self
//
//
//                                        //m_Scrollview.addSubview(Personalized_scroll)
//
//                                        //페이지컨트롤러 추가
//
//                                        pageControl.frame =  CGRect(x: 100, y: 520 *  heightRatio,
//                                                                    width: DeviceManager.sharedInstance.width,
//                                                                    height: 30 *  heightRatio)
//                                        pageControl.numberOfPages = result.Message.count
//                                        pageControl.currentPage = 0
//                                        pageControl.tintColor = UIColor.red
//                                        pageControl.pageIndicatorTintColor = UIColor.black
//                                        pageControl.currentPageIndicatorTintColor = UIColor.green
//                                        pageControl.addTarget(self, action: #selector(pageControltapped(_:)), for: .touchUpInside)
//
//                                        //m_Scrollview.addSubview(pageControl)
//
//
//                                        //추천 라벨
//                                        let recommendLabel = UILabel()
//                                        recommendLabel.frame =  CGRect(x: 20, y: 80 *  heightRatio,
//                                                                       width: DeviceManager.sharedInstance.width,
//                                                                       height: 90 *  heightRatio)
//                                        recommendLabel.backgroundColor = UIColor.white
//                                        var nickName : String = ""
//                                        if(UserDefaults.standard.string(forKey: "nickName") != nil){
//                                            nickName = UserDefaults.standard.string(forKey: "nickName")!
//                                        }
//                                        recommendLabel.text = "\(nickName) 님에게\n    복지혜택 \(PersonalizedList.count)개를 추천해요"
//                                        recommendLabel.numberOfLines = 2
//                                        recommendLabel.font = UIFont(name: "Jalnan", size: 26  *  heightRatio)
//
//
//                                        //색상변경
//                                        let attributedStr = NSMutableAttributedString(string: recommendLabel.text!)
//                                        attributedStr.addAttribute(.foregroundColor, value: UIColor(displayP3Red:238/255,green : 47/255, blue : 67/255, alpha: 1), range: (recommendLabel.text! as NSString).range(of: nickName))
//                                        attributedStr.addAttribute(.foregroundColor, value: UIColor(displayP3Red:238/255,green : 47/255, blue : 67/255, alpha: 1), range: (recommendLabel.text! as NSString).range(of: "\(PersonalizedList.count)개"))
//                                        recommendLabel.attributedText = attributedStr
            
                                        //m_Scrollview.addSubview(recommendLabel)
                                    }
            
                                    catch let DecodingError.dataCorrupted(context) {
                                        debugPrint(context)
                                    } catch let DecodingError.keyNotFound(key, context) {
                                        debugPrint("Key '\(key)' not found:", context.debugDescription)
                                        debugPrint("codingPath:", context.codingPath)
                                    } catch let DecodingError.valueNotFound(value, context) {
                                        debugPrint("Value '\(value)' not found:", context.debugDescription)
                                        debugPrint("codingPath:", context.codingPath)
                                    } catch let DecodingError.typeMismatch(type, context)  {
                                        debugPrint("Type '\(type)' mismatch:", context.debugDescription)
                                        debugPrint("codingPath:", context.codingPath)
                                    } catch {
                                        debugPrint("error: ", error)
                                    }
                                case .failure(let error):
                                    debugPrint(error)
                                }
                            }
            
            //            setPageViewController()
            //             setPageControl()
            
//
//            bannerView.frame =  CGRect(x: 0, y: 0 * heightRatio,
//                                       width: DeviceManager.sharedInstance.width,
//                                       height: 495 *  heightRatio)
            
  

          
            
   
            
        }else{
            debugPrint("키워드 정보 입력 안되어있는 경우")
            
            
            //배너부분 뷰
            let bannerView = UIView()
            bannerView.frame =  CGRect(x: 20, y: 20 * heightRatio,
                                       width: DeviceManager.sharedInstance.width - 40,
                                       height: 495 *  heightRatio)
            bannerView.backgroundColor = UIColor.white
            m_Scrollview.addSubview(bannerView)
            
            
            //배너 부분
            let bannerLabel = UILabel()
            bannerLabel.frame = CGRect(x: 40  *  DeviceManager.sharedInstance.widthRatio, y: 80  *  heightRatio, width: 400 * DeviceManager.sharedInstance.widthRatio, height: 150 *  heightRatio)
            bannerLabel.backgroundColor = UIColor.clear
            bannerLabel.text = "당신만 놓치고 있는"
            bannerLabel.textColor = UIColor.white
            bannerLabel.font = UIFont(name: "Jalnan", size: 22  *  heightRatio)
            
            let attrString = NSMutableAttributedString(string: bannerLabel.text!)
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 20  *  heightRatio
            attrString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attrString.length))
            bannerLabel.attributedText = attrString
            bannerLabel.textAlignment = .left
            
            
            let MainUi = UIView()
            MainUi.frame = CGRect(x: 20, y: 100 * heightRatio, width: DeviceManager.sharedInstance.width - 40, height: 300 *  heightRatio)
            MainUi.backgroundColor = UIColor(displayP3Red:242/255,green : 182/255, blue : 157/255, alpha: 1)
            
            MainUi.layer.borderColor = UIColor(displayP3Red:242/255,green : 182/255, blue : 157/255, alpha: 1).cgColor
            MainUi.layer.borderWidth = 0.1
            MainUi.layer.cornerRadius = 10 *  DeviceManager.sharedInstance.heightRatio

            
            
            let animationView = AnimationView(name:"present")
            
            //메인 뷰에 삽입
            animationView.frame = CGRect(x: 0 * DeviceManager.sharedInstance.heightRatio, y: 120 *  heightRatio, width: DeviceManager.sharedInstance.width, height: 240 *  heightRatio)
            animationView.contentMode = .scaleAspectFit
            animationView.backgroundColor = .clear
            
            //애니메이션 재생(애니메이션 재생모드 미 설정시 1회)
            animationView.play()
            
            //애니메이션 재생모드( .loop = 애니메이션 무한재생)
            animationView.loopMode = .loop
            
            //            let mainImg = UIImageView()
            //            mainImg.frame = CGRect(x: 100 * DeviceManager.sharedInstance.heightRatio, y: 100 *  heightRatio, width: 260 *  DeviceManager.sharedInstance.widthRatio, height: 300 *  heightRatio)
            //            mainImg.backgroundColor = UIColor.clear
            //            mainImg.setImage(flipImageLeftRight(UIImage(named: "main")!)!)
            //            MainUi.addSubview(mainImg)
            m_Scrollview.addSubview(MainUi)
            m_Scrollview.addSubview(bannerLabel)
            m_Scrollview.addSubview(animationView)
            
            
            let moveBtn = UIButton(type: .system)
            moveBtn.setTitle("혜택 추천 받으러 가기 >", for: .normal)
            moveBtn.frame = CGRect(x: 110 * DeviceManager.sharedInstance.widthRatio , y: 220 *  heightRatio, width: 200 *  DeviceManager.sharedInstance.widthRatio, height:  50 *  heightRatio)
            moveBtn.titleLabel!.font = UIFont(name: "Jalnan", size:16.1 *  heightRatio)
            // moveBtn.titleLabel!.textColor = UIColor.black
            moveBtn.tintColor = UIColor.black
            
            //            moveBtn.layer.cornerRadius = 13 *  heightRatio
            //            moveBtn.layer.borderWidth = 1.3
            //            moveBtn.layer.borderColor = UIColor.white.cgColor
            //            moveBtn.backgroundColor =  UIColor.white
            //            moveBtn.tintColor =  UIColor(displayP3Red:238/255,green : 47/255, blue : 67/255, alpha: 1)
            //선택결과 페이지로 이동하는 메소드
            moveBtn.addTarget(self, action: #selector(self.inputInfo), for: .touchUpInside)
            //            moveBtn.layer.shadowColor = UIColor.black.cgColor
            //            moveBtn.layer.shadowOffset = CGSize(width: 5 *  DeviceManager.sharedInstance.widthRatio, height: 5 *  heightRatio) // 반경에 대해서 너무 적용이 되어서 4point 정도 ㅐ림.
            //            moveBtn.layer.shadowOpacity = 1
            //            moveBtn.layer.shadowRadius = 1 // 반경?
            //            moveBtn.layer.shadowOpacity = 0.5 // alpha값입니다.
            m_Scrollview.addSubview(moveBtn)
        }
    }
    
    
    @objc func pageControltapped(_ sender: Any) {
        let selectedPage = pageControl.currentPage
        print(selectedPage)
        // self.setViewControllers([viewControllerList[selectedPage]], direction: .forward, animated: true, completion: nil)
    }
    
    // 지도화면으로 이동
    @objc func mapPage(_ sender: UIButton) {
        debugPrint("혜택지도 페이지로 이동")
        DeviceManager.sharedInstance.sendLog(content: "혜택지도 페이지로 이동", type: type)
        
        
        guard let RVC = self.storyboard?.instantiateViewController(withIdentifier: "mapTestViewController") as? mapTestViewController else{
            return
        }
        
        RVC.modalPresentationStyle = .fullScreen
        
        //혜택 상세보기 페이지로 이동
        //self.present(RVC, animated: true, completion: nil)
        self.navigationController?.pushViewController(RVC, animated: true)
    }
    
    
    //이미지 자르는 메소드
    func crop(imgUrl : String) -> UIImage? {
        let imageUrl = URL(string: imgUrl)!
        let data = try! Data(contentsOf: imageUrl)
        let image = UIImage(data: data)!
        
        
        // Crop rectangle
        let width = min(image.size.width, image.size.height)
        let size = CGSize(width: width, height: image.size.height )
        
        //뷰상에 이미지를 배치하는 위치
        let startPoint = CGPoint(x: 0, y: -45 * DeviceManager.sharedInstance.heightRatio)
        
        // UIGraphicsBeginImageContextWithOptions:
        // size: 새 비트 맵 컨텍스트의 크기 (포인트로 측정)입니다. 이것은 함수가 반환하는 이미지의 크기를 나타냅니다 . 비트 맵의 ​​크기 (픽셀)를 얻으려면 너비 및 높이 값에 매개 변수 의 값을 곱해야합니다
        // opaque: 비트 맵이 불투명한지 여부를 나타내는 부울 플래그입니다. 비트 맵이 완전히 불투명하다는 것을 알고있는 경우 true알파 채널을 무시하고 비트 맵의 ​​저장소를 최적화하도록 지정하십시오.
        // 지정 false은 부분적으로 투명한 픽셀을 처리하기 위해 비트 맵에 알파 채널이 포함되어야 함을 의미합니다.
        // scale: 비트 맵에 적용 할 배율입니다. 값을 지정 하면 배율이 장치 기본 화면의 배율로 설정됩니다.0.0
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        
        image.draw(in: CGRect(origin: startPoint, size: size))
        
        let croppedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return croppedImage
    }
    
    
    // 개인정보 및 키워드 입력하는 페이지로 이동
    @objc func inputInfo(_ sender: UIButton) {
        debugPrint("기본정보 입력페이지로 이동")
        
        //로그인도 안되있을경우
        if(LoginManager.sharedInstance.token == ""){
            DeviceManager.sharedInstance.sendLog(content: "로그인 페이지로 이동",type: "home")
            
            guard let RVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController else{
                return
            }
            
            
            RVC.moveView = "keyword"
            RVC.modalPresentationStyle = .fullScreen
            
            //혜택 상세보기 페이지로 이동
            //self.present(RVC, animated: true, completion: nil)
            self.navigationController?.pushViewController(RVC, animated: true)
        }else{
            //로그인은 되있지만 키워드가 입력되어있지 않은 경우
            DeviceManager.sharedInstance.sendLog(content: "기본정보 입력페이지로 이동", type: type)
            
            guard let RVC = self.storyboard?.instantiateViewController(withIdentifier: "newInfoViewController") as? newInfoViewController else{
                return
            }
            
            RVC.modalPresentationStyle = .fullScreen
            
            //혜택 상세보기 페이지로 이동
            //self.present(RVC, animated: true, completion: nil)
            self.navigationController?.pushViewController(RVC, animated: true)
        }
    }
    
    
    // 이미지 좌우반전
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
    
    
    // 혜택 소개영상을 클릭하면 영상을 보여주는 화면으로 이동, 영상 클릭시 실행하는 함수
    @objc func onViewClicked(sender: ClickListener) {
        debugPrint("onViewClicked 이벤트 실행","영상 id:",sender.videoId!, "영상 제목:",sender.title!)
        
        //유튜브클릭일 경우
        guard let RVC = self.storyboard?.instantiateViewController(withIdentifier: "testYoutubeViewController") as? testYoutubeViewController else{
            return
        }
        
        //뷰 이동
        RVC.modalPresentationStyle = .fullScreen
        RVC.videoID = sender.videoId!
        RVC.videoTitle = sender.title!
        
        self.navigationController?.pushViewController(RVC, animated: true)
    }
    
    
    // 혜택 상세 보기 페이지로 이동
    @objc func onCustomizedClicked(sender: PersonalizedClickListener) {
        debugPrint("onCustomizedClicked 이벤트 실행",sender.welfName!)
        
        guard let RVC = self.storyboard?.instantiateViewController(withIdentifier: "NewDetailView") as? NewDetailView else{
            return
        }
        
        RVC.selectedPolicy = sender.welfName!
        RVC.selectedLocal = sender.welfLocal!
        
        RVC.modalPresentationStyle = .fullScreen
        
        //혜택 상세보기 페이지로 이동
        //self.present(RVC, animated: true, completion: nil)
        self.navigationController?.pushViewController(RVC, animated: true)
    }
    
    
    //  컨텐츠 뷰컨을 만들어주는 메서드를 따로 만들어줬습니다
    //  그냥 뷰컨 하나를 생성하고 태그에 인덱스 번호를 넣어주고 배경색만 바꿔줬습니다
    private func instantiateViewController(index: Int, color: UIColor) -> UIViewController {
        let vc = UIViewController()
        
        
        vc.view.tag = index
        vc.view.backgroundColor = color
        return vc
    }
    
    private func setPageViewController() {
        //  데이터소스와 델리게이트로 부모 뷰컨을 설정해줍니다
        pageViewController.dataSource = self
        pageViewController.delegate = self
        
        //  처음에 보여줄 컨텐츠 설정
        let firstVC = instantiateViewController(index: 0, color: backgroundColors[0])
        pageViewController.setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
        
        
        //  페이지 뷰컨을 부모 뷰컨에 띄워줍니다
        //m_Scrollview.addSubview(pageViewController)
        m_Scrollview.addSubview(pageViewController.view)
        //
        addChild(pageViewController)
        //           view.addSubview(pageViewController.view)
        pageViewController.didMove(toParent: self)
    }
    
    private func setPageControl() {
        //  페이지 컨트롤에 전체 페이지 수를 설정해줍시다
        pageControl.numberOfPages = backgroundColors.count
        
        //  그리고 페이지 컨트롤을 화면에 띄워주면 됩니다
        view.addSubview(pageControl)
        NSLayoutConstraint.activate([
            pageControl.bottomAnchor.constraint(equalTo: view.topAnchor, constant: 200),
            pageControl.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pageControl.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print("end scroll")
        pageControl.currentPage = Int(floor(Personalized_scroll.contentOffset.x / UIScreen.main.bounds.width))
        print(Int(floor(Personalized_scroll.contentOffset.x / UIScreen.main.bounds.width)))
    }
    
    //콜렉션뷰(추천혜택화면) 메소드
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
         return itemCount
     }


 
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath as IndexPath) as! recommendCell
        
        var title = items[indexPath.row].welf_name.replacingOccurrences(of: " ", with: "\n")
    cell.policyName.text = "\(title)"
        cell.localName.text = "#\(items[indexPath.row].welf_local)"
        
        cell.backgroundColor = UIColor(displayP3Red:242/255,green : 182/255, blue : 157/255, alpha: 1)
        //애니메이션 재생(애니메이션 재생모드 미 설정시 1회)
        cell.animationView.play()
        
        //애니메이션 재생모드( .loop = 애니메이션 무한재생)
        cell.animationView.loopMode = .loop
    
         return cell
    }
    //터치 스크롤
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("콜렉션 아이템 선택")
        
        guard let RVC = self.storyboard?.instantiateViewController(withIdentifier: "NewDetailView") as? NewDetailView         else{
            
            return
            
        }
        RVC.selectedPolicy = "\(items[indexPath.row].welf_name)"
            RVC.selectedLocal = "\(items[indexPath.row].welf_local)"
        RVC.modalPresentationStyle = .fullScreen

        //혜택 상세보기 페이지로 이동
        //self.present(RVC, animated: true, completion: nil)
        self.navigationController?.pushViewController(RVC, animated: true)
        
        
        
//        let cell = collectionView.cellForItem(at: indexPath)
//
//        //Briefly fade the cell on selection
//        UIView.animate(withDuration: 0.5,
//                       animations: {
//                        //Fade-out
//                        cell!.alpha = 0.1
//        }) { (completed) in
//            UIView.animate(withDuration: 0.5,
//                           animations: {
//                            //Fade-out
//                            cell!.alpha = 1
//            })
//        }
//
        //cell.animationView.play()
    
        
        //collectionView.isPagingEnabled = true

        //timer.invalidate()
    
        //collectionView.scrollToItem(at: indexPath, at: .right, animated: true)
        
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath as IndexPath) as! recommendCell
//        cell.animationView.play()
        
        
        }
    
    
//    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
//        targetContentOffset.pointee = scrollView.contentOffset
//        var indexes = self.collectionView.indexPathsForVisibleItems
//        indexes.sort()
//        var index = indexes.first!
//        let cell = self.collectionView.cellForItem(at: index)!
//        let position = self.collectionView.contentOffset.x - cell.frame.origin.x
//        if position > cell.frame.size.width/2{
//           index.row = index.row+1
//        }
//        self.collectionView.scrollToItem(at: index, at: .left, animated: true )
//    }
//
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        guard let layout = self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        
        let cellWidthIncludingSpacing = layout.itemSize.width + layout.minimumLineSpacing
        
        let estimatedIndex = scrollView.contentOffset.x / cellWidthIncludingSpacing
        let index: Int
        if velocity.x > 0 {
            index = Int(ceil(estimatedIndex))
        } else if velocity.x < 0 {
            index = Int(floor(estimatedIndex))
        } else {
            index = Int(round(estimatedIndex))
        }
        
        targetContentOffset.pointee = CGPoint(x: CGFloat(index) * cellWidthIncludingSpacing, y: 0)
        
        // 현재페이지가 마지막 페이지일 경우
        if  index == 10 {
        // 맨 처음 페이지로 돌아감
            //collectionView.scrollToItem(at: NSIndexPath(item: 11, section: 0) as IndexPath, at: .left, animated: true)
         
            //스크롤을 빨리 이동시키는 경우 거꾸로 돌아감
            collectionView.scrollToItem(at: NSIndexPath(item: 0, section: 0) as IndexPath, at: .left, animated: false)
            targetContentOffset.pointee = CGPoint(x: CGFloat(0) * cellWidthIncludingSpacing, y: 0)

            print("마지막 배너 메소드 호출")
            

            return
        }
        
    }
    
    
    // 2초마다 실행되는 타이머
    func bannerTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { (Timer) in
           // print("타이머메소드 호출")
            //self.bannerMove()
        }
    }
    // 배너 움직이는 매서드
    func bannerMove() {
        
        //움직이는동안 페이징을 꺼줘야 작동한다.
        collectionView.isPagingEnabled = false

        // 현재페이지가 마지막 페이지일 경우
        if self.nowPage == 10 {
        // 맨 처음 페이지로 돌아감
            //collectionView.scrollToItem(at: NSIndexPath(item: 11, section: 0) as IndexPath, at: .left, animated: true)
            self.nowPage = 0
            collectionView.scrollToItem(at: NSIndexPath(item: 0, section: 0) as IndexPath, at: .left, animated: false)
            print("마지막 배너 메소드 호출")
            

            return
        }
        // 다음 페이지로 전환

        self.nowPage += 1

        collectionView.scrollToItem(at: NSIndexPath(item: nowPage, section: 0) as IndexPath, at: .right, animated: true)
        print("배너 메소드 호출")
        collectionView.isPagingEnabled = true


    }
    
    //터치감지
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {

// Stop your timer  here
        print("터치종료감지")
        //bannerTimer()
        
        //현재 페이지로 설정
        nowPage = Int(self.collectionView.contentOffset.x / self.collectionView.frame.size.width)
        print("현재 페이지 : \(nowPage)")
        
    }
    
    //콜렉션뷰 셀크기 조정
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
//     {
//        return CGSize(width: 300.0, height: 300.0)
//     }
    
}
  
    




// 유튜브 영상 클릭시 매개변수로 값 받기 위한 목적으로 클래스 생성
class ClickListener: UITapGestureRecognizer {
    var title: String?
    var url: String?
    var videoId: String?
}


// 맞춤 혜택 정보 클릭시 전달할 매개변수 사용할 클래스 생성
class PersonalizedClickListener: UITapGestureRecognizer {
    var welfName: String?
    var welfLocal: String?
}


extension NewMainViewController: UIPageViewControllerDataSource {
    
    //  이전 컨텐츠 뷰컨을 리턴해주시면 됩니다
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController
    ) -> UIViewController? {
        
        //  컨텐츠 뷰컨을 생성할 때 태그에 인덱스를 넣어줬기 때문에 몇번째 페이지인지 바로 알 수 있어요
        guard let index = pageViewController.viewControllers?.first?.view.tag else {
            return nil
        }
        
        // 이전 인덱스를 계산해주고요
        let nextIndex = index > 0 ? index - 1 : backgroundColors.count - 1
        
        // 이전 컨텐츠를 담은 뷰컨을 생성해서 리턴해줍니다
        let nextVC = instantiateViewController(index: nextIndex, color: backgroundColors[nextIndex])
        return nextVC
    }
    
    //  다음 컨텐츠 뷰컨을 리턴해주시면 됩니다. 위에 메서드랑 똑같은데 다음 컨텐츠를 담으면 돼요
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController
    ) -> UIViewController? {
        
        guard let index = pageViewController.viewControllers?.first?.view.tag else {
            return nil
        }
        let nextIndex = (index + 1) % backgroundColors.count
        let nextVC = instantiateViewController(index: nextIndex, color: backgroundColors[nextIndex])
        return nextVC
    }
    
    
 
}

extension NewMainViewController: UIPageViewControllerDelegate {
    
    //  스와이프 제스쳐가 끝나면 호출되는 메서드입니다. 여기서 페이지 컨트롤의 인디케이터를 움직여줄꺼에요
    func pageViewController(_ pageViewController: UIPageViewController,
                            didFinishAnimating finished: Bool,
                            previousViewControllers: [UIViewController],
                            transitionCompleted completed: Bool
    ) {
        //  페이지 이동이 안됐으면 그냥 종료
        guard completed else { return }
        
        //  페이지 이동이 됐기 때문에 페이지 컨트롤의 인디케이터를 갱신해줍시다
        if let vc = pageViewController.viewControllers?.first {
            pageControl.currentPage = vc.view.tag
        }
    }
}


class AnimationUtility: UIViewController, CAAnimationDelegate {

    static let kSlideAnimationDuration: CFTimeInterval = 0.4

    static func viewSlideInFromRight(toLeft views: UIView) {
        var transition: CATransition? = nil
        transition = CATransition.init()
        transition?.duration = kSlideAnimationDuration
        transition?.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition?.type = CATransitionType.push
        transition?.subtype = CATransitionSubtype.fromRight
//        transition?.delegate = (self as! CAAnimationDelegate)
        views.layer.add(transition!, forKey: nil)
    }

    static func viewSlideInFromLeft(toRight views: UIView) {
        var transition: CATransition? = nil
        transition = CATransition.init()
        transition?.duration = kSlideAnimationDuration
        transition?.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition?.type = CATransitionType.push
        transition?.subtype = CATransitionSubtype.fromLeft
//        transition?.delegate = (self as! CAAnimationDelegate)
        views.layer.add(transition!, forKey: nil)
    }

    static func viewSlideInFromTop(toBottom views: UIView) {
        var transition: CATransition? = nil
        transition = CATransition.init()
        transition?.duration = kSlideAnimationDuration
        transition?.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition?.type = CATransitionType.push
        transition?.subtype = CATransitionSubtype.fromBottom
//        transition?.delegate = (self as! CAAnimationDelegate)
        views.layer.add(transition!, forKey: nil)
    }

    static func viewSlideInFromBottom(toTop views: UIView) {
        var transition: CATransition? = nil
        transition = CATransition.init()
        transition?.duration = kSlideAnimationDuration
        transition?.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition?.type = CATransitionType.push
        transition?.subtype = CATransitionSubtype.fromTop
//        transition?.delegate = (self as! CAAnimationDelegate)
        views.layer.add(transition!, forKey: nil)
    }
}


//콜렉션셀 클래스 정의
class CarouselLayout: UICollectionViewFlowLayout {
    
    public var sideItemScale: CGFloat = 0.5
    public var sideItemAlpha: CGFloat = 0.5
    public var spacing: CGFloat = 10

    public var isPagingEnabled: Bool = false
    
    private var isSetup: Bool = false
    
    override public func prepare() {
        super.prepare()
        if isSetup == false {
            setupLayout()
            isSetup = true
        }
    }
    
    private func setupLayout() {
        guard let collectionView = self.collectionView else {return}
                
//        let collectionViewSize = collectionView.bounds.size
//
//        let xInset = (collectionViewSize.width - self.itemSize.width) / 2
//        let yInset = (collectionViewSize.height - self.itemSize.height) / 2
        
        
        let xInset = (DeviceManager.sharedInstance.width - self.itemSize.width) / 2
        let yInset = (360 - self.itemSize.height) / 2
        
        self.sectionInset = UIEdgeInsets(top: yInset, left: xInset, bottom: yInset, right: xInset)
        
        let itemWidth = self.itemSize.width
        
        let scaledItemOffset =  (itemWidth - itemWidth*self.sideItemScale) / 2
        self.minimumLineSpacing = spacing - scaledItemOffset

        self.scrollDirection = .horizontal
    }
    
    public override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    public override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let superAttributes = super.layoutAttributesForElements(in: rect),
            let attributes = NSArray(array: superAttributes, copyItems: true) as? [UICollectionViewLayoutAttributes]
            else { return nil }
        
        return attributes.map({ self.transformLayoutAttributes(attributes: $0) })
    }
    
    private func transformLayoutAttributes(attributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        
        guard let collectionView = self.collectionView else {return attributes}
        
        let collectionCenter = collectionView.frame.size.width / 2
        let contentOffset = collectionView.contentOffset.x
        let center = attributes.center.x - contentOffset
        
        let maxDistance = self.itemSize.width + self.minimumLineSpacing
        let distance = min(abs(collectionCenter - center), maxDistance)

        let ratio = (maxDistance - distance)/maxDistance

        let alpha = ratio * (1 - self.sideItemAlpha) + self.sideItemAlpha
        let scale = ratio * (1 - self.sideItemScale) + self.sideItemScale
        
        attributes.alpha = alpha
        
        let visibleRect = CGRect(origin: collectionView.contentOffset, size: collectionView.bounds.size)
        let dist = attributes.frame.midX - visibleRect.midX
        var transform = CATransform3DScale(CATransform3DIdentity, scale, scale, 1)
        transform = CATransform3DTranslate(transform, 0, 0, -abs(dist/1000))
        attributes.transform3D = transform
        
        return attributes
    }
}


//class FadingLayout: UICollectionViewFlowLayout,UICollectionViewDelegateFlowLayout {
//
//    //should be 0<fade<1
//    private let fadeFactor: CGFloat = 0.5
//    private let cellHeight : CGFloat = 60.0
//
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//    }
//
//    init(scrollDirection:UICollectionView.ScrollDirection) {
//        super.init()
//        self.scrollDirection = scrollDirection
//
//    }
//
//    override func prepare() {
//        setupLayout()
//        super.prepare()
//    }
//
//    func setupLayout() {
//        self.itemSize = CGSize(width: self.collectionView!.bounds.size.width,height:cellHeight)
//        self.minimumLineSpacing = 0
//    }
//
//    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
//        return true
//    }
//
//    func scrollDirectionOver() -> UICollectionView.ScrollDirection {
//        return UICollectionView.ScrollDirection.vertical
//    }
//    //this will fade both top and bottom but can be adjusted
//    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
//        let attributesSuper: [UICollectionViewLayoutAttributes] = super.layoutAttributesForElements(in: rect) as [UICollectionViewLayoutAttributes]?
//
//
//        if let attributes = NSArray(array: attributesSuper, copyItems: true) as? [UICollectionViewLayoutAttributes]{
//            var visibleRect = CGRect()
//            visibleRect.origin = collectionView!.contentOffset
//            visibleRect.size = collectionView!.bounds.size
//            for attrs in attributes {
//                if attrs.frame.intersects(rect) {
//                    let distance = visibleRect.midY - attrs.center.y
//                    let normalizedDistance = abs(distance) / (visibleRect.height * fadeFactor)
//                    let fade = 1 - normalizedDistance
//                    attrs.alpha = fade
//                }
//            }
//            return attributes
//        }else{
//            return nil
//        }
//    }
//    //appear and disappear at 0
//    override func initialLayoutAttributesForAppearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
//        let attributes = super.layoutAttributesForItem(at: itemIndexPath)! as UICollectionViewLayoutAttributes
//        attributes.alpha = 0
//        return attributes
//    }
//
//    override func finalLayoutAttributesForDisappearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
//        let attributes = super.layoutAttributesForItem(at: itemIndexPath)! as UICollectionViewLayoutAttributes
//        attributes.alpha = 0
//        return attributes
//    }
//}

//extension NewMainViewController: UIScrollViewDelegate {
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        // floor 내림, ceil 올림
//        // contentOffset는 현재 스크롤된 좌표
//        pageControl.currentPage = Int(floor(scrollView.contentOffset.x / UIScreen.main.bounds.width))
//    }
//}
