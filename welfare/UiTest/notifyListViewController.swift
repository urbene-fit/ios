//
//  notifyListViewController.swift
//  welfare
//
//  Created by 김동현 on 2020/12/06.
//알림리스트를 보여주는 화면

//화면구성
// 알림 종류를 선택할수 잇는 상단바
// 알림리스트를 보여주는 테이블 뷰
///
//

//  Copyright © 2020 com. All rights reserved.
//

import UIKit
import Alamofire


class notifyListViewController: UIViewController, UITableViewDataSource, UISearchBarDelegate, UITableViewDelegate {
    
    
    //알림리스트를 파싱하기 위한 구조체
    struct  localPolicy : Decodable {
        let welf_name: String
    }
    
    //알림리스트를 보여주는 테이블 뷰
    private var alramTbView: UITableView!
    //알림리스트를 보여줄 아이템
    struct item {
        
        var welf_name : String
        var title : String
        var content : String
        var update_date : String
        var welf_local : String

    }
    
    //데이터 파싱
    struct welfList: Decodable {
        // var welf_apply : String
       var welf_name : String
        var title : String
        var content : String
        var update_date : String
        var welf_local : String

    }
    
    
    struct welf_data: Decodable {
        var welf_name : String
        var welf_local : String
        
    }
    
    
    struct parse: Decodable {
        let Status : String
        //반환값이 없을떄 처리
        //let Message : [welfList]
    }
    
    
    struct notifyParse: Decodable {
      //  let Status : String
        //반환값이 없을떄 처리
        let Message : [welfList]
    }
    
    
    var date : String = ""
    
    var items: [item] = []
    
    
    //네비게이션 컨트롤러 변경
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        print("알림 : viewDidAppear")
        //        DuViewController의 view가 사라짐
        //        ReViewViewController의 view가 화면에 나타남
        setBarButton()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print("알림화면")
        
        //화면 스크롤 크기
        var screenWidth = Int(view.bounds.width)
        var screenHeight = Int(view.bounds.height)
        
        
        let headers = ["LoginToken": LoginManager.sharedInstance.token,"SessionId": LoginManager.sharedInstance.sessionID]
        
        let parameters = ["type": "pushList","login_token": LoginManager.sharedInstance.token]
            
