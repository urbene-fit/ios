//
//  mapViewController.swift
//  welfare
//
//  Created by 김동현 on 2020/11/25.
//  Copyright © 2020 com. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit


//커스텀 mk포인트
class ImageAnnotation : NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    var image: UIImage?
    var colour: UIColor?

    override init() {
        print("ImageAnnotation 생성")
        self.coordinate = CLLocationCoordinate2D()
        self.title = nil
        self.subtitle = nil
        self.image = nil
        self.colour = UIColor.white
    }
}

class ImageAnnotationView: MKAnnotationView {
    private var imageView: UIImageView!

    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        print("ImageAnnotationView 생성")

        self.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        //이미지 그려주는 부분
        self.imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
       
        
        //정책숫자 라벨
        let titleLabel = UILabel()
        titleLabel.frame = CGRect(x: 0, y: 0, width: 100, height:100)
        titleLabel.textAlignment = .center
        //titleLabel.textColor = UIColor(displayP3Red: 93/255.0, green: 33/255.0, blue: 210/255.0, alpha: 1)
        //폰트지정 추가
        
        titleLabel.text = "27개의 정책"
        titleLabel.font = UIFont(name: "TTCherryblossomR", size: 12)
        self.imageView.addSubview(titleLabel)
        self.addSubview(self.imageView)
        self.imageView.layer.cornerRadius = 5.0
        self.imageView.layer.masksToBounds = true

       
    }

    override var image: UIImage? {
        get {
            return self.imageView.image
        }

        set {
            self.imageView.image = newValue
        }
    }

    required init?(coder aDecoder: NSCoder) {

        fatalError("init(coder:) has not been implemented")
    }
}



//class LocationConverter {
//    let map: MapGridData = MapGridData()
//
//    let PI: Double = .pi
//    let DEGRAD: Double = .pi / 180.0
//    let RADDEG: Double = 180.0 / .pi
//
//    var re: Double
//    var slat1: Double
//    var slat2: Double
//    var olon: Double
//    var olat: Double
//    var sn: Double
//    var sf: Double
//    var ro: Double
//
//    init() {
//        re = map.re / map.grid
//        slat1 = map.slat1 * DEGRAD
//        slat2 = map.slat2 * DEGRAD
//        olon = map.olon * DEGRAD
//        olat = map.olat * DEGRAD
//
//        sn = tan(PI * 0.25 + slat2 * 0.5) / tan(PI * 0.25 + slat1 * 0.5)
//        sn = log(cos(slat1) / cos(slat2)) / log(sn)
//        sf = tan(PI * 0.25 + slat1 * 0.5)
//        sf = pow(sf, sn) * cos(slat1) / sn
//        ro = tan(PI * 0.25 + olat * 0.5)
//        ro = re * sf / pow(ro, sn)
//    }
//
//    func convertGrid(lon: Double, lat: Double) -> (Int, Int) {
//
//        var ra: Double = tan(PI * 0.25 + lat * DEGRAD * 0.5)
//        ra = re * sf / pow(ra, sn)
//        var theta: Double = lon * DEGRAD - olon
//
//        if theta > PI {
//            theta -= 2.0 * PI
//        }
//
//        if theta < -PI {
//            theta += 2.0 * PI
//        }
//
//        theta *= sn
//
//        let x: Double = ra * sin(theta) + map.xo
//        let y: Double = ro - ra * cos(theta) + map.yo
//
//        return (Int(x + 1.5), Int(y + 1.5))
//    }
//}

//맵뷰 오버레이
//class ImageOverlay : NSObject, MKOverlay {
//
//    let image:UIImage
//    let boundingMapRect: MKMapRect
//    let coordinate:CLLocationCoordinate2D
//
//    init(image: UIImage, rect: MKMapRect) {
//        self.image = image
//        self.boundingMapRect = rect
//       // self.coordinate = rect.
//    }
//}
//
//class ImageOverlayRenderer : MKOverlayRenderer {
//
//    override func draw(_ mapRect: MKMapRect, zoomScale: MKZoomScale, in context: CGContext) {
//
//        guard let overlay = self.overlay as? ImageOverlay else {
//            return
//        }
//
//        let rect = self.rect(for: overlay.boundingMapRect)
//
//        UIGraphicsPushContext(context)
//        overlay.image.draw(in: rect)
//        UIGraphicsPopContext()
//    }
//}



class mapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    let locationManager = CLLocationManager()
   // var locationManager : CLLocationManager!
    
    
     var myMap =  MKMapView()
        var lblLocationInfo1 =  UILabel()
       var lblLocationInfo2 =  UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let overlayPath = self.mapViewModel.overlayURL
//        let overlay = MKTileOverlay(URLTemplate: overlayPath)
//        overlay.canReplaceMapContent = true
//        self.mapView.addOverlay(overlay)

        // Do any additional setup after loading the view.
//        locationManager = CLLocationManager()
//        locationManager.delegate = self
//
//        //포그라운드시 위치추적 요청
//        locationManager.requestWhenInUseAuthorization()
//        //배터리 최적화
//        locationManager.desiredAccuracy = kCLLocationAccuracyBest
//        //위치 업데이트
//        locationManager.startUpdatingLocation()
//
//        //위,경도 가져오기
//        let coor = locationManager.location?.coordinate
//        let latitude =  coor?.latitude
//        let longitude = coor?.longitude
//
//        print("위도 '\(String(describing: coor?.latitude))'")
//        print("경도 '\(String(describing: coor?.longitude))'")

        
        //화면 스크롤 크기
       var screenWidth = Int(view.bounds.width)
   var screenHeight = Int(view.bounds.height)
        
        
        //맵표시
        //myMap.showsCompass = MapKit.FeatureVisibility.Hidden

        myMap.frame = CGRect(x:0, y: 0, width: screenWidth, height: screenHeight)
        self.view.addSubview(myMap)
        lblLocationInfo1.frame = CGRect(x:0, y: 100, width: screenWidth, height: 90)
        self.view.addSubview(lblLocationInfo1)
        lblLocationInfo2.frame = CGRect(x:0, y: 200, width: screenWidth, height: 90)
        self.view.addSubview(lblLocationInfo2)

        
        
        lblLocationInfo1.text = ""
                lblLocationInfo2.text = ""
                locationManager.delegate = self
                // 정확도를 최고로 설정
                locationManager.desiredAccuracy = kCLLocationAccuracyBest
                // 위치 데이터를 추적하기 위해 사용자에게 승인 요구
                locationManager.requestWhenInUseAuthorization()
                // 위치 업데이트를 시작
                locationManager.startUpdatingLocation()
                // 위치 보기 설정
                myMap.showsUserLocation = false
        
        //        myMap.mapType = .mutedStandard

        //myMap.mapType = .satelliteFlyover

        //myMap.mapType = .satellite
        
        //myMap.mapType =  .standard
        
       // myMap.mapType = .satelliteFlyover
        
        //myMap.mapType = .satellite
        //대리자를 선언해줘야 mk메소드가 호출
        
        //myMap.mapType = .hybrid

        myMap.delegate = self
        let overlayURL = "http://tile.stamen.com/watercolor/{z}/{x}/{y}.jpg"
        let overlay = MKTileOverlay(urlTemplate: overlayURL)
        overlay.canReplaceMapContent = true
        myMap.addOverlay(overlay)
        
