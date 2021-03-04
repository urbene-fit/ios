//  mapTestViewController.swift
//  welfare
//
//  Created by 김동현 on 2020/11/25.
//  Copyright © 2020 com. All rights reserved.

import UIKit
import CoreLocation
import MapKit
import Alamofire


class mapTestViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate , UISearchBarDelegate, UITabBarControllerDelegate {
    
    //로그 보낼떄 화면을 알려주는 변수
    var type : String = "map"
    
    private var observer: NSObjectProtocol?
    
    struct areaCounts : Decodable {
        let areaCount : [areaCount]
    }
    
    //지역별 정책숫자를 받아와 파싱할 구조체
    struct areaCount : Decodable {
        let local: String
        let welf_count: Int
    }
    
    struct parse: Decodable {
        let Status : String
        //반환값이 없을떄 처리
        let Message : [areaCount]
    }
    
    //데이터 파싱
    struct SearchList: Decodable {
        var welf_name : String
        // var welf_local : String
        var parent_category : String
        var welf_category : String
        var tag : String
    }
    
    struct searchParse: Decodable {
        let Status : String
        
        //반환값이 없을떄 처리
        let Message : [SearchList]
    }
    
    struct Parse: Decodable {
        let Status : String
    }
    
    //네비게이션 바 변수
    let navBar = UINavigationBar()
    
    //검색창 바
    let searchBar = UISearchBar()
    
    //현재 지역을 저장하는 변수
    var city = String()
    
    //지역별 위치를 표시할 좌표값
    struct cityXY {
        var cityName: String
        var cityX: Int
        var cityY: Int
    }
    
    var cityXYs = [cityXY]()
    
    let titleLabel = UILabel()
    
    //상단에 지역을 표시하는 라벨
    let areaLabel = UILabel()
    
    //지역을 변경하는 화면으로 이동하게 하는 버튼
    let areaMoveBtn = UIButton()
    
    //지역의 정책갯수
    var count : Int = 0
    var local : String = ""
    
    //효과를 줄 원형 이미지
    weak var mask: CAShapeLayer?
    
    let imgView = UIImageView()
    
    var myMap =  MKMapView()
    
    struct MapGridData {
        let re = 6371.00877    // 사용할 지구반경  [ km ]
        let grid = 5.0         // 사용할 지구반경  [ km ]
        let slat1 = 30.0       // 표준위도       [degree]
        let slat2 = 60.0       // 표준위도       [degree]
        let olon = 126.0       // 기준점의 경도   [degree]
        let olat = 38.0        // 기준점의 위도   [degree]
        let xo = 42.0          // 기준점의 X좌표  [격자거리] // 210.0 / grid
        let yo = 135.0         // 기준점의 Y좌표  [격자거리] // 675.0 / grid
    }
    
    // ???
    class LocationConverter {
        let map: MapGridData = MapGridData()
        
        let PI: Double = .pi
        let DEGRAD: Double = .pi / 180.0
        let RADDEG: Double = 180.0 / .pi
        
        var re: Double
        var slat1: Double
        var slat2: Double
        var olon: Double
        var olat: Double
        var sn: Double
        var sf: Double
        var ro: Double
        
        init() {
            re = map.re / map.grid
            slat1 = map.slat1 * DEGRAD
            slat2 = map.slat2 * DEGRAD
            olon = map.olon * DEGRAD
            olat = map.olat * DEGRAD
            
            sn = tan(PI * 0.25 + slat2 * 0.5) / tan(PI * 0.25 + slat1 * 0.5)
            sn = log(cos(slat1) / cos(slat2)) / log(sn)
            sf = tan(PI * 0.25 + slat1 * 0.5)
            sf = pow(sf, sn) * cos(slat1) / sn
            ro = tan(PI * 0.25 + olat * 0.5)
            ro = re * sf / pow(ro, sn)
        }
        
        func convertGrid(lon: Double, lat: Double) -> (Int, Int) {
            
            var ra: Double = tan(PI * 0.25 + lat * DEGRAD * 0.5)
            ra = re * sf / pow(ra, sn)
            var theta: Double = lon * DEGRAD - olon
            
            if theta > PI {
                theta -= 2.0 * PI
            }
            
            if theta < -PI {
                theta += 2.0 * PI
            }
            
            theta *= sn
            
            let x: Double = ra * sin(theta) + map.xo
            let y: Double = ro - ra * cos(theta) + map.yo
            
            return (Int(x + 1.5), Int(y + 1.5))
        }
    }
    
