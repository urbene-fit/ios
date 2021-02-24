//
//  testYoutubeViewController.swift
//  welfare
//
//  Created by 김동현 on 2020/12/15.
//  Copyright © 2020 com. All rights reserved.
//

import UIKit
import YoutubePlayer_in_WKWebView
import GoogleAPIClientForREST
import GoogleSignIn
import Alamofire
import Kingfisher

class testYoutubeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    
    
    
    
    
    //유튜브 영상 아이디
    var videoID = String()
    var videoTitle = String()
    
    
    private let scopes = [kGTLRAuthScopeYouTubeReadonly]
    
    //데이터 파싱
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
    
    var items: [saerchList] = []
    
    //유튜버의 다른 영상 목록
    private var resultTbView: UITableView!
    
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
    //본 영상을 제외한 목록
    var filterList = [ytb]()
    
    //유튜브 플레이어
    var player = WKYTPlayerView()
//영상제목
    var titleLabel = UILabel()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //연관영상 목록 받아오기
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
                            //본 페이지 영상 제외
                            self.ytbList.append(ytb.init(videoId: ytbList.Message[i].videoId, title: ytbList.Message[i].title, thumbnail: ytbList.Message[i].thumbnail))
                            
                            if(ytbList.Message[i].videoId != videoID){
                            self.filterList.append(ytb.init(videoId: ytbList.Message[i].videoId, title: ytbList.Message[i].title, thumbnail: ytbList.Message[i].thumbnail))
                            }
                        }
                        
                        resultTbView = UITableView(frame: CGRect(x: 0, y: 530 *  DeviceManager.sharedInstance.heightRatio, width:  CGFloat(DeviceManager.sharedInstance.width), height: CGFloat(DeviceManager.sharedInstance.height) - (550 *  DeviceManager.sharedInstance.heightRatio)))
                        //테이블 셀간의 줄 없애기
                        resultTbView.separatorStyle = UITableViewCell.SeparatorStyle.none
                        //커스텀 테이블뷰를 등록
                        //myTableView.register(UITableViewCell.self, forCellReuseIdentifier: "MyCell")
                        
                        
                        resultTbView.register(YtbCell.self, forCellReuseIdentifier: YtbCell.identifier)
                        
                        resultTbView.dataSource = self
                        resultTbView.delegate = self
                        
                        resultTbView.rowHeight = 200  *  DeviceManager.sharedInstance.heightRatio
                        //myTableView.separatorStyle = UITableViewCell.SeparatorStyle.none
                        
                        self.view.addSubview(resultTbView)
                        
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
        
        
        
        //화면크기
        var screenWidth = Int(view.bounds.width)
        var screenHeight = Int(view.bounds.height)
        //        let naviLabel = UILabel()
        //        naviLabel.frame = CGRect(x: Double(screenWidth/2) - 30 , y: 0, width: 60, height: 17.3)
        //        naviLabel.textAlignment = .center
        //        //naviLabel.textColor = UIColor(displayP3Red: 93/255.0, green: 33/255.0, blue: 210/255.0, alpha: 1)
        //        //폰트지정 추가
        //        naviLabel.text = "유튜버 혜택리뷰"
        //           naviLabel.font = UIFont(name: "Jalnan", size: 16)
        //        self.view.addSubview(naviLabel)
        //
        
       // self.title = "유튜버 혜택리뷰"
        
        
        
        
        //복지관련 영상 검색 -> 영상재생을 위한 영상id
        
        
        player.frame = CGRect(x: 0, y: 110 *  DeviceManager.sharedInstance.heightRatio, width: CGFloat(screenWidth), height: 280 *  DeviceManager.sharedInstance.heightRatio)
        self.view.addSubview(player)
        
        //뷰안에서 재생
        let playVarsDic = ["playsinline": 1]
        player.load(withVideoId: videoID, playerVars: playVarsDic)
        
        // player.load(withVideoId: "Mc0TMWYTU_k")
        
        
        titleLabel.frame = CGRect(x: 20 *  DeviceManager.sharedInstance.heightRatio, y: 420 *  DeviceManager.sharedInstance.heightRatio, width: CGFloat(screenWidth) - (40 *  DeviceManager.sharedInstance.heightRatio), height: 50 *  DeviceManager.sharedInstance.heightRatio)
        titleLabel.textAlignment = .left
        
        //폰트지정 추가
        titleLabel.text = videoTitle
        titleLabel.font = UIFont(name: "Jalnan", size: 16 *  DeviceManager.sharedInstance.heightRatio)
        titleLabel.textColor = UIColor.gray
        titleLabel.numberOfLines = 3
        self.view.addSubview(titleLabel)
        
        //연관정책
        var policyLabel = UILabel()
        
        policyLabel.frame = CGRect(x: 20 *  DeviceManager.sharedInstance.heightRatio, y: 490 *  DeviceManager.sharedInstance.heightRatio, width: CGFloat(screenWidth) - (40 *  DeviceManager.sharedInstance.heightRatio), height: 30 *  DeviceManager.sharedInstance.heightRatio)
        policyLabel.textAlignment = .left
        
        //폰트지정 추가
        policyLabel.text = "다른 혜택리뷰 영상"
        policyLabel.font = UIFont(name: "Jalnan", size: 20)
        self.view.addSubview(policyLabel)
        
        //다른 유튜브 리스트 추가
        
        resultTbView = UITableView(frame: CGRect(x: 0, y: Int(550 *  DeviceManager.sharedInstance.heightRatio), width: Int(DeviceManager.sharedInstance.width), height: Int(DeviceManager.sharedInstance.height) - Int(311.7 *  DeviceManager.sharedInstance.heightRatio)))
        
        
        //테이블 셀간의 줄 없애기
        resultTbView.separatorStyle = UITableViewCell.SeparatorStyle.none
        //커스텀 테이블뷰를 등록
    
        
        
        resultTbView.register(NewResultCell.self, forCellReuseIdentifier: NewResultCell.identifier)
        
        resultTbView.dataSource = self
        resultTbView.delegate = self
        
        resultTbView.rowHeight = 220 *  DeviceManager.sharedInstance.heightRatio
        //myTableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        
        self.view.addSubview(resultTbView)
        
        
        
    }
    
    
    //네비게이션 컨트롤러 변경
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        print("유툽 : viewDidAppear")
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
        naviLabel.frame = CGRect(x: 63.8  *  DeviceManager.sharedInstance.heightRatio, y: 235.4 *  DeviceManager.sharedInstance.heightRatio, width: 118 *  DeviceManager.sharedInstance.heightRatio, height: 17.3 *  DeviceManager.sharedInstance.heightRatio)
        naviLabel.textAlignment = .center
        naviLabel.textColor = UIColor(displayP3Red:238/255,green : 47/255, blue : 67/255, alpha: 1)
        
        naviLabel.text = "UrBene_Fit"
        naviLabel.font = UIFont(name: "Bowhouse-Black", size: 30  *  DeviceManager.sharedInstance.heightRatio)
        self.navigationController?.navigationBar.topItem?.titleView = naviLabel
        
    }
    
    //셀 클릭이벤트
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("유툽 선택")
        
        
        let playVarsDic = ["playsinline": 1]
        self.player.load(withVideoId: filterList[indexPath.row].videoId, playerVars: playVarsDic)
 
        //폰트지정 추가
        titleLabel.text = filterList[indexPath.row].title
        videoID = filterList[indexPath.row].videoId
    
        //다른 영상리스트를 다시 만들어준다
        filterList = [ytb]()

        //리뷰데이터를 테이블아이템에 추가해준다.
        for i in 0..<ytbList.count {
            //본 페이지 영상 제외
        
            
            if(ytbList[i].videoId != videoID){
            self.filterList.append(ytb.init(videoId: ytbList[i].videoId, title: ytbList[i].title, thumbnail: ytbList[i].thumbnail))
            }
        }
        
        //리스트를 관리하는 테이블뷰 리로드
        self.resultTbView.reloadData()
        
        
        //유튜브클릭일 경우
