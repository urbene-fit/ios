//  NewResultView.swift
//  welfare
//
//  Created by 김동현 on 2020/12/31.
//  Copyright © 2020 com. All rights reserved.

import UIKit
import Alamofire
import iOSDropDown


class NewResultView: UIViewController , UISearchBarDelegate {
    
    
    // 이전 페이지에서 조회한 혜택 정보를 담기 위한 객체
    struct item {
        var welf_name : String
        var welf_local : String
        var parent_category : String
        var welf_category : [String]
        var tag : String
    }
    
    var items: [item] = []
    
    // ??
    var filtered : [item] = []
    
    
    // 카테고리 정보
    var categoryItems: [String] = []
    
    
    // 메인을 구성하는 이미지 및 라벨 뷰
    let appLogo = UIImageView()
    let resultLabel = UILabel()
    
    
    //정책검색결과를 보여주는 테이블 뷰
    var resultTbView: UITableView!
    
    
    // 카테고리를 선택하게하는 가로 스크롤뷰
    let categoryScrlview = UIScrollView()
    
    
    // 가져온 혜택 갯수
    var itemCount : Int = 0
    
    
    // 선택 정보
    var selected : String = "전체"
    
    
    //카테고리 선택버튼들을 담을 배열
    var buttons = [UIButton]()
    
    
    // 메인 UI
    let stackView = UIStackView()
    
    
    // 내용 UI
    let bottomView = UIStackView()
    
    
    // 선택한 지역 정보
    var selectCity = "전국"
    
    
    // 데이터 파싱 - 서버 결과 상태값
    struct parse: Codable {
        let Status : String
    }
    
