//
//  searchViewController.swift
//  welfare
//
//  Created by 김동현 on 2020/12/13.
//  Copyright © 2020 com. All rights reserved.
//

import UIKit
import Alamofire

class searchViewController: UIViewController, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate {
    
    //버튼들을 담을 배열
    var buttons = [UIButton]()
    //태그내용들을 담을 배열
    //임시 더미데이터
    var TagName = ["#아기·어린이","#청년","#중장년·노인","#육아·임신","#장애인","#문화·생활"]
    //태그 색상을 담을 배열
    var TagColor = ["UIColor.blue","UIColor.purple","UIColor.red","UIColor.systemPink","UIColor.brown","UIColor.orange"]
    
    //태그명 길이를 합산해주는 변수
    var TagLength : Int = 0
    
    //태그를 배치해줄 Y값
    var TagYPosition : Int = 0
    
    //검색결과를 보여주 더미데이터
    //라벨명을 담을 배열
    private var myTableView: UITableView!
    
    // Define the array to use in the Table.
    // private let iOSItems: [String] = ["저소득층 기저귀,조제분유 지원","육아기 근로시간 단축 지원","출산육아기 고용 안정장려금","출산육아기 대체인력 지원금","배우자 출산휴가급여 지원","직장어린이집 설치 지원","만 0~2세 보육료 지원"]
    
    var firstItems = Array<String>()
    
    
    
    //네비게이션 바 변수
    let navBar = UINavigationBar()
    //검색창 바
    let searchBar = UISearchBar()
    
    //선택한 검색어 태그를 저장하는 변수
    var selectTag : String = ""
    
    
    
    
    //데이터 파싱
    struct SearchList: Decodable {
        var welf_name : String
        var welf_local : String
        var parent_category : String
        var welf_category : String
        var tag : String
        
    }
    
    
    struct parse: Decodable {
        let Status : String
        //반환값이 없을떄 처리
    }
    
    struct searchParse: Decodable {
    
        let Message : [SearchList]
    }
    
    
    
    //    enum MyValue: Codable {
    //        case string(String)
    //        case searchList([SearchList])
    //
    //        init(from decoder: Decoder) throws {
    //            let container = try decoder.singleValueContainer()
    //            if let x = try? container.decode(String.self) {
    //                self = .string(x)
    //                return
    //            }
    //            if let x = try? container.decode(InnerItem.self) {
    //                self = .innerItem(x)
    //                return
    //            }
    //            throw DecodingError.typeMismatch(MyValue.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for MyValue"))
    //        }
    //
    //        func encode(to encoder: Encoder) throws {
    //            var container = encoder.singleValueContainer()
    //            switch self {
    //            case .string(let x):
    //                try container.encode(x)
    //            case .innerItem(let x):
    //                try container.encode(x)
    //            }
    //        }
    //    }
    
    
    struct item {
        
        var welf_name : String
        var welf_local : String
        var parent_category : String
        var welf_category : String
        var tag : String
        
    }
    
    var items: [item] = []
    
    //카테고리 버튼에 사용할 이미지
    var ImgFile = ["Employment","youngman","Dwelling","pregnancy","baby","Cultural","enterprise","BasicLivelihood","oldman","disable","cultures","law","etc"]
    
    //카테고리명들
    var LabelName = ["취업·창업","청년","주거","육아·임신","아기·어린이","문화·생활","기업·자영업자",
                     "저소득층","중장년·노인","장애인","다문화","법률"]
    
    //카테고리 라벨을 담을 배열
    var labels = [UILabel]()
    
    var imgViews = [UIImageView]()
    
    
    // 메인 세로 스크롤
    let m_Scrollview = UIScrollView()

    
    
    //네비게이션 컨트롤러 변경
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        print("검색 : viewDidAppear")
        //        DuViewController의 view가 사라짐
        //        ReViewViewController의 view가 화면에 나타남
        setBarButton()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //서치바를 동작하기 위한 대리자 선언
        searchBar.showsScopeBar = true
        
