//  searchViewController.swift
//  welfare
//
//  Created by 김동현 on 2020/12/13.
//  Copyright © 2020 com. All rights reserved.

import UIKit
import Alamofire
import DropDown


// https://stackoverflow.com/questions/51789511/want-to-create-a-search-bar-like-google-in-swift
// https://www.swiftdevcenter.com/drop-down-list-ios-swift-5/
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
    
    
    // 검색결과를 보여주 더미데이터, 라벨명을 담을 배열
    var myTableView: UITableView!
    
    
    var firstItems = Array<String>()
    
    
    //네비게이션 바 변수
    let navBar = UINavigationBar()
    
    
    //검색창 바
    let searchBar = UISearchBar()
    
    
    //선택한 검색어 태그를 저장하는 변수
    var selectTag : String = ""
    
    
    struct parse: Codable {
        let Status : String
    }
    
    
    struct orderParse: Codable {
        let Message : String
    }
    
    
    //데이터 파싱
    struct SearchList: Codable {
        var welf_name : String
        var welf_local : String
        var parent_category : String
        var welf_category : String
        var tag : String
    }
    
    
    struct searchParse: Codable {
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
    
    
    let conteainerView = UIView()
    
    
    // 참고: https://www.youtube.com/watch?v=-tpJMQRSl_o
    let menu: DropDown = {
        let menu = DropDown()
        menu.dataSource = [ "전국", "강원", "경기", "경남" , "경북", "광주","대구","대전","부산", "서울", "세종","울산", "인천", "전남", "전북","제주","충남", "충북" ]
        return menu
    }()
    
    
    let stackView = UIStackView()
    
    
    // 내용 UI
    let bottomView = UIStackView()
    
    
    // 선택한 지역 정보
    var selectCity = "전국"
    
    
    // viewDidLoad: 뷰의 컨트롤러가 메모리에 로드되고 난 후에 호출, 화면이 처음 만들어질 때 한 번만 실행, 일반적으로 리소스를 초기화하거나 초기 화면을 구성하는 용도로 주로 사용
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // 배경색 Gradient 적용
        createGradientUI()
        
        
        // 스택 뷰 적용
        createStackViewUI()
        
        
        // 서치 바 UI 생성
        createSearchBarUI()
        
        
        // 메인 UI 생성
        createMainUI()
    }
    
    
    // Gradient 적용
    func createGradientUI() {
        // CAGradientLayouer를 생성해주고
        let gradient = CAGradientLayer()
        
        
        // frame을 잡아주고
        gradient.frame = view.bounds
        
        
        // 섞어줄 색을 colors에 넣어준 뒤
        gradient.colors = [UIColor(displayP3Red:242/255,green : 182/255, blue : 157/255, alpha: 1).cgColor,UIColor(displayP3Red:255/255,green : 112/255, blue : 136/255, alpha: 1).cgColor]
        gradient.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradient.endPoint = CGPoint(x: 0.5, y: 1.0)
        
        
        // layer에 붙여주면 끝!
        self.view.layer.addSublayer(gradient)
    }
    
    
    // 스택 뷰 적용
    func createStackViewUI() {
        // 스택 뷰 적용
        self.view.addSubview(stackView)
        
        
        // 스택 뷰 설정
        stackView.axis = .vertical // 수평 또는 수직 스택의 방향을 결정
        stackView.distribution = .fill // 스택 축을 따라 정렬 된 뷰의 레이아웃을 결정
        stackView.alignment = .fill // 스택 축에 수직으로 정렬 된 뷰의 레이아웃을 결정
        stackView.spacing = 10 // 배치 뷰 사이 간격 최소값을 결정
        
        
        // 스택 뷰 autolayout 설정
        let safeArea = view.safeAreaLayoutGuide
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 5).isActive = true
        stackView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: 0).isActive = true
        stackView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 0).isActive = true
        stackView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: 0).isActive = true
    }
    
    
    // 서치 바 UI 생성, 참고 - https://zeddios.tistory.com/1196
    func createSearchBarUI() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "혜택을 검색해보세요"
        searchController.hidesNavigationBarDuringPresentation = false // NavigationTitle 숨김 설정
        searchController.automaticallyShowsCancelButton = false // 자동으로 cancel버튼이 나오게 할지 여부
        searchController.searchBar.delegate = self // 검색창, 서치바를 동작하기 위한 대리자 선언
        searchController.searchBar.sizeToFit()
        searchController.searchBar.scopeButtonTitles = [ "전국", "강원", "경기", "경남" , "경북", "광주","대구","대전","부산", "서울", "세종","울산", "인천", "전남", "전북","제주","충남", "충북" ]
        searchController.searchBar.showsScopeBar = false
        
        
        // 드롭 다운이 표시되는보기
        let button = UIButton()
        button.frame = CGRect(x: 0, y: 0, width: 100, height: self.accessibilityFrame.height)
        button.backgroundColor = .clear
        button.setTitle("전국", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.addTarget(self, action: #selector(self.dropEvent), for: .touchUpInside)
        
        
        // 참고
        // https://somedd.github.io/TIL_SearchViewControllerAndSearchBar/
        // https://stackoverflow.com/questions/58061378/labels-and-text-inside-text-field-becoming-white-automatically-for-ios-13-dark-m
        // https://fomaios.tistory.com/entry/%EC%84%9C%EC%B9%98%EB%B0%94-%EC%BB%A4%EC%8A%A4%ED%85%80%ED%95%98%EA%B8%B0-Custom-UISearchBar
        if let textfield = searchController.searchBar.value(forKey: "searchField") as? UITextField {
            textfield.overrideUserInterfaceStyle = .light
            textfield.backgroundColor = .lightText
            textfield.leftView = button
//            textfield.leftView?.layer.addCategoryBtnBorder([.left], color:#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), width: 1.0)
//            textfield.leftView?.layer.borderWidth = 1.0
            textfield.leftView?.layer.addBtnBorder([UIRectEdge.left], color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), width: 1.0)
            textfield.leftViewMode = .always
        }
        
        
        // 드랍 다운 정보를 버튼으로 붙이겠습니다.
        menu.anchorView = button
        
        // 버튼을 가리는게 싫을 경우 설정
        menu.bottomOffset = CGPoint(x: 0, y:(menu.anchorView?.plainView.bounds.height)!)
        
        menu.direction = .bottom
        
        
        // 드랍박스 가로 길이 설정
        menu.width = 80
        
        
        // 선택시 트리거되는 작업
        menu.selectionAction = { [unowned self] (index: Int, item: String) in
            debugPrint("Selected item: \(item) at index: \(index)") //Selected item: code at index: 0
            
            // 선택한 지역 정보 저장
            selectCity = item
            
            // 타이틀 이름 수정
            button.setTitle(item, for: .normal)
        }
        
        // NavigationBar에 SearchBar 추가
        self.navigationItem.searchController = searchController
        self.navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    
    // 메인 UI 생성
    func createMainUI() {
        // 메인 뷰 상단 UI
        let centerView = UILabel()
        centerView.textAlignment = .center
        centerView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        centerView.layer.backgroundColor = UIColor.clear.cgColor
        
        
        // 메인 뷰 하단 UI
        bottomView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        bottomView.layer.backgroundColor = UIColor.white.cgColor
        bottomView.layer.cornerRadius = 30
        bottomView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        
        // 스택 뷰에 추가
        self.stackView.addArrangedSubview(centerView)
        self.stackView.addArrangedSubview(bottomView)
    }
    
    
    // viewDidAppear: 뷰가 화면에 나타난 직후에 실행, 화면에 적용될 애니메이션을 그려줌, 네비게이션 컨트롤러 변경
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        debugPrint("검색 - viewDidAppear")
        
        
        // 네비게이션 UI생성
        setBarButton()
    }
    
    
    // 네비게이션 UI 생성
    private func setBarButton() {
        debugPrint("검색 - setBarButton 실행")
        
        // 뒤로가기 글자 설정
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "혜택모아", style: .plain, target: self, action: nil)
        
        // 뒤로가기 폰트 설정
        self.navigationController?.navigationBar.topItem?.backBarButtonItem?.setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "Jalnan", size: 20)!], for: .normal)
        
        // 백버튼 색상 변경
        self.navigationController?.navigationBar.tintColor = .white
        
        
        // 네비게이션바 색 변경 - 참고: https://hyerios.tistory.com/46
        self.navigationController?.navigationBar.barTintColor = UIColor(displayP3Red:242/255,green : 182/255, blue : 157/255, alpha: 1)
        // self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(displayP3Red:242/255,green : 182/255, blue : 157/255, alpha: 1)]
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(displayP3Red:242/255,green : 182/255, blue : 157/255, alpha: 1)]
        
        
        let naviLabel = UILabel()
        naviLabel.textAlignment = .left
        naviLabel.textColor = .white
        naviLabel.text = "혜택모아"
        naviLabel.font = UIFont(name: "Jalnan", size: 25  *  DeviceManager.sharedInstance.heightRatio)
        self.navigationController?.navigationBar.topItem?.titleView = naviLabel
    }
    
    
    // 엔터 감지하는 함수
    func searchBarSearchButtonClicked(_ seachBar: UISearchBar) {
        debugPrint("searchViewController - searchBarSearchButtonClicked 실행, 엔터감지")
        
        let search : String = seachBar.text!
        let params = ["type":"search", "keyword":search, "city":selectCity, "userAgent" : DeviceManager.sharedInstance.log]
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
                        
                        
                        switch parseResult.Status {
                        case "200":
                            let parseResult = try JSONDecoder().decode(searchParse.self, from: data)
                            
                            // 검색 결과값 파싱 해서 처리 후 다음 화면에 전달
                            for i in 0..<parseResult.Message.count {
                                let tag = parseResult.Message[i].welf_category.replacingOccurrences(of: " ", with: "")
                                let split = tag.components(separatedBy: ";;")
                                
                                RVC.items.append(NewResultView.item.init(welf_name: parseResult.Message[i].welf_name, welf_local: parseResult.Message[i].welf_local, parent_category: parseResult.Message[i].parent_category, welf_category: split, tag: parseResult.Message[i].tag))
                                
                                
                                // NewResultView 태그 추가
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
                            debugPrint("Status:", parseResult.Status, ", parseResult:",parseResult)
                            
                            let orderResult = try JSONDecoder().decode(orderParse.self, from: data)
                            
                            // 알림창 출력
                            let alert = UIAlertController(title: "알림", message: orderResult.Message, preferredStyle: .alert)
                            
                            let cancelAction = UIAlertAction(title: "확인", style: .cancel){
                                (action : UIAlertAction) -> Void in
                                alert.dismiss(animated: false)
                            }
                            
                            alert.addAction(cancelAction)
                            
                            self.present(alert, animated: true, completion: nil)
                        }
                    } catch let DecodingError.dataCorrupted(context) {
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
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        debugPrint("searchViewController - touchesBegan() 실헹, 키보드 내리기")
//        self.view.endEditing(true)
//    }
    
    
    // 테마 키워드 카테고리 버튼 누를 경우 실행
    @objc func move(_ sender: UIButton) {
        debugPrint("searchViewController - move() 실헹, 결과페이지로 이동하는 버튼 클릭")
        
        // 테스트용, 상세페이지로 카테고리선택결과 데이터를  전달하기 위해 상세페이지 객체를 선언
        guard let RVC = self.storyboard?.instantiateViewController(withIdentifier: "ThemeListViewController") as? ThemeListViewController else {
            return
        }
        
        
        //뷰 이동
        RVC.modalPresentationStyle = .overFullScreen
        
        
        // 상세정보 뷰로 이동
        self.navigationController?.pushViewController(RVC, animated: true)
    }
    
    
    // 드랍박스 버튼 클릭시 실행
    @objc func dropEvent(_ sender: UIButton) {
        menu.show()
    }
}
