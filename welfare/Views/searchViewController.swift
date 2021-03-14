//  searchViewController.swift
//  welfare
//
//  Created by 김동현 on 2020/12/13.
//  Copyright © 2020 com. All rights reserved.

import UIKit
import Alamofire


// class searchViewController: UIViewController, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate {
class searchViewController: UIViewController, UISearchBarDelegate, UITableViewDelegate {
    
    //버튼들을 담을 배열
    var buttons = [UIButton]()
    
    
    // 태그내용들을 담을 배열, 임시 더미데이터
    var TagName = ["#아기·어린이","#청년","#중장년·노인","#육아·임신","#장애인","#문화·생활"]
    
    
    // 태그 색상을 담을 배열
    var TagColor = ["UIColor.blue","UIColor.purple","UIColor.red","UIColor.systemPink","UIColor.brown","UIColor.orange"]
    
    
    // 태그명 길이를 합산해주는 변수
    var TagLength : Int = 0
    
    
    // 태그를 배치해줄 Y값
    var TagYPosition : Int = 0
    
    
    // 검색결과를 보여주 더미데이터
    // 라벨명을 담을 배열
    private var myTableView: UITableView!
    
    
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
    }
    
    
    struct searchParse: Decodable {
        let Message : [SearchList]
    }
    
    
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
    
    
    // viewDidLoad: 뷰의 컨트롤러가 메모리에 로드되고 난 후에 호출, 화면이 처음 만들어질 때 한 번만 실행, 일반적으로 리소스를 초기화하거나 초기 화면을 구성하는 용도로 주로 사용
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // 네비게이션 바 백버튼 설정 (back 글자 제거)
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        
        
        // 서치 바 UI 생성, 참고 - https://zeddios.tistory.com/1196
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "혜택을 검색해보세요"
        searchController.hidesNavigationBarDuringPresentation = false // NavigationTitle 숨김 설정
        searchController.automaticallyShowsCancelButton = false // 자동으로 cancel버튼이 나오게 할지 여부
        searchController.searchBar.delegate = self // 검색창, 서치바를 동작하기 위한 대리자 선언
        
        
        // 참고: https://stackoverflow.com/questions/58061378/labels-and-text-inside-text-field-becoming-white-automatically-for-ios-13-dark-m
        // 참고: https://fomaios.tistory.com/entry/%EC%84%9C%EC%B9%98%EB%B0%94-%EC%BB%A4%EC%8A%A4%ED%85%80%ED%95%98%EA%B8%B0-Custom-UISearchBar
        if let textfield = searchController.searchBar.value(forKey: "searchField") as? UITextField {
            textfield.overrideUserInterfaceStyle = .light
            textfield.backgroundColor = .lightText
        }
        
        
        // NavigationBar에 SearchBar 추가
        self.navigationItem.searchController = searchController
        self.navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    
    // viewDidAppear: 뷰가 화면에 나타난 직후에 실행, 화면에 적용될 애니메이션을 그려줌, 네비게이션 컨트롤러 변경
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        debugPrint("검색 - viewDidAppear")
        
        // 네비게이션 UI생성
        setBarButton()
        
        // 테마 키워드 - 카테고리 버튼 UI 생성
        for i in 0..<12 {
            let xInt = i % 3
            let yInt = ceil(Double((i)/3))
            
            let button = UIButton(type: .system)
            button.frame = CGRect(x: CGFloat((20 + (130 * xInt)))  * DeviceManager.sharedInstance.widthRatio, y: CGFloat(240 + (60 * yInt))  * DeviceManager.sharedInstance.heightRatio, width: 110 * DeviceManager.sharedInstance.widthRatio, height: 40 * DeviceManager.sharedInstance.heightRatio)
            buttons.append(button)
            
            button.tag = i
            button.setTitle("# \(LabelName[i])", for: .normal)
            button.tintColor = UIColor(displayP3Red:242/255,green : 182/255, blue : 157/255, alpha: 1)
            button.titleLabel?.font = UIFont(name: "Jalnan", size: 12 *  DeviceManager.sharedInstance.heightRatio)!
            button.setTitleColor(UIColor.white, for: .normal)
            button.backgroundColor = UIColor(displayP3Red:242/255,green : 182/255, blue : 157/255, alpha: 1)
            button.layer.cornerRadius = 17 *  DeviceManager.sharedInstance.heightRatio
            button.layer.borderWidth = 0.1
            button.layer.borderColor = UIColor(displayP3Red:242/255,green : 182/255, blue : 157/255, alpha: 1).cgColor
            
            //카테고리 선택시 선택한 카테고리를 저장해주는 메소드
            button.addTarget(self, action: #selector(self.move), for: .touchUpInside)
            
            //카테고리에 사용되는 뷰들을 리스트로 관리해서 선택됫을경우 선탟된 카테고리의 뷰들에 대해 변형해준다.
            self.view.addSubview(button)
        }
    }
    
    
    // 네비게이션 UI 생성
    private func setBarButton() {
        debugPrint("검색 - setBarButton 실행")
        
        self.navigationController?.navigationBar.topItem?.titleView = nil
        self.navigationController?.navigationBar.shadowImage = nil
        self.navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "혜택모아", style: .plain, target: self, action: nil)
        
        // 뒤로가기 폰트 설정
        self.navigationController?.navigationBar.topItem?.backBarButtonItem?.setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "Jalnan", size: 20)!], for: .normal)
        
        // 백버튼 색상 변경
        self.navigationController?.navigationBar.tintColor = .white

        
        
        // 네비게이션바 색 변경 - 참고: https://hyerios.tistory.com/46
        self.navigationController?.navigationBar.barTintColor = UIColor(displayP3Red:242/255,green : 182/255, blue : 157/255, alpha: 1)
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(displayP3Red:242/255,green : 182/255, blue : 157/255, alpha: 1)]
        self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(displayP3Red:242/255,green : 182/255, blue : 157/255, alpha: 1)]
        
        
        let naviLabel = UILabel()
        naviLabel.frame = CGRect(x: 0  *  DeviceManager.sharedInstance.heightRatio, y: 235.4  *  DeviceManager.sharedInstance.heightRatio, width: 118  *  DeviceManager.sharedInstance.heightRatio, height: 17.3  *  DeviceManager.sharedInstance.heightRatio)
        naviLabel.textAlignment = .left
        naviLabel.textColor = .white
        naviLabel.text = "혜택모아"
        naviLabel.font = UIFont(name: "Jalnan", size: 25  *  DeviceManager.sharedInstance.heightRatio)
        self.navigationController?.navigationBar.topItem?.titleView = naviLabel
    }
    
    
    // 엔터 감지하는 함수
    func searchBarSearchButtonClicked(_ seachBar: UISearchBar) {
        debugPrint("search - searchBarSearchButtonClicked 실행, 엔터감지")
        
        let search : String = seachBar.text!
        let params = ["type":"search", "keyword":search, "userAgent" : DeviceManager.sharedInstance.log]
        Alamofire.request("https://www.hyemo.com/welf", method: .get, parameters: params)
            .validate()
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    
                    //상세페이지로 카테고리선택결과 데이터를  전달하기 위해 상세페이지 객체를 선언
                    do {
                        let data = try JSONSerialization.data(withJSONObject: value, options: .prettyPrinted)
                        let parseResult = try JSONDecoder().decode(parse.self, from: data)
                        
                        guard let RVC = self.storyboard?.instantiateViewController(withIdentifier: "NewResultView") as? NewResultView else{
                            return
                        }
                        
                        
                        if(parseResult.Status == "200"){
                            let parseResult = try JSONDecoder().decode(searchParse.self, from: data)
                            
                            for i in 0..<parseResult.Message.count {
                                let tag = parseResult.Message[i].welf_category.replacingOccurrences(of: " ", with: "")
                                let split = tag.components(separatedBy: ";;")
                                
                                RVC.items.append(NewResultView.item.init(welf_name: parseResult.Message[i].welf_name, welf_local: parseResult.Message[i].welf_local, parent_category: parseResult.Message[i].parent_category, welf_category: split, tag: parseResult.Message[i].tag))
                                
                                
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
                        }else{
                            debugPrint(parseResult.Status)
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
    
    
    // 키보드 내리기
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        debugPrint("검색 - touchesBegan() 실헹, 키보드 내리기")
        self.view.endEditing(true)
    }
    
    
    // 테마 키워드 카테고리 버튼 누를 경우 실행
    @objc func move(_ sender: UIButton) {
        debugPrint("검색화면 - move() 실헹, 결과페이지로 이동하는 버튼 클릭")
        
        // 테스트용
        // 상세페이지로 카테고리선택결과 데이터를  전달하기 위해 상세페이지 객체를 선언
        guard let RVC = self.storyboard?.instantiateViewController(withIdentifier: "ThemeListViewController") as? ThemeListViewController else {
            return
        }
        
        
        //뷰 이동
        RVC.modalPresentationStyle = .overFullScreen
        
        // 상세정보 뷰로 이동
        self.navigationController?.pushViewController(RVC, animated: true)
        
        
        
//        let parameters = ["type":"category_search", "keyword":LabelName[sender.tag], "userAgent" : DeviceManager.sharedInstance.log]
//        Alamofire.request("https://www.hyemo.com/welf", method: .get, parameters: parameters)
//            .validate()
//            .responseJSON { response in
//                switch response.result {
//                case .success(let value):
//
//                    //상세페이지로 카테고리선택결과 데이터를  전달하기 위해 상세페이지 객체를 선언
//                    guard let RVC = self.storyboard?.instantiateViewController(withIdentifier: "NewResultView") as? NewResultView else {
//                        return
//                    }
//
//                    do {
//                        let data = try JSONSerialization.data(withJSONObject: value, options: .prettyPrinted)
//                        let parseResult = try JSONDecoder().decode(parse.self, from: data)
//
//                        if(parseResult.Status == "200"){
//                            let parseResult = try JSONDecoder().decode(searchParse.self, from: data)
//                            for i in 0..<parseResult.Message.count {
//                                debugPrint(parseResult.Message[i].tag)
//
//                                //띄어쓰기 되어있는거 처리
//                                let tag = parseResult.Message[i].welf_category.replacingOccurrences(of: " ", with: "")
//                                let split = tag.components(separatedBy: ";;")
//
//
//                                RVC.items.append(NewResultView.item.init(welf_name: parseResult.Message[i].welf_name, welf_local: parseResult.Message[i].welf_local, parent_category: parseResult.Message[i].parent_category, welf_category: split, tag: parseResult.Message[i].tag))
//
//                                //태그 추가
//                                for i in 0..<split.count {
//                                    if(!RVC.categoryItems.contains(split[i])){
//                                        RVC.categoryItems.append(split[i])
//                                    }
//                                }
//                            }
//
//                            //뷰 이동
//                            RVC.modalPresentationStyle = .fullScreen
//
//                            // 상세정보 뷰로 이동
//                            self.navigationController?.pushViewController(RVC, animated: true)
//                        }else{
//                            debugPrint(parseResult.Status)
//                        }
//                    }
//                    catch let DecodingError.dataCorrupted(context) {
//                        debugPrint(context)
//                    } catch let DecodingError.keyNotFound(key, context) {
//                        debugPrint("Key '\(key)' not found:", context.debugDescription)
//                        debugPrint("codingPath:", context.codingPath)
//                    } catch let DecodingError.valueNotFound(value, context) {
//                        debugPrint("Value '\(value)' not found:", context.debugDescription)
//                        debugPrint("codingPath:", context.codingPath)
//                    } catch let DecodingError.typeMismatch(type, context)  {
//                        debugPrint("Type '\(type)' mismatch:", context.debugDescription)
//                        debugPrint("codingPath:", context.codingPath)
//                    } catch {
//                        debugPrint("error: ", error)
//                    }
//                case .failure(let error):
//                    debugPrint(error)
//                }
//            }
    }
}
