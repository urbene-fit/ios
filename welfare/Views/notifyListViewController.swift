//  notifyListViewController.swift
//  welfare
//
// 알림리스트를 보여주는 화면
// 화면구성
// 알림 종류를 선택할수 잇는 상단바
// 알림리스트를 보여주는 테이블 뷰
//  Created by 김동현 on 2020/12/06.


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
    }
    
    
    struct notifyParse: Decodable {
        let Message : [welfList]
    }
    
    
    var date : String = ""
    
    var items: [item] = []
    

    // viewDidLoad: 뷰의 컨트롤러가 메모리에 로드되고 난 후에 호출, 화면이 처음 만들어질 때 한 번만 실행, 일반적으로 리소스를 초기화하거나 초기 화면을 구성하는 용도로 주로 사용
    override func viewDidLoad() {
        super.viewDidLoad()
        
        debugPrint("알림화면")
        
        //화면 스크롤 크기
        let screenWidth = Int(view.bounds.width)
        let screenHeight = Int(view.bounds.height)
        
        
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
                            debugPrint(parseResult.Status)
                            let parseResult = try JSONDecoder().decode(notifyParse.self, from: data)
                            
                            for i in 0..<parseResult.Message.count {
                                
                                let format = DateFormatter()
                                format.dateFormat = "yyyy-MM-dd HH:mm:ss"
                                
                                guard let startTime = format.date(from: parseResult.Message[i].update_date) else {return }
                                let formatter = DateFormatter()
                                formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                                let current_date_string = formatter.string(from: Date())
                                
                                guard let endTime = format.date(from: current_date_string) else {return }
                                let interval = endTime.timeIntervalSince(startTime)
                                let days = Int(interval / 86400)
                                let hours = Int(interval / 3600)
                                
                                
                                if(days > 0){
                                    self.date = "\(days)일전"
                                } else{
                                    self.date = "\(hours)시간전"
                                }
                                
                                
                                self.items.append(item.init(welf_name: parseResult.Message[i].welf_name ,title: parseResult.Message[i].title, content: parseResult.Message[i].content, update_date: self.date, welf_local : parseResult.Message[i].welf_local))
                            }
                            self.alramTbView = UITableView(frame: CGRect(x: 0, y: Int(CGFloat(30  *  DeviceManager.sharedInstance.heightRatio)), width: screenWidth, height: screenHeight - Int(60 *  DeviceManager.sharedInstance.heightRatio)))
                            
                            //테이블 셀간의 줄 없애기
                            self.alramTbView.separatorStyle = UITableViewCell.SeparatorStyle.singleLine
                            self.alramTbView.register(alramTableViewCell.self, forCellReuseIdentifier: alramTableViewCell.identifier)
                            self.alramTbView.dataSource = self
                            self.alramTbView.delegate = self
                            self.alramTbView.rowHeight = 100 * DeviceManager.sharedInstance.heightRatio
                            
                            self.view.addSubview(self.alramTbView)
                        }else{
                            debugPrint("알림 0 개")
                            let reviewLabel = UILabel()
                            reviewLabel.frame = CGRect(x: 20 *  DeviceManager.sharedInstance.widthRatio, y: 200 *  DeviceManager.sharedInstance.heightRatio, width: DeviceManager.sharedInstance.width - 20, height: 30 *  DeviceManager.sharedInstance.heightRatio)
                            reviewLabel.text = "아직 도착한 혜택알림이 없어요"
                            reviewLabel.font = UIFont(name: "Jalnan", size: 19 *  DeviceManager.sharedInstance.heightRatio)
                            self.view.addSubview(reviewLabel)
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
        
        alramTbView = UITableView(frame: CGRect(x: 0, y: Int(30 * DeviceManager.sharedInstance.widthRatio), width: screenWidth, height: screenHeight - Int(60 * DeviceManager.sharedInstance.heightRatio)))
        
        //테이블 셀간의 줄 없애기
        alramTbView.separatorStyle = UITableViewCell.SeparatorStyle.none
        alramTbView.register(alramTableViewCell.self, forCellReuseIdentifier: alramTableViewCell.identifier)
        alramTbView.dataSource = self
        alramTbView.delegate = self
        alramTbView.rowHeight = 100 * DeviceManager.sharedInstance.heightRatio
        alramTbView.separatorStyle = UITableViewCell.SeparatorStyle.none
        
        self.view.addSubview(alramTbView)
    }

    
    // viewDidAppear: 뷰가 화면에 나타난 직후에 실행, 화면에 적용될 애니메이션을 그려줌, 네비게이션 컨트롤러 변경
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        debugPrint("알림 : viewDidAppear")
        
        // 네비게이션 UI 생성
        setBarButton()
    }
    
    
    // 네비게이션 UI 생성
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
        debugPrint("수신알림 선택 ")
        
        //상세페이지로 이동
        guard let RVC = self.storyboard?.instantiateViewController(withIdentifier: "NewDetailView") as? NewDetailView else{
            return
        }
        
        RVC.selectedPolicy = "\(items[indexPath.row].welf_name)"
        RVC.selectedLocal = "\(items[indexPath.row].welf_local)"
        RVC.modalPresentationStyle = .fullScreen
        
        
        self.navigationController?.pushViewController(RVC, animated: true)
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: alramTableViewCell.identifier, for: indexPath) as! alramTableViewCell
        
        cell.alramName.text = "\(items[indexPath.row].title)"
        cell.alramContent.text = "\(items[indexPath.row].content)"
        cell.date.text = "\(items[indexPath.row].update_date)"
        //셀 선택시 회색으로 변하지 않게 하기
        cell.selectionStyle = .none
        
        return cell
    }
}
