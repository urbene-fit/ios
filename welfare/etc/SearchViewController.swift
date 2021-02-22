//
//  SearchViewController.swift
//  GatheredYourBenefits
//
//  Created by 김동현 on 2020/09/02.
//  Copyright © 2020 com. All rights reserved.
//
/*
 맞춤정책을 검색하는 뷰
 1 네비게이션 바
 1-1 네비게이션 바에 검색(텍스트 필드)창
 1-2 네비게이션바에 뒤로가기버튼과 삭제버튼
 2 메인 뷰
 
 2-1 메인뷰 상의 태그
 2-1-1 태그를 클릭하면 바로 검색결과
 
 2-2 검색결과를 보여주는 테이블 뷰
 
 */






import UIKit
import Alamofire
import SwiftyJSON


class SearchViewController: UIViewController, UISearchBarDelegate , UITableViewDelegate, UITableViewDataSource{
    
    
    //버튼들을 담을 배열
    var buttons = [UIButton]()
    //태그내용들을 담을 배열
    //임시 더미데이터
    var TagName = ["#아기·어린이","#학생·청년","#중장년·노인","#육아·임신","#장애인","#문화·생활"]
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
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //서치바를 동작하기 위한 대리자 선언
        searchBar.showsScopeBar = true
        
        searchBar.delegate = self
        // 네비게이션 바
        //화면 스크롤 크기
        var screenWidth = view.bounds.width
        var screenHeight = view.bounds.height
        
        
        
