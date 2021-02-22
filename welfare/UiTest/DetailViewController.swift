/*
 
 상세페이지
  
 혜택에 대한 내용/리뷰등을 보여주는 화면
 
 상세페이지로 들어오는 경우
  
 1.검색결과리스트 화면(카테고리,지역)
  
 이전화면에서 클릭한 정책명을 받아와 내용메뉴의 화면을 보여준다.
  
 2. 알림리스트화면에서
  
 이전화면에서 클릭한 정책명을 받아와 내용메뉴의 화면을 보여준다.
  
  
 3.메인화면에서 추천혜택 선택을 통해서
  
 이전화면에서 클릭한 정책명을 받아와 내용메뉴의 화면을 보여준다.
  
 4.리뷰메뉴를 클릭한 경우
  
 내용메뉴의 UI를 없애고, 리뷰메뉴의 UI를 추가한 후, 평점,리뷰데이터를 ui에 반영한다.
  
 5. 리뷰 작성/수정 완료 후
  
 다시 상세페이지로 돌아와, 평점,리뷰데이터를 UI에 반영한다.
  
 6.리뷰 작성/수정 중 뒤로가기
  
 스택에 쌓여있는 화면을 사용한다.
 
 
 내용 메뉴를 보여주는 경우와 리뷰메뉴를 먼저 보여주는 경우로 크게 나뉜다.

 두 메뉴 모두 공통적으로 상단에 정책명과 문구등을 보여준다.
 
 
 
 */

import UIKit
import Alamofire
import Kingfisher