    // CLLocationManager: 위치정보 권한 요청을 해주는 객체, lazy: 처음 사용되기 전까지는 연산이 되지 않는다는 것?
    lazy var locationManager: CLLocationManager = {
        debugPrint("locationManager: 클로저 함수 실행")
        
        // //locationManager 인스턴스 생성 및 델리게이트 생성
        let manager = CLLocationManager()
        manager.delegate = self
        
        // 위치정보 권한 설정 확인
        switch CLLocationManager.authorizationStatus() {
        case .authorizedAlways, .authorizedWhenInUse:
            print("GPS: 권한 있음")
        case .restricted, .notDetermined:
            print("GPS: 아직 선택하지 않음")
            
            //포그라운드 상태에서 위치 추적 권한 요청
            manager.requestWhenInUseAuthorization()
        case .denied:
            print("GPS: 권한 없음")
            
            //Alert 생성 후 액션 연결
            let alertController = UIAlertController(title: "위치권한이 '허용' 되어 있지 않습니다.", message: "앱 설정 화면으로 이동하시겠습니까?", preferredStyle: .alert)
            
            alertController.addAction(UIAlertAction(title: "네", style: .default, handler: { (action) -> Void in
                debugPrint("네 touched..")
                if let appSettings = URL(string: UIApplication.openSettingsURLString){
                    UIApplication.shared.open(appSettings, options: [:], completionHandler: nil)
                }
            }))
            
            alertController.addAction(UIAlertAction(title: "아니오", style: .destructive, handler: { (action) -> Void in
                debugPrint("아니오 touched..")
            }))
            
            self.present(alertController, animated: true, completion: nil)
            
        default:
            print("GPS: Default")
        }
        
        
        //배터리에 맞게 권장되는 최적의 정확도
        manager.desiredAccuracy = kCLLocationAccuracyBest
        
        
        manager.distanceFilter = kCLHeadingFilterNone
        
        
        return manager
    }()
    
    var start: CFTimeInterval!          // when the animationㅌ was started
    let duration: CFTimeInterval = 0.5  // how long will the animation take
    
    //지역버튼들을 관리하는 배열
    var buttons = [UIButton]()
    
    //인치별 높이비율 수치
    var heightRatio : CGFloat = 0
    
