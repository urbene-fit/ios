//  NewResultView.swift
//  welfare
//
//  Created by 김동현 on 2020/12/31.
//  Copyright © 2020 com. All rights reserved.

import UIKit
import Alamofire
import DropDown



class NewResultView: UIViewController , UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    
    // 이전 페이지에서 조회한 혜택 정보를 담기 위한 객체
    struct item {
        var welf_name : String
        var welf_local : String
        var parent_category : String
        var welf_category : [String]
        var tag : String
    }
    
    var items: [item] = []
    
    var categoryItems: [String] = ["전체"]
    
    // 메인을 구성하는 이미지 및 라벨 뷰
    let appLogo = UIImageView()
    let resultLabel = UILabel()
    
    //정책검색결과를 보여주는 테이블 뷰
    private var resultTbView: UITableView!
    
    // 카테고리를 선택하게하는 가로 스크롤뷰
    let categoryScrlview = UIScrollView()
    let message : String = "복지 혜택 결과가 '100'개가\n검색되었습니다."
    
    var count : Int = 0
    let footer = UIView()
    
    var itemCount : Int = 0
    var selected : String = "전체"
    
    //카테고리 선택버튼들을 담을 배열
    var buttons = [UIButton]()
    
    
    var filtered : [item] = []
    
    
    //아이템 이미지 불러올때 사용할 자료구조
    var imgDic : [String : String] = ["일자리지원":"job", "공간지원":"house","교육지원":"traning","현금지원":"cash","사업화지원":"business","카드지원":"giftCard","취업지원":"job","활동지원":"activity","보험지원":"insurance","상담지원":"counseling","진료지원":"treat","임대지원":"rent","창업지원":"business","재활지원":"recover","인력지원":"support","물품지원":"goods","현물지원":"goods","숙식지원":"bedBoard","정보지원":"information","멘토링지원":"mentor","감면지원":"tax","대출지원":"loan","치료지원":"care","서비스지원":"service","홍보지원":"service","세탁서비스지원":"service","컨설팅지원":"Consulting"]
    
    
    // 참고: https://www.youtube.com/watch?v=-tpJMQRSl_o
    let menu: DropDown = {
        let menu = DropDown()
        menu.dataSource = [ "전국", "강원", "경기", "경남" , "경북", "광주","대구","대전","부산", "서울", "세종","울산", "인천", "전남", "전북","제주","충남", "충북" ]
        return menu
    }()
    
    
    // set frame
    var dropButton = DropDown()
    
    // 메인 UI
    let stackView = UIStackView()
    
    
    // 내용 UI
    let bottomView = UIStackView()
    
    
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
        
        
        // 배경색 설정
