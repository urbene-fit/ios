//
//  mapTestViewController.swift
//  welfare
//
//  Created by 김동현 on 2020/11/25.
//  Copyright © 2020 com. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
import Alamofire

class mapTestViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate , UISearchBarDelegate, UITabBarControllerDelegate {
    
    // var areaCounts : [areaCount] = []
    
    //로그 보낼떄 화면을 알려주는 변수
    var type : String = "map"
    
    private var observer: NSObjectProtocol?
    
    
    struct  areaCounts : Decodable {
        let areaCount : [areaCount]
        
    }
    
    //지역별 정책숫자를 받아와 파싱할 구조체
    struct  areaCount : Decodable {
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
        // let Message : String
        
        //반환값이 없을떄 처리
        let Message : [SearchList]
    }
    struct Parse: Decodable {
        let Status : String
        // let Message : String
        
        //반환값이 없을떄 처리
        //  let Message : [SearchList]
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
    
    var tabBarCnt = UITabBarController()
    
    
    let imgView = UIImageView()
    
    //let locationManager = CLLocationManager()
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
    
    lazy var locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.distanceFilter = kCLHeadingFilterNone
        manager.requestWhenInUseAuthorization()
        manager.delegate = self
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
    
    
    
    //네비게이션 컨트롤러 변경
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        print("검색 : viewDidAppear")
        //        DuViewController의 view가 사라짐
        //        ReViewViewController의 view가 화면에 나타남
        setBarButton()
    }
    
    private func setBarButton() {
        print("ReViewViewController의 setBarButton")
        
        
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("화면비율\(DeviceManager.sharedInstance.heightRatio)")
        
        //사용자가 어떤 페이지에서 이탈하지는 체크하기위해, 백그라운드 진입시 로그를 보낸다.
        observer = NotificationCenter.default.addObserver(forName: UIApplication.didEnterBackgroundNotification,
                                                          object: nil,
                                                          queue: .main) {
            [unowned self] notification in
            print("지도화면에서 백그라운드로 진입")
            DeviceManager.sharedInstance.sendLog(content: "지도화면에서 종료", type: type)
            
        }
        
        //self.navigationController?.isNavigationBarHidden = true
        print("맵뷰 시작")
        
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
        
        //지도상의 지역버튼을 표시해주기 위한 메소드
        setCity()
        //레이아웃 셋팅
        setLayout()
        
        //화면 스크롤 크기
        var screenWidth = Int(view.bounds.width)
        var screenHeight = Int(view.bounds.height)
        self.view.backgroundColor = UIColor.white
        
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // update the mask for the image view for the size of the view (which was unknown at `viewDidLoad`, but is known here)
        
        if mask != nil {
            updatePath(percent: 0)
        }
    }
    
    
    //위치 업데이트
    // 위치 정보에서 국가, 지역, 도로를 추출하여 레이블에 표시
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("locationManager호출")
        //로케이션 매니저를 통해 마지막 위치정보를 받아와서
        //지도에 표시해주는 메소드를 호출한다,
        let pLocation = locations.last
        
        
        var lat :CLLocationDegrees = (pLocation?.coordinate.latitude)!
        var long : CLLocationDegrees = (pLocation?.coordinate.longitude)!
        
        
        let converter: LocationConverter = LocationConverter()
        let (x, y): (Int, Int)
            = converter.convertGrid(lon: long, lat: lat)
        
        let findLocation: CLLocation = CLLocation(latitude: lat, longitude: long)
        print("찾은지역: \(findLocation)")
        let geoCoder: CLGeocoder = CLGeocoder()
        let local: Locale = Locale(identifier: "Ko-kr") // Korea
        
