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
    
    struct  areaCounts : Decodable {
        let areaCount : [areaCount]
        
    }
    
    //지역별 정책숫자를 받아와 파싱할 구조체
    struct  areaCount : Decodable {
        let local: String
        let welf_count: Int
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
    
    
    //지역위치정보를 관리하는 배열
    //    var cityXYs   =  [{ "area": "서울", "x" : 30 ,"y" : 60},{"area" : "서울", "x" : 30 ,"y" : 60},{"area" : "서울", "x" : 30 ,"y" : 60},{"area" : "서울", "x" : 30 ,"y" : 60},{"area" : "서울", "x" : 30 ,"y" : 60},{"area" : "서울", "x" : 30 ,"y" : 60},{"area" : "서울", "x" : 30 ,"y" : 60},{"area" : "서울", "x" : 30 ,"y" : 60},{"area" : "서울", "x" : 30 ,"y" : 60},{"area" : "서울", "x" : 30 ,"y" : 60}
    //
    //    ]
    
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //self.navigationController?.isNavigationBarHidden = true

        //화면 스크롤 크기
        var screenWidth = Int(view.bounds.width)
        var screenHeight = Int(view.bounds.height)
        self.view.backgroundColor = UIColor.white
        
        cityXYs.append(cityXY.init(cityName: "서울", cityX: 50, cityY: 200))
        cityXYs.append(cityXY.init(cityName: "강원", cityX: 230, cityY: 220))
        cityXYs.append(cityXY.init(cityName: "경기", cityX: 140, cityY: 270))
        cityXYs.append(cityXY.init(cityName: "경남", cityX: 230, cityY: 460))
        cityXYs.append(cityXY.init(cityName: "경북", cityX: 260, cityY: 350))
        cityXYs.append(cityXY.init(cityName: "광주", cityX: 120, cityY: 500))
        cityXYs.append(cityXY.init(cityName: "대구", cityX: 240, cityY: 400))
        cityXYs.append(cityXY.init(cityName: "대전", cityX: 140, cityY: 340))
        cityXYs.append(cityXY.init(cityName: "부산", cityX: 330, cityY: 480))
        cityXYs.append(cityXY.init(cityName: "제주", cityX: 50, cityY: 550))

//       self.tabBarController?.delegate = self
//        let tab = UITabBar()
//        tab.frame =  CGRect(x: 0, y: 0, width: view.frame.size.width, height: 500)
//        view.addSubview(tab)
//
//        tabBarCnt = UITabBarController()
//          tabBarCnt.tabBar.barStyle = .black
//
//
//          let journalVC = UiTestController()
//          journalVC.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 1)
//
//          tabBarCnt.viewControllers = [journalVC]
//          self.view.addSubview(tabBarCnt.view)
//
        
        
        //        //앱 로고
        //        let appLogo = UIImageView()
        //        let LogoImg = UIImage(named: "appLogo")
        //        appLogo.image = LogoImg
        //        appLogo.frame = CGRect(x: 25, y: 45, width: 116.6, height: 16)
        //        self.view.addSubview(appLogo)
        //
        //
        //
        //        //헤더
        //        let header = UIView()
        //        let headerLabel = UILabel()
        //        //헤더에 무슨화면인지 설명
        //        header.frame = CGRect(x: 0, y: Int(80), width: screenWidth, height: Int(100))
        //
        //        //추후 그라데이션 적용
        //        header.backgroundColor = UIColor(displayP3Red: 111/255.0, green: 82/255.0, blue: 232/255.0, alpha: 1)
        //
        //        //헤더라벨
        //        headerLabel.frame = CGRect(x: 0, y: 0, width: screenWidth, height: Int(100))
        //        headerLabel.textColor = UIColor.white
        //        //폰트지정 추가
        //
        //        headerLabel.text = "지도에서 혜택찾기"
        //        headerLabel.numberOfLines = 2
        //
        //        //라벨 줄간격 조절
        //        let attrString = NSMutableAttributedString(string: headerLabel.text!)
        //        let paragraphStyle = NSMutableParagraphStyle()
        //        paragraphStyle.lineSpacing = 8
        //        attrString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attrString.length))
        //        headerLabel.attributedText = attrString
        //        headerLabel.textAlignment = .center
        //
        //
        //        headerLabel.font = UIFont(name: "Jalnan", size: 28)
        //        // inquiryLabel.font = UIFont(name: "NanumGothicBold", size: 13.7)
        //        header.addSubview(headerLabel)
        //        self.view.addSubview(header)
        
        
        //서치바를 동작하기 위한 대리자 선언
        //        searchBar.showsScopeBar = true
        //
        //        searchBar.delegate = self
        //
        //        //네비게이션 바 설정
        //        navBar.frame = CGRect(x: 0, y: 30, width: view.frame.size.width, height: 80)
        //        view.addSubview(navBar)
        //
        //        let navItem = UINavigationItem()
        //        //검색시 사용하는 네비게이션의 텍스트 필드
        //        let Image = UIImage(named: "back")
        //
        //        //navItem.leftBarButtonItem = UIBarButtonItem(image: Image, style: .done, target: self, action: nil)
        //
        //        // navItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: nil, action: nil)
        //
        //
        //
        //
        //
        //        var backbutton = UIButton(type: .custom)
        //        backbutton.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        //        backbutton.setImage(UIImage(named: "BackButton.png"), for: .normal) // Image can be downloaded from here below link
        //        backbutton.widthAnchor.constraint(equalToConstant: 20).isActive = true
        //        backbutton.heightAnchor.constraint(equalToConstant: 20).isActive = true
        //        backbutton.setTitleColor(backbutton.tintColor, for: .normal)
        //
        //        // You can change the TitleColor
        //        //backbutton.addTarget(self, action: "backAction", forControlEvents: .TouchUpInside)
        //        //        backbutton.sizeToFit()
        //        navItem.leftBarButtonItem = UIBarButtonItem(customView: backbutton)
        //
        //
        //        navBar.setItems([navItem], animated: false)
        
        
        
        
        //네비바에 타이틀 설정
        //컨테이너 뷰
        //        let titleView = UIView()
        //        titleView.frame = CGRect(x: 100, y: 20, width: 170, height: 60)
        //
        //
        //
        //        //로고
        //        let logoView = UIImageView()
        //        logoView.setImage(UIImage(named: "newLogo")!)
        //        logoView.frame = CGRect(x: 0, y: 20, width: 40, height: 40)
        //        //logoView.image = logoView.image?.withRenderingMode(.alwaysTemplate)
        //        //logoView.tintColor =  #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
        //
        //        logoView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        //        logoView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        //        titleView.addSubview(logoView)
        //
        //        //라벨
        ////        let titleLabel = UILabel()
        ////        titleLabel.font = UIFont(name: "Jalnan", size: 17)
        ////        titleLabel.text = "너의 혜택은"
        ////        titleLabel.frame = CGRect(x: 50, y: 0, width: 120, height: 60)
        ////        titleLabel.textAlignment = .center
        ////        titleView.addSubview(titleLabel)
        //
        //
        //
        //        //navItem.titleView = logoView
        //
        //
        //        var plusBtn = UIButton(type: .custom)
        //        plusBtn.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        //        plusBtn.setImage(UIImage(named: "search"), for: .normal) // Image can be downloaded from here below link
        //        plusBtn.widthAnchor.constraint(equalToConstant: 20).isActive = true
        //        plusBtn.heightAnchor.constraint(equalToConstant: 20).isActive = true
        //        plusBtn.setTitleColor(backbutton.tintColor, for: .normal)
        //
        //        // You can change the TitleColor
        //        //backbutton.addTarget(self, action: "backAction", forControlEvents: .TouchUpInside)
        //        //        backbutton.sizeToFit()
        //        navItem.rightBarButtonItem = UIBarButtonItem(customView: plusBtn)
        //
        //
        //        navBar.setItems([navItem], animated: false)
        
        //지도UI상에 표시할 지도 좌표를 저장한다.
        
        //상단 뷰
        //지역명
        //라벨
        areaLabel.font = UIFont(name: "Jalnan", size: 17)
        areaLabel.frame = CGRect(x: 20, y: 60, width: 220, height: 30)
        areaLabel.textAlignment = .left
        self.view.addSubview(areaLabel)
        
        
        //거주지역을 변경해줘야할때 지역변경 화면으로 이동하게 해주는 버튼
        
        
        areaMoveBtn.setTitleColor(UIColor.gray, for: .normal)
        areaMoveBtn.frame = CGRect(x: 300, y: 560, width: 100, height: 50)
        areaMoveBtn.setTitle("지역변경", for: .normal)
        areaMoveBtn.titleLabel!.font = UIFont(name: "Jalnan", size:14.7)
        
        
        //카테고리 선택시 선택한 카테고리를 저장해주는 메소드
        areaMoveBtn.addTarget(self, action: #selector(self.areaMove), for: .touchUpInside)
        
        
        
        
        
        // cityXYs.append(cityXY.init(cityName: "서울", cityX: 50, cityY: 200))
        
        
        
        //메인 지도 이미지뷰
        
        let img = UIImage(named: "newMap")
        imgView.setImage(img!)
        imgView.frame = CGRect(x: 0, y: 140, width:screenWidth , height: 550)
        imgView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        //        imgView.image = imgView.image?.withRenderingMode(.alwaysTemplate)
        //imgView.tintColor =  #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        self.view.addSubview(imgView)
        self.view.addSubview(areaMoveBtn)

        // Do any additional setup after loading the view.
        
        locationManager.delegate = self
        // 정확도를 최고로 설정
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        // 위치 데이터를 추적하기 위해 사용자에게 승인 요구
        locationManager.requestWhenInUseAuthorization()
        // 위치 업데이트를 시작
        locationManager.startUpdatingLocation()
        
        //테이블뷰 상단에 위치하여 몇개의 정첵이 있는지 보여주는 뷰
        let discriptionView = UIView()
        discriptionView.frame = CGRect(x: 0, y: 700, width: screenWidth, height: 60)
        discriptionView.backgroundColor = #colorLiteral(red: 0.1918275654, green: 0.191522032, blue: 0.1921892762, alpha: 0.4443760702)
        
        //라벨
        titleLabel.font = UIFont(name: "Jalnan", size: 17)
        titleLabel.textColor = UIColor.white
        titleLabel.frame = CGRect(x: 20, y: 5, width: 220, height: 50)
        titleLabel.textAlignment = .left
        discriptionView.addSubview(titleLabel)
        
        
        //전체보기 버튼
        let viewBtn = UIButton()
        
        viewBtn.frame = CGRect(x: screenWidth - 90, y: 5, width: 80, height: 50)
        viewBtn.setTitle("보러가기", for: .normal)
        viewBtn.backgroundColor = UIColor.white
        viewBtn.titleLabel!.font = UIFont(name: "Jalnan", size:14.7)
        viewBtn.setTitleColor(UIColor.black, for: .normal)
        
        viewBtn.layer.cornerRadius = 23
        viewBtn.layer.borderWidth = 1.3
        
        viewBtn.layer.borderColor = UIColor.white.cgColor
        
        viewBtn.addTarget(self, action: #selector(self.moveList), for: .touchUpInside)
        
        discriptionView.addSubview(viewBtn)
        
        
        
        self.view.addSubview(discriptionView)
        
        
        //        let mask = CAShapeLayer()
        //        mask.fillColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1).cgColor
        //        mask.strokeColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0).cgColor
        //        imgView.layer.mask = mask
        //        self.mask = mask
        
        
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
        let geoCoder: CLGeocoder = CLGeocoder()
        let local: Locale = Locale(identifier: "Ko-kr") // Korea
        geoCoder.reverseGeocodeLocation(findLocation, preferredLocale: local) { (place, error) in
            if let address: [CLPlacemark] = place {
                print("(longitude, latitude) = (\(x), \(y))")
                print("시(도): \(address.last?.administrativeArea)")
                print("구(군): \(address.last?.locality)")
                
                
                self.local = (address.last?.administrativeArea!)!
                //지역표시
                self.areaLabel.text = address.last?.locality!
                
                
                //                    //시 정보 저장
                //                    self.city =  String((address.last?.administrativeArea)!)
                //                    //효과 이미지
                //                    let testView = UIView(frame: CGRect(x: 50, y: 200, width:  100, height: 100))
                //                         //testView.backgroundColor = #colorLiteral(red: 1, green: 0.2739933722, blue: 0.9001957098, alpha: 1)
                //                    testView.backgroundColor = UIColor(red: 1, green: 0.2739933722, blue: 0.9001957098, alpha: 0.3)
                //                    //색상고르는 법 Color Literal
                //                    //let colorLiteral = #colorLiteral(red: 1, green: 0.2739933722, blue: 0.9001957098, alpha: 1)
                //
                //
                //                    testView.layer.cornerRadius = testView.frame.height/2
                //                    testView.layer.borderWidth = 1
                //                    testView.layer.borderColor = UIColor.clear.cgColor
                //                                // 뷰의 경계에 맞춰준다
                //                    testView.clipsToBounds = true
                //
                //해당지역의 정책갯수를 서버로부터 받아온다.
                let parameters = ["local": "부산", "page_number": "1"]
                
                Alamofire.request("http://www.urbene-fit.com/map", method: .get, parameters: parameters)
                    .validate()
                    .responseJSON { [self] response in
                        
                        switch response.result {
                        case .success(let value):
                            
                            do {
                                let data = try JSONSerialization.data(withJSONObject: value, options: .prettyPrinted)
                                let areaLists = try JSONDecoder().decode([areaCount].self, from: data)
                                
                                
                                for i in 1..<areaLists.count {
                                    
                                    if("부산" == areaLists[i].local){
                                        self.count = areaLists[i].welf_count
                                        self.titleLabel.text = "내 주변 혜택보기 \(areaLists[i].welf_count)개 >"
                                        
                                    }
                                    
                                    
                                    print(areaLists[i].local)
                                    print(areaLists[i].welf_count)
                                    
                                    
//                                    let testView = UIView(frame: CGRect(x: self.cityXYs[i].cityX, y: self.cityXYs[i].cityY, width:  70, height: 70))
                                    let testView = UIView(frame: CGRect(x: 50, y: 50, width:  70, height: 70))
                                    testView.backgroundColor = #colorLiteral(red: 1, green: 0.2739933722, blue: 0.9001957098, alpha: 1)
                                    testView.backgroundColor = UIColor(red: 1, green: 0.2739933722, blue: 0.9001957098, alpha: 0.3)
                                    //색상고르는 법 Color Literal
                                    //let colorLiteral = #colorLiteral(red: 1, green: 0.2739933722, blue: 0.9001957098, alpha: 1)
                                    
                                    
                                    testView.layer.cornerRadius = testView.frame.height/2
                                    testView.layer.borderWidth = 1
                                    testView.layer.borderColor = UIColor.clear.cgColor
                                    // 뷰의 경계에 맞춰준다
                                    testView.clipsToBounds = true
                                    let infoLabel = UILabel()
                                    infoLabel.frame = CGRect(x: 0, y: 0, width: 70, height: 70)
                                    infoLabel.numberOfLines = 2
                                    
                                    infoLabel.textAlignment = .center
                                    infoLabel.text = "\(areaLists[i].local)\n  \(areaLists[i].welf_count)개의 혜택"
                                    infoLabel.font = UIFont(name: "Jalnan", size: 10)
                                    testView.addSubview(infoLabel)
                                    self.view.addSubview(testView)
                                    
                                    
                                    
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
                        //                                if let json = value as? [String: Any] {
                        //                                              print(json)
                        //                                for (key, value) in json {
                        //                                    print(value)
                        //                            //카테고리데이터를 집어넣는다.
                        ////                                    if(key == "local"){
                        ////                                    print(value as! String)
                        ////                                    }
                        //                        }
                        //
                        //
                        //
                        //}
                        
                        
                        case .failure(let error):
                            print("Error: \(error)")
                            break
                            
                            
                        }
                    }
                
                
                //지역명과 정책수를 알려준다.
                let infoLabel = UILabel()
                infoLabel.frame = CGRect(x: 0, y: 25, width: 100, height: 50)
                infoLabel.textAlignment = .center
                infoLabel.numberOfLines = 2
                //infoLabel.textColor = UIColor(displayP3Red: 93/255.0, green: 33/255.0, blue: 210/255.0, alpha: 1)
                //폰트지정 추가
                
                infoLabel.text = "\(self.city)\n 정책 231개"
                infoLabel.font = UIFont(name: "Jalnan", size: 13)
                print(self.city)
                //                        testView.addSubview(infoLabel)
                //                         self.view.addSubview(testView)
                //
                
                
                
                
                
                //                    self.start = CACurrentMediaTime()
                //
                //                    let displayLink = CADisplayLink(target: self, selector: #selector(self.handleDisplaylink(_:)))
                //
                //                    displayLink.add(to: .main, forMode: .common)
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
    
    
    class View2: UIView {
        override func draw(_ rect: CGRect) {
            //            let path = UIBezierPath()
            //
            //            path.move(to: CGPoint(x: self.frame.width/2, y: 30))
            //            path.addLine(to: CGPoint(x: self.frame.width/2 - sqrt(2700), y: 120))
            //            path.addLine(to: CGPoint(x: self.frame.width/2 + sqrt(2700), y: 120))
            //            path.close()
            //
            //            UIColor.black.set()
            //            path.stroke()
            //
            //            UIColor.yellow.set()
            //            path.fill()
            
            // 원 그리는법 1
            let circlePath = UIBezierPath(roundedRect: CGRect(origin: CGPoint(x: self.frame.width/2-30, y: 60), size: CGSize(width: 60, height: 60)), cornerRadius: 30)
            UIColor.black.set()
            circlePath.stroke()
            UIColor.green.setFill()
            circlePath.fill()
            
            // 원 그리는법 2
            //        let circlePath = UIBezierPath(arcCenter: CGPoint(x: self.frame.width/2, y: 90), radius: 30, startAngle: 0, endAngle: (135 * .pi) / 180, clockwise: true)
            //        UIColor.black.set()
            //        circlePath.stroke()
        }
    }
    
    
    //지역변경화면으로 이동하는 메소드
    //최종확인 버튼 mapSearchViewController
    @objc func areaMove(_ sender: UIButton) {
        print("지역변경 페이지로 이동하는 버튼 클릭")
        
        
        guard let RVC = self.storyboard?.instantiateViewController(withIdentifier: "mapSearchViewController") as? mapSearchViewController         else{
            
            return
            
        }
        
        RVC.local = local
        
        //뷰 이동
        RVC.modalPresentationStyle = .overFullScreen
        
        //self.present(RVC, animated: true, completion: nil)
        self.navigationController?.pushViewController(RVC, animated: true)

        
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let mainTabBar = storyboard.instantiateViewController(withIdentifier: "tabBarController") as! tabBarController
//        let tset = mapTestViewController()
//        mainTabBar.present(tset, animated: false, completion: nil)
//
//        self.present(RVC, animated: false) {
//            mainTabBar.selectedIndex = 1
//        }

        //mainTabBar.selectedIndex = 1
       // tabBarController(tabBarController: mainTabBar, didSelectViewController: tset)
        //self.tabBarController?.present(RVC, animated: true, completion: nil)
//        self.present(RVC, animated:true, completion:nil)
//        tabBarController?.selectedViewController = RVC
//        self.navigationController?.pushViewController(RVC, animated: true)
        //tabBarController!.selectedIndex = 0
         
        //self.selectedIndex = 0



//        self.tabBarController?.present(RVC, animated: false, completion: nil)
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)

//
//        let mainTabBar = storyboard.instantiateViewController(withIdentifier: "tabBarController") as! UITabBarController
//            // mainTabBar.popToViewController(RVC, animated: true)
//        let viewNumNavController  = mainTabBar.viewControllers![1] as! ViewNumNavigationController
//
//        viewNumNavController.popToViewController(RVC, animated: true)
    }
    
    
    //지역혜택 리스트를 보여주는 페이지로 이동
    @objc func moveList(_ sender: UIButton) {
        
        print("move")
       // self.dismiss(animated: false, completion: nil)
        
        guard let RVC = self.storyboard?.instantiateViewController(withIdentifier: "mapSearchViewController") as? mapSearchViewController         else{
            
            return
            
        }
        
        RVC.local = local
        
        //뷰 이동
        RVC.modalPresentationStyle = .fullScreen
        
        // B 컨트롤러 뷰로 넘어간다.
        //self.present(RVC, animated: true, completion: nil)
        self.navigationController?.pushViewController(RVC, animated: true)
        
//        guard let RVC = self.storyboard?.instantiateViewController(withIdentifier: "mapResultViewController") as? mapResultViewController         else{
//
//            return
//
//        }
//
//        RVC.local = local
//
//        //뷰 이동
//        RVC.modalPresentationStyle = .fullScreen
//
//        // B 컨트롤러 뷰로 넘어간다.
//        self.present(RVC, animated: true, completion: nil)
    }
    
    func tabBarController(tabBarController: UITabBarController, didSelectViewController viewController: UIViewController) {
      
        print("tabbar메소드")

      
    }
    
}