            Alamofire.request("https://www.urbene-fit.com/push", method: .get, parameters: parameters,encoding: URLEncoding.default, headers: headers)
                .validate()
                .responseJSON { response in
                    
                    switch response.result {
                    case .success(let value):
                        
                                  
                       
                                        do {
                                            let data = try JSONSerialization.data(withJSONObject: value, options: .prettyPrinted)
                                            let parseResult = try JSONDecoder().decode(parse.self, from: data)
                    
                    
                                            if(parseResult.Status == "200"){
                                                print(parseResult.Status)
                                                let parseResult = try JSONDecoder().decode(notifyParse.self, from: data)
                                                
                                                for i in 0..<parseResult.Message.count {
                    
                    //                                print(parseResult.Message[i].welf_name)
                    //                                print(parseResult.Message[i].title)
                    //                                print(parseResult.Message[i].content)
                                                    print(parseResult.Message[i].update_date)
                                                    let format = DateFormatter()
                                                    format.dateFormat = "yyyy-MM-dd HH:mm:ss"
                                                    guard let startTime = format.date(from: parseResult.Message[i].update_date) else {return }
                                                    var formatter = DateFormatter()
                                                    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                                                    var current_date_string = formatter.string(from: Date())
                                                    print(current_date_string)
                    
                                                    guard let endTime = format.date(from: current_date_string) else {return }
                                                    var useTime = Int(endTime.timeIntervalSince(startTime))
                    
                    //                                print("시간차")
                    //                                print((useTime ))
                    //
                    //                                print((useTime / 360))
                                                    let interval = endTime.timeIntervalSince(startTime)
                                                    let days = Int(interval / 86400)
                                                    let hours = Int(interval / 3600)
                    
                                                    print("\(days) 차이.")
                    
                                                    if(days > 0){
                                                        self.date = "\(days)일전"
                                                    } else{
                                                        self.date = "\(hours)시간전"
                    
                                                    }
                    
                                                    //몇일전인지 계산
                                                    //알림받은지 하루가 안지났으면
                    //                                if(useTime < 60 * 60 * 24){
                    //                                    date = "\(floor(Double(useTime % (60 * 60))) )시간전"
                    //
                    //                                    //몇일이 지난거면
                    //                                }else{
                    //                                    date = "\(floor(Double(useTime % (60 * 60 * 24))) )일전"
                    //
                    //                                }
                    
                    
                                                    self.items.append(item.init(welf_name: parseResult.Message[i].welf_name ,title: parseResult.Message[i].title, content: parseResult.Message[i].content, update_date: self.date, welf_local : parseResult.Message[i].welf_local))
                                            }
                                                self.alramTbView = UITableView(frame: CGRect(x: 0, y: Int(CGFloat(30  *  DeviceManager.sharedInstance.heightRatio)), width: screenWidth, height: screenHeight - Int(60 *  DeviceManager.sharedInstance.heightRatio)))
                        
                                                //테이블 셀간의 줄 없애기
                                                self.alramTbView.separatorStyle = UITableViewCell.SeparatorStyle.singleLine
                        
                                                self.alramTbView.register(alramTableViewCell.self, forCellReuseIdentifier: alramTableViewCell.identifier)
                        
                                                self.alramTbView.dataSource = self
                                                self.alramTbView.delegate = self
                        
                                             //   localTbView.backgroundColor = UIColor.darkGray
                                                self.alramTbView.rowHeight = 100 * DeviceManager.sharedInstance.heightRatio
                        
                                                self.view.addSubview(self.alramTbView)
                                                
                                            }else{
                                                print(parseResult.Status)
                                              
                                                print("알림 0 개")
                                                let reviewLabel = UILabel()
                                                //reviewLabel.backgroundColor = UIColor.white
                                                reviewLabel.frame = CGRect(x: 20 *  DeviceManager.sharedInstance.widthRatio, y: 200 *  DeviceManager.sharedInstance.heightRatio, width: DeviceManager.sharedInstance.width - 20, height: 30 *  DeviceManager.sharedInstance.heightRatio)
                                                reviewLabel.text = "아직 도착한 혜택알림이 없어요"
                                                reviewLabel.font = UIFont(name: "Jalnan", size: 19 *  DeviceManager.sharedInstance.heightRatio)
                                                             self.view.addSubview(reviewLabel)

                    
                                            }
                    
                    
                    
//                                            self.alramTbView = UITableView(frame: CGRect(x: 0, y: Int(CGFloat(30  *  DeviceManager.sharedInstance.heightRatio)), width: screenWidth, height: screenHeight - Int(60 *  DeviceManager.sharedInstance.heightRatio)))
//
//                                            //테이블 셀간의 줄 없애기
//                                            self.alramTbView.separatorStyle = UITableViewCell.SeparatorStyle.singleLine
//
//                                            self.alramTbView.register(alramTableViewCell.self, forCellReuseIdentifier: alramTableViewCell.identifier)
//
//                                            self.alramTbView.dataSource = self
//                                            self.alramTbView.delegate = self
//
//                                         //   localTbView.backgroundColor = UIColor.darkGray
//                                            self.alramTbView.rowHeight = 100 * DeviceManager.sharedInstance.heightRatio
//
//                                            self.view.addSubview(self.alramTbView)
                    

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
        
        
        //네비바 백버튼 설정
//    self.navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
//
//        
//       // self.navigationController?.navigationBar.topItem?.title = "알림"
//        
//        let naviLabel = UILabel()
//       // naviLabel.frame = CGRect(x: 63.8, y: 235.4, width: 118, height: 17.3)
//        naviLabel.textAlignment = .right
//        //naviLabel.textColor = UIColor(displayP3Red: 93/255.0, green: 33/255.0, blue: 210/255.0, alpha: 1)
//        //폰트지정 추가
//        
//        naviLabel.text = "알림"
//        naviLabel.font = UIFont(name: "Jalnan", size: 18.1 * DeviceManager.sharedInstance.heightRatio)
//        
//        self.navigationController?.navigationBar.topItem?.titleView = naviLabel



        
        alramTbView = UITableView(frame: CGRect(x: 0, y: Int(30 * DeviceManager.sharedInstance.widthRatio), width: screenWidth, height: screenHeight - Int(60 * DeviceManager.sharedInstance.heightRatio)))
        
        //테이블 셀간의 줄 없애기
        alramTbView.separatorStyle = UITableViewCell.SeparatorStyle.none
        
        alramTbView.register(alramTableViewCell.self, forCellReuseIdentifier: alramTableViewCell.identifier)
        
        alramTbView.dataSource = self
        alramTbView.delegate = self
        
     //   localTbView.backgroundColor = UIColor.darkGray
        alramTbView.rowHeight = 100 * DeviceManager.sharedInstance.heightRatio
        alramTbView.separatorStyle = UITableViewCell.SeparatorStyle.none
        
        self.view.addSubview(alramTbView)
        
        
        //guard let idToken = UserDefaults.standard.string(forKey: "idToken")! else{return}
//        var idToken = UserDefaults.standard.string(forKey: "idToken")!
//        
//        let parameters = ["type": "pushList","login_token": "123"]
//
//
//        Alamofire.request("https://www.urbene-fit.com/push", method: .get, parameters: ["type": "pushList","login_token": "123"])
//            .validate()
//            .responseJSON { response in
//
//                switch response.result {
//                case .success(let value):
//                    print("통신성공")
//                    if let json = value as? [String: Any] {
//                        //print(json)
//                        for (key, value) in json {
//                            print(key)
//                            print(value)
//
//                        }
//                    }
//                    
////
////                    do {
////                        let data = try JSONSerialization.data(withJSONObject: value, options: .prettyPrinted)
////                        let parseResult = try JSONDecoder().decode(parse.self, from: data)
////
////
////                        if(parseResult.Status == "200"){
////                            print(parseResult.Status)
////                            for i in 0..<parseResult.Message.count {
////
//////                                print(parseResult.Message[i].welf_name)
//////                                print(parseResult.Message[i].title)
//////                                print(parseResult.Message[i].content)
////                                print(parseResult.Message[i].update_date)
////                                let format = DateFormatter()
////                                format.dateFormat = "yyyy-MM-dd HH:mm:ss"
////                                guard let startTime = format.date(from: parseResult.Message[i].update_date) else {return }
////                                var formatter = DateFormatter()
////                                formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
////                                var current_date_string = formatter.string(from: Date())
////                                print(current_date_string)
////
////                                guard let endTime = format.date(from: current_date_string) else {return }
////                                var useTime = Int(endTime.timeIntervalSince(startTime))
////
//////                                print("시간차")
//////                                print((useTime ))
//////
//////                                print((useTime / 360))
////                                let interval = endTime.timeIntervalSince(startTime)
////                                let days = Int(interval / 86400)
////                                let hours = Int(interval / 3600)
////
////                                print("\(days) 차이.")
////
////                                if(days > 0){
////                                                                        date = "\(days)일전"
////                                } else{
////                                                                        date = "\(hours)시간전"
////
////                                }
////
////                                //몇일전인지 계산
////                                //알림받은지 하루가 안지났으면
//////                                if(useTime < 60 * 60 * 24){
//////                                    date = "\(floor(Double(useTime % (60 * 60))) )시간전"
//////
//////                                    //몇일이 지난거면
//////                                }else{
//////                                    date = "\(floor(Double(useTime % (60 * 60 * 24))) )일전"
//////
//////                                }
////
////
////                                items.append(item.init(welf_name: parseResult.Message[i].welf_name, title: parseResult.Message[i].title, content: parseResult.Message[i].content, update_date: date))
////                        }
////                        }else{
////                            print(parseResult.Status)
////
////                        }
////
////
////
////                        alramTbView = UITableView(frame: CGRect(x: 0, y: 30, width: screenWidth, height: screenHeight - 60))
////
////                        //테이블 셀간의 줄 없애기
////                        alramTbView.separatorStyle = UITableViewCell.SeparatorStyle.singleLine
////
////                        alramTbView.register(alramTableViewCell.self, forCellReuseIdentifier: alramTableViewCell.identifier)
////
////                        alramTbView.dataSource = self
////                        alramTbView.delegate = self
////
////                     //   localTbView.backgroundColor = UIColor.darkGray
////                        alramTbView.rowHeight = 100
////
////                        self.view.addSubview(alramTbView)
////
////
////
////
////                    }
////                    catch let DecodingError.dataCorrupted(context) {
////                        print(context)
////                    } catch let DecodingError.keyNotFound(key, context) {
////                        print("Key '\(key)' not found:", context.debugDescription)
////                        print("codingPath:", context.codingPath)
////                    } catch let DecodingError.valueNotFound(value, context) {
////                        print("Value '\(value)' not found:", context.debugDescription)
////                        print("codingPath:", context.codingPath)
////                    } catch let DecodingError.typeMismatch(type, context)  {
////                        print("Type '\(type)' mismatch:", context.debugDescription)
////                        print("codingPath:", context.codingPath)
////                    } catch {
////                        print("error: ", error)
////                    }
////
//
//
//
//
//                case .failure(let error):
//                    print("Error: \(error)")
//                    break
//
//
//                }
//            }
//        
        
    }
    
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
       return items.count
    }
    
    
    //셀 클릭이벤트
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("수신알림 선택 ")
        
        //상세페이지로 이동
        guard let RVC = self.storyboard?.instantiateViewController(withIdentifier: "NewDetailView") as? NewDetailView         else{
            
            return
            
        }
        
        RVC.selectedPolicy = "\(items[indexPath.row].welf_name)"
            RVC.selectedLocal = "\(items[indexPath.row].welf_local)"
        RVC.modalPresentationStyle = .fullScreen

       
        self.navigationController?.pushViewController(RVC, animated: true)
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: alramTableViewCell.identifier, for: indexPath) as! alramTableViewCell
        
        cell.alramName.text = "\(items[indexPath.row].title)"
        cell.alramContent.text = "\(items[indexPath.row].content)"
        cell.date.text = "\(items[indexPath.row].update_date)"
        //셀 선택시 회색으로 변하지 않게 하기
        cell.selectionStyle = .none

        return cell }
    

}