        searchBar.delegate = self
        // 네비게이션 바
        //화면 스크롤 크기
        var screenWidth = view.bounds.width
        var screenHeight = view.bounds.height
        
        
        //네비바 백버튼 설정
    self.navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)

        
        
        //네비게이션 컨트롤러 설정
        //self.navigationController?.navigationBar.backgroundColor = #colorLiteral(red: 0.9372549057, green: 0.1913873077, blue: 0.2772851493, alpha: 1)
        
        
       
        //        let naviLabel = UILabel()
        //        naviLabel.textAlignment = .right
        //
        //        naviLabel.text = "검색"
        //        naviLabel.font = UIFont(name: "Jalnan", size: 18.1)
        //
        //        self.navigationController?.navigationBar.topItem?.titleView = naviLabel
        
        
        //검색창
        //서치바를 동작하기 위한 대리자 선언
        searchBar.showsScopeBar = true
        
        searchBar.delegate = self
        
        
        searchBar.placeholder = "혜택을 검색해보세요"
        
        //서치 바 추가
        searchBar.frame = CGRect(x: 20 * DeviceManager.sharedInstance.heightRatio, y: 100 * DeviceManager.sharedInstance.heightRatio, width: DeviceManager.sharedInstance.width - (40 * DeviceManager.sharedInstance.heightRatio), height: 50 * DeviceManager.sharedInstance.heightRatio)
        searchBar.backgroundImage = UIImage()
        searchBar.tintColor = UIColor(displayP3Red:238/255,green : 47/255, blue : 67/255, alpha: 1)