//        guard let RVC = self.storyboard?.instantiateViewController(withIdentifier: "testYoutubeViewController") as? testYoutubeViewController         else{
//
//            return
//
//        }
//        //뷰 이동
//        RVC.modalPresentationStyle = .fullScreen
//
//
//        //선택한 영상의 번호를 스크롤뷰의 x 좌표값을 통해 받아온다.
//        RVC.videoID = ytbList[indexPath.row].videoId
//        RVC.videoTitle = ytbList[indexPath.row].title
        //self.navigationController?.pushViewController(RVC, animated: true)
        
//         for vc in self.navigationController!.viewControllers {
//             if let YoutubeView  = vc as? testYoutubeViewController {
//
//                YoutubeView.videoID = ytbList[indexPath.row].videoId
//                YoutubeView.videoTitle = ytbList[indexPath.row].title
//                YoutubeView.modalPresentationStyle = .fullScreen
//
//                 self.navigationController?.popToViewController(YoutubeView, animated: true)
//             }
//         }
        
        
        
    }
    
    //섹션별 로우 숫자
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return filterList.count
        
    }
    
    //테이블뷰의 셀을 만드는 메소드
    //테이블뷰의 셀이 어떤 커스텀셀을 참조하는지 지정해준다.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: YtbCell.identifier, for: indexPath) as! YtbCell
        
        
        
        
        cell.backgroundColor = UIColor.white
        
                    if let encoded = filterList[indexPath.row].thumbnail.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let myURL = URL(string: encoded) {
        
                        cell.thumbnail.kf.setImage(with: myURL)
        
                           //print(myURL)
        
        
                    }

        //cell.thumbnail.setImage(crop(imgUrl: ytbList[indexPath.row].thumbnail)!)
//        if let encoded =  ytbList[indexPath.row].thumbnail.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let myURL = URL(string: encoded) {
//
//            cell.thumbnail.kf.setImage(with: myURL)
//
//               //print(myURL)
//
//
//        }



        cell.title.text = "\(filterList[indexPath.row].title)"
        
        
        //"\(items[indexPath.row].welf_name)\n(\(items[indexPath.row].parent_category))"
        
        
        return cell }
    
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
        let startPoint = CGPoint(x: 0, y: -45  *  DeviceManager.sharedInstance.heightRatio)
        let endPoint = CGPoint(x: image.size.width, y: image.size.height - (38 *  DeviceManager.sharedInstance.heightRatio))
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        
        image.draw(in: CGRect(origin: startPoint, size: size))
        //image.draw(in: CGRect(origin: startPoint, size : endPoint))
        //image.draw(in: CGRect(x: 0, y: -45, width: image.size.width, height: image.size.height))
        
        let croppedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        
        
        
        return croppedImage
    }
    
}