        //네비게이션 바 설정
        navBar.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: 40)
        view.addSubview(navBar)
        
        let navItem = UINavigationItem()
        //검색시 사용하는 네비게이션의 텍스트 필드
        let Image = UIImage(named: "back")
        
        //navItem.leftBarButtonItem = UIBarButtonItem(image: Image, style: .done, target: self, action: nil)
        
        // navItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: nil, action: nil)
        
        
        
        
        
        var backbutton = UIButton(type: .custom)
        backbutton.frame = CGRect(x: 0, y: 0, width: 16, height: 16)
        backbutton.setImage(UIImage(named: "BackButton.png"), for: .normal) // Image can be downloaded from here below link
        backbutton.widthAnchor.constraint(equalToConstant: 16.0).isActive = true
        backbutton.heightAnchor.constraint(equalToConstant: 16.0).isActive = true
        backbutton.setTitleColor(backbutton.tintColor, for: .normal)
        
        // You can change the TitleColor
        //backbutton.addTarget(self, action: "backAction", forControlEvents: .TouchUpInside)
        //        backbutton.sizeToFit()
        navItem.leftBarButtonItem = UIBarButtonItem(customView: backbutton)
        
        //서치 바 추가
        searchBar.sizeToFit()
        navItem.titleView = searchBar
        
        
        
        //네비게이션 백버튼
        
        //검색창을 입력할 텍스트 필드
        //        self.SearchView.frame = CGRect(x: 0, y: 5, width: 34, height: 34)
        //
        //
        //        navItem.titleView = self.SearchView
        
        //검색어 삭제 버튼
        //        let CancleBtn = UIBarButtonItem(barButtonSystemItem: .close, target: nil, action:#selector(Cancle))
        //
        //        navItem.rightBarButtonItem = CancleBtn
        //
        //
        navBar.setItems([navItem], animated: false)
        
        
        //태그보여주는 뷰 (라벨 + 태그뷰) 구성
        let MainView = UIView()
        MainView.frame = CGRect(x: 0, y: 72, width: screenWidth, height: 72)
        
        let tagLabel = UILabel()
        tagLabel.frame = CGRect(x: 16, y: 0, width: screenWidth, height: 16)
        tagLabel.text = "이런 건 어때요?"
        MainView.addSubview(tagLabel)
        
        
        
        let tagListLabel = UILabel()
        tagListLabel.frame = CGRect(x: 0, y: 24, width: screenWidth, height: 48)
        //태그 검색으로 사용하는 버튼들
        for i in 0..<TagName.count {
            //print(TagName[i])
            
            
            //태그명의 길이를 센다 한줄에 총합이 10줄이 넘으면 한줄 아래로 배치한다.
            TagLength += TagName[i].count
            if(TagLength > 18){
                TagLength = 0
                TagYPosition += 20
            }
            let button = UIButton(type: .system)
            button.tag = i
            button.addTarget(self, action: #selector(selected), for: .touchUpInside)
            if(i % 3 != 0){
                button.frame = CGRect(x:CGFloat(TagLength * 12 + 10), y:CGFloat(TagYPosition + 48), width: CGFloat(TagLength * 12), height: 12)
            }else if(i == 3){
                button.frame = CGRect(x:CGFloat(5), y:CGFloat(TagYPosition + 48), width: CGFloat(TagLength * 12), height: 12)
            }else{
                button.frame = CGRect(x:CGFloat(0), y:CGFloat(TagYPosition + 48), width: CGFloat(TagLength * 12), height: 12)
            }
            button.setTitle(TagName[i], for: .normal)
            //            var random = arc4random_uniform(255) + 1
            //            var random2 = arc4random_uniform(255) + 1
            //            var random3 = arc4random_uniform(255) + 1
            //
            //            print(random)
            //            button.setTitleColor(UIColor(displayP3Red:CGFloat(random/255),green : CGFloat(random2/255), blue : CGFloat(random3/255), alpha: 1), for: .normal)
            //
            if(i == 0){
                button.setTitleColor(UIColor.blue, for: .normal)
            }else if(i == 1){
                button.setTitleColor(UIColor.purple, for: .normal)
                
            }else if(i == 2){
                button.setTitleColor(UIColor.red, for: .normal)
                
            }else if(i == 3){
                button.setTitleColor(UIColor.systemPink, for: .normal)
                
            }else if(i == 4){
                button.setTitleColor(UIColor.systemYellow, for: .normal)
                
            }else if(i == 5){
                button.setTitleColor(UIColor.brown, for: .normal)
                
            }
            button.backgroundColor = .clear
            
            
            MainView.addSubview(button)
            buttons.append(button)
            
            
            
        }
        
        
        //MainView.addSubview(tagListLabel)
        
        
        
        
        self.view.addSubview(MainView)
        
        
        //검색결과를 보여주는 테이블 뷰
        myTableView = UITableView(frame: CGRect(x: 0, y: 72, width: screenWidth, height: screenHeight - 100))
        myTableView.register(UITableViewCell.self, forCellReuseIdentifier: "MyCell")
        myTableView.dataSource = self
        myTableView.delegate = self
        
        
        
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
    
    
    
    func searchBarSearchButtonClicked(_ seachBar: UISearchBar) {
        
        print("엔터감지")
        //seachBar.text = ""
        var search : String = seachBar.text!
        let params = ["reqBody":search]
        
        Alamofire.request("http://3.34.4.196/backend/ios/ios_search.php", method: .post, parameters: params)
            .validate()
            .responseJSON { response in
                
                switch response.result {
                case .success(let value):
                    //print(value)
                    if let json = value as? [String: Any] {
                       print(json)
                        for (key, value) in json {
                            //버튼들을 추가한다.
                            if(key != "search"){
                                // print(value)
                                self.firstItems.append(value as! String)
                            }
                            else{
                                print("총숫자:")
                                print(value)
                            }
                            
                            
                        }
                        //태그를 보여주는 뷰를 지워준다.
                        self.view.subviews.forEach({ $0.removeFromSuperview() })
                        //검색결과를 보여주는 테이블 뷰를 보여준다.
                        self.view.addSubview(self.navBar)
                        
                        self.view.addSubview(self.myTableView)
                    }
                    
                    
                    
                case .failure(let error):
                    print(error)
                }
                
                
                
                
        }
        
        
        
        
        
        
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
        
        
        
        //검색결과 뷰로 바꿔준다.
        self.view.subviews.forEach({ $0.removeFromSuperview() })
        //검색결과를 보여주는 테이블 뷰를 보여준다.
        self.view.addSubview(navBar)
        
        self.view.addSubview(myTableView)
        
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
        footerView.frame = CGRect(x: 0, y: 0, width: 100, height: 50)
        
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
    
}