class DetailViewController:  UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    
    
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

    //혜택대상
    var targetUI = UIView()
    

    //혜택이름
    var nameUI = UILabel()

    //혜택 이미지
    var imageView1 = UIImageView()
    
    //점수 뷰를 보여주는 화면
    var reviewGradeView = UIView()

    //작성가능여부를 체크해주는 불린 변수
    var ableWrie = Bool()

    //혜택내용의 길이를 저장하는 변수
    var contentHeight = Int()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("상세화면의 view가 viewWillAppear")
        
        
        
        if(setMenu == "리뷰"){
            
            print("리뷰메뉴")

            //menu(buttons[1])

        }else{
            print("기본메뉴")

            //menu(buttons[0])

        }
        //메인 네비 타이틀 초기화
       // self.title = "메인"
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("상세화면의 view가 viewDidAppear")
        setBarButton()
        
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
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("상세화면의 view가 viewWillDisappear")

    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print("상세화면의 view가 viewDidDisappear")

        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("상세화면의 view가 viewDidLoad")
        menu(buttons[0])
        
        //비로그인이면 작성불가능
        if(LoginManager.sharedInstance.token == ""){
            ableWrie = false
        }else{
            ableWrie = true
        }
        
        
        print("혜택 아이디;\(welf_id)")
        
        self.view.backgroundColor = #colorLiteral(red: 0.9222517449, green: 0.9222517449, blue: 0.9222517449, alpha: 1)
        
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
        nameUI.font = UIFont(name: "Jalnan", size: 20)
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
  
        //스크롤뷰 사이즈 지정
        m_Scrollview.frame = CGRect(x: 0, y: 20  *  DeviceManager.sharedInstance.heightRatio, width: DeviceManager.sharedInstance.width, height: DeviceManager.sharedInstance.height)
        m_Scrollview.contentSize = CGSize(width: DeviceManager.sharedInstance.width, height: CGFloat(1000 + (40 * targets.count) + contentHeight) * DeviceManager.sharedInstance.heightRatio)
        self.view.addSubview(m_Scrollview)

        
      
        
    }
    
    //메뉴 클릭할 경우 하단화면을 바꾸주는 메소드
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
          
            for subview in m_Scrollview.subviews{
                //반복문으로 각 메뉴별 뷰를 지정해서 삭제 한다.
                if subview is  UIView && subview.tag == 11 || subview.tag == 12 || subview.tag == 21 || subview.tag == 22 || subview.tag == 31 || subview.tag == 32{ // Check if view is type of VisualEffect and tag is equal to the view clicked
                    subview.removeFromSuperview()
                    
                }
                
            }
            
            if (sender.tag == 0){
                basicInfo()
            }else if(sender.tag == 1){
                
                print("리뷰버튼 선택")
                setReview()
                
                
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
    
    //내용 메뉴 보여주는 메소드
    func basicInfo(){
        print("선택 된 지역 : \(selectedLocal)")
        print("선택 된 혜택 : \(selectedPolicy)")

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
                            if(parseResult.Message[0].target_tag != nil){
                                target_tags =  parseResult.Message[0].target_tag!.components(separatedBy: "/")
                            }
                             welf_id = parseResult.Message[0].id
                            
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
                            
                            m_Scrollview.addSubview(targetUI)
                            
                            
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
                           // tl.frame = CGRect(x:20 *  DeviceManager.sharedInstance.widthRatio, y: CGFloat(80 + (i*40) *  DeviceManager.sharedInstance.heightRatio), width: 200 *  DeviceManager.sharedInstance.widthRatio, height: 30 *  DeviceManager.sharedInstance.heightRatio)
                                
                                
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
                            var infoUI = UIView()
                            infoUI.tag = 12
                            infoUI.backgroundColor = UIColor.white
                            
                          
                            
                            
                            var infoLabel = UILabel()
                            //nameUI.backgroundColor = UIColor.white
                            infoLabel.frame = CGRect(x:0, y: 0 *  DeviceManager.sharedInstance.heightRatio, width: CGFloat(DeviceManager.sharedInstance.width - (100 *  DeviceManager.sharedInstance.widthRatio)),  height: 60 *  DeviceManager.sharedInstance.heightRatio)
                            infoLabel.font = UIFont(name: "NanumBarunGothicBold", size: 16 *  DeviceManager.sharedInstance.heightRatio)
                            infoLabel.text = "당신이 받을 혜택에 대해 설명해드릴게요."
                            infoLabel.textAlignment = .center
                            infoLabel.layer.addBorder([.bottom], color:#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), width: 1.0)
                            infoUI.addSubview(infoLabel)
                            
                            
                            var contentLabel = UILabel()
                            //nameUI.backgroundColor = UIColor.white
                            
                            contentLabel.font = UIFont(name: "NanumBarunGothicBold", size: 16  *  DeviceManager.sharedInstance.heightRatio)
                            contentLabel.numberOfLines = 100
                            var content = parseResult.Message[0].welf_contents.replacingOccurrences(of: ";;", with: ",")

                            content = content.replacingOccurrences(of: "^;", with: "\n")
                                
                            contentLabel.textAlignment = .left
                            contentLabel.text = content
                            

                            var count = 0
                            var indexS = [Int]()

                            for i in content {
                                if i == "\n" {
                                    count += 1
                                }
                            }
                            
                            print("줄바꿈 수 :  \(count)")
                            
                            contentHeight = Int((content as! NSString).size(withAttributes: [NSAttributedString.Key.font : contentLabel.font]).height + CGFloat((20 * count)) * DeviceManager.sharedInstance.heightRatio) + 50

                            print("글자 길이 : \(contentHeight)")
                            
                            contentLabel.frame = CGRect(x:0, y: 100 *  DeviceManager.sharedInstance.heightRatio, width: CGFloat(DeviceManager.sharedInstance.width - (100  *  DeviceManager.sharedInstance.widthRatio)),  height: CGFloat(contentHeight) *  DeviceManager.sharedInstance.heightRatio)
                            
                            contentLabel.textAlignment = .center
                            infoUI.addSubview(contentLabel)
                            
                            
                            infoUI.frame = CGRect(x: 50 *  DeviceManager.sharedInstance.widthRatio, y: CGFloat(720 + 40 * targets.count) * DeviceManager.sharedInstance.heightRatio, width: CGFloat(DeviceManager.sharedInstance.width - (100 *  DeviceManager.sharedInstance.widthRatio)),  height: CGFloat((100 + contentHeight)) *  DeviceManager.sharedInstance.heightRatio)
                            
                            
                            infoUI.layer.cornerRadius = 23 *  DeviceManager.sharedInstance.heightRatio
                            infoUI.layer.borderWidth = 1.3
                            
                            infoUI.layer.borderColor = UIColor.white.cgColor
                            
                            m_Scrollview.addSubview(infoUI)
                            
                            //스크롤뷰 사이즈 지정
                            m_Scrollview.frame = CGRect(x: 0, y: 20  *  DeviceManager.sharedInstance.heightRatio, width: DeviceManager.sharedInstance.width, height: DeviceManager.sharedInstance.height)
                            m_Scrollview.contentSize = CGSize(width: DeviceManager.sharedInstance.width, height: CGFloat(1000 + (40 * targets.count) + contentHeight) * DeviceManager.sharedInstance.heightRatio)
                            self.view.addSubview(m_Scrollview)
                            
                            
                            
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
        
        
        //혜택대상
       
        
      

//        for i in 0..<3 {
//
//
//            let imageView1 = UIImageView()
//            imageView1.frame = CGRect(x:20, y: 80 + (i*40), width: 30, height: 30)
//
//
//
//            //imageView.kf.setImage(with: url)
//            imageView1.backgroundColor = UIColor.clear
//
//            imageView1.setImage(UIImage(named: "gift-card")!)
//            imageView1.image = imageView1.image?.withRenderingMode(.alwaysTemplate)
//            imageView1.tintColor = UIColor(displayP3Red:238/255,green : 47/255, blue : 67/255, alpha: 1)
//            imageView1.layer.shadowColor = UIColor(displayP3Red:238/255,green : 47/255, blue : 67/255, alpha: 1).cgColor
//            imageView1.layer.shadowOffset = CGSize(width: 5, height: 5) // 반경에 대해서 너무 적용이 되어서 4point 정도 ㅐ림.
//
//            imageView1.layer.shadowOpacity = 1
//            imageView1.layer.shadowRadius = 1 // 반경?
//
//            imageView1.layer.shadowOpacity = 0.5 // alpha값입니다.
//
//            infoUI.addSubview(imageView1)
//            let tl = UILabel()
//            tl.frame = CGRect(x:70, y: 80 + (i*40), width: 200, height: 30)
//            tl.font = UIFont(name: "NanumBarunGothicBold", size: 16)
//            tl.text = "혜택\(i)"
//            tl.textAlignment = .center
//            //infoUI.addSubview(tl)
//
//        }
        
        
        
        
//        m_Scrollview.frame = CGRect(x: 0, y: 20, width: DeviceManager.sharedInstance.width, height: DeviceManager.sharedInstance.height)
//        m_Scrollview.contentSize = CGSize(width: DeviceManager.sharedInstance.width, height: 1400)
//        self.view.addSubview(m_Scrollview)
        
        //기본 메뉴버튼의 색상 지정
        buttons[0].setTitleColor(UIColor(displayP3Red:238/255,green : 47/255, blue : 67/255, alpha: 1), for: .normal)
        buttons[0].layer.addBorder([.bottom], color:UIColor(displayP3Red:238/255,green : 47/255, blue : 67/255, alpha: 1), width: 1.0)

    }
    
    //리뷰화면을 보여주는 메소드
    /*//혜택의 평점
    var grade = Int()
    //평점 비율
    var oneRatio = Float()
    var twoRatio = Float()
    var threeRatio = Float()
    var fourRatio = Float()
    var fiveRatio = Float()
 */
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
        gradeLabel.frame = CGRect(x:40 *  DeviceManager.sharedInstance.widthRatio, y: 40 *  DeviceManager.sharedInstance.heightRatio, width: 120,  height: 60 *  DeviceManager.sharedInstance.heightRatio)
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
        
        
        
        
   
        
      
        
        
        
        //평점과 의견 구분선
        let border = UIView()
        border.frame = CGRect.init(x: 0, y: 200, width: DeviceManager.sharedInstance.width - 40, height: 1)
        border.backgroundColor = UIColor.black
        reviewGradeView.addSubview(border)

        //의견
        //신청복잡도
        var applyLabel = UILabel()
        //nameUI.backgroundColor = UIColor.white
        applyLabel.frame = CGRect(x:20 *  DeviceManager.sharedInstance.widthRatio, y: 220 *  DeviceManager.sharedInstance.heightRatio, width: 100 *  DeviceManager.sharedInstance.widthRatio,  height: 30 *  DeviceManager.sharedInstance.heightRatio)
        applyLabel.font = UIFont(name: "NanumBarunGothicBold", size: 16 *  DeviceManager.sharedInstance.heightRatio)
        applyLabel.text = "신청난이도"
        applyLabel.textAlignment = .center
        applyLabel.layer.borderWidth = 0.1
        applyLabel.layer.cornerRadius = 13 * DeviceManager.sharedInstance.heightRatio
        reviewGradeView.addSubview(applyLabel)
        
        //신청복잡도
        var easyLabel = UILabel()
        //nameUI.backgroundColor = UIColor.white
        easyLabel.frame = CGRect(x:40 *  DeviceManager.sharedInstance.widthRatio, y: 260 *  DeviceManager.sharedInstance.heightRatio, width: 120 *  DeviceManager.sharedInstance.widthRatio,  height: 30 *  DeviceManager.sharedInstance.heightRatio)
        easyLabel.font = UIFont(name: "NanumBarunGothicBold", size: 12 *  DeviceManager.sharedInstance.heightRatio)
        easyLabel.text = "신청이 쉬워요"
        easyLabel.textAlignment = .left
        
        reviewGradeView.addSubview(easyLabel)
        
        let easyPv: UIProgressView = UIProgressView(frame: CGRect(x:220 *  DeviceManager.sharedInstance.widthRatio, y:275 *  DeviceManager.sharedInstance.heightRatio, width:100  *  DeviceManager.sharedInstance.widthRatio, height:30 *  DeviceManager.sharedInstance.heightRatio))
        easyPv.progressTintColor = UIColor(displayP3Red:238/255,green : 47/255, blue : 67/255, alpha: 1)
        easyPv.trackTintColor = UIColor.lightGray
        // Set the coordinates.
        easyPv.layer.position = CGPoint(x: 220 *  DeviceManager.sharedInstance.widthRatio, y: 275 *  DeviceManager.sharedInstance.heightRatio)
        // Set the height of the bar (1.0 times horizontally, 2.0 times vertically).
        easyPv.transform = CGAffineTransform(scaleX: 1.0, y: 2.0)
        // Set the progress degree (0.0 to 1.0).
        easyPv.progress = 0.0 // Add an animation.
        easyPv.setProgress(Float(easyRatio), animated: true)
        reviewGradeView.addSubview(easyPv)
        
        var difficultLabel = UILabel()
        //nameUI.backgroundColor = UIColor.white
        difficultLabel.frame = CGRect(x:40 *  DeviceManager.sharedInstance.widthRatio, y: 300 *  DeviceManager.sharedInstance.heightRatio, width: 120 *  DeviceManager.sharedInstance.widthRatio,  height: 30 *  DeviceManager.sharedInstance.heightRatio)
        difficultLabel.font = UIFont(name: "NanumBarunGothicBold", size: 12 *  DeviceManager.sharedInstance.heightRatio)
        difficultLabel.text = "신청이 어려워요"
        difficultLabel.textAlignment = .left
        
        reviewGradeView.addSubview(difficultLabel)
        
        let  difficultPv: UIProgressView = UIProgressView(frame: CGRect(x:220 *  DeviceManager.sharedInstance.widthRatio, y:315 *  DeviceManager.sharedInstance.heightRatio, width:100  *  DeviceManager.sharedInstance.widthRatio, height:30 *  DeviceManager.sharedInstance.heightRatio))
        difficultPv.progressTintColor = UIColor(displayP3Red:238/255,green : 47/255, blue : 67/255, alpha: 1)
        difficultPv.trackTintColor = UIColor.lightGray
        // Set the coordinates.
        difficultPv.layer.position = CGPoint(x: 220 *  DeviceManager.sharedInstance.widthRatio, y: 315 *  DeviceManager.sharedInstance.heightRatio)
        // Set the height of the bar (1.0 times horizontally, 2.0 times vertically).
        difficultPv.transform = CGAffineTransform(scaleX: 1.0, y: 2.0)
        // Set the progress degree (0.0 to 1.0).
        difficultPv.progress = 0.0 // Add an animation.
        difficultPv.setProgress(Float(hardRatio), animated: true)
        reviewGradeView.addSubview(difficultPv)
        
        
        //혜택만족도
        var satisfyLabel = UILabel()
        //nameUI.backgroundColor = UIColor.white
        satisfyLabel.frame = CGRect(x:20 *  DeviceManager.sharedInstance.widthRatio, y: 360 *  DeviceManager.sharedInstance.heightRatio, width: 100 *  DeviceManager.sharedInstance.widthRatio,  height: 30 *  DeviceManager.sharedInstance.heightRatio)
        satisfyLabel.font = UIFont(name: "NanumBarunGothicBold", size: 16 *  DeviceManager.sharedInstance.heightRatio)
        satisfyLabel.text = "혜택 만족도"
        satisfyLabel.textAlignment = .center
        satisfyLabel.layer.borderWidth = 0.1
        satisfyLabel.layer.cornerRadius = 13 * DeviceManager.sharedInstance.heightRatio
        reviewGradeView.addSubview(satisfyLabel)
        
        //신청복잡도
        var goodLabel = UILabel()
        //nameUI.backgroundColor = UIColor.white
        goodLabel.frame = CGRect(x:40 *  DeviceManager.sharedInstance.widthRatio, y: 400 *  DeviceManager.sharedInstance.heightRatio, width: 120 *  DeviceManager.sharedInstance.widthRatio,  height: 30 *  DeviceManager.sharedInstance.heightRatio)
        goodLabel.font = UIFont(name: "NanumBarunGothicBold", size: 12 *  DeviceManager.sharedInstance.heightRatio)
        goodLabel.text = "혜택이 도움됬어요"
        goodLabel.textAlignment = .left
        
        reviewGradeView.addSubview(goodLabel)
        
        let goodPv: UIProgressView = UIProgressView(frame: CGRect(x:220 *  DeviceManager.sharedInstance.widthRatio, y:415 *  DeviceManager.sharedInstance.heightRatio, width:100  *  DeviceManager.sharedInstance.widthRatio, height:30 *  DeviceManager.sharedInstance.heightRatio))
        goodPv.progressTintColor = UIColor(displayP3Red:238/255,green : 47/255, blue : 67/255, alpha: 1)
        goodPv.trackTintColor = UIColor.lightGray
        // Set the coordinates.
        goodPv.layer.position = CGPoint(x: 220 *  DeviceManager.sharedInstance.widthRatio, y: 415 *  DeviceManager.sharedInstance.heightRatio)
        // Set the height of the bar (1.0 times horizontally, 2.0 times vertically).
        goodPv.transform = CGAffineTransform(scaleX: 1.0, y: 2.0)
        // Set the progress degree (0.0 to 1.0).
        goodPv.progress = 0.0 // Add an animation.
        goodPv.setProgress(Float(helpRatio), animated: true)
        reviewGradeView.addSubview(goodPv)
        
        var badLabel = UILabel()
        //nameUI.backgroundColor = UIColor.white
        badLabel.frame = CGRect(x:40 *  DeviceManager.sharedInstance.widthRatio, y: 440 *  DeviceManager.sharedInstance.heightRatio, width: 120 *  DeviceManager.sharedInstance.widthRatio,  height: 30 *  DeviceManager.sharedInstance.heightRatio)
        badLabel.font = UIFont(name: "NanumBarunGothicBold", size: 12 *  DeviceManager.sharedInstance.heightRatio)
        badLabel.text = "별로 도움이 안됬어요"
        badLabel.textAlignment = .left
        
        reviewGradeView.addSubview(badLabel)
        
        let  badPv: UIProgressView = UIProgressView(frame: CGRect(x:220 *  DeviceManager.sharedInstance.widthRatio, y:455 *  DeviceManager.sharedInstance.heightRatio, width:100  *  DeviceManager.sharedInstance.widthRatio, height:30 *  DeviceManager.sharedInstance.heightRatio))
        badPv.progressTintColor = UIColor(displayP3Red:238/255,green : 47/255, blue : 67/255, alpha: 1)
        badPv.trackTintColor = UIColor.lightGray
        // Set the coordinates.
        badPv.layer.position = CGPoint(x: 220 *  DeviceManager.sharedInstance.widthRatio, y: 455 *  DeviceManager.sharedInstance.heightRatio)
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
    
   
    
    
    
    //리뷰 테이블 세팅
    func setReview(){
        print("리뷰셋팅")
        print("리뷰셋팅 시 혜택 아이디\(welf_id)")
        
        //이중 스크롤 문제 기존 스크롤뷰를 중지
        //리뷰 파싱
        //리뷰데이터를 받아온다.
        //결과페이지에 사용할 데이터를 서버로부터 받아온다.
        
        
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
                            m_Scrollview.contentSize = CGSize(width: DeviceManager.sharedInstance.width, height: 1800)

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
                                
                                print("도움변수 : \(resultList.Review_stats[i].help)")
                                helpRatio = Double(resultList.Review_stats[i].help)/Double(resultList.Review_stats[i].total_user)
                                print("도움됨 : \(Double(resultList.Review_stats[i].help)/Double(resultList.Review_stats[i].total_user))")

                                helpLessRatio = Double(resultList.Review_stats[i].helf_not)/Double(resultList.Review_stats[i].total_user)
                                print("도움안됨 : \(Double(resultList.Review_stats[i].helf_not)/Double(resultList.Review_stats[i].total_user))")

                                
                                
                            }

                            //점수 분포도
                            for i in 0..<5{
                                
                                
                                pv = UIProgressView(frame: CGRect(x:280 * DeviceManager.sharedInstance.widthRatio, y:CGFloat(((i * 30 ) + 50)) * DeviceManager.sharedInstance.heightRatio, width:100 * DeviceManager.sharedInstance.widthRatio, height:20 * DeviceManager.sharedInstance.heightRatio))
                                
                                pv.progressTintColor = UIColor(displayP3Red:238/255,green : 47/255, blue : 67/255, alpha: 1)
                                pv.trackTintColor = UIColor.lightGray
                                // Set the coordinates.
                                pv.layer.position = CGPoint(x: 280, y: (i * 30 ) + 50)
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
                                gradeLabel.frame = CGRect(x:190 *  DeviceManager.sharedInstance.widthRatio, y: (CGFloat(i) * 30 ) + 40 *  DeviceManager.sharedInstance.heightRatio, width: 30,  height: 20 *  DeviceManager.sharedInstance.heightRatio)
                                gradeLabel.font = UIFont(name: "NanumBarunGothicBold", size: 20 *  DeviceManager.sharedInstance.heightRatio)
                                gradeLabel.text = "\(i+1)점"
                                gradeLabel.textAlignment = .left
                                reviewGradeView.addSubview(gradeLabel)

                                
                            }
                            
                            reviewInfo(grade: grade,oneRatio: oneRatio,twoRatio: twoRatio,threeRatio: threeRatio,fourRatio: fourRatio,fiveRatio: fiveRatio,easyRatio: easyRatio,hardRatio: hardRatio,helpRatio: helpRatio,helpLessRatio: helpLessRatio)

                            reViewTbView = UITableView(frame: CGRect(x: 20 *  DeviceManager.sharedInstance.widthRatio, y: 1170 *  DeviceManager.sharedInstance.heightRatio , width: DeviceManager.sharedInstance.width - (40 *  DeviceManager.sharedInstance.widthRatio), height: 522 *  DeviceManager.sharedInstance.heightRatio))
                            reViewTbView.layer.cornerRadius = 33
                            reViewTbView.tag = 22
                          
                            //reViewTbView.separatorStyle = UITableViewCell.SeparatorStyle.none
                            //커스텀 테이블뷰를 등록
                            //myTableView.register(UITableViewCell.self, forCellReuseIdentifier: "MyCell")
                            
                            
                            reViewTbView.register(NewReview.self, forCellReuseIdentifier: NewReview.identifier)
                            reViewTbView.register(NewModdableReview.self, forCellReuseIdentifier: NewModdableReview.identifier)
                            
                     
                            
                            reViewTbView.dataSource = self
                            reViewTbView.delegate = self
                            if(resultList.Message!.count > 0){

                         
                            self.m_Scrollview.addSubview(reViewTbView)
                            self.reViewTbView.reloadData()
                            
                            
                            //리뷰가 0개인 경우
                            }
                            
                            
                            
                            
                        }else{
                            m_Scrollview.contentSize = CGSize(width: DeviceManager.sharedInstance.width, height: 900 *  DeviceManager.sharedInstance.heightRatio)
                            print("리뷰 0 개")
                            let reviewLabel = UILabel()
                            //reviewLabel.backgroundColor = UIColor.white
                            reviewLabel.frame = CGRect(x: 20 *  DeviceManager.sharedInstance.widthRatio, y: 590 *  DeviceManager.sharedInstance.heightRatio, width: DeviceManager.sharedInstance.width - (20 *  DeviceManager.sharedInstance.widthRatio), height: 30 *  DeviceManager.sharedInstance.heightRatio)
                            reviewLabel.text = "아직 리뷰가 없습니다."
                            reviewLabel.font = UIFont(name: "Jalnan", size: 19 *  DeviceManager.sharedInstance.heightRatio)
                            reviewLabel.tag = 31
                            self.m_Scrollview.addSubview(reviewLabel)

                            
                            let writeBtn = UIButton(type: .system)
                            
                            
                            writeBtn.frame = CGRect(x:40 * DeviceManager.sharedInstance.widthRatio, y: 700, width: DeviceManager.sharedInstance.width - (80 * DeviceManager.sharedInstance.widthRatio), height: 60)
                            
                            writeBtn.layer.borderWidth = 1
                            writeBtn.tag = 32

                            writeBtn.addTarget(self, action: #selector(self.write), for: .touchUpInside)
                            
                            writeBtn.setTitle("첫 리뷰 쓰기", for: .normal)
                            writeBtn.layer.cornerRadius = 13
                            writeBtn.backgroundColor = UIColor(displayP3Red:238/255,green : 47/255, blue : 67/255, alpha: 1)
                            writeBtn.layer.borderColor = UIColor(displayP3Red:238/255,green : 47/255, blue : 67/255, alpha: 1).cgColor
                            writeBtn.setTitleColor(UIColor.white, for: .normal)
                            writeBtn.titleLabel!.font = UIFont(name: "Jalnan", size:20)
                            
                            self.m_Scrollview.addSubview(writeBtn)

                            
                            
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
    
    //테이블뷰 총 섹션 숫자
    func numberOfSections(in tableView: UITableView) -> Int { return 1 }
    //셀 클릭이벤트
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    //테이블 셀 크기 조정
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
    //색션별 행 숫자
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviewItems.count
   
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if(UserDefaults.standard.string(forKey: "nickName") != nil){
        cellCase = UserDefaults.standard.string(forKey: "nickName")!
        }
        print("사용자 : \(cellCase)")
        print("아이템 닉네임 : \(self.reviewItems[indexPath.row].writer)")

        //별점
        var grade : Int = Int(reviewItems[indexPath.row].star_count)!
        
        switch cellCase {
        //1.이미지가 있고, 작성자인경우
        
//        let cell = tableView.dequeueReusableCell(withIdentifier: "NewReview") as! NewReview
//
//        cell.content.text = self.reviewItems[indexPath.row].content
//        cell.nickName.text = self.reviewItems[indexPath.row].writer
        
        
        //자신이 작성한 리뷰인 경우
        case self.reviewItems[indexPath.row].writer:
            print("사용자가 작성하 리뷰 \(indexPath.row)")

            //리뷰 중복 작성이 안되게끔 한다.
            ableWrie = false
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "NewModdableReview") as! NewModdableReview
            
            cell.content.text = self.reviewItems[indexPath.row].content
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
                
                
                starImgView.frame = CGRect(x:30 * DeviceManager.sharedInstance.widthRatio * CGFloat(i), y: 0 *  DeviceManager.sharedInstance.heightRatio, width: 20  * DeviceManager.sharedInstance.widthRatio,  height: 20 *  DeviceManager.sharedInstance.heightRatio)
           starImgView.image = starImgView.image?.withRenderingMode(.alwaysOriginal)
                starImgView.tintColor = UIColor(displayP3Red:238/255,green : 47/255, blue : 67/255, alpha: 1)

                cell.gradeView.addSubview(starImgView)
           }
        
            //별점
            for i in grade..<5 {
           let starImg = UIImage(named: "star_off")
           var starImgView = UIImageView()
           starImgView.setImage(starImg!)
                starImgView.frame = CGRect(x:30 * DeviceManager.sharedInstance.widthRatio * CGFloat(i), y: 0 *  DeviceManager.sharedInstance.heightRatio, width: 20  * DeviceManager.sharedInstance.widthRatio,  height: 20 *  DeviceManager.sharedInstance.heightRatio)
           starImgView.image = starImgView.image?.withRenderingMode(.alwaysOriginal)
                starImgView.tintColor = UIColor.gray

                cell.gradeView.addSubview(starImgView)
           }
        
            
            
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
        
            
            return cell
            
            

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
     
                           
                                self.menu(self.buttons[0])
      

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
    
    
 
    
   //클래스 종료
}