//        var template = "http://tile.openstreetmap.org/{z}/{x}/{y}.png"
//
//        let carte_indice = MKTileOverlay(urlTemplate:template)
//
//
//        carte_indice.isGeometryFlipped = true
//
//        carte_indice.canReplaceMapContent = false
//
//
//        self.myMap.addOverlay(carte_indice)
        

            }
            
            // 위도와 경도, 스팬(영역 폭)을 입력받아 지도에 표시
            func goLocation(latitudeValue: CLLocationDegrees,
                            longtudeValue: CLLocationDegrees,
                            delta span: Double) -> CLLocationCoordinate2D {
                let pLocation = CLLocationCoordinate2DMake(latitudeValue, longtudeValue)
//
//            let spanValue = MKCoordinateSpan(latitudeDelta: span, longitudeDelta: span)
//                let pRegion = MKCoordinateRegion(center: pLocation, span: spanValue)
                
                //setAnnotation(latitudeValue: latitudeValue,longitudeValue: longtudeValue,delta: span,title: "서울",subtitle: "정책 777개")
                
                //myMap.setRegion(pRegion, animated: true)
                return pLocation
            }
            
            // 특정 위도와 경도에 핀 설치하고 핀에 타이틀과 서브 타이틀의 문자열 표시
            func setAnnotation(latitudeValue: CLLocationDegrees,
                               longitudeValue: CLLocationDegrees,
                               delta span :Double,
                               title strTitle: String,
                               subtitle strSubTitle:String){
                
//                let annotation = MKPointAnnotation()
//                annotation.coordinate = goLocation(latitudeValue: latitudeValue, longtudeValue: longitudeValue, delta: span)
//                annotation.title = strTitle
//                annotation.subtitle = strSubTitle
//                myMap.addAnnotation(annotation)
                
                
                let point = MKPointAnnotation()
                let point2 = MKPinAnnotationView()

                point.coordinate = CLLocationCoordinate2DMake(latitudeValue, longitudeValue)
                point.title = "서울특별시"
                point.subtitle = "정책 777개"
                
                
                           //print("지역 :  \(strTitle)")


                myMap.addAnnotation(point)

                
                
            }
            
            // 위치 정보에서 국가, 지역, 도로를 추출하여 레이블에 표시
            func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
                print("locationManager호출")
                //로케이션 매니저를 통해 마지막 위치정보를 받아와서
                //지도에 표시해주는 메소드를 호출한다,
                let pLocation = locations.last
//                _ = goLocation(latitudeValue: (pLocation?.coordinate.latitude)!,
//                           longtudeValue: (pLocation?.coordinate.longitude)!,
//                           delta: 0.01)
                _ = loadAnnotations(latitudeValue: (pLocation?.coordinate.latitude)!,
                                    longitudeValue: (pLocation?.coordinate.longitude)!)
                
              
                
                
                
    
                
                
//                //위치변동에 따라 기존에 표시되었던 지역들을 삭제
//                CLGeocoder().reverseGeocodeLocation(pLocation!, completionHandler: {(placemarks, error) -> Void in
//                    let pm = placemarks!.first
//                    let country = pm!.country
//                    var address: String = ""
//                    if country != nil {
//                        address = country!
//                    }
//                    if pm!.locality != nil {
//                        address += " "
//                        address += pm!.locality!
//                    }
//                    if pm!.thoroughfare != nil {
//                        address += " "
//                        address += pm!.thoroughfare!
//                    }
////                    self.lblLocationInfo1.text = "현재 위치"
////                    self.lblLocationInfo2.text = address
//                })
                locationManager.stopUpdatingLocation()
//                self.loadAnnotations(latitudeValue: (pLocation?.coordinate.latitude)!,
//                                     longitudeValue: (pLocation?.coordinate.longitude)!)
                
            }
            
            // 세크먼트 컨트롤을 선택하였을 때 호출
