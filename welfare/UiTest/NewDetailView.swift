
/*
 1.리스트 결과화면 또는 리뷰 작성/수정/뒤로가기 또는 알림선택을 통해서 상세페이지 화면으로 들ㅇ어온다.
 
 2.각 화면에서 어떤 정책의 상세화면인지 정책명을 저장한다.
 
 3. 혜택 상세정보(대상자,내용) 에대 한 정보를 받아온다.
 
 //리뷰관련
 리뷰는 작성/수정/삭제/처음 들어올 경우 리뷰정보를 갱신한다.
 생명주기에 따라 변수가 새로 호출되지않거나, 기존의 정보를 계속 가지고 있는 경우
 
 4.리뷰메뉴를 클릭시 리뷰정보를 받아온다.
 
 
 
 */

import UIKit
import Alamofire
import Kingfisher


class NewDetailView: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    

  
    
    
    //카테고리 결과페이지에서 선택한 정책을 저장하는 변수
    var selectedPolicy : String = ""
    var selectedLocal : String = ""
    var selectedImg : String = ""
    
    
    //아이템 이미지 불러올때 사용할 자료구조
    var imgDic : [String : String] = ["일자리지원":"job", "공간지원":"house","교육지원":"traning","현금지원":"cash","사업화지원":"business"]
    
    
    // 메인 세로 스크롤
    let m_Scrollview = UIScrollView()
    
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
        var target : String?
        var target_tag : String?
        var welf_image : String
        var welf_wording : String

        
    }
    
    struct StatusParse: Decodable {
        let Status : String
        //반환값이 없을떄 처리
    }
    
    struct parse: Decodable {
        let Status : String
        //반환값이 없을떄 처리
        let Message : [detail]
    }
    
    //혜택 아이디
    var welf_id = Int()
    var targetName = ["가족","영아","신혼부부"]

    //기본문구,이미지에 사용할 변수
    var welf_wording : String = "쉽고\n빠르게\n혜택을\n받아보세요."
    var welf_image : String = "detail_main"

    
    //메뉴버튼에 관한 뷰들을 관리하는 배열
    var LabelName = ["내용","리뷰","주변센터"]
    var buttons = [UIButton]()
    var CALayers = [CALayer]()
    
    
    //리뷰를 보여주는 테이블 뷰
    private var reViewTbView: UITableView!
    
    //리뷰를 받아와 파싱할 구조체
    struct  reviewItem : Decodable {
        let content: String
        let image_url: String
        let id : Int
        let writer : String
        let star_count : String
    }
    
    //의견을 받아와 파싱할 구조체
    //1점 / 총 리뷰한 유저 신청이 쉽다 / 총 리뷰한 유저
    struct Review_stat : Decodable {
        let total_user: Int
        let star_sum: Int
        let one_point : Int
        let two_point : Int
        let three_point : Int
        let four_point : Int
        let five_point : Int
        let esay : Int
        let hard : Int
        let help : Int
        let helf_not : Int
 
    }
    
    
    var reviewItems : [reviewItem] = []
    struct reviewParse: Decodable {
        let Status : String
        //반환값이 없을떄 처리
        var Message : [reviewItem]?
        var TotalCount : Int
        var Review_stats : [Review_stat]
    }
    
    var thumbImg = UIImageView()
    
    //현재메뉴상태를 알려주는 변수
    var setMenu = String()
    
    //혜택의 평점
    var grade = Int()
    //평점 비율
    var oneRatio = Double()
    var twoRatio = Double()
    var threeRatio = Double()
    var fourRatio = Double()
    var fiveRatio = Double()
    
    //점수비율으 저장하는 배열
    var ratios = [Double]()
    
    
    //각 의견 비율
    var easyRatio  = Double()
    var hardRatio  = Double()
    var helpRatio = Double()
    var helpLessRatio = Double()

    
    var cellCase = String()
    
    //점수 분포도 바를 관리하는 배열
    //var pvs = [UIProgressView]()
    var pv = UIProgressView()
    


    
    var targets = [String]()
    var target_tags = [String]()

    
    

    //혜택이름
    var nameUI = UILabel()

    //혜택 이미지
    var imageView1 = UIImageView()
    

    //작성가능여부를 체크해주는 불린 변수
    var ableWrie = Bool()

    //혜택내용의 길이를 저장하는 변수
    var contentHeight = Int()
    
    
    //2가지 메뉴
    //내용
    
 
    //혜택대상
    var targetUI = UIView()
    
    //혜택정보
    var infoUI = UIView()
    //혜택정보 라벨
    var infoLabel = UILabel()
    
    
    //리뷰
    //점수 뷰를 보여주는 화면
    var reviewGradeView = UIView()

    
    
  
    //혜택정보 길이를 세는 변수
    var contentCount : CGFloat = 0
    
  
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
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("상세화면의 view가 viewWillDisappear")

    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print("상세화면의 view가 viewDidDisappear")

        
    }
    
    //상세화면이 처음생성된 경우
    //검새결과화면에서 들어오거나, 추천,알림 화면에서 들어온경우만 활성화하는 메소드
    //1번 기본 혜택의 내용과 로그인/비로그인 여부를 체크
    //2번 공통적으로 사용되는 상단 UI를 만들어준다.
    //3번 내용메뉴의 데이터를 받아온다.
    //4번 내용메뉴의 ui를 만든다.
    //5번 내용메뉴의 ui를 스크롤뷰에 추가한다
    //6번 스크롤뷰를 추가한다.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("상세화면의 view가 viewDidLoad")
        //menu(buttons[0])
        
        //화면색상 설정
        self.view.backgroundColor = #colorLiteral(red: 0.9222517449, green: 0.9222517449, blue: 0.9222517449, alpha: 1)
        
        //1번 작업
        if(LoginManager.sharedInstance.token == ""){
            ableWrie = false
        }else{
            ableWrie = true
        }
        
        
        print("혜택 아이디;\(welf_id)")
        
        //2번 작업
        //상단 뷰
        var topUI = UIView()
        //             topUI.backgroundColor = UIColor(displayP3Red:238/255,green : 47/255, blue : 67/255, alpha: 1)
        
        topUI.backgroundColor = UIColor.white
        topUI.frame = CGRect(x: 0, y: 0, width: DeviceManager.sharedInstance.width - (150 * DeviceManager.sharedInstance.widthRatio),  height: 400 *  DeviceManager.sharedInstance.heightRatio)
        
        //self.view.addSubview(topUI)
        
        
        
        
        //상단 뷰
        var secUI = UILabel()
        secUI.backgroundColor = UIColor(displayP3Red:238/255,green : 47/255, blue : 67/255, alpha: 1)
        secUI.frame = CGRect(x: DeviceManager.sharedInstance.width - 150, y: 0, width: CGFloat(150),  height: 400 *  DeviceManager.sharedInstance.heightRatio)
        secUI.numberOfLines = 10
        secUI.text = welf_wording
        secUI.textColor = UIColor.white
        secUI.font = UIFont(name: "Jalnan", size: 20)
        let attrString = NSMutableAttributedString(string: secUI.text!)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 20
        attrString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attrString.length))
        secUI.attributedText = attrString
        secUI.textAlignment = .center
        m_Scrollview.addSubview(secUI)
        
        //let imageView1 = UIImageView()
        
        imageView1.frame = CGRect(x: 0, y: 100,
                                  width: DeviceManager.sharedInstance.width - (150 * DeviceManager.sharedInstance.widthRatio),
                                  height: 200 *  DeviceManager.sharedInstance.heightRatio)
        imageView1.backgroundColor = UIColor.clear
        
        //imageView1.setImage(UIImage(named: "Baby-pana")!)
        imageView1.layer.shadowColor = UIColor.black.cgColor
        imageView1.layer.shadowOffset = CGSize(width: 5, height: 5) // 반경에 대해서 너무 적용이 되어서 4point 정도 ㅐ림.
        
        imageView1.layer.shadowOpacity = 1
        imageView1.layer.shadowRadius = 1 // 반경?
        
        imageView1.layer.shadowOpacity = 0.5 // alpha값입니다.
        //
        
        
        topUI.addSubview(imageView1)
        m_Scrollview.addSubview(topUI)
        
        
        
        
        var nameView = UIView()
        nameView.frame = CGRect(x:0, y: 400 *  DeviceManager.sharedInstance.heightRatio, width: CGFloat(DeviceManager.sharedInstance.width),  height: 160 *  DeviceManager.sharedInstance.heightRatio)
        nameView.backgroundColor = UIColor.white
        //상단 뷰
        
        
       // var nameUI = UILabel()
        //nameUI.backgroundColor = UIColor.white
        nameUI.frame = CGRect(x:0, y: 20 *  DeviceManager.sharedInstance.heightRatio, width: CGFloat(DeviceManager.sharedInstance.width),  height: 40 *  DeviceManager.sharedInstance.heightRatio)
        nameUI.font = UIFont(name: "Jalnan", size: 20 *  DeviceManager.sharedInstance.heightRatio)
        nameUI.numberOfLines = 2
       nameUI.text = selectedPolicy
        nameUI.textAlignment = .center
        
        
        
        
        nameView.addSubview(nameUI)
      
        
        
        
    
        m_Scrollview.addSubview(nameView)
        
        //메뉴 버튼 추가
        for i in 0..<2 {
            
            
            let button = UIButton(type: .system)
            button.frame = CGRect(x:CGFloat(100  + (i*100)) *  DeviceManager.sharedInstance.widthRatio, y: 520 *  DeviceManager.sharedInstance.heightRatio, width: 100 *  DeviceManager.sharedInstance.widthRatio, height: 30 *  DeviceManager.sharedInstance.heightRatio)
            
            button.setTitle(LabelName[i], for: .normal)
            button.titleLabel?.font = UIFont(name: "NanumBarunGothicBold", size: 16 *  DeviceManager.sharedInstance.heightRatio)!
            
            button.setTitleColor(UIColor.black, for: .normal)
            button.layer.addBorder([.bottom], color:#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), width: 1.0)
            button.tag = i
            button.addTarget(self, action: #selector(self.menu), for: .touchUpInside)
            
            buttons.append(button)
            
            
            
            m_Scrollview.addSubview(button)
            
            
        }
  
        
        //공유하기 버튼 추가
    
    let shareBtn = UIButton(type: .system)
    
    shareBtn.frame = CGRect(x: DeviceManager.sharedInstance.width - (50 * DeviceManager.sharedInstance.widthRatio), y: 0 *  DeviceManager.sharedInstance.heightRatio, width: 50 *  DeviceManager.sharedInstance.widthRatio, height: 50 *  DeviceManager.sharedInstance.heightRatio)
    
       
        
        
    var Img = UIImageView(image: UIImage(named: "share")!)
    Img.frame =  CGRect(x: 10 *  DeviceManager.sharedInstance.widthRatio, y: 0 , width: 40 *  DeviceManager.sharedInstance.widthRatio, height: 40 *  DeviceManager.sharedInstance.heightRatio)
        Img.contentMode = UIView.ContentMode.scaleAspectFill
        Img.tintColor = .clear
    shareBtn.addSubview(Img)
    shareBtn.addTarget(self, action: #selector(self.sendlink), for: .touchUpInside)
   

    
    m_Scrollview.addSubview(shareBtn)
        
        
        //3번 4번 작업
        requestBasic()
        
        
        
        //5번 작업
        //setBasicScrollView()
        
        //6번 작업
        //스크롤뷰 사이즈 지정
        m_Scrollview.frame = CGRect(x: 0, y: 20  *  DeviceManager.sharedInstance.heightRatio, width: DeviceManager.sharedInstance.width, height: DeviceManager.sharedInstance.height)
        

        
        
        self.view.addSubview(m_Scrollview)
        
        
          

        
        
    }
    
    
    //viewdidload다음에 호출,
    //뒤로가기,리뷰작성 및 수정후에는 viewdidload를 거치지 않고 바로 호출
    
    //1)리뷰의 데이터를 가져오고, 2)리뷰의 데이터를 ui에 반영한다.
    //리뷰메뉴일경우 그 데이터가 바로 반영이 되고, 그렇지 않은경우 리뷰메뉴를 클릭시 반영된다.
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("상세화면의 view가 viewWillAppear")
        
    //1,2번 작업
        //requestReview()
        
    
       
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("상세화면의 view가 viewDidAppear")
        setBarButton()
        if(setMenu == "리뷰"){
            
            print("리뷰메뉴")
            requestReview()
        }
        
        //
    

    }
    
    //혜택 상세정보 데이터 요청 및 ui만들기 및 ui에 데이터 반영
    func requestBasic(){
        
        print("상세내용 데이터 받아오기")
        
        print("지역정보:\(selectedLocal)")
        print("정책명:\(selectedPolicy)")

        
        //서버에 혜택 상세내용을 요청
        let params = ["type":"detail", "local" : selectedLocal , "welf_name" : selectedPolicy,  "login_token" : LoginManager.sharedInstance.token]
        Alamofire.request("https://www.urbene-fit.com/welf", method: .get, parameters: params)
            .validate()
            .responseJSON { [self] response in
                switch response.result {
                case .success(let value): ////print(value)
                   print("정책 성공")
                   // print(value)
                    
                    
                    do {
                        let data = try JSONSerialization.data(withJSONObject: value, options: .prettyPrinted)
                        let parseResult = try JSONDecoder().decode(parse.self, from: data)
                        print("요청 결과 : \(parseResult.Status)")
                        if(parseResult.Status == "200"){
                            
                            print("기본문구 : \(parseResult.Message[0].welf_wording)")
                            // print("대상 : \(parseResult.Message[0].target)")
                            //대상들을 배열에 넣어준다.
                            if(parseResult.Message[0].target != nil){
                                targets =  parseResult.Message[0].target!.components(separatedBy: "/")
                            }
                            welf_id = parseResult.Message[0].id
                            print("혜택아이디 : \(welf_id)")
                            
                            //혜택id를 받아오면 이를 이용해서 리뷰를 요청한다.
                            requestReview()
                            
                            if(parseResult.Message[0].target_tag != nil){
                                target_tags =  parseResult.Message[0].target_tag!.components(separatedBy: "/")
                            }
                            
                            //기본문구 혹은 이미지인지 아닌지를 구분하고 메인에 배치해준다
                            if(parseResult.Message[0].welf_wording != "기본 문구"){
                                welf_wording = parseResult.Message[0].welf_wording
                            }
                            
                         if(parseResult.Message[0].welf_image != "기본 이미지"){
                            
                            if let encoded = parseResult.Message[0].welf_image.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let myURL = URL(string: encoded) {
                
                                imageView1.kf.setImage(with: myURL)
                
                            }
                           // imageView1.kf.se
                         }else{
                            imageView1.setImage(UIImage(named: "detail_main")!)
                         }

                            
                            print("혜택 아이디 : \(welf_id)")
                            targetUI.tag = 11
                            targetUI.backgroundColor = UIColor.white
                            
                            targetUI.frame = CGRect(x: 50 *  DeviceManager.sharedInstance.widthRatio, y: 600 *  DeviceManager.sharedInstance.heightRatio, width: DeviceManager.sharedInstance.width - (100  *  DeviceManager.sharedInstance.widthRatio),  height: CGFloat((80 + 40 * targets.count)) * DeviceManager.sharedInstance.heightRatio)
                            
                            
                            targetUI.layer.cornerRadius = 23 *  DeviceManager.sharedInstance.heightRatio
                            targetUI.layer.borderWidth = 1.3
                            
                            targetUI.layer.borderColor = UIColor.white.cgColor
                            
                            
                            
                            var targetLabel = UILabel()
                            //nameUI.backgroundColor = UIColor.white
                            targetLabel.frame = CGRect(x:0, y: 0 *  DeviceManager.sharedInstance.heightRatio, width: CGFloat(DeviceManager.sharedInstance.width) - (100 *  DeviceManager.sharedInstance.widthRatio),  height: 60 *  DeviceManager.sharedInstance.heightRatio)
                            targetLabel.font = UIFont(name: "NanumBarunGothicBold", size: 16 *  DeviceManager.sharedInstance.heightRatio)
                            targetLabel.text = "당신도 혜택을 받을 수 있는지 확인해보세요"
                            targetLabel.textAlignment = .center
                            targetLabel.layer.addBorder([.bottom], color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), width: 1.0)
                            targetUI.addSubview(targetLabel)

                            
                            
                            
                            
                            //대상을 집어넣는다.
                            for i in 0..<targets.count {
                            let tl = UILabel()
                       
                                
                                
                                tl.frame = CGRect(x:20 *  DeviceManager.sharedInstance.widthRatio, y:CGFloat(80 + (i*40)) *  DeviceManager.sharedInstance.heightRatio, width: 200 *  DeviceManager.sharedInstance.widthRatio, height: 30 *  DeviceManager.sharedInstance.heightRatio)
                            tl.font = UIFont(name: "NanumBarunGothicBold", size: 16)
                            //대상입ㄹ
                            tl.text = "\(targets[i])"
                            tl.textAlignment = .left
                            targetUI.addSubview(tl)
                            
                      
                            }
                            
                            
                            for i in 0..<target_tags.count {

                                let button = UIButton(type: .system)
                                button.frame = CGRect(x:200 *  DeviceManager.sharedInstance.widthRatio, y:CGFloat(80 + (i*40)) *  DeviceManager.sharedInstance.heightRatio, width: 100 *  DeviceManager.sharedInstance.widthRatio, height: 30 *  DeviceManager.sharedInstance.heightRatio)
                                
                                button.setTitle("상세조건", for: .normal)
                                button.titleLabel?.font = UIFont(name: "Jalnan", size: 16 *  DeviceManager.sharedInstance.heightRatio)!
                                    button.tag = i
                                button.addTarget(self, action: #selector(requirement), for: .touchUpInside)

                                
                                button.setTitleColor(UIColor.black, for: .normal)
                                targetUI.addSubview(button)
                            }
                            
                            //혜택내용
                            infoUI.tag = 12
                            infoUI.backgroundColor = UIColor.white
                            
                          
                            
                            
                            //nameUI.backgroundColor = UIColor.white
                            infoLabel.frame = CGRect(x:0, y: 0 *  DeviceManager.sharedInstance.heightRatio, width: CGFloat(DeviceManager.sharedInstance.width - (100 *  DeviceManager.sharedInstance.widthRatio)),  height: 60 *  DeviceManager.sharedInstance.heightRatio)
                            infoLabel.font = UIFont(name: "NanumBarunGothicBold", size: 16 *  DeviceManager.sharedInstance.heightRatio)
                            infoLabel.text = "당신이 받을 혜택에 대해 설명해드릴게요."
                            infoLabel.textAlignment = .center
                            infoLabel.layer.addBorder([.bottom], color:#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), width: 1.0)
                            infoUI.addSubview(infoLabel)
                            
                            
                            var contentView = UITextView()
                            //nameUI.backgroundColor = UIColor.white
                            
                            contentView.font = UIFont(name: "NanumBarunGothicBold", size: 16  *  DeviceManager.sharedInstance.heightRatio)
                            var content = parseResult.Message[0].welf_contents.replacingOccurrences(of: ";;", with: ",")

                            content = content.replacingOccurrences(of: "^;", with: "\n")
                                
                            contentView.textAlignment = .left
                            contentView.text = content
                            
                            print("설명 길이 : \(content.count)")

                            var count = 0
                            var indexS = [Int]()

                            for i in content {
                                if i == "\n" {
                                    count += 1
                                }
                            }
                            
                            print("줄바꿈 수 :  \(count)")
                            
//                            contentHeight = Int((content as! NSString).size(withAttributes: [NSAttributedString.Key.font : contentLabel.font]).height + CGFloat((20 * count)) * DeviceManager.sharedInstance.heightRatio) + 50
                            
                            
//                            contentCount  = CGFloat(content.count / 25 * 20)  *  DeviceManager.sharedInstance.heightRatio + CGFloat(CGFloat((20 * count)) * DeviceManager.sharedInstance.heightRatio)
//
                            
//
//                            var numLines = (CGFloat(DeviceManager.sharedInstance.width - (120  *  DeviceManager.sharedInstance.widthRatio)) / contentView.font!.lineHeight) as? CGFloat
                            
                 


                            
                            contentView.frame = CGRect(x:10 *  DeviceManager.sharedInstance.widthRatio, y: 100 *  DeviceManager.sharedInstance.heightRatio, width: CGFloat(DeviceManager.sharedInstance.width - (120  *  DeviceManager.sharedInstance.widthRatio)),  height: CGFloat(200) *  DeviceManager.sharedInstance.heightRatio)
                            
                            var numLines : CGFloat = contentView.contentSize.height / contentView.font!.lineHeight

                        
                            print("줄 수 : \(numLines)")
                            
                            
                            contentHeight = Int(numLines * 19)
                            print("정보길이 : \(numLines)")
                            
                            contentView.frame = CGRect(x:10 *  DeviceManager.sharedInstance.widthRatio, y: 100 *  DeviceManager.sharedInstance.heightRatio, width: CGFloat(DeviceManager.sharedInstance.width - (120  *  DeviceManager.sharedInstance.widthRatio)),  height: CGFloat(contentHeight) *  DeviceManager.sharedInstance.heightRatio)
                            
                            contentView.isUserInteractionEnabled = false

                            
                       
                            
                            infoUI.addSubview(contentView)
                            
                            
                            infoUI.frame = CGRect(x: 50 *  DeviceManager.sharedInstance.widthRatio, y: CGFloat(720 + 40 * targets.count) * DeviceManager.sharedInstance.heightRatio, width: CGFloat(DeviceManager.sharedInstance.width - (100 *  DeviceManager.sharedInstance.widthRatio)),  height: CGFloat(contentHeight + 120)  *  DeviceManager.sharedInstance.heightRatio)
                            
                            
                            infoUI.layer.cornerRadius = 23 *  DeviceManager.sharedInstance.heightRatio
                            infoUI.layer.borderWidth = 1.3
                            
                            infoUI.layer.borderColor = UIColor.white.cgColor
                            
                            //스크롤븅에 배치해준다.
                            setBasicScrollView()
                            
                            
                            
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
                    //print("Error: \(error)")
                    break
                    
                    
                }
            }
        
    
        
        //기본 메뉴버튼의 색상 지정
        buttons[0].setTitleColor(UIColor(displayP3Red:238/255,green : 47/255, blue : 67/255, alpha: 1), for: .normal)
        buttons[0].layer.addBorder([.bottom], color:UIColor(displayP3Red:238/255,green : 47/255, blue : 67/255, alpha: 1), width: 1.0)
        
        
    }
    
        //1)스크롤뷰에 다른 화면을 삭제하고, 2)스크롤뷰에 내용메뉴의 데이터를 반영하고, 3)스크롤뷰의 컨텐츠 사이즈를 조정하는 메소드
    func setBasicScrollView(){
        //1번
        for subview in m_Scrollview.subviews{
            //반복문으로 각 메뉴별 뷰를 지정해서 삭제 한다.
            if subview is  UIView && subview.tag == 11 || subview.tag == 12 || subview.tag == 21 || subview.tag == 22 || subview.tag == 31 || subview.tag == 32{ // Check if view is type of VisualEffect and tag is equal to the view clicked
                subview.removeFromSuperview()
                
            }
            
        }
        
        //2번
        m_Scrollview.addSubview(targetUI)
        m_Scrollview.addSubview(infoUI)
        
        
        m_Scrollview.contentSize = CGSize(width: DeviceManager.sharedInstance.width, height: CGFloat(contentHeight + 900 + (40 * targets.count)) * DeviceManager.sharedInstance.heightRatio)
        
    
    }
    
    //리뷰화면을 스크롤뷰에 반영하는 메소드
   //1번 기존의 화면을 스크롤뷰에서 삭제해주고, 2번 리뷰가 있는지를 체크하고  리뷰화면 또는 리뷰작성하러가기를 스크롤뷰에 추가한다. 3번 스크롤뷰 스크롤사이즈를 변경해준다.
    func setReviewScrollView(){

        for subview in m_Scrollview.subviews{
            //반복문으로 각 메뉴별 뷰를 지정해서 삭제 한다.
            if subview is  UIView && subview.tag == 11 || subview.tag == 12 || subview.tag == 21 || subview.tag == 22 || subview.tag == 31 || subview.tag == 32{ // Check if view is type of VisualEffect and tag is equal to the view clicked
                subview.removeFromSuperview()
                
            }
            
        }
        
        
   
        //2번 작업
        //리뷰가 있을경우
        if(reviewItems.count > 0){

            print("리뷰 아이템이 있는 경우")
            //리뷰 리스트
            reViewTbView = UITableView(frame: CGRect(x: 20 *  DeviceManager.sharedInstance.widthRatio, y: 1170 *  DeviceManager.sharedInstance.heightRatio , width: DeviceManager.sharedInstance.width - (40 *  DeviceManager.sharedInstance.widthRatio), height: 522 *  DeviceManager.sharedInstance.heightRatio))
            reViewTbView.layer.cornerRadius = 33
            reViewTbView.tag = 22
          
         
            
            
            reViewTbView.register(NewReview.self, forCellReuseIdentifier: NewReview.identifier)
            reViewTbView.register(NewModdableReview.self, forCellReuseIdentifier: NewModdableReview.identifier)
            
     
            
            reViewTbView.dataSource = self
            reViewTbView.delegate = self
        self.m_Scrollview.addSubview(reViewTbView)
        self.reViewTbView.reloadData()
       
        
            
            
            reviewInfo(grade: grade,oneRatio: oneRatio,twoRatio: twoRatio,threeRatio: threeRatio,fourRatio: fourRatio,fiveRatio: fiveRatio,easyRatio: easyRatio,hardRatio: hardRatio,helpRatio: helpRatio,helpLessRatio: helpLessRatio)
            
            
            m_Scrollview.contentSize = CGSize(width: DeviceManager.sharedInstance.width, height: 1800 * DeviceManager.sharedInstance.heightRatio)
            
        
        //리뷰가 0개인 경우
        }else{

            
            m_Scrollview.contentSize = CGSize(width: DeviceManager.sharedInstance.width, height: DeviceManager.sharedInstance.height)

            
        print("리뷰 0 개")
        let reviewLabel = UILabel()
        //reviewLabel.backgroundColor = UIColor.white
        reviewLabel.frame = CGRect(x: 20 *  DeviceManager.sharedInstance.widthRatio, y: 590 *  DeviceManager.sharedInstance.heightRatio, width: DeviceManager.sharedInstance.width - (20 *  DeviceManager.sharedInstance.widthRatio), height: 30 *  DeviceManager.sharedInstance.heightRatio)
        reviewLabel.text = "아직 리뷰가 없습니다."
        reviewLabel.font = UIFont(name: "Jalnan", size: 19 *  DeviceManager.sharedInstance.heightRatio)
        reviewLabel.tag = 31
        self.m_Scrollview.addSubview(reviewLabel)

        
        let writeBtn = UIButton(type: .system)
        
        
        writeBtn.frame = CGRect(x:40 * DeviceManager.sharedInstance.widthRatio, y: 700 * DeviceManager.sharedInstance.heightRatio, width: DeviceManager.sharedInstance.width - (80 * DeviceManager.sharedInstance.widthRatio), height: 60 * DeviceManager.sharedInstance.heightRatio)
        
        writeBtn.layer.borderWidth = 1
        writeBtn.tag = 32

        writeBtn.addTarget(self, action: #selector(self.write), for: .touchUpInside)
        
        writeBtn.setTitle("첫 리뷰 쓰기", for: .normal)
        writeBtn.layer.cornerRadius = 13 * DeviceManager.sharedInstance.heightRatio
        writeBtn.backgroundColor = UIColor(displayP3Red:238/255,green : 47/255, blue : 67/255, alpha: 1)
        writeBtn.layer.borderColor = UIColor(displayP3Red:238/255,green : 47/255, blue : 67/255, alpha: 1).cgColor
        writeBtn.setTitleColor(UIColor.white, for: .normal)
        writeBtn.titleLabel!.font = UIFont(name: "Jalnan", size:20 * DeviceManager.sharedInstance.heightRatio)
        
        self.m_Scrollview.addSubview(writeBtn)

        
        
    }
        
        
        
        
    }
    
   
    //상세조건을 보는 메소드
    @objc func requirement(_ sender: UIButton){
        
        
        var content = target_tags[sender.tag].replacingOccurrences(of: "#", with: "\n#")
        
        
        let alert = UIAlertController(title: "상세조건", message: content, preferredStyle: .alert)

        let cancelAction = UIAlertAction(title: "확인", style: .cancel){

            (action : UIAlertAction) -> Void in

            alert.dismiss(animated: false)

        }

      

        alert.addAction(cancelAction)


        self.present(alert, animated: true, completion: nil)
    }
    
    
    //메뉴 클릭할 경우 스크롤뷰를 조정해서 하단화면을 바꾸주는 메소드
    @objc func menu(_ sender: UIButton) {
        
        
        print("메뉴버튼 클릭")
        print("태그번호\(sender.tag)")
        
   
        
        //클릭되지 않은 버튼을 클릭한 경우
        if (buttons[sender.tag].currentTitleColor != UIColor(displayP3Red:238/255,green : 47/255, blue : 67/255, alpha: 1)){
            
            buttons[sender.tag].setTitleColor(UIColor(displayP3Red:238/255,green : 47/255, blue : 67/255, alpha: 1), for: .normal)

            buttons[sender.tag].layer.addBorder([.bottom], color:UIColor(displayP3Red:238/255,green : 47/255, blue : 67/255, alpha: 1), width: 1.0)

            
            
            //클릭되었던 다른 메뉴 버튼의 색을 바꾸고, 해당 메뉴의 화면을 지워준다.
            
            for i in 0..<2 {
                if (i != sender.tag){
                    buttons[i].setTitleColor(UIColor.black, for: .normal)
                    buttons[i].layer.addBorder([.bottom], color:#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), width: 1.0)

                }
                
            }
          
        
            
            if (sender.tag == 0){
                
                setBasicScrollView()
                
            }else if(sender.tag == 1){
                
                print("리뷰버튼 선택")
                
                setReviewScrollView()
                
                
            }else{
                
                
                let alert = UIAlertController(title: "알림", message: "현재 준비중인 컨텐츠입니다.", preferredStyle: .alert)

                let cancelAction = UIAlertAction(title: "확인", style: .cancel){

                    (action : UIAlertAction) -> Void in

                    alert.dismiss(animated: false)

                }

              

                alert.addAction(cancelAction)


                self.present(alert, animated: true, completion: nil)
                
            }

            
            
            
            
        }
    }
    
    
    //1)리뷰 데이터를 가져오고,2)리뷰관련 ui를 만들고 3)뎅이터를 ui에 반영하는 작업
    func requestReview(){
        print("requestReview 메소드")
        print("리뷰셋팅 시 혜택 아이디\(welf_id)")
        
     //1번 작업
        
        //정책 리뷰 수정
        let parameters : Parameters = ["type": "list","welf_id": welf_id]
        
        Alamofire.request("https://www.urbene-fit.com/review", method: .get, parameters: parameters)
            .validate()
            .responseJSON { [self] response in
                
                switch response.result {
                case .success(let value):
                    print("리뷰 데이터 성공")
                    //print(value)
                    do {
                        
                        
                        let data = try JSONSerialization.data(withJSONObject: value, options: .prettyPrinted)
                        let StatusList = try JSONDecoder().decode(StatusParse.self, from: data)
                        print("리뷰요청 결과 : \(StatusList.Status)")
                        //리뷰가 있을 경우에만)
                        if(StatusList.Status == "200"){
                        //리뷰데이터를 테이블아이템에 추가해준다.
                            //스크롤뷰의 스크롤크기를 바꿔준다


                            let resultList = try JSONDecoder().decode(reviewParse.self, from: data)
                            self.reviewItems.removeAll()
                            print("리뷰 데이터 \(resultList.Message!.count)")
                            
                            //리뷰내용 파싱
                        for i in 0..<resultList.Message!.count {
                     
                            
                            print(resultList.Message![i].content)
                            self.reviewItems.append(reviewItem.init(content: resultList.Message![i].content,image_url : resultList.Message![i].image_url, id: resultList.Message![i].id, writer : resultList.Message![i].writer, star_count: resultList.Message![i].star_count))
                            
                            
                  
                        }
                            
                            
                            
                        //리뷰의견 파싱
                            //전체숫자에서 각자 점수를 나눠서 퍼센트에이지로 의견통꼐
                            
                      
                            print("resultList.TotalCount : \(resultList.TotalCount)")
                            for i in 0..<resultList.Review_stats.count {
                                print("토탈유저 : \(resultList.Review_stats[i].total_user)")
                                print("토탈별 : \(resultList.Review_stats[i].one_point)")
                                print("1점 : \(resultList.Review_stats[i].one_point)")

                                print("2점 : \(resultList.Review_stats[i].two_point)")
                                print("3점 : \(resultList.Review_stats[i].three_point)")
                                print("4점 : \(resultList.Review_stats[i].four_point)")
                                print("5점 : \(resultList.Review_stats[i].five_point)")

                                print("토탈점수 : \(resultList.Review_stats[i].star_sum)")

                                grade = resultList.Review_stats[i].star_sum/resultList.Review_stats[i].total_user
                                oneRatio = Double(resultList.Review_stats[i].one_point)/Double(resultList.Review_stats[i].total_user)
                                ratios.append(oneRatio)
                                print("1점 비율 : \(oneRatio)")

                                twoRatio = Double(resultList.Review_stats[i].two_point)/Double(resultList.Review_stats[i].total_user)
                                ratios.append(twoRatio)
                                print("2점 비율 : \(twoRatio)")

                                threeRatio = Double(resultList.Review_stats[i].three_point)/Double(resultList.Review_stats[i].total_user)
                                ratios.append(threeRatio)
                                print("3점 비율 : \(threeRatio)")


                                fourRatio = Double(resultList.Review_stats[i].four_point)/Double(resultList.Review_stats[i].total_user)
                                ratios.append(fourRatio)

                                fiveRatio = Double(resultList.Review_stats[i].five_point)/Double(resultList.Review_stats[i].total_user)
                                ratios.append(fiveRatio)
                                print("5점 비율 : \(fiveRatio)")
                                
                                
                                easyRatio = Double(resultList.Review_stats[i].esay)/Double(resultList.Review_stats[i].total_user)
                                hardRatio = Double(resultList.Review_stats[i].hard)/Double(resultList.Review_stats[i].total_user)
                                helpRatio = Double(resultList.Review_stats[i].help)/Double(resultList.Review_stats[i].total_user)
                                
                                print("도움변수 : \(resultList.Review_stats[i].help)")

                                print("도움됨 : \(Double(resultList.Review_stats[i].help)/Double(resultList.Review_stats[i].total_user))")

                                helpLessRatio = Double(resultList.Review_stats[i].helf_not)/Double(resultList.Review_stats[i].total_user)
                                print("도움안됨 : \(Double(resultList.Review_stats[i].helf_not)/Double(resultList.Review_stats[i].total_user))")
                           

                                
                                
                            }

                        
                                   
                            
                            
                           
                      
                            if(setMenu == "리뷰"){
                                
                                print("리뷰메뉴")
                                setReviewScrollView()
                            }
                            
                            
                            //리뷰 삭제 또는 요청시 없을 경우
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
                    print(error)
                }
            }
    }
    
    //리뷰작성하는 페이지로 이동하는 메소드
    @objc func write(){
        print("작성하러 가기")
        
        
        var nickName = UserDefaults.standard.string(forKey: "nickName")
    
        if(ableWrie && nickName != nil){
            
            
            
        guard let RVC = self.storyboard?.instantiateViewController(withIdentifier: "NewReviewlViewController") as? NewReviewlViewController         else{
            
            return
            
        }
        RVC.welf_id = welf_id
        RVC.selectedLocal = selectedLocal
        RVC.selectedPolicy = selectedPolicy

    
        self.navigationController?.pushViewController(RVC, animated: true)
        }else{
            if(LoginManager.sharedInstance.token == ""){
                
                let alert = UIAlertController(title: "알림", message: "로그인을 해주세요", preferredStyle: .alert)

                let cancelAction = UIAlertAction(title: "확인", style: .cancel){

                    (action : UIAlertAction) -> Void in

                    alert.dismiss(animated: false)

                }

              

                alert.addAction(cancelAction)


                self.present(alert, animated: true, completion: nil)
         
            }else if(nickName == nil){
                
                
                
                let alert = UIAlertController(title: "알림", message: "먼저 메인에서 혜택찾기를 눌러 닉네임정보를 입력해주세요.", preferredStyle: .alert)

                let cancelAction = UIAlertAction(title: "확인", style: .cancel){

                    (action : UIAlertAction) -> Void in

                    alert.dismiss(animated: false)

                }

              

                alert.addAction(cancelAction)


                self.present(alert, animated: true, completion: nil)
                
            }else{
                
                let alert = UIAlertController(title: "알림", message: "리뷰는 중복으로 남기실수 없습니다.", preferredStyle: .alert)

                let cancelAction = UIAlertAction(title: "확인", style: .cancel){

                    (action : UIAlertAction) -> Void in

                    alert.dismiss(animated: false)

                }

              

                alert.addAction(cancelAction)


                self.present(alert, animated: true, completion: nil)
            }
            
            
            
        }
    }
    
    
    
    func reviewInfo(grade : Int,oneRatio : Double, twoRatio : Double, threeRatio : Double, fourRatio : Double, fiveRatio : Double, easyRatio : Double, hardRatio : Double, helpRatio : Double, helpLessRatio : Double){

        reviewGradeView = UIView()
        
        //리뷰 평점 관련 정보를 보여주는 뷰
        reviewGradeView.tag = 21
        reviewGradeView.backgroundColor = UIColor.white
        
        reviewGradeView.frame = CGRect(x: 20 *  DeviceManager.sharedInstance.widthRatio, y: 590 *  DeviceManager.sharedInstance.heightRatio, width: DeviceManager.sharedInstance.width - (40 *  DeviceManager.sharedInstance.widthRatio),  height: 540 *  DeviceManager.sharedInstance.heightRatio)
        
        
        reviewGradeView.layer.cornerRadius = 23 *  DeviceManager.sharedInstance.heightRatio
        reviewGradeView.layer.borderWidth = 1.3
        
        reviewGradeView.layer.borderColor = UIColor.white.cgColor
        
        //평점과 별
        var gradeLabel = UILabel()
        //nameUI.backgroundColor = UIColor.white
        gradeLabel.frame = CGRect(x:70 *  DeviceManager.sharedInstance.widthRatio, y: 40 *  DeviceManager.sharedInstance.heightRatio, width: 120,  height: 60 *  DeviceManager.sharedInstance.heightRatio)
        gradeLabel.font = UIFont(name: "NanumBarunGothicBold", size: 40)
        gradeLabel.text = "\(grade)"
        gradeLabel.textAlignment = .left
        reviewGradeView.addSubview(gradeLabel)
        
        //별
        //별점 이미지on
        for i in 0..<grade {
            
            print("노란별 그리기")
            let starImg = UIImage(named: "star_on")
            var starImgView = UIImageView()
            
            starImgView.setImage(starImg!)
            starImgView.frame = CGRect(x:(i * 25) + 20, y: 100, width: 20, height: 20)
            starImgView.image = starImgView.image?.withRenderingMode(.alwaysTemplate)
            starImgView.tintColor = UIColor(displayP3Red:238/255,green : 47/255, blue : 67/255, alpha: 1)
            reviewGradeView.addSubview(starImgView)
 
            
            
        }
        //나머지 별
        for k in grade..<5{
            print("회색별 그리기")

            let starImg = UIImage(named: "star_off")
            var starImgView = UIImageView()
            
            starImgView.setImage(starImg!)
            starImgView.frame = CGRect(x:(k * 25) + 20, y: 100, width: 20, height: 20)
            starImgView.image = starImgView.image?.withRenderingMode(.alwaysTemplate)
            starImgView.tintColor = UIColor.gray
            reviewGradeView.addSubview(starImgView)
        }
        
        
        
        
        //리뷰 점수 및 통계
            //점수 분포도
            for i in 0..<5{
                
                
//                pv = UIProgressView(frame: CGRect(x:280 * DeviceManager.sharedInstance.widthRatio, y:CGFloat(((i * 30 ) + 50)) * DeviceManager.sharedInstance.heightRatio, width:100 * DeviceManager.sharedInstance.widthRatio, height:20 * DeviceManager.sharedInstance.heightRatio))
                
                pv = UIProgressView(frame: CGRect(x:280 * DeviceManager.sharedInstance.widthRatio, y:CGFloat(((i * 50 ) + 50)) * DeviceManager.sharedInstance.heightRatio, width:100 * DeviceManager.sharedInstance.widthRatio, height:20 * DeviceManager.sharedInstance.heightRatio))
                
                pv.progressTintColor = UIColor(displayP3Red:238/255,green : 47/255, blue : 67/255, alpha: 1)
                pv.trackTintColor = UIColor.lightGray
                // Set the coordinates.
                
                //layer 포지션이 직접적인 영향을 주는 것 같음
                pv.layer.position = CGPoint(x: 280  * DeviceManager.sharedInstance.widthRatio, y: CGFloat((i * 30 ) + 50) * DeviceManager.sharedInstance.heightRatio)
                // Set the height of the bar (1.0 times horizontally, 2.0 times vertically).
                pv.transform = CGAffineTransform(scaleX: 1.0, y: 2.0)
                // Set the progress degree (0.0 to 1.0).
                pv.progress = 0.0 // Add an animation.
                var k : Float = Float(i) * 0.1
             pv.setProgress(Float(ratios[i]), animated: true)
               // pvs.append(pv)
                reviewGradeView.addSubview(pv)
                
                
                var gradeLabel = UILabel()
                //nameUI.backgroundColor = UIColor.white
                gradeLabel.frame = CGRect(x:190 *  DeviceManager.sharedInstance.widthRatio, y: CGFloat((i * 30 ) + 40) *  DeviceManager.sharedInstance.heightRatio, width: 30 *  DeviceManager.sharedInstance.widthRatio,  height: 20 *  DeviceManager.sharedInstance.heightRatio)
                gradeLabel.font = UIFont(name: "NanumBarunGothicBold", size: 20 *  DeviceManager.sharedInstance.widthRatio)
                gradeLabel.text = "\(i+1)점"
                gradeLabel.textAlignment = .left
                reviewGradeView.addSubview(gradeLabel)

                
            }
        
      
        
        
        
        //평점과 의견 구분선
        let border = UIView()
        border.frame = CGRect.init(x: 0, y: 200 *  DeviceManager.sharedInstance.heightRatio, width: DeviceManager.sharedInstance.width - (40  *  DeviceManager.sharedInstance.widthRatio), height: 1)
        border.backgroundColor = UIColor.black
        reviewGradeView.addSubview(border)

        //의견
        //신청복잡도
        var applyLabel = UILabel()
        //nameUI.backgroundColor = UIColor.white
        applyLabel.frame = CGRect(x:20 *  DeviceManager.sharedInstance.widthRatio, y: 230 *  DeviceManager.sharedInstance.heightRatio, width: 100 *  DeviceManager.sharedInstance.widthRatio,  height: 30 *  DeviceManager.sharedInstance.heightRatio)
        applyLabel.font = UIFont(name: "Jalnan", size: 13 *  DeviceManager.sharedInstance.heightRatio)
        applyLabel.text = "신청난이도"
        applyLabel.textAlignment = .center
//        applyLabel.layer.borderWidth = 0.1
//        applyLabel.layer.cornerRadius = 13 * DeviceManager.sharedInstance.heightRatio
        reviewGradeView.addSubview(applyLabel)
        
        //신청복잡도
        var easyLabel = UILabel()
        //nameUI.backgroundColor = UIColor.white
        easyLabel.frame = CGRect(x:40 *  DeviceManager.sharedInstance.widthRatio, y: 280 *  DeviceManager.sharedInstance.heightRatio, width: 120 *  DeviceManager.sharedInstance.widthRatio,  height: 30 *  DeviceManager.sharedInstance.heightRatio)
        easyLabel.font = UIFont(name: "NanumBarunGothicBold", size: 12 *  DeviceManager.sharedInstance.heightRatio)
        easyLabel.text = "신청이 쉬워요"
        easyLabel.textAlignment = .left
        
        reviewGradeView.addSubview(easyLabel)
        
        let easyPv: UIProgressView = UIProgressView(frame: CGRect(x:220 *  DeviceManager.sharedInstance.widthRatio, y:275 *  DeviceManager.sharedInstance.heightRatio, width:100  *  DeviceManager.sharedInstance.widthRatio, height:30 *  DeviceManager.sharedInstance.heightRatio))
        easyPv.progressTintColor = UIColor(displayP3Red:238/255,green : 47/255, blue : 67/255, alpha: 1)
        easyPv.trackTintColor = UIColor.lightGray
        // Set the coordinates.
        easyPv.layer.position = CGPoint(x: 220 *  DeviceManager.sharedInstance.widthRatio, y: 295 *  DeviceManager.sharedInstance.heightRatio)
        // Set the height of the bar (1.0 times horizontally, 2.0 times vertically).
        easyPv.transform = CGAffineTransform(scaleX: 1.0, y: 2.0)
        // Set the progress degree (0.0 to 1.0).
        easyPv.progress = 0.0 // Add an animation.
        easyPv.setProgress(Float(easyRatio), animated: true)
        reviewGradeView.addSubview(easyPv)
        
        var difficultLabel = UILabel()
        //nameUI.backgroundColor = UIColor.white
        difficultLabel.frame = CGRect(x:40 *  DeviceManager.sharedInstance.widthRatio, y: 320 *  DeviceManager.sharedInstance.heightRatio, width: 120 *  DeviceManager.sharedInstance.widthRatio,  height: 30 *  DeviceManager.sharedInstance.heightRatio)
        difficultLabel.font = UIFont(name: "NanumBarunGothicBold", size: 12 *  DeviceManager.sharedInstance.heightRatio)
        difficultLabel.text = "신청이 어려워요"
        difficultLabel.textAlignment = .left
        
        reviewGradeView.addSubview(difficultLabel)
        
        let  difficultPv: UIProgressView = UIProgressView(frame: CGRect(x:220 *  DeviceManager.sharedInstance.widthRatio, y:315 *  DeviceManager.sharedInstance.heightRatio, width:100  *  DeviceManager.sharedInstance.widthRatio, height:30 *  DeviceManager.sharedInstance.heightRatio))
        difficultPv.progressTintColor = UIColor(displayP3Red:238/255,green : 47/255, blue : 67/255, alpha: 1)
        difficultPv.trackTintColor = UIColor.lightGray
        // Set the coordinates.
        difficultPv.layer.position = CGPoint(x: 220 *  DeviceManager.sharedInstance.widthRatio, y: 335 *  DeviceManager.sharedInstance.heightRatio)
        // Set the height of the bar (1.0 times horizontally, 2.0 times vertically).
        difficultPv.transform = CGAffineTransform(scaleX: 1.0, y: 2.0)
        // Set the progress degree (0.0 to 1.0).
        difficultPv.progress = 0.0 // Add an animation.
        difficultPv.setProgress(Float(hardRatio), animated: true)
        reviewGradeView.addSubview(difficultPv)
        
        
        //혜택만족도
        var satisfyLabel = UILabel()
        //nameUI.backgroundColor = UIColor.white
        satisfyLabel.frame = CGRect(x:20 *  DeviceManager.sharedInstance.widthRatio, y: 380 *  DeviceManager.sharedInstance.heightRatio, width: 100 *  DeviceManager.sharedInstance.widthRatio,  height: 30 *  DeviceManager.sharedInstance.heightRatio)
        satisfyLabel.font = UIFont(name: "Jalnan", size: 15 *  DeviceManager.sharedInstance.heightRatio)
        satisfyLabel.text = "혜택 만족도"
        satisfyLabel.textAlignment = .center
//        satisfyLabel.layer.borderWidth = 0.1
//        satisfyLabel.layer.cornerRadius = 13 * DeviceManager.sharedInstance.heightRatio
        reviewGradeView.addSubview(satisfyLabel)
        
        //신청복잡도
        var goodLabel = UILabel()
        //nameUI.backgroundColor = UIColor.white
        goodLabel.frame = CGRect(x:40 *  DeviceManager.sharedInstance.widthRatio, y: 420 *  DeviceManager.sharedInstance.heightRatio, width: 120 *  DeviceManager.sharedInstance.widthRatio,  height: 30 *  DeviceManager.sharedInstance.heightRatio)
        goodLabel.font = UIFont(name: "NanumBarunGothicBold", size: 12 *  DeviceManager.sharedInstance.heightRatio)
        goodLabel.text = "혜택이 도움됬어요"
        goodLabel.textAlignment = .left
        
        reviewGradeView.addSubview(goodLabel)
        
        let goodPv: UIProgressView = UIProgressView(frame: CGRect(x:220 *  DeviceManager.sharedInstance.widthRatio, y:415 *  DeviceManager.sharedInstance.heightRatio, width:100  *  DeviceManager.sharedInstance.widthRatio, height:30 *  DeviceManager.sharedInstance.heightRatio))
        goodPv.progressTintColor = UIColor(displayP3Red:238/255,green : 47/255, blue : 67/255, alpha: 1)
        goodPv.trackTintColor = UIColor.lightGray
        // Set the coordinates.
        goodPv.layer.position = CGPoint(x: 220 *  DeviceManager.sharedInstance.widthRatio, y: 435 *  DeviceManager.sharedInstance.heightRatio)
        // Set the height of the bar (1.0 times horizontally, 2.0 times vertically).
        goodPv.transform = CGAffineTransform(scaleX: 1.0, y: 2.0)
        // Set the progress degree (0.0 to 1.0).
        goodPv.progress = 0.0 // Add an animation.
        goodPv.setProgress(Float(helpRatio), animated: true)
        reviewGradeView.addSubview(goodPv)
        
        var badLabel = UILabel()
        //nameUI.backgroundColor = UIColor.white
        badLabel.frame = CGRect(x:40 *  DeviceManager.sharedInstance.widthRatio, y: 460 *  DeviceManager.sharedInstance.heightRatio, width: 120 *  DeviceManager.sharedInstance.widthRatio,  height: 30 *  DeviceManager.sharedInstance.heightRatio)
        badLabel.font = UIFont(name: "NanumBarunGothicBold", size: 12 *  DeviceManager.sharedInstance.heightRatio)
        badLabel.text = "별로 도움이 안됬어요"
        badLabel.textAlignment = .left
        
        reviewGradeView.addSubview(badLabel)
        
        let  badPv: UIProgressView = UIProgressView(frame: CGRect(x:220 *  DeviceManager.sharedInstance.widthRatio, y:455 *  DeviceManager.sharedInstance.heightRatio, width:100  *  DeviceManager.sharedInstance.widthRatio, height:30 *  DeviceManager.sharedInstance.heightRatio))
        badPv.progressTintColor = UIColor(displayP3Red:238/255,green : 47/255, blue : 67/255, alpha: 1)
        badPv.trackTintColor = UIColor.lightGray
        // Set the coordinates.
        badPv.layer.position = CGPoint(x: 220 *  DeviceManager.sharedInstance.widthRatio, y: 475 *  DeviceManager.sharedInstance.heightRatio)
        // Set the height of the bar (1.0 times horizontally, 2.0 times vertically).
        badPv.transform = CGAffineTransform(scaleX: 1.0, y: 2.0)
        // Set the progress degree (0.0 to 1.0).
        badPv.progress = 0.0 // Add an animation.
        badPv.setProgress(Float(helpLessRatio), animated: true)
        reviewGradeView.addSubview(badPv)
        
        m_Scrollview.addSubview(reviewGradeView)
        
        
        //리뷰들을 보여주는 테이블 뷰 위의 뷰(리뷰갯수와 리뷰 쓰기 버튼)
        
        
        
        
        
        //리뷰들을 보여주는 테이블 뷰
        
        
    }
    
    //헤더 높이설정
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
            return 70
        }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
            let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 70))

            let label = UILabel()
            label.frame = CGRect.init(x: 20 *  DeviceManager.sharedInstance.widthRatio, y: 20 *  DeviceManager.sharedInstance.heightRatio, width: 100 *  DeviceManager.sharedInstance.widthRatio, height: 30 *  DeviceManager.sharedInstance.heightRatio)
        label.text = "리뷰 총 \(reviewItems.count)개"
        label.font = UIFont(name: "Jalnan", size: 15 *  DeviceManager.sharedInstance.heightRatio)
        label.textAlignment = .left
        headerView.backgroundColor = UIColor.white
            headerView.addSubview(label)
        
        let writeBtn = UIButton(type: .system)
        
        
        writeBtn.frame = CGRect(x:260 *  DeviceManager.sharedInstance.widthRatio, y: 20 *  DeviceManager.sharedInstance.heightRatio, width: 100 *  DeviceManager.sharedInstance.widthRatio, height: 40 *  DeviceManager.sharedInstance.heightRatio)
        
        writeBtn.layer.borderWidth = 1
 
        writeBtn.addTarget(self, action: #selector(self.write), for: .touchUpInside)
        
        writeBtn.setTitle("리뷰 쓰기", for: .normal)
        writeBtn.layer.cornerRadius = 13
        writeBtn.backgroundColor = UIColor(displayP3Red:238/255,green : 47/255, blue : 67/255, alpha: 1)
        writeBtn.layer.borderColor = UIColor(displayP3Red:238/255,green : 47/255, blue : 67/255, alpha: 1).cgColor
        writeBtn.setTitleColor(UIColor.white, for: .normal)
        writeBtn.titleLabel!.font = UIFont(name: "Jalnan", size:12 *  DeviceManager.sharedInstance.heightRatio)
        
        headerView.addSubview(writeBtn)
        
        //하단 테두리 추가
        headerView.layer.addBorder([.bottom], color:  #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), width: 1)

            return headerView
        }
    
    //테이블뷰 총 섹션 숫자
    func numberOfSections(in tableView: UITableView) -> Int { return 1 }
    //셀 클릭이벤트
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    //테이블 셀 크기 조정
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        
        print("셀 크기 지정 메소드")
        
        if(UserDefaults.standard.string(forKey: "nickName") != nil){
        cellCase = UserDefaults.standard.string(forKey: "nickName")!
        }
      

        
        switch cellCase {
        
        
        //자신이 작성한 리뷰인 경우
        case self.reviewItems[indexPath.row].writer:
            
            //셀길이
            var height : CGFloat = CGFloat(((self.reviewItems[indexPath.row].content.count / 23 * 20) + 240)) *  DeviceManager.sharedInstance.heightRatio
         

            
            return height
        
        
        default:
            
            //셀길이
            var height : CGFloat = CGFloat(((self.reviewItems[indexPath.row].content.count / 23 * 20) + 200)) *  DeviceManager.sharedInstance.heightRatio
         
            
        return height
            
            
            

        }
    }
    //색션별 행 숫자
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviewItems.count
   
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        print("셀 생성 메소드")

        if(UserDefaults.standard.string(forKey: "nickName") != nil){
        cellCase = UserDefaults.standard.string(forKey: "nickName")!
        }
        print("사용자 : \(cellCase)")
        print("아이템 닉네임 : \(self.reviewItems[indexPath.row].writer)")

        //별점
        var grade : Int = Int(reviewItems[indexPath.row].star_count)!
        
        switch cellCase {
        
        
        //자신이 작성한 리뷰인 경우
        case self.reviewItems[indexPath.row].writer:
            print("사용자가 작성하 리뷰 \(indexPath.row)")

            //리뷰 중복 작성이 안되게끔 한다.
            ableWrie = false
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "NewModdableReview") as! NewModdableReview
            
            cell.content.text = self.reviewItems[indexPath.row].content
            
            //길이 조정
            
            
            cell.nickName.text = self.reviewItems[indexPath.row].writer
            
            cell.modifyBtn.tag = indexPath.row
            print("태그에 사용하는 셀 인덱스 번호: \(indexPath.row)")
            // call the subscribeTapped method when tapped
            cell.modifyBtn.addTarget(self, action: #selector(modify(_:)), for: .touchUpInside)
            cell.deleteBtn.tag = indexPath.row

            // call the subscribeTapped method when tapped
            cell.deleteBtn.addTarget(self, action: #selector(deleteR(_:)), for: .touchUpInside)
            
            //별점
            for i in 0..<grade {
           let starImg = UIImage(named: "star_on")
           var starImgView = UIImageView()
           starImgView.setImage(starImg!)
           //starImgView.frame = CGRect(x:30 * CGFloat(DeviceManager.sharedInstance.widthRatio) * i, y: 0, width: 20, height: 20)
                
                
                starImgView.frame = CGRect(x:25 * DeviceManager.sharedInstance.widthRatio * CGFloat(i), y: 0 *  DeviceManager.sharedInstance.heightRatio, width: 20  * DeviceManager.sharedInstance.widthRatio,  height: 20 *  DeviceManager.sharedInstance.heightRatio)
           starImgView.image = starImgView.image?.withRenderingMode(.alwaysOriginal)
                starImgView.tintColor = UIColor(displayP3Red:238/255,green : 47/255, blue : 67/255, alpha: 1)

                cell.gradeView.addSubview(starImgView)
           }
        
            //별점
            for i in grade..<5 {
           let starImg = UIImage(named: "star_off")
           var starImgView = UIImageView()
           starImgView.setImage(starImg!)
                starImgView.frame = CGRect(x:25 * DeviceManager.sharedInstance.widthRatio * CGFloat(i), y: 0 *  DeviceManager.sharedInstance.heightRatio, width: 20  * DeviceManager.sharedInstance.widthRatio,  height: 20 *  DeviceManager.sharedInstance.heightRatio)
           starImgView.image = starImgView.image?.withRenderingMode(.alwaysOriginal)
                starImgView.tintColor = UIColor.gray

                cell.gradeView.addSubview(starImgView)
           }
        
            
            //셀 선택시 회색으로 변하지 않게 하기
            cell.selectionStyle = .none
            return cell
        
        
        default:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "NewReview") as! NewReview
            
            cell.content.text = self.reviewItems[indexPath.row].content
            cell.nickName.text = self.reviewItems[indexPath.row].writer
            
            //별점
            for i in 0..<grade {
           let starImg = UIImage(named: "star_on")
           var starImgView = UIImageView()
           starImgView.setImage(starImg!)
           //starImgView.frame = CGRect(x:30 * CGFloat(DeviceManager.sharedInstance.widthRatio) * i, y: 0, width: 20, height: 20)
                
                
                starImgView.frame = CGRect(x:25 * DeviceManager.sharedInstance.widthRatio * CGFloat(i), y: 0 *  DeviceManager.sharedInstance.heightRatio, width: 20  * DeviceManager.sharedInstance.widthRatio,  height: 20 *  DeviceManager.sharedInstance.heightRatio)
           starImgView.image = starImgView.image?.withRenderingMode(.alwaysOriginal)
                starImgView.tintColor = UIColor(displayP3Red:238/255,green : 47/255, blue : 67/255, alpha: 1)

                cell.gradeView.addSubview(starImgView)
           }
        
            //별점
            for i in grade..<5 {
           let starImg = UIImage(named: "star_off")
           var starImgView = UIImageView()
           starImgView.setImage(starImg!)
                starImgView.frame = CGRect(x:25 * DeviceManager.sharedInstance.widthRatio * CGFloat(i), y: 0 *  DeviceManager.sharedInstance.heightRatio, width: 20  * DeviceManager.sharedInstance.widthRatio,  height: 20 *  DeviceManager.sharedInstance.heightRatio)
           starImgView.image = starImgView.image?.withRenderingMode(.alwaysOriginal)
                starImgView.tintColor = UIColor.gray

                cell.gradeView.addSubview(starImgView)
           }
        
            //셀 선택시 회색으로 변하지 않게 하기
            cell.selectionStyle = .none

            return cell
            
            

        }
      
        
        
        
        
        

        
    }
    
    
    //수정 버튼
    //셀 수정 버튼
    @objc func modify(_ sender: UIButton) {
        //print("수정")
        
        
        guard let RVC = self.storyboard?.instantiateViewController(withIdentifier: "NewReviewlViewController") as? NewReviewlViewController         else{
            
            return
            
        }
        //뷰 이동
        RVC.modalPresentationStyle = .fullScreen
        
        //수정
        RVC.welf_id = welf_id
        RVC.selectedLocal = selectedLocal
        RVC.selectedPolicy = selectedPolicy
        RVC.modify = true
        RVC.grade = grade
        RVC.review_id = reviewItems[sender.tag].id

        RVC.oldContent = reviewItems[sender.tag].content
        print(reviewItems[sender.tag].content)

//        RVC.modifyContent = reviewItems[sender.tag].content
//        RVC.review_id = reviewItems[sender.tag].id

        
        
        //리뷰작성 페이지로 이동
       // self.present(RVC, animated: true, completion: nil)
        self.navigationController?.pushViewController(RVC, animated: true)
        
        
        
    }
    
    
    //리뷰 삭제
    @objc func deleteR(_ sender: UIButton) {
        //print("삭제")
        
        
        
        let alert = UIAlertController(title: "알림", message: "리뷰를 정말 삭제하시겠습니까?", preferredStyle: .alert)

        let cancelAction = UIAlertAction(title: "취소", style: .cancel){

            (action : UIAlertAction) -> Void in

            alert.dismiss(animated: false)

        }
        
        
        let defaultAction = UIAlertAction(title: "확인", style: .destructive) { (action) in



            
            //삭제시 리뷰 작성이 가능하게끔 바꿔준다
            self.ableWrie = true
            
            var review_id : Int = self.reviewItems[sender.tag].id
            
            var id : Int = sender.tag
            print("삭제id: \(id)")
            
            let parameters  : Parameters = ["login_token": LoginManager.sharedInstance.token,"review_id": review_id, "type" : "delete"]

            Alamofire.request("https://www.urbene-fit.com/review", method: .post, parameters: parameters)
                .validate()
                .responseJSON { response in
                    
                    switch response.result {
                    case .success(let value):
    //
                        if let json = value as? [String: Any] {
                                      //print(json)
                        for (key, value) in json {
                            print("\(key) : \(value)")
                 
                            //리뷰가 삭제되면,테이블뷰롤 갱신해준다.
                            if(key == "Status" && value as! String == "200"){
                                
                                //리뷰가 0개 된 경우
                                if(self.reviewItems.count == 1){
                                    self.reviewItems.removeAll()
                                    self.setReviewScrollView()
                                }else{
                                self.setMenu = "리뷰"
                                //삭제후 다시 리뷰데이터를 받고
                                self.requestReview()
                                }
                                //다시 리뷰ui에 데이터를 반영한다.
                               // self.setReviewScrollView()

                            }
            
                }
                        
                            
                            
    }
                        
                        
                     case .failure(let error):
                         print(error)
                     }
                     
                     
                     
                 }


        }



      
        alert.addAction(defaultAction)
        alert.addAction(cancelAction)


        self.present(alert, animated: true, completion: nil)
     
    }
    
    //공유하기 메소드
    
    @objc func sendlink(){
        
        // Feed 타입 템플릿 오브젝ㄹ트 생성
        let template = KMTFeedTemplate { (feedTemplateBuilder) in
            
            // 컨텐츠
            feedTemplateBuilder.content = KMTContentObject(builderBlock: { (contentBuilder) in
                contentBuilder.title = "당신이 놓치고 있는 혜택"
                contentBuilder.desc = self.selectedPolicy
                contentBuilder.imageURL = URL(string: "https://www.urbene-fit.com/images/about_1.jpg")!
                contentBuilder.link = KMTLinkObject(builderBlock: { (linkBuilder) in
                    linkBuilder.mobileWebURL = URL(string: "https://www.urbene-fit.com")
                })
            })
            
            // 소셜
            feedTemplateBuilder.social = KMTSocialObject(builderBlock: { (socialBuilder) in
                socialBuilder.likeCount = 286
                socialBuilder.commnentCount = 45
                socialBuilder.sharedCount = 845
            })
            
            // 버튼
            feedTemplateBuilder.addButton(KMTButtonObject(builderBlock: { (buttonBuilder) in
                buttonBuilder.title = "웹으로 보기"
                buttonBuilder.link = KMTLinkObject(builderBlock: { (linkBuilder) in
                    linkBuilder.mobileWebURL = URL(string: "https://www.urbene-fit.com")
                })
            }))
            feedTemplateBuilder.addButton(KMTButtonObject(builderBlock: { (buttonBuilder) in
                buttonBuilder.title = "앱으로 보기"
                buttonBuilder.link = KMTLinkObject(builderBlock: { (linkBuilder) in
                    linkBuilder.iosExecutionParams = "param1=value1&param2=value2"
                    linkBuilder.androidExecutionParams = "param1=value1&param2=value2"
                })
            }))
        }
        
        // 서버에서 콜백으로 받을 정보
        let serverCallbackArgs = ["user_id": "abcd",
                                  "product_id": "1234"]

        // 카카오링크 실행
        KLKTalkLinkCenter.shared().sendDefault(with: template, serverCallbackArgs: serverCallbackArgs, success: { (warningMsg, argumentMsg) in
            
            // 성공
            print("warning message: \(String(describing: warningMsg))")
            print("argument message: \(String(describing: argumentMsg))")
            
        }, failure: { (error) in
            
            // 실패
           // UIAlertController.showMessage(error.localizedDescription)
            print("error \(error)")
            
        })
    }
    
    
    
    
   //클래스 종료
}
extension CALayer {
    func addBorder(_ arr_edge: [UIRectEdge], color: UIColor, width: CGFloat) {
        for edge in arr_edge {
            let border = CALayer()
            
            switch edge {
            case UIRectEdge.top:
                border.frame = CGRect.init(x: 0, y: 0, width: frame.width, height: width)
                break
            case UIRectEdge.bottom:
                border.frame = CGRect.init(x: 20, y: frame.height - width, width: frame.width - 40, height: width)
                break
            case UIRectEdge.left:
                border.frame = CGRect.init(x: 0, y: 0, width: width, height: frame.height)
                break
            case UIRectEdge.right:
                border.frame = CGRect.init(x: frame.width - width, y: 0, width: width, height: frame.height)
                break
            default:
                break
            }
            border.backgroundColor = color.cgColor;
            self.addSublayer(border)
        }
    }
    func addBtnBorder(_ arr_edge: [UIRectEdge], color: UIColor, width: CGFloat) {
        for edge in arr_edge {
            let border = CALayer()
            
            switch edge {
            case UIRectEdge.top:
                border.frame = CGRect.init(x: 0, y: 0, width: frame.width, height: width)
                break
            case UIRectEdge.bottom:
                border.frame = CGRect.init(x: 20, y: frame.height - width, width: frame.width - 40, height: width)
                break
            case UIRectEdge.left:
                border.frame = CGRect.init(x: 0, y: 0, width: width, height: frame.height)
                break
            case UIRectEdge.right:
                border.frame = CGRect.init(x: frame.width - width, y: 0, width: width, height: frame.height)
                break
            default:
                break
            }
            border.backgroundColor = color.cgColor;
            self.addSublayer(border)
        }
    }
    
    
    func addCategoryBtnBorder(_ arr_edge: [UIRectEdge], color: UIColor, width: CGFloat) {
        for edge in arr_edge {
            let border = CALayer()
            
            switch edge {
            case UIRectEdge.top:
                border.frame = CGRect.init(x: 0, y: 0, width: frame.width, height: width)
                break
            case UIRectEdge.bottom:
                border.frame = CGRect.init(x: 0, y: frame.height - width, width: frame.width, height: width)
                break
            case UIRectEdge.left:
                border.frame = CGRect.init(x: 0, y: 0, width: width, height: frame.height)
                break
            case UIRectEdge.right:
                border.frame = CGRect.init(x: frame.width - width, y: 0, width: width, height: frame.height)
                break
            default:
                break
            }
            border.backgroundColor = color.cgColor;
            self.addSublayer(border)
        }
    }
    
}


