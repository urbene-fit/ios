//  searchViewController.swift
//  welfare
//
//  Created by 김동현 on 2020/12/13.
//  Copyright © 2020 com. All rights reserved.

import UIKit
import Alamofire
import PopMenu


class searchViewController: UIViewController, UISearchBarDelegate, UITableViewDelegate {
    
    
    //네비게이션 바 변수
    let navBar = UINavigationBar()
    
    
    //검색창 바
    let searchBar = UISearchBar()
    
    
    //선택한 검색어 태그를 저장하는 변수
    var selectTag : String = ""
    
    
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
    
    
    // 메인 UI 담을 변수
    let stackView = UIStackView()
    
    
    // 내용 UI
    let bottomView = UIStackView()
    
    
    // 선택한 지역 정보
    var selectCity = "전국"
    
    
    // 드롭다운 표시할 버튼
    let cityButton = UIButton()
    
    
    // 드랍박스_v1
    var menuItems: [UIAction] {
        return [
            
            UIAction(title: "전국", handler: { (_) in
            }),
            UIAction(title: "강원", handler: { (_) in
            }),
            UIAction(title: "경기", handler: { (_) in
            }),
            UIAction(title: "경남", handler: { (_) in
            }),
            UIAction(title: "경북", handler: { (_) in
            }),
            UIAction(title: "광주", handler: { (_) in
            }),
            UIAction(title: "대구", handler: { (_) in
            }),
            UIAction(title: "대전", handler: { (_) in
            }),
            UIAction(title: "부산", handler: { (_) in
            }),
            UIAction(title: "서울", handler: { (_) in
            }),
            UIAction(title: "세종", handler: { (_) in
            }),
            UIAction(title: "울산", handler: { (_) in
            }),
            UIAction(title: "인천", handler: { (_) in
            }),
            UIAction(title: "전남", handler: { (_) in
            }),
            UIAction(title: "전북", handler: { (_) in
            }),
            UIAction(title: "제주", handler: { (_) in
            }),
            UIAction(title: "충남", handler: { (_) in
            }),
            UIAction(title: "충북", handler: { (_) in
            })
            
            //            UIAction(title: "충남", image: UIImage(systemName: "moon"), attributes: .disabled, handler: { (_) in
            //            }),
            //            UIAction(title: "충북", image: nil, attributes: .destructive, handler: { (_) in
            //            })
        ]
    }
    
    
    var demoMenu: UIMenu {
        return UIMenu(children: menuItems)
    }
    
    
    // 드랍박스_v2, 도시 리스트
    let cityList = [ "전국", "강원", "경기", "경남", "경북", "광주", "대구", "대전", "부산", "서울", "세종", "울산", "인천", "전남", "전북", "제주", "충남", "충북" ]
    
    
    // 드랍박스 틀 생성
    var actions : [PopMenuDefaultAction] = []
    
    
    
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
        //        stackView.spacing = 10 // 배치 뷰 사이 간격 최소값을 결정
        
        
        // 스택 뷰 autolayout 설정
        let safeArea = view.safeAreaLayoutGuide
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 5).isActive = true
        stackView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: 0).isActive = true
        stackView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 0).isActive = true
        stackView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: 0).isActive = true
    }
    
    
    // 서치 바 UI 생성, 참고
    func createSearchBarUI() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "혜택을 검색해보세요"
        searchController.hidesNavigationBarDuringPresentation = false // NavigationTitle 숨김 설정
        searchController.automaticallyShowsCancelButton = false // 자동으로 cancel버튼이 나오게 할지 여부
        searchController.searchBar.delegate = self // 검색창, 서치바를 동작하기 위한 대리자 선언
        searchController.searchBar.sizeToFit()
        
        
        // 드롭 다운 표시할 버튼 UI 생성
        cityButton.frame = CGRect(x: 0, y: 0, width: 100, height: self.accessibilityFrame.height)
        cityButton.backgroundColor = .clear
        cityButton.setTitle("전국", for: .normal)
        cityButton.setTitleColor(UIColor.black, for: .normal)
        cityButton.imageEdgeInsets = UIEdgeInsets(top: 3.0, left: 3.0, bottom: 3.0, right: 3.0)
        cityButton.addTarget(self, action: #selector(self.dropEvent), for: .touchUpInside)
        
        
        let rightButton  = UIButton()
        //this is not taken into account
        rightButton.frame = CGRect(x:0, y:0, width:100, height:self.accessibilityFrame.height)
        rightButton.imageView?.contentMode = .scaleAspectFit
        rightButton.backgroundColor = .blue
        rightButton.setTitle("전국", for: .normal)
        rightButton.setTitleColor(UIColor.black, for: .normal)
        rightButton.setImage(UIImage(named: "searchIcon") , for: .normal)
        rightButton.imageEdgeInsets = UIEdgeInsets(top: 3.0, left: 3.0, bottom: 3.0, right: 3.0)

        
        // 검색바 텍스트 필드 UI 수정
        if let textfield = searchController.searchBar.value(forKey: "searchField") as? UITextField {
            textfield.overrideUserInterfaceStyle = .light
            textfield.backgroundColor = .lightText
            
            textfield.leftView = cityButton
            textfield.leftViewMode = .always
            
            //오른쪽 x버튼 이미지넣기
                       if let rightView = textfield.rightView as? UIImageView {
                           rightView.image = rightView.image?.withRenderingMode(.alwaysTemplate)
                           //이미지 틴트 정하기
                           rightView.tintColor = UIColor.blue
                       }
            
            textfield.autoresizesSubviews = true
           
        }
        
        
        // 버튼 드랍다운_v1 적용 - 참고: https://nemecek.be/blog/85/how-to-show-uimenu-from-uibutton-or-uibarbuttonitem
        //        button.menu = demoMenu
        //        button.showsMenuAsPrimaryAction = true
        
        
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
        
        
        // 빈 뷰 추가 - 간격 벌리기 목적
        let empty = UILabel()
        empty.heightAnchor.constraint(equalToConstant: 10).isActive = true
        
        
        // 메인 뷰 하단 UI
        bottomView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        bottomView.layer.backgroundColor = UIColor.white.cgColor
        bottomView.layer.cornerRadius = 30
        bottomView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        
        // 스택 뷰에 추가
        self.stackView.addArrangedSubview(centerView)
        self.stackView.addArrangedSubview(empty)
        self.stackView.addArrangedSubview(bottomView)
    }
    
    
    // viewDidAppear: 뷰가 화면에 나타난 직후에 실행, 화면에 적용될 애니메이션을 그려줌, 네비게이션 컨트롤러 변경
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        debugPrint("검색 - viewDidAppear")
        
        
        // 네비게이션 UI 생성
        createNaviUI()
    }
    
    
    // 네비게이션 UI 생성
    func createNaviUI() {
        debugPrint("검색 - setBarButton 실행")
        
        
        // 네비게이션 UI 이름 설정
        let naviLabel = UILabel()
        naviLabel.textAlignment = .left
        naviLabel.textColor = .white
        naviLabel.text = "혜택모아"
        naviLabel.font = UIFont(name: "Jalnan", size: 25  *  DeviceManager.sharedInstance.heightRatio)
        self.navigationController?.navigationBar.topItem?.titleView = naviLabel
        
        
        // 뒤로가기 글자 설정
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "혜택모아", style: .plain, target: self, action: nil)
        
        
        // 뒤로가기 폰트 설정
        self.navigationController?.navigationBar.topItem?.backBarButtonItem?.setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "Jalnan", size: 20)!], for: .normal)
        
        
        // 백버튼 색상 변경
        self.navigationController?.navigationBar.tintColor = .white
    }
    
    
    // 드랍박스 버튼 클릭시 실행
    @objc func dropEvent(_ sender: UIButton) {
        
        // 드랍박스 UI 안에 표시할 값 추가
        for i in cityList {
            actions.append(PopMenuDefaultAction(title: i, didSelect: { action in
                
                // 선택한 지역 정보명으로 버튼 타이틀 수정
                self.cityButton.setTitle(action.title, for: .normal)
            }))
        }
        
        
        // 드랍박스 UI 생성 및 설정
        let menu = PopMenuViewController(sourceView: sender, actions: actions)
        menu.appearance.popMenuBackgroundStyle = .dimmed(color: .white, opacity: 0.2)
        menu.appearance.popMenuColor.backgroundColor = .solid(fill: .white) // 내용 배경색
        menu.appearance.popMenuColor.actionColor = .tint(.red) // 글자색
        menu.appearance.popMenuItemSeparator = .fill(.gray, height: 1) // 항목 구분선
        menu.appearance.popMenuActionCountForScrollable = 8 // default 6
        menu.appearance.popMenuScrollIndicatorHidden = true // default false
        menu.appearance.popMenuScrollIndicatorStyle = .black // default .white
        
        
        // 드랍박스 UI 표시
        present(menu, animated: true, completion: nil)
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
                                for i in split {
                                    if(!RVC.categoryItems.contains(i)){
                                        RVC.categoryItems.append(i)
                                    }
                                }
                            }
                            
                            
                            //뷰 이동
                            RVC.modalPresentationStyle = .fullScreen
                            
                            
                            // 상세정보 뷰로 이동
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
}

extension UITextField {
    func rightImage(_ image: UIImage?, imageWidth: CGFloat, padding: CGFloat) {
        let imageView = UIImageView()
        imageView.frame = CGRect(x: padding + 2, y: 0, width: imageWidth, height: frame.height)
        imageView.contentMode = .scaleAspectFit
        imageView.image = image
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: imageWidth + padding , height: frame.height))
        containerView.addSubview(imageView)
        rightView = containerView
        rightViewMode = .always
    }
}