    //서버에서 사용하는 지역명
    var localList = ["서울", "부산", "대구","인천", "광주", "대전", "울산","세종", "경기", "강원", "충북", "충남", "전북", "전남", "경북", "경남", "제주"]
    
    
    // viewDidLoad: 뷰의 컨트롤러가 메모리에 로드되고 난 후에 호출, 화면이 처음 만들어질 때 한 번만 실행, 일반적으로 리소스를 초기화하거나 초기 화면을 구성하는 용도로 주로 사용
    override func viewDidLoad() {
        super.viewDidLoad()
        debugPrint("map - viewDidLoad 실행", "화면비율\(DeviceManager.sharedInstance.heightRatio)")
        
        // Observer 등록, 알림 정보 수정하고 올 경우 실행하기위해 등록
        // UIApplication.willEnterForegroundNotification 가 나타나기 직전에 알려줘라,object는 어떤객체를 전달할지, queue는 스레드 using은 수행할 로직.
        observer = NotificationCenter.default.addObserver(forName: UIApplication.willEnterForegroundNotification, object: nil, queue: .main) {
            
            // unowned self: 순환 참조를 해결할 수 있는 방법, unowned self는 옵셔널이 아니기 때문에 힙에 있지 않는다면 crash가 발생
            [unowned self] notification in
            debugPrint("map - 개인정보 foreground로 돌아오는 경우 ")
            
            // 위치정보 권한 설정 확인
            switch CLLocationManager.authorizationStatus() {
            case .authorizedAlways, .authorizedWhenInUse:
                print("GPS: 권한 있음")
            case .restricted, .notDetermined:
                print("GPS: 아직 선택하지 않음")
            case .denied:
                print("GPS: 권한 없음")
            default:
                print("GPS: Default")
            }
        }
        
        // Observer 등록, 사용자가 어떤 페이지에서 이탈하지는 체크하기위해, 백그라운드 진입시 로그를 보낸다.
        // UIApplication.willEnterForegroundNotification 가 나타나기 직전에 알려줘라,object는 어떤객체를 전달할지, queue는 스레드 using은 수행할 로직.
        observer = NotificationCenter.default.addObserver(forName: UIApplication.didEnterBackgroundNotification, object: nil, queue: .main) {
            [unowned self] notification in
            debugPrint("지도화면에서 백그라운드로 진입")
            // DeviceManager.sharedInstance.sendLog(content: "지도화면에서 종료", type: type)
        }
        
        
        // 디바이스 크기 조회
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
        
        // 배경화면 색 지정
        self.view.backgroundColor = UIColor.white
        
        // 화면에 보여줄 지역 UI 생성
        setCity()
        
        // 레이아웃 생성
        setLayout()
    }
    
    
    // viewWillAppear: 뷰가 나타나기 직전에 호출, 다른뷰에서 갔다가 다시 돌아오는 상황에 해주고 싶은 처리 용도로 사용
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        debugPrint("map - viewWillAppear 실행")
    }
    
    
    // viewDidAppear: 뷰가 화면에 나타난 직후에 실행, 화면에 적용될 애니메이션을 그려줌, 네비게이션 컨트롤러 변경
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        debugPrint("map - viewDidAppear 실행")
        
        // 네비게이션 UI 생성
        setBarButton()
    }
    
    
    // viewWillDisappear: 뷰가 사라지기 직전에 호출되는 함수인데요, 뷰가 삭제 되려고하고있는 것을 뷰 콘트롤러에 통지
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        debugPrint("map - viewWillDisappear 실행")
    }
    
    
    // viewDidDisappear: 뷰 컨트롤러가 뷰가 제거되었음을 알려줌
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        debugPrint("map - viewDidDisappear 실행")
    }
    
    
    // 네비게이션 UI 생성
    private func setBarButton() {
        debugPrint("map - setBarButton 실행")
        
        self.navigationController?.navigationBar.topItem?.titleView = nil
        self.navigationController?.navigationBar.shadowImage = nil
        self.navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        
        
        let naviLabel = UILabel()
        naviLabel.frame = CGRect(x: 63.8  *  DeviceManager.sharedInstance.widthRatio, y: 235.4 *  DeviceManager.sharedInstance.heightRatio, width: 118 *  DeviceManager.sharedInstance.widthRatio, height: 17.3 *  DeviceManager.sharedInstance.heightRatio)
        naviLabel.textAlignment = .center
        naviLabel.textColor = UIColor(displayP3Red:238/255,green : 47/255, blue : 67/255, alpha: 1)
        
        naviLabel.text = "UrBene_Fit"
        naviLabel.font = UIFont(name: "Bowhouse-Black", size: 30  *  DeviceManager.sharedInstance.heightRatio)
        self.navigationController?.navigationBar.topItem?.titleView = naviLabel
    }
    
    
    // 화면에 보여줄 지역 UI 생성
    func setCity(){
        debugPrint("setCity 실행 - 화면에 보여줄 지역 UI 생성")
        cityXYs.append(cityXY.init(cityName: "전국", cityX: Int(CGFloat(20 *  DeviceManager.sharedInstance.widthRatio)), cityY: Int(110 *  heightRatio)))
        cityXYs.append(cityXY.init(cityName: "강원", cityX: Int(230 *  DeviceManager.sharedInstance.widthRatio), cityY: Int(220 *  heightRatio)))
        cityXYs.append(cityXY.init(cityName: "경기", cityX: Int(140 *  DeviceManager.sharedInstance.widthRatio), cityY: Int(270 *  heightRatio)))
        cityXYs.append(cityXY.init(cityName: "경남", cityX: Int(230 *  DeviceManager.sharedInstance.widthRatio), cityY: Int(460 *  heightRatio)))
        cityXYs.append(cityXY.init(cityName: "경북", cityX: Int(270 *  DeviceManager.sharedInstance.widthRatio), cityY: Int(320 *  heightRatio)))
        cityXYs.append(cityXY.init(cityName: "광주", cityX: Int(100 *  DeviceManager.sharedInstance.widthRatio), cityY: Int(480 *  heightRatio)))
        cityXYs.append(cityXY.init(cityName: "대구", cityX: Int(240 *  DeviceManager.sharedInstance.widthRatio), cityY: Int(400 *  heightRatio)))
        cityXYs.append(cityXY.init(cityName: "대전", cityX: Int(140 *  DeviceManager.sharedInstance.widthRatio), cityY: Int(340 *  heightRatio)))
        cityXYs.append(cityXY.init(cityName: "부산", cityX: Int(300 *  DeviceManager.sharedInstance.widthRatio), cityY: Int(480 *  heightRatio)))
        cityXYs.append(cityXY.init(cityName: "서울", cityX: Int(100 *  DeviceManager.sharedInstance.widthRatio), cityY: Int(210 *  heightRatio)))
        cityXYs.append(cityXY.init(cityName: "세종", cityX: Int(110 *  DeviceManager.sharedInstance.widthRatio), cityY: Int(320 *  heightRatio)))
        cityXYs.append(cityXY.init(cityName: "울산", cityX: Int(310 *  DeviceManager.sharedInstance.widthRatio), cityY: Int(430 *  heightRatio)))
        cityXYs.append(cityXY.init(cityName: "인천", cityX: Int(40 *  DeviceManager.sharedInstance.widthRatio), cityY: Int(210 *  heightRatio)))
        cityXYs.append(cityXY.init(cityName: "전남", cityX: Int(120 *  DeviceManager.sharedInstance.widthRatio), cityY: Int(530 *  heightRatio)))
        cityXYs.append(cityXY.init(cityName: "전북", cityX: Int(120 *  DeviceManager.sharedInstance.widthRatio), cityY: Int(415 *  heightRatio)))
        cityXYs.append(cityXY.init(cityName: "충북", cityX: Int(170 *  DeviceManager.sharedInstance.widthRatio), cityY: Int(300 *  heightRatio)))
        cityXYs.append(cityXY.init(cityName: "충남", cityX: Int(50 *  DeviceManager.sharedInstance.widthRatio), cityY: Int(330 *  heightRatio)))
        cityXYs.append(cityXY.init(cityName: "제주", cityX: Int(60 *  DeviceManager.sharedInstance.widthRatio), cityY: Int(580 *  heightRatio)))
    }
    
    
    // 레이아웃 UI 생성
    func setLayout(){
        debugPrint("map - setLayout 실행")
        
        // 지도 UI - 지도 이미지
        let img = UIImage(named: "newMap")
        imgView.setImage(img!)
        imgView.frame = CGRect(x: 0, y: 140 *  DeviceManager.sharedInstance.heightRatio, width: DeviceManager.sharedInstance.width, height: 550 *  heightRatio)
        self.view.addSubview(imgView)
        
        // 위치 업데이트를 시작
        locationManager.startUpdatingLocation()
        
        
        //테이블뷰 상단에 위치하여 몇개의 정첵이 있는지 보여주는 뷰
        let discriptionView = UIView()
        discriptionView.frame = CGRect(x: 0, y: CGFloat(751 * heightRatio), width: DeviceManager.sharedInstance.width, height: (60 * heightRatio))
        discriptionView.backgroundColor = UIColor(displayP3Red:238/255,green : 47/255, blue : 67/255, alpha: 1)
        
        
        //라벨
        titleLabel.font = UIFont(name: "Jalnan", size: 17  *  heightRatio)
        titleLabel.textColor = UIColor.white
        titleLabel.frame = CGRect(x: 20  *  DeviceManager.sharedInstance.widthRatio, y: 5 *  heightRatio, width: 220 *  DeviceManager.sharedInstance.widthRatio, height: 50 *  heightRatio)
        titleLabel.textAlignment = .left
        discriptionView.addSubview(titleLabel)
        
        
        // 내 주변혜택 보기 버튼
        let viewBtn = UIButton()
        viewBtn.frame = CGRect(x: DeviceManager.sharedInstance.width - (200 *  DeviceManager.sharedInstance.widthRatio), y: 700 *  DeviceManager.sharedInstance.heightRatio, width: 200 *  DeviceManager.sharedInstance.widthRatio, height: 50 *  heightRatio)
        viewBtn.setTitle("내 주변혜택 보기", for: .normal)
        viewBtn.titleLabel!.font = UIFont(name: "Jalnan", size:14.7 *  heightRatio)
        viewBtn.setTitleColor(UIColor.white, for: .normal)
        viewBtn.backgroundColor =  UIColor(displayP3Red:238/255,green : 47/255, blue : 67/255, alpha: 1)
        viewBtn.layer.cornerRadius = 23
        viewBtn.layer.borderWidth = 1.3
        viewBtn.layer.borderColor = UIColor.white.cgColor
        viewBtn.addTarget(self, action: #selector(self.moveList), for: .touchUpInside)
        viewBtn.layer.shadowColor = UIColor.black.cgColor
        viewBtn.layer.shadowOffset = CGSize(width: 5 *  DeviceManager.sharedInstance.widthRatio, height: 5 *  heightRatio) // 반경에 대해서 너무 적용이 되어서 4point 정도 ㅐ림.
        viewBtn.layer.shadowOpacity = 1
        viewBtn.layer.shadowRadius = 1 // 반경?
        viewBtn.layer.shadowOpacity = 0.5 // alpha값입니다.
        self.view.addSubview(viewBtn)
    }
    
    
    // 위치정보 권한이 허용일 경우 실행, 위치 업데이트, 위치 정보에서 국가, 지역, 도로를 추출하여 레이블에 표시
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        debugPrint("map - locationManager호출")
        
        
        // locations라는 배열로 현재 위치를 가져온다.
        let pLocation = locations.last
        
        // 위도, 경도, 국가 정보 설정
        let lat :CLLocationDegrees = (pLocation?.coordinate.latitude)!
        let long : CLLocationDegrees = (pLocation?.coordinate.longitude)!
        let findLocation: CLLocation = CLLocation(latitude: lat, longitude: long)
        let geoCoder: CLGeocoder = CLGeocoder()
        let local: Locale = Locale(identifier: "Ko-kr") // Korea
        
        // geoCoder로 주소를 읽어 온다. address.last?. 뒤에 옵션으로 주소 범위를 지정할 수 있다.
        geoCoder.reverseGeocodeLocation(findLocation, preferredLocale: local) { [self] (place, error) in
            if let address: [CLPlacemark] = place {
                
                city = (address.last?.administrativeArea!)!
                
                //지역명을 앞에 2글자까지만 남겨준다.
                let endIdx: String.Index = city.index(city.startIndex, offsetBy: 1)
                city = String(city[...endIdx])
                
                // debugPrint("자른후:\(city)")
                self.local = city
                
                // 지역표시
                self.areaLabel.text = address.last?.locality!
                
                
                //해당지역의 정책갯수를 서버로부터 받아온다.
                let parameters = ["local": city, "page_number": "1"]
                
                Alamofire.request("https://www.urbene-fit.com/map", method: .get, parameters: parameters)
                    .validate()
                    .responseJSON { [self] response in
                        
                        switch response.result {
                        case .success(let value):
                            debugPrint("지역명 : \(city)")
                            debugPrint("지도 결과")
                            
                            do {
                                let data = try JSONSerialization.data(withJSONObject: value, options: .prettyPrinted)
                                let areaLists = try JSONDecoder().decode(parse.self, from: data)
                                
                                if(areaLists.Status == "200"){
                                    // print("로컬에서 처리 지역 갯수: \( self.cityXYs.count)개 >")
                                    // print("지역갯수: \(areaLists.count)개 >")
                                    
                                    for i in 0..<areaLists.Message.count {
                                        
                                        if(city.contains(areaLists.Message[i].local)){
                                            self.count = areaLists.Message[i].welf_count
                                            self.titleLabel.text = "내 주변 혜택보기 \(areaLists.Message[i].welf_count)개 >"
                                            // debugPrint("지역갯수 : \(areaLists.Message[i].welf_count)")
                                        }
                                        
                                        
                                        //버튼으로 지역이 클릭가능하게 끔 수정
                                        let button = UIButton(type: .system)
                                        
                                        //위치를 지역이름과 비교후 추가
                                        for k in 0..<cityXYs.count{
                                            if(areaLists.Message[i].local == cityXYs[k].cityName){
                                                button.frame = CGRect(x: self.cityXYs[k].cityX, y: self.cityXYs[k].cityY, width:  Int(55  *  DeviceManager.sharedInstance.widthRatio), height: Int(55  *  heightRatio))
                                                button.tag = k
                                                button.backgroundColor = UIColor(red: 1, green: 0.2739933722, blue: 0.9001957098, alpha: 0.3)                                
                                                button.layer.cornerRadius = button.frame.height/2
                                                button.layer.borderWidth = 1
                                                button.layer.borderColor = UIColor.clear.cgColor
                                                button.clipsToBounds = true
                                                //지역을 클릭했을때 지역의 혜택리스트를 보여주는 페이지로 이동하는 메소드 추가
                                                button.addTarget(self, action: #selector(self.selected), for: .touchUpInside)
                                                //버튼을 구분할 수 있게 태그넘버를 지정해주고 버튼배열에 관리한다.
                                                
                                                
                                                let infoLabel = UILabel()
                                                infoLabel.frame = CGRect(x: 0, y: 0, width: 58  *  DeviceManager.sharedInstance.widthRatio, height: 58  *  heightRatio)
                                                infoLabel.numberOfLines = 2
                                                infoLabel.textAlignment = .center
                                                infoLabel.text = "\(areaLists.Message[i].local)\n(\(areaLists.Message[i].welf_count))"
                                                infoLabel.font = UIFont(name: "Jalnan", size: 11  *  heightRatio)
                                                button.addSubview(infoLabel)
                                                
                                                if(areaLists.Message[i].local != "전국"){
                                                    self.view.addSubview(button)
                                                }
                                                buttons.append(button)
                                            }
                                        }
                                    }
                                }
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
                            debugPrint("Error: \(error)")
                            break
                        }
                    }
                
                
                //지역명과 정책수를 알려준다.
                let infoLabel = UILabel()
                infoLabel.frame = CGRect(x: 0, y: 25 *  heightRatio, width: 100 *  DeviceManager.sharedInstance.widthRatio, height: 50 *  heightRatio)
                infoLabel.textAlignment = .center
                infoLabel.numberOfLines = 2
                
                
                //폰트지정 추가
                infoLabel.text = "\(self.city)\n 정책 231개"
                infoLabel.font = UIFont(name: "Jalnan", size: 13  *  heightRatio)
                debugPrint(self.city)
            }
        }
        
        // 코드가 더 이상 위치 관련 이벤트를 수신 할 필요가 없을 때마다이 메서드를 호출합니다. 이벤트 전달을 비활성화하면 클라이언트가 위치 데이터를 필요로하지 않을 때 수신기가 적절한 하드웨어를 비활성화하여 전력을 절약 할 수있는 옵션을 제공
        // 이 코드 지우면 지도에 지역 정보 표시 안됨
        locationManager.stopUpdatingLocation()
    }
    
    
    // 원은 왜 그릴까?
    private func updatePath(percent: CGFloat) {
        debugPrint("원 그리기")
        let center = CGPoint(x: 20,  y: 20)
        // let startRadius = min(imgView.bounds.width, imgView.bounds.height) * 0.4
        
        let startRadius = min(20, 20) * 0.4
        // start radius is 40% of smallest dimension
        let endRadius = hypot(20, 20) * 0.5  // stop radius is the distance from the center to the corner of the image view
        let radius = startRadius + (endRadius - startRadius) * Double(percent)                // given percent done, what is the radius
        
        mask?.path = UIBezierPath(arcCenter: center, radius: CGFloat(radius), startAngle: 0, endAngle: .pi * 2, clockwise: true).cgPath
    }
    
    
    // 지역혜택 리스트를 보여주는 페이지로 이동
    @objc func moveList(_ sender: UIButton) {
        debugPrint("지역혜택 리스트를 보여주는 페이지로 이동")
        DeviceManager.sharedInstance.sendLog(content: "혜택지도 결괴페이지로 이동", type: type)
        
        
        let params = ["page_number":"2", "local":"경기", "userAgent" : DeviceManager.sharedInstance.log]
        
        Alamofire.request("https://www.urbene-fit.com/map", method: .get, parameters: params)
            .validate()
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    
                    //상세페이지로 카테고리선택결과 데이터를  전달하기 위해 상세페이지 객체를 선언
                    do {
                        let data = try JSONSerialization.data(withJSONObject: value, options: .prettyPrinted)
                        let parseResult = try JSONDecoder().decode(Parse.self, from: data)
                        
                        guard let RVC = self.storyboard?.instantiateViewController(withIdentifier: "NewResultView") as? NewResultView else{
                            return
                        }
                        
                        
                        if(parseResult.Status == "200"){
                            debugPrint(parseResult.Status)
                            let parseResult = try JSONDecoder().decode(searchParse.self, from: data)
                            for i in 0..<parseResult.Message.count {
                                
                                let tag = parseResult.Message[i].welf_category.replacingOccurrences(of: " ", with: "")
                                let split = tag.components(separatedBy: ";;")
                                
                                RVC.items.append(NewResultView.item.init(welf_name: parseResult.Message[i].welf_name, welf_local: self.local, parent_category: parseResult.Message[i].parent_category, welf_category: split, tag: parseResult.Message[i].tag))
                                
                                //태그 추가
                                for i in 0..<split.count {
                                    if(!RVC.categoryItems.contains(split[i])){
                                        RVC.categoryItems.append(split[i])
                                    }
                                }
                            }
                            
                            
                            //뷰 이동
                            RVC.modalPresentationStyle = .fullScreen
                            
                            
                            // 상세정보 뷰로 이동
                            //self.present(RVC, animated: true, completion: nil)
                            self.navigationController?.pushViewController(RVC, animated: true)
                        } else {
                            debugPrint("Status:",parseResult.Status)
                            
                            let alert = UIAlertController(title: "알림", message: "현재 준비중인 지역입니다.", preferredStyle: .alert)
                            let cancelAction = UIAlertAction(title: "확인", style: .cancel){
                                (action : UIAlertAction) -> Void in
                                alert.dismiss(animated: false)
                            }
                            
                            alert.addAction(cancelAction)
                            self.present(alert, animated: true, completion: nil)
                        }
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
    }
    
    
    // 지역을 클릭했을 경우 지역의 혜택리스트를 보여주는 페이지로 이동하는 메소드
    @objc func selected(_ sender: UIButton) {
        debugPrint("map - 선택한 지역(\(cityXYs[sender.tag].cityName)) 결과 페이지로 이동" )
        
        // 로그 기록
        DeviceManager.sharedInstance.sendLog(content: "혜택지도 결괴페이지로 이동", type: type)
        
        let selected : String = cityXYs[sender.tag].cityName
        let params = ["page_number":"2", "local":selected, "userAgent" : DeviceManager.sharedInstance.log]
        
        Alamofire.request("https://www.urbene-fit.com/map", method: .get, parameters: params)
            .validate()
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    
                    //상세페이지로 카테고리선택결과 데이터를  전달하기 위해 상세페이지 객체를 선언
                    do {
                        let data = try JSONSerialization.data(withJSONObject: value, options: .prettyPrinted)
                        let parseResult = try JSONDecoder().decode(Parse.self, from: data)
                        
                        // instantiateViewController: toryboard 파일로 부터 데이터를 불러와서 view controller를 생성
                        // 이 메소드가 호출될 때마다, init(coder: ) method 를 통해 매번 새로운 view controller 인스턴스를 생성한다
                        guard let RVC = self.storyboard?.instantiateViewController(withIdentifier: "NewResultView") as? NewResultView else{
                            return
                        }
                        
                        switch parseResult.Status {
                        case "200":
                            debugPrint("parseResult.Status:",parseResult.Status)
                            
                            let parseResult = try JSONDecoder().decode(searchParse.self, from: data)
                            
                            for i in 0..<parseResult.Message.count {
                                let tag = parseResult.Message[i].welf_category.replacingOccurrences(of: " ", with: "")
                                let split = tag.components(separatedBy: ";;")
                                
                                // NewResultView 클래스에 있는 items 배열 안에 조회한 혜택 정보들 저장
                                RVC.items.append(NewResultView.item.init(welf_name: parseResult.Message[i].welf_name, welf_local: selected, parent_category: parseResult.Message[i].parent_category, welf_category: split, tag: parseResult.Message[i].tag))
                                
                                // 태그 추가
                                for i in 0..<split.count {
                                    if(!RVC.categoryItems.contains(split[i])){
                                        RVC.categoryItems.append(split[i])
                                    }
                                }
                            }
                            
                            
                            //뷰 이동
                            RVC.modalPresentationStyle = .fullScreen
                            
                            
                            // 상세정보 뷰로 이동
                            //self.present(RVC, animated: true, completion: nil)
                            self.navigationController?.pushViewController(RVC, animated: true)
                        default:
                            debugPrint("parseResult.Status:",parseResult.Status)
                            
                            let alert = UIAlertController(title: "알림", message: "현재 준비중인 지역입니다.", preferredStyle: .alert)
                            
                            let cancelAction = UIAlertAction(title: "확인", style: .cancel){
                                (action : UIAlertAction) -> Void in
                                alert.dismiss(animated: false)
                            }
                            
                            alert.addAction(cancelAction)
                            self.present(alert, animated: true, completion: nil)
                        }
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
    }
}