    // 데이터 파싱 - 성공 이외 정보값
    struct orderParse: Codable {
        let Message : String
    }
    
    
    // 데이터 파싱 - 성공할 경우 내용 정보들
    struct SearchList: Codable {
        var welf_name : String
        var welf_local : String
        var parent_category : String
        var welf_category : String
        var tag : String
    }
    
    
    // 데이터 파싱 - 성공할 경우
    struct searchParse: Codable {
        let Message : [SearchList]
    }
    
    
    // 드랍박스 UI
    let leftView = UIStackView()
    
    
    // 도시 리스트
    let cityList = [ "전국", "강원", "경기", "경남", "경북", "광주", "대구", "대전", "부산", "서울", "세종", "울산", "인천", "전남", "전북", "제주", "충남", "충북" ]
    
    
    //검색창 바
    let searchBar = UISearchBar()
    
    
    // viewDidLoad: 뷰의 컨트롤러가 메모리에 로드되고 난 후에 호출, 화면이 처음 만들어질 때 한 번만 실행, 일반적으로 리소스를 초기화하거나 초기 화면을 구성하는 용도로 주로 사용
    override func viewDidLoad() {
        super.viewDidLoad()
        debugPrint("검색결과화면: viewDidLoad")
        
        
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
        //        stackView.spacing = 10 // 배치 뷰 사이 간격 최소값을 결정
        
        
        // 스택 뷰 autolayout 설정
        let safeArea = view.safeAreaLayoutGuide
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 5).isActive = true
        stackView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: 0).isActive = true
        stackView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 0).isActive = true
        stackView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: 0).isActive = true
    }
    
    
    // 서치 바 UI 생성
    func createSearchBarUI() {
        
        
        // 스택 뷰에 추가
        self.stackView.addArrangedSubview(leftView)
        
        
        // 가로 스택 뷰 설정
        leftView.translatesAutoresizingMaskIntoConstraints = false
        leftView.heightAnchor.constraint(equalToConstant: 50  *  DeviceManager.sharedInstance.heightRatio).isActive = true
        
        
        // 패딩 증가
        leftView.backgroundColor = .clear
        leftView.axis = .horizontal // 수평 또는 수직 스택의 방향을 결정
        leftView.distribution = .equalSpacing // 스택 축을 따라 정렬 된 뷰의 레이아웃을 결정
        leftView.alignment = .center // 스택 축에 수직으로 정렬 된 뷰의 레이아웃을 결정
        leftView.spacing = 5
        
        
        // 메인 뷰 상단 UI
        let centerView = UILabel()
        centerView.text = "검색결과 "+String(items.count)+"개 입니다. "
        centerView.frame = CGRect(x: 0, y: 0, width: 200, height: 50 * DeviceManager.sharedInstance.heightRatio)
        centerView.textColor = .white
        centerView.font = UIFont(name: "Jalnan", size: 20  *  DeviceManager.sharedInstance.heightRatio)
        centerView.textAlignment = .right
        centerView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        centerView.layer.backgroundColor = UIColor.clear.cgColor
        self.stackView.addArrangedSubview(centerView)
        
        
        // 지역 선택 버튼 - 드랍 박스 추가
        let dropDown = DropDown()
        dropDown.frame = CGRect(x: self.stackView.frame.minX+20, y: 0, width: 100, height: 50 * DeviceManager.sharedInstance.heightRatio)
        dropDown.arrowSize = 10
        dropDown.borderColor = .clear
        dropDown.borderWidth = 1.0
        dropDown.cornerRadius = 5
        dropDown.backgroundColor = UIColor.white
        dropDown.selectedRowColor = UIColor(displayP3Red:242/255,green : 182/255, blue : 157/255, alpha: 1)
        
        
        // 지역 정보 추가
        dropDown.optionArray = cityList
        
        
        // 지역 선택시 발생하는 이벤트 추가
        dropDown.didSelect{(selectedText , index ,id) in
            debugPrint("Selected String: \(selectedText) \n index: \(index)")
            self.selectCity = selectedText
        }
        
        
        self.leftView.addSubview(dropDown)
        
        
        // 참고 - https://medium.com/flawless-app-stories/customize-uisearchbar-for-different-ios-versions-6ee02f4d4419
        self.leftView.addSubview(searchBar)
        searchBar.frame = CGRect(x: self.stackView.frame.minX+130, y: 0, width: 300 * DeviceManager.sharedInstance.heightRatio, height: 50 * DeviceManager.sharedInstance.heightRatio)
        
        
        // 배경색 제거
        searchBar.backgroundColor = .clear
        searchBar.backgroundImage = UIImage()
        
        
        // 검색 텍스트 필드 색 설정
        searchBar.searchTextField.backgroundColor = .white
        
        
        // 검색바 이벤트 추가
        searchBar.delegate = self
    }
    
    
    // 메인 UI 생성
    func createMainUI() {
        
        
        // 빈 뷰 추가 - 간격 벌리기 목적
        let empty = UILabel()
        empty.heightAnchor.constraint(equalToConstant: 10).isActive = true
        
        
        // 이전 클래스에서 받아온 값 저장
        itemCount = items.count
        
        
        // 카테고리 버튼 UI 생성
        for i in 0..<categoryItems.count {
            let button = UIButton(type: .system)
            button.frame = CGRect(x:CGFloat(20 + (Int(100) * i)) *  DeviceManager.sharedInstance.widthRatio, y:10, width: 80 *  DeviceManager.sharedInstance.widthRatio, height: 52 *  DeviceManager.sharedInstance.heightRatio)
            button.setTitle(categoryItems[i], for: .normal)
            button.setTitleColor(.gray, for: .normal)
            button.titleLabel?.font = UIFont(name: "NanumGothicBold", size: 16 *  DeviceManager.sharedInstance.heightRatio)!
            button.tintColor = UIColor.gray
            button.layer.backgroundColor = UIColor.white.cgColor
            button.layer.borderColor = UIColor.gray.cgColor
            button.layer.cornerRadius = 15
            button.layer.borderWidth = 1.0
            button.tag = i
            button.addTarget(self, action: #selector(self.selectCategory), for: .touchUpInside)
            buttons.append(button)
            
            
            // 카테고리 '전체' 버튼색 수정
            if(i == 0) {
                buttons[i].layer.borderColor = UIColor(displayP3Red:242/255,green : 182/255, blue : 157/255, alpha: 1).cgColor
                buttons[i].setTitleColor(UIColor(displayP3Red:242/255,green : 182/255, blue : 157/255, alpha: 1), for: .normal)
            }
            
            categoryScrlview.addSubview(button)
        }
        
        
        // 가로 카테고리 스크롤뷰 추가
        categoryScrlview.frame = CGRect(x: 0, y: 120 * DeviceManager.sharedInstance.heightRatio, width: CGFloat(DeviceManager.sharedInstance.width), height: 52 * DeviceManager.sharedInstance.heightRatio)
        categoryScrlview.contentSize = CGSize(width:(CGFloat(100 * categoryItems.count) * DeviceManager.sharedInstance.widthRatio)+20, height: 0)
        categoryScrlview.showsHorizontalScrollIndicator = false
        categoryScrlview.heightAnchor.constraint(equalToConstant: 50).isActive = true
        categoryScrlview.backgroundColor = UIColor.white // 색 지정
        categoryScrlview.layer.cornerRadius = 30 // 테두리 둥글게 지정
        categoryScrlview.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner] // 밑 동그란 부분 채우게 설정
        categoryScrlview.setContentOffset(CGPoint(x: 0, y: 0), animated: true) // 테이블뷰(스크롤뷰) 상단으로 이동하는 코드 - 참고: https://devsc.tistory.com/94
        
        
        // UITableView 생성
        resultTbView = UITableView(frame: CGRect(x: 0, y: Int(220 *  DeviceManager.sharedInstance.heightRatio), width: Int(DeviceManager.sharedInstance.width), height: Int(DeviceManager.sharedInstance.height) - Int(311.7 *  DeviceManager.sharedInstance.heightRatio)))
        resultTbView.separatorStyle = UITableViewCell.SeparatorStyle.none // 테이블 셀간의 줄 없애기
        resultTbView.register(NewResultCell.self, forCellReuseIdentifier: NewResultCell.identifier) // 커스텀 테이블뷰를 등록
        resultTbView.rowHeight = 220 *  DeviceManager.sharedInstance.heightRatio
        resultTbView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        resultTbView.dataSource = self
        resultTbView.delegate = self
        
        
        // 스택 뷰에 추가
        self.stackView.addArrangedSubview(empty)
        self.stackView.addArrangedSubview(empty)
        self.stackView.addArrangedSubview(categoryScrlview)
        self.stackView.addArrangedSubview(resultTbView)
        
        
        // 레이아웃 재정비
        self.stackView.layoutIfNeeded()
    }
    
    
    // viewDidAppear: 뷰가 화면에 나타난 직후에 실행, 화면에 적용될 애니메이션을 그려줌, 네비게이션 컨트롤러 변경
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
        // 네비게이션 UI 생성
        createNaviUI()
    }
    
    
    // 네비게이션 UI 생성
    func createNaviUI() {
        debugPrint("검색 - setBarButton 실행")
        
        
        // 뒤로가기 글자 설정
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "혜택모아", style: .plain, target: self, action: nil)
        
        
        // 뒤로가기 폰트 설정
        self.navigationController?.navigationBar.topItem?.backBarButtonItem?.setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "Jalnan", size: 20)!], for: .normal)
        
        
        // 백버튼 색상 변경
        self.navigationController?.navigationBar.tintColor = .white
    }
    
    
    // 테이블뷰 내용 리셋
    func resetList() {
        debugPrint("테이블뷰 리스트 리셋 - count:", items.count)
        
        
        selected = buttons[0].title(for: .normal)!
        
        
        // 해당 카테고리의 아이템 숫자를 센다.
        switch selected {
        case "전체":
            itemCount = items.count
        default:
            filtered = items.filter{ $0.welf_category.contains(selected)}
        }
        
        
        // 셀, 섹션 머리글 및 바닥 글, 인덱스 배열 등을 포함하여 테이블을 구성하는 데 사용되는 모든 데이터를 다시로드
        // reloadData: collectionView, tableView 를 새로 그려야 할 경우 가장 먼저 떠오르는 방법
        // 테이블 뷰의 현재 보이는 전체 열(row), 섹션(section) 업데이트를 할 때 사용
        // 특정 열, 섹션의 부분적 업데이트가 아닌, 테이블뷰의 보이는 영역 전체를 업데이트 해줄 때 효율적
        self.resultTbView.reloadData()
    }
    
    
    // 카테고리 선택시 실행, 선택한 카테고리 정보 출력
    @objc func selectCategory(_ sender: UIButton) {
        
        // 선택한 카테고리 버튼의 색깔만 변경
        for i in 0..<buttons.count {
            switch buttons[i].tag {
            case sender.tag:
                buttons[i].setTitleColor(UIColor(displayP3Red:242/255,green : 182/255, blue : 157/255, alpha: 1), for: .normal)
                buttons[i].layer.borderColor = UIColor(displayP3Red:242/255,green : 182/255, blue : 157/255, alpha: 1).cgColor
            // buttons[sender.tag].layer.addCategoryBtnBorder([.bottom], color:UIColor(displayP3Red:238/255,green : 47/255, blue : 67/255, alpha: 1), width: 1.0)
            default:
                buttons[i].layer.borderColor = UIColor.gray.cgColor
                // buttons[i].layer.addCategoryBtnBorder([.bottom], color:#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), width: 1.0)
                buttons[i].setTitleColor(.gray, for: .normal)
            }
        }
        
        
        selected = buttons[sender.tag].title(for: .normal)!
        
        
        // 해당 카테고리의 아이템 숫자를 센다.
        switch selected {
        case "전체":
            itemCount = items.count
        default:
            filtered = items.filter{ $0.welf_category.contains(selected)}
        }
        
        
        // 셀, 섹션 머리글 및 바닥 글, 인덱스 배열 등을 포함하여 테이블을 구성하는 데 사용되는 모든 데이터를 다시로드
        // reloadData: collectionView, tableView 를 새로 그려야 할 경우 가장 먼저 떠오르는 방법
        // 테이블 뷰의 현재 보이는 전체 열(row), 섹션(section) 업데이트를 할 때 사용
        // 특정 열, 섹션의 부분적 업데이트가 아닌, 테이블뷰의 보이는 영역 전체를 업데이트 해줄 때 효율적
        self.resultTbView.reloadData()
    }
    
    
    // 엔터 감지하는 함수
    func searchBarSearchButtonClicked(_ seachBar: UISearchBar) {
        debugPrint("searchViewController - searchBarSearchButtonClicked 실행, 엔터감지")
        
        
        // 검색어가 있는지 확인해보고, 비어있는지 확인하고 출력
        guard let search = seachBar.text, search.isEmpty == false else { return }
        
        let params = ["type":"search", "keyword":search, "city":selectCity, "userAgent" : DeviceManager.sharedInstance.log]
        Alamofire.request("https://www.hyemo.com/welf", method: .get, parameters: params)
            .validate()
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    
                    // 상세페이지로 카테고리선택결과 데이터를  전달하기 위해 상세페이지 객체를 선언
                    do {
                        let data = try JSONSerialization.data(withJSONObject: value, options: .prettyPrinted)
                        let parseResult = try JSONDecoder().decode(parse.self, from: data)
                        
                        switch parseResult.Status {
                        case "200":
                            let parseResult = try JSONDecoder().decode(searchParse.self, from: data)
                            
                            
                            DispatchQueue.global(qos: .background).async {
                                debugPrint("DispatchQueue.global(qos: .background).async 실행")
                                
                                // 기존 값 제거
                                self.items.removeAll()
                                self.categoryItems.removeAll()
                                
                                
                                // 검색 결과값 파싱 해서 처리 후 다음 화면에 전달
                                for i in 0..<parseResult.Message.count {
                                    let tag = parseResult.Message[i].welf_category.replacingOccurrences(of: " ", with: "")
                                    let split = tag.components(separatedBy: ";;")
                                    
                                    
                                    self.items.append(NewResultView.item.init(welf_name: parseResult.Message[i].welf_name, welf_local: parseResult.Message[i].welf_local, parent_category: parseResult.Message[i].parent_category, welf_category: split, tag: parseResult.Message[i].tag))
                                    
                                    
                                    // NewResultView 태그 추가
                                    for i in 0..<split.count {
                                        if(!self.categoryItems.contains(split[i])){
                                            self.categoryItems.append(split[i])
                                        }
                                    }
                                }
                                
                                
                                // UI 관련 작업은 메인 스레드에서!
                                DispatchQueue.main.async { 
                                    debugPrint("DispatchQueue.main.async 실행")
                                    
                                    
                                    // 기존에 생성한 UI 초기화
                                    self.buttons.removeAll()
                                    
                                    // 테이블 뷰의 모든 subview들을 없애는 함수
                                    self.resultTbView.subviews.forEach({ $0.removeFromSuperview() })
                                    
                                    // 레이아웃 재정비
                                    self.resultTbView.layoutIfNeeded()
                                    
                                    
                                    // 스크롤 뷰의 모든 subview들을 없애는 함수
                                    self.categoryScrlview.subviews.forEach({ $0.removeFromSuperview() })
                                    
                                    // 레이아웃 재정비
                                    self.categoryScrlview.layoutIfNeeded()
                                    
                                    
                                    // 스택 뷰의 모든 subview들을 없애는 함수
                                    for subview in self.stackView.arrangedSubviews {
                                        subview.removeFromSuperview()
                                    }
                                    
                                    // 레이아웃 재정비
                                    self.stackView.layoutIfNeeded()
                                    
                                    
                                    // 메인 UI 생성
                                    self.createMainUI()
                                    
                                    
                                    // 테이블뷰 리스트 리셋
                                    self.resetList()
                                    
                                    
                                    // 버튼 값 초기화
                                    self.selected = ""
                                    
                                    
                                    // 검색 포커스 해제
                                    self.navigationItem.searchController?.isActive = false
                                }
                            }
                        default:
                            // 알림창 출력
                            debugPrint("Status:", parseResult.Status, ", parseResult:",parseResult)
                            
                            let orderResult = try JSONDecoder().decode(orderParse.self, from: data)
                            
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
}


extension NewResultView : UITableViewDelegate, UITableViewDataSource {
    
    
    // 혜택 클릭시 실행
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        debugPrint("정책 선택")
        
        
        // 상세페이지로 이동한다.
        guard let RVC = self.storyboard?.instantiateViewController(withIdentifier: "NewDetailView") as? NewDetailView else{
            return
        }
        
        
        switch selected {
        case "전체":
            RVC.selectedPolicy = "\(items[indexPath.row].welf_name)"
            RVC.selectedLocal = "\(items[indexPath.row].welf_local)"
            
            debugPrint("선택한 정책명 : \(items[indexPath.row].welf_name), 선택한 정책의 지역 : \(items[indexPath.row].welf_local), 선택한 정책의 카테고리 : \(items[indexPath.row].welf_category[0])")
        default:
            RVC.selectedPolicy = "\(filtered[indexPath.row].welf_name)"
            RVC.selectedLocal = "\(filtered[indexPath.row].welf_local)"
            
            debugPrint("선택한 정책명 : \(filtered[indexPath.row].welf_name), 선택한 정책의 지역 : \(filtered[indexPath.row].welf_local)")
        }
        
        
        RVC.modalPresentationStyle = .fullScreen
        
        
        //혜택 상세보기 페이지로 이동
        self.navigationController?.pushViewController(RVC, animated: true)
    }
    
    
    // 섹션별 행 숫자
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        debugPrint("행 숫자: \(itemCount)")
        
        
        switch selected {
        case ("전체"):
            return itemCount
        case (let value) where value != "전체":
            return filtered.count
        default:
            return itemCount
        }
    }
    
    
    // 테이블뷰의 셀을 만드는 메소드, 테이블뷰의 셀이 어떤 커스텀셀을 참조하는지 지정해준다. 실제 셀에 데이터를 반환하는 메소드, (필수)
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NewResultCell.identifier, for: indexPath) as! NewResultCell
        
        
        //아이템의 제목을 받아 바꿔준다
        cell.backgroundColor = UIColor.white
        cell.layer.borderColor = UIColor.gray.cgColor
        cell.layer.borderWidth = 1.3
        cell.layer.cornerRadius = 34 *  DeviceManager.sharedInstance.heightRatio
        cell.clipsToBounds = true
        
        
        switch selected {
        case "전체":
            let title = items[indexPath.row].welf_name.replacingOccurrences(of: " ", with: "\n")
            cell.policyName.text = "\(title)"
            cell.localName.text = "#\(items[indexPath.row].welf_local)"
        default:
            let title = filtered[indexPath.row].welf_name.replacingOccurrences(of: " ", with: "\n")
            cell.policyName.text = "\(title)"
            cell.localName.text = "#\(items[indexPath.row].welf_local)"
        }
        
        
        // 정책 이름 설정
//        cell.policyName.backgroundColor = .yellow
        cell.policyName.lineBreakStrategy = .hangulWordPriority
        
        cell.layer.shadowOffset = CGSize(width: 5, height: 5) // 반경에 대해서 너무 적용이 되어서 4point 정도 내림.
        cell.layer.shadowRadius = 1 // 반경?
        cell.layer.shadowOpacity = 0.5 // alpha값입니다.
        cell.selectionStyle = .none //셀 선택시 회색으로 변하지 않게 하기
        return cell
    }
}