        geoCoder.reverseGeocodeLocation(findLocation, preferredLocale: local) { [self] (place, error) in
            if let address: [CLPlacemark] = place {
                print("(longitude, latitude) = (\(x), \(y))")
                print("시(도): \(address.last?.administrativeArea)")
                print("구(군): \(address.last?.locality)")
                
                
                city = (address.last?.administrativeArea!)!
                
                //지역명을 앞에 2글자까지만 남겨준다.
                let endIdx: String.Index = city.index(city.startIndex, offsetBy: 1)
                city = String(city[...endIdx])
                
                print("자른후:\(city)")
                self.local = city
                //지역표시
                self.areaLabel.text = address.last?.locality!
                
                
                //해당지역의 정책갯수를 서버로부터 받아온다.
                let parameters = ["local": city, "page_number": "1"]
                
                Alamofire.request("https://www.urbene-fit.com/map", method: .get, parameters: parameters)
                    .validate()
                    .responseJSON { [self] response in
                        
                        switch response.result {
                        case .success(let value):
                            print("지역명 : \(city)")
                            print("지도 결과")
                            
                            do {
                                let data = try JSONSerialization.data(withJSONObject: value, options: .prettyPrinted)
                                //let areaLists = try JSONDecoder().decode([areaCount].self, from: data)
                                
                                let areaLists = try JSONDecoder().decode(parse.self, from: data)
                                if(areaLists.Status == "200"){
                                    
                                    //                                print("로컬에서 처리 지역 갯수: \( self.cityXYs.count)개 >")
                                    //
                                    //                                print("지역갯수: \(areaLists.count)개 >")
                                    
                                    for i in 0..<areaLists.Message.count {
                                        
                                        if(city.contains(areaLists.Message[i].local)){
                                            self.count = areaLists.Message[i].welf_count
                                            self.titleLabel.text = "내 주변 혜택보기 \(areaLists.Message[i].welf_count)개 >"
                                            print("지역갯수 : \(areaLists.Message[i].welf_count)")
                                            
                                        }
                                        
                                        
                                        print(areaLists.Message[i].local)
                                        print(areaLists.Message[i].welf_count)
                                        
                                        //버튼으로 지역이 클릭가능하게 끔 수정
                                        var button = UIButton(type: .system)
                                        //button.frame = CGRect(x: self.cityXYs[i].cityX, y: self.cityXYs[i].cityY, width:  50, height: 50)
                                        
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
                            print("Error: \(error)")
                            break
                            
                            
                        }
                    }
                
                
                //지역명과 정책수를 알려준다.
                let infoLabel = UILabel()
                infoLabel.frame = CGRect(x: 0, y: 25 *  heightRatio, width: 100 *  DeviceManager.sharedInstance.widthRatio, height: 50 *  heightRatio)
                infoLabel.textAlignment = .center
                infoLabel.numberOfLines = 2
                //infoLabel.textColor = UIColor(displayP3Red: 93/255.0, green: 33/255.0, blue: 210/255.0, alpha: 1)
                //폰트지정 추가
                
                infoLabel.text = "\(self.city)\n 정책 231개"
                infoLabel.font = UIFont(name: "Jalnan", size: 13  *  heightRatio)
                print(self.city)
                
            }
        }
        locationManager.stopUpdatingLocation()
        
        
    }
    
    @objc func handleDisplaylink(_ displayLink: CADisplayLink) {
        // calculate, based upon elapsed time, how far along we are
        
        let percent = CGFloat(min(1, (CACurrentMediaTime() - start) / duration))
        
        // update the path based upon what percent of the animation has been completed
        
        print("percent: \(percent)!")
        
        //원을 그리는 화면을  반복해준다.
        // for i in 0 ..< 10 {
        updatePath(percent: percent)
        //   }
        // if we're done, stop display link and go ahead and remove mask now that it's not needed any more
        
        if percent >= 1 {
            displayLink.invalidate()
            imgView.layer.mask = nil
        }
        
        
    }
    
    
    private func updatePath(percent: CGFloat) {
        print("원 그리기")
        let center = CGPoint(x: 20,  y: 20)
        // let startRadius = min(imgView.bounds.width, imgView.bounds.height) * 0.4
        
        let startRadius = min(20, 20) * 0.4
        // start radius is 40% of smallest dimension
        let endRadius = hypot(20, 20) * 0.5  // stop radius is the distance from the center to the corner of the image view
        let radius = startRadius + (endRadius - startRadius) * Double(percent)                // given percent done, what is the radius
        
        mask?.path = UIBezierPath(arcCenter: center, radius: CGFloat(radius), startAngle: 0, endAngle: .pi * 2, clockwise: true).cgPath
    }
    
    
    
    
    
    //지역변경화면으로 이동하는 메소드
    //최종확인 버튼 mapSearchViewController
    @objc func areaMove(_ sender: UIButton) {
        print("지역변경 페이지로 이동하는 버튼 클릭")
        
        
    }
    
    
    //지역혜택 리스트를 보여주는 페이지로 이동
    @objc func moveList(_ sender: UIButton) {
        
        print("혜택지도 결괴페이지로 이동")
        DeviceManager.sharedInstance.sendLog(content: "혜택지도 결괴페이지로 이동", type: type)
        
        
        //
        
        let params = ["page_number":"2", "local":"경기", "userAgent" : DeviceManager.sharedInstance.log]
        //let params = ["type":"category_search", "keyword":"취업·창업"]
        print(DeviceManager.sharedInstance.log)
        
        
        Alamofire.request("https://www.urbene-fit.com/map", method: .get, parameters: params)
            .validate()
            .responseJSON { response in
                
                switch response.result {
                case .success(let value):
                    
                    //상세페이지로 카테고리선택결과 데이터를  전달하기 위해 상세페이지 객체를 선언
                    
                    
                    do {
                        let data = try JSONSerialization.data(withJSONObject: value, options: .prettyPrinted)
                        let parseResult = try JSONDecoder().decode(Parse.self, from: data)
                        
                        guard let RVC = self.storyboard?.instantiateViewController(withIdentifier: "NewResultView") as? NewResultView         else{
                            
                            return
                            
                        }
                        
                        
                        if(parseResult.Status == "200"){
                            print(parseResult.Status)
                            let parseResult = try JSONDecoder().decode(searchParse.self, from: data)
                            for i in 0..<parseResult.Message.count {
                                
                                print(parseResult.Message[i].welf_name)
                                //print(parseResult.Message[i].welf_local)
                                print(parseResult.Message[i].parent_category)
                                print(parseResult.Message[i].welf_category)
                                print(parseResult.Message[i].tag)
                                
                                
                                var tag = parseResult.Message[i].welf_category.replacingOccurrences(of: " ", with: "")
                                //split
                                var arr = tag.components(separatedBy: ";;")
                                
                                
                                RVC.items.append(NewResultView.item.init(welf_name: parseResult.Message[i].welf_name, welf_local: self.local, parent_category: parseResult.Message[i].parent_category, welf_category: arr, tag: parseResult.Message[i].tag))
                                
                                
                                //태그 추가
                                for i in 0..<arr.count {
                                    if(!RVC.categoryItems.contains(arr[i])){
                                        RVC.categoryItems.append(arr[i])
                                    }
                                }
                                
                                
                                
                                
                                //
                            }
                            //검색결과 페이지로 이동
                            
                            
                            
                            //뷰 이동
                            RVC.modalPresentationStyle = .fullScreen
                            
                            // 상세정보 뷰로 이동
                            //self.present(RVC, animated: true, completion: nil)
                            self.navigationController?.pushViewController(RVC, animated: true)
                            
                            
                            
                        }else{
                            print(parseResult.Status)
                            
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
                //
                
                
                
                
                case .failure(let error):
                    print(error)
                }
                
                
                
            }
        //
        
    }
    
    func tabBarController(tabBarController: UITabBarController, didSelectViewController viewController: UIViewController) {
        
        print("tabbar메소드")
        
        
    }
    
    
    func setRegionBtn(){
        
    }
    
    
    
    //지역을 클릭했을 경우 지역의 혜택리스트를 보여주는 페이지로 이동하는 메소드
    @objc func selected(_ sender: UIButton) {
        // print("지역혜텍리스트 페이지로 이동")
        
        //        guard let RVC = self.storyboard?.instantiateViewController(withIdentifier: "mapResultViewController") as? mapResultViewController         else{
        //
        //            return
        //
        //        }
        //
        //        RVC.local = cityXYs[sender.tag].cityName
        //
        //        //뷰 이동
        //        RVC.modalPresentationStyle = .fullScreen
        //
        //        // B 컨트롤러 뷰로 넘어간다.
        //        //self.present(RVC, animated: true, completion: nil)
        //        self.navigationController?.pushViewController(RVC, animated: true)
        
        
        
        print("혜택지도 결괴페이지로 이동")
        DeviceManager.sharedInstance.sendLog(content: "혜택지도 결괴페이지로 이동", type: type)
        
        print("선택한 지역 : \(cityXYs[sender.tag].cityName)")
        var selected : String = cityXYs[sender.tag].cityName
        //
        
        let params = ["page_number":"2", "local":selected, "userAgent" : DeviceManager.sharedInstance.log]
        //let params = ["type":"category_search", "keyword":"취업·창업"]
        
        
        Alamofire.request("https://www.urbene-fit.com/map", method: .get, parameters: params)
            .validate()
            .responseJSON { response in
                
                switch response.result {
                case .success(let value):
                    
                    //상세페이지로 카테고리선택결과 데이터를  전달하기 위해 상세페이지 객체를 선언
                    
                    
                    do {
                        let data = try JSONSerialization.data(withJSONObject: value, options: .prettyPrinted)
                        let parseResult = try JSONDecoder().decode(Parse.self, from: data)
                        
                        guard let RVC = self.storyboard?.instantiateViewController(withIdentifier: "NewResultView") as? NewResultView         else{
                            
                            return
                            
                        }
                        
                        // print(parseResult.Message)
                        
                        
                        if(parseResult.Status == "200"){
                            print(parseResult.Status)
                            
                            let parseResult = try JSONDecoder().decode(searchParse.self, from: data)
                            
                            for i in 0..<parseResult.Message.count {
                                
                                print(parseResult.Message[i].welf_name)
                                print(parseResult.Message[i].parent_category)
                                print(parseResult.Message[i].welf_category)
                                print(parseResult.Message[i].tag)
                                
                                
                                var tag = parseResult.Message[i].welf_category.replacingOccurrences(of: " ", with: "")
                                //split
                                var arr = tag.components(separatedBy: ";;")
                                
                                
                                RVC.items.append(NewResultView.item.init(welf_name: parseResult.Message[i].welf_name, welf_local: selected, parent_category: parseResult.Message[i].parent_category, welf_category: arr, tag: parseResult.Message[i].tag))
                                
                                
                                //태그 추가
                                for i in 0..<arr.count {
                                    if(!RVC.categoryItems.contains(arr[i])){
                                        RVC.categoryItems.append(arr[i])
                                    }
                                }
                                
                                
                                
                                
                                //
                            }
                            // 검색결과 페이지로 이동
                            
                            
                            
                            //뷰 이동
                            RVC.modalPresentationStyle = .fullScreen
                            
                            // 상세정보 뷰로 이동
                            //self.present(RVC, animated: true, completion: nil)
                            self.navigationController?.pushViewController(RVC, animated: true)
                            
                            
                            
                        }else{
                            print(parseResult.Status)
                            
                            
                            
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
                //
                
                
                
                
                case .failure(let error):
                    print(error)
                }
                
                
                
            }
        
    }
    
    
    func setCity(){
        
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
    
    func setLayout(){
        //메인 지도 이미지뷰
        
        let img = UIImage(named: "newMap")
        imgView.setImage(img!)
        
        imgView.frame = CGRect(x: 0, y: 140 *  DeviceManager.sharedInstance.heightRatio, width: DeviceManager.sharedInstance.width, height: 550 *  heightRatio)
        
        self.view.addSubview(imgView)
        
        
        locationManager.delegate = self
        // 정확도를 최고로 설정
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        // 위치 데이터를 추적하기 위해 사용자에게 승인 요구
        locationManager.requestWhenInUseAuthorization()
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
        
        
        //전체보기 버튼
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
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("지도페이지의 view가 사라지기 전")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print("지도페이지의 view가 사라짐")
    }
    
    
    
    
    
}