//            @IBAction func sgChangeLocation(_ sender: UISegmentedControl) {
//                if sender.selectedSegmentIndex == 0 {
//                    // "현재 위치" 선택 - 현재 위치 표시
//                    self.lblLocationInfo1.text = ""
//                    self.lblLocationInfo2.text = ""
//                    locationManager.startUpdatingLocation()
//                } else if sender.selectedSegmentIndex == 1 {
//                    // "물왕저수지 정통밥집" 선택 - 핀을 설치하고 위치 정보 표시
//                    setAnnotation(latitudeValue: 37.3826616, longitudeValue: 126.840719, delta: 0.1, title: "물왕저수지 정통밥집", subtitle: "경기 시흥시 동서로857번길 6")
//                    self.lblLocationInfo1.text = "보고 계신 위치"
//                    self.lblLocationInfo2.text = "물왕저수지 정통밥집"
//                } else if sender.selectedSegmentIndex == 2 {
//                    // "이디야 북한산점" 선택 - 핀을 설치하고 위치 정보 표시
//                    setAnnotation(latitudeValue: 37.6447360, longitudeValue: 127.005575, delta: 0.1, title: "이디야 북한산점", subtitle: "서울 강북구 4.19로 85")
//                               self.lblLocationInfo1.text = "보고 계신 위치"
//                               self.lblLocationInfo2.text = "이디야 북한산점"
//                }
//
//            }
    
    
//    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//
//
//
//            let identifier = "MyPin"
//            var  annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView
//
//            if annotationView == nil {
//                annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
//                annotationView?.canShowCallout = true
//
//                if annotation.title! == "부산시민공원" {
//                    annotationView?.pinTintColor = UIColor.green
//                }
//            } else {
//                annotationView?.annotation = annotation
//            }
//
//            let leftIconView = UIImageView(frame: CGRect(x: 0, y: 0, width: 53, height: 53))
//            leftIconView.image = UIImage(named:"bright-7.png" )
//            annotationView?.leftCalloutAccessoryView = leftIconView
//
//            let btn = UIButton(type: .detailDisclosure)
//            annotationView?.rightCalloutAccessoryView = btn
//
//            return annotationView
//
//        }
//
//        func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
//
//            print("callout Accessory Tapped!")
//
//            let viewAnno = view.annotation
//            let viewTitle: String = ((viewAnno?.title)!)!
//            let viewSubTitle: String = ((viewAnno?.subtitle)!)!
//
//            print("\(viewTitle) \(viewSubTitle)")
//
//            let ac = UIAlertController(title: viewTitle, message: viewSubTitle, preferredStyle: .alert)
//            ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//            present(ac, animated: true, completion: nil)
//        }
    
    
//
//    func returnCity(latitudeValue: CLLocationDegrees,
//                    longitudeValue: CLLocationDegrees){
//
//           let converter: LocationConverter = LocationConverter()
//                  let (x, y): (Int, Int)
//                      = converter.convertGrid(lon: longitudeValue, lat: latitudeValue)
//
//                  let findLocation: CLLocation = CLLocation(latitude: latitudeValue, longitude: longitudeValue)
//                  let geoCoder: CLGeocoder = CLGeocoder()
//                  let local: Locale = Locale(identifier: "Ko-kr") // Korea
//                  geoCoder.reverseGeocodeLocation(findLocation, preferredLocale: local) { (place, error) in
//                      if let address: [CLPlacemark] = place {
//                          print("(longitude, latitude) = (\(x), \(y))")
//                          print("시(도): \(address.last?.administrativeArea)")
//                          print("구(군): \(address.last?.locality)")
//                      }
//                  }
//
//
//    }
    
    //어노테이션 관련 메소드 
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
          
        print("mapView메소드")
        if annotation.isKind(of: MKUserLocation.self) {  //Handle user location annotation..
               return nil  //Default is to let the system handle it.
           }

           if !annotation.isKind(of: ImageAnnotation.self) {  //Handle non-ImageAnnotations..
               var pinAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "DefaultPinView")
               if pinAnnotationView == nil {
                   pinAnnotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "DefaultPinView")
               }
               return pinAnnotationView
           }

           //Handle ImageAnnotations..
           var view: ImageAnnotationView? = mapView.dequeueReusableAnnotationView(withIdentifier: "imageAnnotation") as? ImageAnnotationView
           if view == nil {
               view = ImageAnnotationView(annotation: annotation, reuseIdentifier: "imageAnnotation")
           }

           let annotation = annotation as! ImageAnnotation
           view?.image = annotation.image
           view?.annotation = annotation

           return view
       }


       func loadAnnotations(latitudeValue: CLLocationDegrees,
                            longitudeValue: CLLocationDegrees) {
        
        print("loadAnnotations호출")

//           let request = NSMutableURLRequest(url: URL(string: "https://i.imgur.com/zIoAyCx.png")!)
//           request.httpMethod = "GET"
//
//           let session = URLSession(configuration: URLSessionConfiguration.default)
//           let dataTask = session.dataTask(with: request as URLRequest) { (data, response, error) in
//               if error == nil {
//
//                   let annotation = ImageAnnotation()
//                   annotation.coordinate = CLLocationCoordinate2DMake(43.761539, -79.411079)
//                   annotation.image = UIImage(data: data!, scale: UIScreen.main.scale)
//                   annotation.title = "Toronto"
//                   annotation.subtitle = "Yonge & Bloor"
//
//
//                   DispatchQueue.main.async {
//                       self.mapView.addAnnotation(annotation)
//                   }
//               }
//           }

           //dataTask.resume()
        let annotation = ImageAnnotation()
        annotation.coordinate = CLLocationCoordinate2DMake(latitudeValue, longitudeValue)
        annotation.image = UIImage(named: "star_on")
        annotation.title = "Toronto"
        annotation.subtitle = "Yonge & Bloor"
        self.myMap.addAnnotation(annotation)
        
        

        //myMap.MKTileOverlay.canReplaceMapContent
        //지역표시범위로 이동
//        let chicagoCoordinate = CLLocationCoordinate2DMake(latitudeValue, longitudeValue)
//        let region = MKCoordinateRegion.init(center: chicagoCoordinate, latitudinalMeters: 5000, longitudinalMeters: 5000)
//        self.myMap.setRegion(region, animated: true)
       }
    
    
    //지역표시범위