//        searchBar.layer.borderWidth = 1
//        searchBar.layer.borderColor = UIColor.white.cgColor
        //searchBar.sizeToFit()
       self.view.addSubview(searchBar)
        //m_Scrollview.addSubview(searchBar)
        
        //추천 검색어 라벨
        let recommendLabel = UILabel()
        //recommendLabel.frame = CGRect(x: 20, y: 180, width: 150, height: 30)
        recommendLabel.text = "추천 검색어"
        recommendLabel.font = UIFont(name: "Jalnan", size: 22  * DeviceManager.sharedInstance.heightRatio)
        //self.view.addSubview(recommendLabel)
        
        
        //최근 검색어 라벨
        let recentLabel = UILabel()
       // recentLabel.frame = CGRect(x: 20, y: 280, width: 150, height: 30)
        recentLabel.frame = CGRect(x: 20 * DeviceManager.sharedInstance.heightRatio, y: 520  * DeviceManager.sharedInstance.heightRatio, width: 400  * DeviceManager.sharedInstance.heightRatio, height: 30  * DeviceManager.sharedInstance.heightRatio)
        recentLabel.text = "최근검색기록"
        recentLabel.font = UIFont(name: "Jalnan", size: 22  * DeviceManager.sharedInstance.heightRatio)
            // self.view.addSubview(recentLabel)
       // m_Scrollview.addSubview(recentLabel)

        
        //최근 카테고리
        let categoryLabel = UILabel()
        //categoryLabel.frame = CGRect(x: 20, y: 380, width: 400, height: 30)
        categoryLabel.frame = CGRect(x: 20 * DeviceManager.sharedInstance.heightRatio, y: 180 * DeviceManager.sharedInstance.heightRatio, width: 400 * DeviceManager.sharedInstance.heightRatio, height: 30 * DeviceManager.sharedInstance.heightRatio)
        categoryLabel.text = "테마 키워드"
        categoryLabel.font = UIFont(name: "Jalnan", size: 22 * DeviceManager.sharedInstance.heightRatio)
        self.view.addSubview(categoryLabel)
        //m_Scrollview.addSubview(categoryLabel)

        
        
        //카테고리 선택버튼 추가하는 부분
        for i in 0..<12 {
            
            var xInt = i % 3
            var yInt = ceil(Double((i)/3))
            
            print("x : \(xInt)")
            print("y : \(yInt)")

            var button = UIButton(type: .system)
          
                      
//            button.frame = CGRect(x: CGFloat((20 + (130 * xInt)))  / DeviceManager.sharedInstance.heightRatio, y: CGFloat(240 + (60 * yInt))  * DeviceManager.sharedInstance.heightRatio, width: 110 * DeviceManager.sharedInstance.heightRatio, height: 40 * DeviceManager.sharedInstance.heightRatio)
            
            button.frame = CGRect(x: CGFloat((20 + (130 * xInt)))  * DeviceManager.sharedInstance.widthRatio, y: CGFloat(240 + (60 * yInt))  * DeviceManager.sharedInstance.heightRatio, width: 110 * DeviceManager.sharedInstance.widthRatio, height: 40 * DeviceManager.sharedInstance.heightRatio)
            
            
            buttons.append(button)
                                  
                                  button.tag = i
            button.setTitle("# \(LabelName[i])", for: .normal)
            button.titleLabel?.font = UIFont(name: "Jalnan", size: 12 *  DeviceManager.sharedInstance.heightRatio)!
            button.setTitleColor(UIColor.white, for: .normal)
                            button.backgroundColor = UIColor(displayP3Red:238/255,green : 47/255, blue : 67/255, alpha: 1)
                            button.layer.cornerRadius = 17 *  DeviceManager.sharedInstance.heightRatio
            button.layer.borderWidth = 0.1
                            button.layer.borderColor = UIColor(displayP3Red:238/255,green : 47/255, blue : 67/255, alpha: 1).cgColor
            
            //카테고리 선택시 선택한 카테고리를 저장해주는 메소드
            button.addTarget(self, action: #selector(self.move), for: .touchUpInside)
            
            //카테고리에 사용되는 뷰들을 리스트로 관리해서 선택됫을경우 선탟된 카테고리의 뷰들
            //에 대해 변형해준다.
            
            
            self.view.addSubview(button)
            //m_Scrollview.addSubview(button)

            

        }
        
//        let singleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(MyTapMethod))
//
//        singleTapGestureRecognizer.numberOfTapsRequired = 1
//
//        singleTapGestureRecognizer.isEnabled = true
//
//        singleTapGestureRecognizer.cancelsTouchesInView = false
//
//        m_Scrollview.addGestureRecognizer(singleTapGestureRecognizer)



        
        

        
        //메인스크롤 뷰 추가
//        m_Scrollview.frame = CGRect(x: 0, y: 110, width: DeviceManager.sharedInstance.width, height: DeviceManager.sharedInstance.height)
//       m_Scrollview.contentSize = CGSize(width:DeviceManager.sharedInstance.width, height: 1060 *  DeviceManager.sharedInstance.heightRatio)
//       self.view.addSubview(m_Scrollview)
        
        
        
        
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    //검색어를 삭제하는 메소드
    //       @objc private func Cancle(sender: UIBarButtonItem) {
    //
    //
    //
    //              }
    
    
    //서치바 관련 메소드
    //    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    //        print("searchText \(searchText)")
    //    }
    
    //    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
    //        print("searchText \(searchBar.text)")
    //    }
    //
    
    
    private func setBarButton() {
        print("ReViewViewController의 setBarButton")
        
        
        self.navigationController?.navigationBar.topItem?.titleView = nil
        self.navigationController?.navigationBar.shadowImage = nil
        self.navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        
        
        let naviLabel = UILabel()
        naviLabel.frame = CGRect(x: 63.8  *  DeviceManager.sharedInstance.heightRatio, y: 235.4  *  DeviceManager.sharedInstance.heightRatio, width: 118  *  DeviceManager.sharedInstance.heightRatio, height: 17.3  *  DeviceManager.sharedInstance.heightRatio)
        naviLabel.textAlignment = .center
        naviLabel.textColor = UIColor(displayP3Red:238/255,green : 47/255, blue : 67/255, alpha: 1)
        
        naviLabel.text = "UrBene_Fit"
        naviLabel.font = UIFont(name: "Bowhouse-Black", size: 30  *  DeviceManager.sharedInstance.heightRatio)
        self.navigationController?.navigationBar.topItem?.titleView = naviLabel
        
    }
    
    @objc func MyTapMethod(sender: UITapGestureRecognizer) {
        print("터치감지")

            //self.view.endEditing(true)
        self.searchBar.resignFirstResponder()//키보드 숨기기

        }



    
    func searchBarSearchButtonClicked(_ seachBar: UISearchBar) {
        
        print("엔터감지")
        //seachBar.text = ""
        let search : String = seachBar.text!
        print(search)
        let params = ["type":"search", "keyword":search, "userAgent" : DeviceManager.sharedInstance.log]
        //let params = ["type":"category_search", "keyword":"취업·창업"]
        
        
        Alamofire.request("https://www.urbene-fit.com/welf", method: .get, parameters: params)
            .validate()
            .responseJSON { response in
                
                switch response.result {
                case .success(let value):
                    
                    //상세페이지로 카테고리선택결과 데이터를  전달하기 위해 상세페이지 객체를 선언
                    
                    
                    do {
                        let data = try JSONSerialization.data(withJSONObject: value, options: .prettyPrinted)
                        let parseResult = try JSONDecoder().decode(parse.self, from: data)
                        
                        guard let RVC = self.storyboard?.instantiateViewController(withIdentifier: "NewResultView") as? NewResultView         else{
                            
                            return
                            
                        }
                        
                        
                        
                        if(parseResult.Status == "200"){
                            print(parseResult.Status)
                            let parseResult = try JSONDecoder().decode(searchParse.self, from: data)
                            for i in 0..<parseResult.Message.count {
                                
                                print(parseResult.Message[i].welf_name)
                                print(parseResult.Message[i].welf_local)
                                print(parseResult.Message[i].parent_category)
                                print(parseResult.Message[i].welf_category)
                                print(parseResult.Message[i].tag)
                        
                                
                                var tag = parseResult.Message[i].welf_category.replacingOccurrences(of: " ", with: "")
                                //split
                                var arr = tag.components(separatedBy: ";;")
                                
                                
                                RVC.items.append(NewResultView.item.init(welf_name: parseResult.Message[i].welf_name, welf_local: parseResult.Message[i].welf_local, parent_category: parseResult.Message[i].parent_category, welf_category: arr, tag: parseResult.Message[i].tag))
                                
                                
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
                            let alert = UIAlertController(title: "알림", message: "다른 검색어로 검색해보세요.", preferredStyle: .alert)

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
        print(params)
        
    }
    
    
    
    
    
    
    
    
    
    
    @objc func selected(_ sender: UIButton) {
        // 원하는 대로 코드 구성
        print("태그 클릭")
        //print(sender.tag)
        
        //태그 클릭하면 선택한 태그값을 저장해준다.
        selectTag = buttons[sender.tag].title(for: .normal)!
        //양쪽끝만 가능한 메소드
        //앞에 붙어있는 태그 삭제
        selectTag = selectTag.trimmingCharacters(in: ["#"])
        
        
        
        //        //검색결과 뷰로 바꿔준다.
        //        self.view.subviews.forEach({ $0.removeFromSuperview() })
        //        //검색결과를 보여주는 테이블 뷰를 보여준다.
        //        self.view.addSubview(navBar)
        //
        //        self.view.addSubview(myTableView)
        
        //상단 검색바에 어떤 태그를 눌러 검색했는지 남겨준다
        searchBar.text = selectTag
        
        
        
    }
    
    
    // Returns the number of sections.
    // Returns the title of the section.
    
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        //   let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 50))
        
        
        //더 들어가기 버튼
        let footerView = UIButton(type: .system)
        // Specify the position of the button.
        footerView.frame = CGRect(x: 0, y: 0, width: 100 * DeviceManager.sharedInstance.heightRatio, height: 50 * DeviceManager.sharedInstance.heightRatio)
        
        footerView.setTitle("더 보기", for: .normal)
        footerView.setTitleColor(UIColor(displayP3Red:86/255,green : 86/255, blue : 86/255, alpha: 1), for: .normal)
        // footerView.setTitleColor = UIColor(displayP3Red:86/255,green : 86/255, blue : 86/255, alpha: 1)
        
        
        //add function for button
        // StudentBtn.addTarget(self, action: #selector(targetTapped), for: .touchUpInside)
        //set frame
        
        //버튼 터두리 설정
        footerView.backgroundColor = .clear
        //                     footerView.layer.cornerRadius = 5
        //                     footerView.layer.borderWidth = 1
        //                     footerView.layer.borderColor = UIColor.systemIndigo.cgColor
        footerView.tag = 2
        
        
        
        return footerView
    }
    
    
    //Called when Cell is selected.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Value: \(firstItems[indexPath.row])")
        
        guard let uvc = self.storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController         else{
            
            return
            
        }
        
        uvc.selectedPolicy = firstItems[indexPath.row]
        
        //전환된 화면의 형태지정
        uvc.modalPresentationStyle = .fullScreen
        
        
        //self.navigationController?.pushViewController(uvc, animated: true)
        self.present(uvc, animated: true, completion: nil)
        
    }
    // Returns the total number of arrays to display in the table.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {  return firstItems.count    }
    // Set a value in Cell.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath)
        cell.textLabel?.text = "\(firstItems[indexPath.row])"
        
        print(firstItems[indexPath.row])
        return cell }
    
    
    
    //키보드 내리기
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        
        self.view.endEditing(true)
        
    }
    
    func endEdit(){
        print("다른 부분 터치")
        self.searchBar.resignFirstResponder()//키보드 숨기기
    }
    
    
    
    @objc func move(_ sender: UIButton) {
        print("결과페이지로 이동하는 버튼 클릭")
        
        print(LabelName[sender.tag])
        
        
        
        let parameters = ["type":"category_search", "keyword":LabelName[sender.tag], "userAgent" : DeviceManager.sharedInstance.log]
        
        Alamofire.request("https://www.urbene-fit.com/welf", method: .get, parameters: parameters)
            .validate()
            .responseJSON { response in
                
                switch response.result {
                case .success(let value):
                    
                    //상세페이지로 카테고리선택결과 데이터를  전달하기 위해 상세페이지 객체를 선언
                    guard let RVC = self.storyboard?.instantiateViewController(withIdentifier: "NewResultView") as? NewResultView         else{
                        
                        return
                        
                    }
                    
                    
                    do {
                        let data = try JSONSerialization.data(withJSONObject: value, options: .prettyPrinted)
                        let parseResult = try JSONDecoder().decode(parse.self, from: data)
                        
                        guard let RVC = self.storyboard?.instantiateViewController(withIdentifier: "NewResultView") as? NewResultView         else{
                            
                            return
                            
                        }
                        
                      //  print(parseResult.Message[0].tag)

                        
                        if(parseResult.Status == "200"){
                            let parseResult = try JSONDecoder().decode(searchParse.self, from: data)
                            for i in 0..<parseResult.Message.count {
                                
//                                print(parseResult.Message[i].welf_name)
//                                print(parseResult.Message[i].welf_local)
//                                print(parseResult.Message[i].parent_category)
//                                print(parseResult.Message[i].welf_category)
                              print(parseResult.Message[i].tag)
                                //
                                //
                                //띄어쓰기 되어있는거 처리
                                var tag = parseResult.Message[i].welf_category.replacingOccurrences(of: " ", with: "")
                                //split
                                var arr = tag.components(separatedBy: ";;")
                                
                                
                                RVC.items.append(NewResultView.item.init(welf_name: parseResult.Message[i].welf_name, welf_local: parseResult.Message[i].welf_local, parent_category: parseResult.Message[i].parent_category, welf_category: arr, tag: parseResult.Message[i].tag))
                                
                                
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
                            self.navigationController?.pushViewController(RVC, animated: true)

                            
                            
                        }else{
                            print(parseResult.Status)
                            
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
        print(parameters)
        
    }
    
    
    
}