//        stackView.layer.backgroundColor = UIColor.white.cgColor
//
//
//        // 테두리 둥글게 지정
//        stackView.layer.cornerRadius = 30
//        stackView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
//
        
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
    
    
    // 서치 바 UI 생성, 참고 - https://zeddios.tistory.com/1196
    func createSearchBarUI() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "혜택을 검색해보세요"
        searchController.hidesNavigationBarDuringPresentation = false // NavigationTitle 숨김 설정
        searchController.automaticallyShowsCancelButton = false // 자동으로 cancel버튼이 나오게 할지 여부
        searchController.searchBar.delegate = self // 검색창, 서치바를 동작하기 위한 대리자 선언
        searchController.searchBar.sizeToFit()
        
        
        // 드롭 다운이 표시되는보기
        // UIView 또는 UIBarButtonItem
        // Top of drop down will be below the anchorView
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
        }
        
        
        menu.anchorView = button
        
        
        menu.direction = .bottom
        
        
        // 드랍박스 가로 길이 설정
        menu.width = 80
        
        
        // 선택시 트리거되는 작업
        menu.selectionAction = { [unowned self] (index: Int, item: String) in
            debugPrint("Selected item: \(item) at index: \(index)") //Selected item: code at index: 0
        }
        
        
        // NavigationBar에 SearchBar 추가
        self.navigationItem.searchController = searchController
        self.navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    
    // 메인 UI 생성
    func createMainUI() {
        
        // 메인 뷰 상단 UI
        let centerView = UILabel()
        centerView.text = "검색결과 1개 입니다."
        centerView.textColor = .white
        centerView.font = UIFont(name: "Jalnan", size: 20  *  DeviceManager.sharedInstance.heightRatio)
        centerView.textAlignment = .right
        centerView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        centerView.layer.backgroundColor = UIColor.clear.cgColor
        
        
        // 검색 결과 메인 뷰에 적용
        self.stackView.addArrangedSubview(centerView)
        
        
        // 빈 뷰 추가 - 간격 벌리기 목적
        let empty = UILabel()
        empty.heightAnchor.constraint(equalToConstant: 10).isActive = true
        
        
        // 검색 결과 메인 뷰에 적용
        self.stackView.addArrangedSubview(empty)
        
        
        // 이전 클래스에서 받아온 값 조회
        itemCount = items.count
        
        
        // 카테고리 버튼 UI 생성
        for i in 0..<categoryItems.count {
            let button = UIButton(type: .system)
            button.frame = CGRect(x:CGFloat(20 + (Int(100) * i)) *  DeviceManager.sharedInstance.widthRatio, y:10, width: 80 *  DeviceManager.sharedInstance.widthRatio, height: 52 *  DeviceManager.sharedInstance.heightRatio)
            button.setTitle(categoryItems[i], for: .normal)
            button.setTitleColor(.gray, for: .normal)
            button.tintColor = UIColor.gray
            button.titleLabel?.font = UIFont(name: "NanumGothicBold", size: 16 *  DeviceManager.sharedInstance.heightRatio)!

            
            button.layer.backgroundColor = UIColor.white.cgColor
            button.layer.borderColor = UIColor.gray.cgColor
            button.layer.cornerRadius = 15
            button.layer.borderWidth = 1.0
            //button.layer.addCategoryBtnBorder([.bottom], color:#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), width: 1.0)
            button.tag = i
            
            
            //카테고리 선택시 카테고리에 해당하는 데이터만 보여주는 메소드
            button.addTarget(self, action: #selector(self.selectCategory), for: .touchUpInside)
            buttons.append(button)
            categoryScrlview.addSubview(button)
        }
        
        
        // 카테고리 '전체' 버튼색을 빨간색으로 수정
        // buttons[0].layer.addCategoryBtnBorder([.bottom], color:UIColor(displayP3Red:238/255,green : 47/255, blue : 67/255, alpha: 1), width: 1.0)
        
        
        //buttons[0].layer.addCategoryBtnBorder([.bottom], color: UIColor(displayP3Red:242/255,green : 182/255, blue : 157/255, alpha: 1), width: 1.0)
        buttons[0].layer.borderColor = UIColor(displayP3Red:242/255,green : 182/255, blue : 157/255, alpha: 1).cgColor
        buttons[0].setTitleColor(UIColor(displayP3Red:242/255,green : 182/255, blue : 157/255, alpha: 1), for: .normal)
        
        
        // 가로 카테고리 스크롤뷰 추가
        
        categoryScrlview.frame = CGRect(x: 0, y: 120 * DeviceManager.sharedInstance.heightRatio, width: CGFloat(DeviceManager.sharedInstance.width), height: 52 * DeviceManager.sharedInstance.heightRatio)
        categoryScrlview.contentSize = CGSize(width:(CGFloat(100 * categoryItems.count) * DeviceManager.sharedInstance.widthRatio)+20, height: 0)
        categoryScrlview.showsHorizontalScrollIndicator = false
        
        
        categoryScrlview.heightAnchor.constraint(equalToConstant: 50).isActive = true
        // categoryScrlview 메인 뷰에 적용
        
        // 색 지정
        categoryScrlview.backgroundColor = UIColor.white
        
        // 테두리 둥글게 지정
        categoryScrlview.layer.cornerRadius = 30
        categoryScrlview.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        
        self.stackView.addArrangedSubview(categoryScrlview)
        
        
        // UITableView 생성
        resultTbView = UITableView(frame: CGRect(x: 0, y: Int(220 *  DeviceManager.sharedInstance.heightRatio), width: Int(DeviceManager.sharedInstance.width), height: Int(DeviceManager.sharedInstance.height) - Int(311.7 *  DeviceManager.sharedInstance.heightRatio)))
        
        
        // 테이블 셀간의 줄 없애기
        resultTbView.separatorStyle = UITableViewCell.SeparatorStyle.none
        
        
        // 커스텀 테이블뷰를 등록
        // register: 새 테이블 셀을 만드는 데 사용할 클래스를 등록, cellClass: 테이블에서 사용하려는 셀의 클래스 ( 하위 클래스 여야 함 ).UITableViewCell, identifier: 셀의 재사용 식별자입니다. 이 매개 변수는 nil빈 문자열이 아니어야하며 비어 있지 않아야합니다.
        resultTbView.register(NewResultCell.self, forCellReuseIdentifier: NewResultCell.identifier)
        
        // TableView에서 dequeueReusableCell 메소드를 사용하기 위해 cell의 identifier가 필요 따라서 identifier 갑설정
        resultTbView.dataSource = self
        resultTbView.delegate = self
        resultTbView.rowHeight = 220 *  DeviceManager.sharedInstance.heightRatio
        
        
        // 메인 뷰 하단 UI
        resultTbView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        
        // 검색 결과 메인 뷰에 적용
        self.stackView.addArrangedSubview(resultTbView)
    }
    
    
    // viewDidAppear: 뷰가 화면에 나타난 직후에 실행, 화면에 적용될 애니메이션을 그려줌, 네비게이션 컨트롤러 변경
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // 네비게이션 UI 생성
        setBarButton()
    }
    
    
    // 네비게이션 UI 생성
    func setBarButton() {
        debugPrint("검색 - setBarButton 실행")
        
        
        // 뒤로가기 글자 설정
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "혜택모아", style: .plain, target: self, action: nil)
        
        
        // 뒤로가기 폰트 설정
        self.navigationController?.navigationBar.topItem?.backBarButtonItem?.setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "Jalnan", size: 20)!], for: .normal)
        
        
        // 백버튼 색상 변경
        self.navigationController?.navigationBar.tintColor = .white
    }
    
    
    // 상세페이지로 이동한다.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        debugPrint("정책 선택")
        
        guard let RVC = self.storyboard?.instantiateViewController(withIdentifier: "NewDetailView") as? NewDetailView else{
            return
        }
        
        switch selected {
        case "전체":
            RVC.selectedPolicy = "\(items[indexPath.row].welf_name)"
            RVC.selectedLocal = "\(items[indexPath.row].welf_local)"
            let imgName = items[indexPath.row].welf_category[0]
            RVC.selectedImg = imgDic[imgName]!
            
            debugPrint("선택한 정책명 : \(items[indexPath.row].welf_name)")
            debugPrint("선택한 정책의 지역 : \(items[indexPath.row].welf_local)")
            debugPrint("선택한 정책의 카테고리 : \(items[indexPath.row].welf_category[0])")
        default:
            RVC.selectedPolicy = "\(filtered[indexPath.row].welf_name)"
            RVC.selectedLocal = "\(filtered[indexPath.row].welf_local)"
            
            let imgName = filtered[indexPath.row].welf_category[0]
            
            RVC.selectedImg = imgDic[imgName]!
            
            debugPrint("선택한 정책명 : \(filtered[indexPath.row].welf_name), 선택한 정책의 지역 : \(filtered[indexPath.row].welf_local)")
        }
        
        
        RVC.modalPresentationStyle = .fullScreen
        
        
        //혜택 상세보기 페이지로 이동
        //self.present(RVC, animated: true, completion: nil)
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
        // cell.backgroundColor = UIColor(displayP3Red:238/255,green : 47/255, blue : 67/255, alpha: 1)
        
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
            
            let imgName = items[indexPath.row].welf_category[0]
            if(imgDic[imgName] != nil){
                cell.categoryImg.setImage(UIImage(named: imgDic[imgName]!)!)
            }else{
                cell.categoryImg.setImage(UIImage(named: "AppIcon")!)
            }
        default:
            let title = filtered[indexPath.row].welf_name.replacingOccurrences(of: " ", with: "\n")
            cell.policyName.text = "\(title)"
            cell.localName.text = "#\(items[indexPath.row].welf_local)"
            
            let imgName = filtered[indexPath.row].welf_category[0]
            if(imgDic[imgName] != nil){
                cell.categoryImg.setImage(UIImage(named: imgDic[imgName]!)!)
            }else{
                cell.categoryImg.setImage(UIImage(named: "AppIcon")!)
            }
        }
        
        
        cell.categoryImg.backgroundColor = UIColor.clear
        //        cell.layer.shadowColor = UIColor.black.cgColor // 음영
        cell.layer.shadowOffset = CGSize(width: 5, height: 5) // 반경에 대해서 너무 적용이 되어서 4point 정도 내림.
        cell.layer.shadowOpacity = 1
        cell.layer.shadowRadius = 1 // 반경?
        cell.layer.shadowOpacity = 0.5 // alpha값입니다.
        cell.selectionStyle = .none //셀 선택시 회색으로 변하지 않게 하기
        return cell
    }
    
    
    // 카테고리 선택시 실행, 선택한 카테고리 정보 출력
    @objc func selectCategory(_ sender: UIButton) {
        
        // 선택한 카테고리 버튼의 색깔만 빨간색으로 변경
        for i in 0..<buttons.count {
            switch buttons[i].tag {
            case sender.tag:
                buttons[i].setTitleColor(UIColor(displayP3Red:242/255,green : 182/255, blue : 157/255, alpha: 1), for: .normal)
                buttons[i].layer.borderColor = UIColor(displayP3Red:242/255,green : 182/255, blue : 157/255, alpha: 1).cgColor
                //buttons[sender.tag].layer.addCategoryBtnBorder([.bottom], color:UIColor(displayP3Red:238/255,green : 47/255, blue : 67/255, alpha: 1), width: 1.0)
            default:
                buttons[i].layer.borderColor = UIColor.gray.cgColor
//                buttons[i].layer.addCategoryBtnBorder([.bottom], color:#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), width: 1.0)
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
    
    
    // 드랍박스 버튼 클릭시 실행
    @objc func dropEvent(_ sender: UIButton) {
        menu.show()
    }
}