//    func resetRegion(){
//        let chicagoCoordinate = CLLocationCoordinate2DMake(41.8832301, -87.6278121)
//        let region = MKCoordinateRegion.init(center: chicagoCoordinate, latitudinalMeters: 5000, longitudinalMeters: 5000)
//        self.myMap.setRegion(region, animated: true)
//    }
    
    //맵뷰 그려주는 메소드
//    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
//        guard let tileOverlay = overlay as? MKTileOverlay else {
//            return MKOverlayRenderer(overlay: overlay)
//        }
//        return MKTileOverlayRenderer(tileOverlay: tileOverlay)
//    }
    
    
//    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
//       // if overlay is ParkMapOverlay {
//            Alamofire.request("http://www.fcst.pl/poland2k/OUT/FCST/press700.curr.0900lst.d2.body.png").responseImage { response in
//                self.imageMap = response.result.value!
//            }
//            return ParkMapOverlayView(overlay: overlay, overlayImage: imageMap)
//      //  } else if overlay is MKPolyline {
//
//
//  //  }
//
//    }
    
//    func mapView(mapView: MKMapView!, rendererForOverlay overlay: MKOverlay!) -> MKOverlayRenderer!
//      {
//
//              if overlay is MKTileOverlay
//              {
//                print("렌더링메소드")
//                  var renderer = MKTileOverlayRenderer(overlay:overlay)
//
//                  renderer.alpha = 0.8
//
//                  return renderer
//              }
//              return nil
//      }
           
    
    
//    lazy var tilesRenderer : MKTileOverlayRenderer! = {
//
//          let urlTemplate = "http://tile.openstreetmap.org/{z}/{x}/{y}.png"  // URL template is a string where the substrings "{x}", "{y}", "{z}", and "{scale}" are replaced with values from a tile path to create a URL to load. For example: http://server/path?x={x}&y={y}&z={z}&scale={scale}.
//          let overlay = MKTileOverlay.init(urlTemplate: urlTemplate)
//          overlay.isGeometryFlipped = false
//          overlay.canReplaceMapContent = true
//       // self.myMap.addOverlay(overlay, level: MKOverlayLevel.aboveLabels)
//        //self.myMap.addOverlay(T##overlay: MKOverlay##MKOverlay)
//
//
//          let renderer = MKTileOverlayRenderer.init(tileOverlay: overlay)
//          return renderer
//      }()
//
//      public func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer{
//
//          return self.tilesRenderer
//      }
    
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
                print("렌더링메소드")

        guard let tileOverlay = overlay as? MKTileOverlay else {
            return MKOverlayRenderer(overlay: overlay)
        }
        return MKTileOverlayRenderer(tileOverlay: tileOverlay)
    }
}
