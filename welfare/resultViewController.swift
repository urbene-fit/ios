//
//  ResultViewController.swift
//  GatheredYourBenefits
//
//  Created by 김동현 on 2020/09/02.
//  Copyright © 2020 com. All rights reserved.
//

import UIKit

class ResultViewController: UIViewController{
//, UITableViewDelegate, UITableViewDataSource {

    private let myArray: NSArray = ["국가 유공자 보철구 지급","국가 유공자 보철구 지급2","국가 유공자 보철구 지급3","국가 유공자 보철구 지급4","국가 유공자 보철구 지급5","재난재해 피해 지원금 지원6","재난재해 피해 지원금 지원7","재난재해 피해 지원금 지원8","재난재해 피해 지원금 지원9","재난재해 피해 지원금 지원10"]
    private var myTableView: UITableView!
    
    // Define the array to use in the Table.
//    private let iOSItems: [String] = ["국가 유공자 보철구 지급","국가유공자 등 보상금","국가유공자 등 생활조정수당","무공영예수당","애국지사 특별예우금"]
//    private let AOSItems: [String] = ["저소득층 기저귀·조제분유 지원","기초생활수급자를 위한 요금감면제도","영구임대주택 공급","국민임대주택 공급"]
//    // Define the array to be used in Section.
//    private let sections: [String] = ["국가 유공자", "저소득층"]
    
    
    //사용자가 선택한 카테고리의 정책들을 저장한 변수
//    var firstItems = Array<String>()
//    var secItems = Array<String>()
//    var thirdItems = Array<String>()
//    var fourthItems = Array<String>()
//    var fifItems = Array<String>()
//    var sixItems = Array<String>()
//
//
    struct item {
        var name: String
        var sd = Array<String>()
      
    }

    var items: [item] = []


    
    
    //var Items = [[String]]()

    //선택한 카테고리를 저장하는 변수
    var category : String = ""
    
    var sections = Array<String>()

    struct Policy: Codable {
           let id: [String]
           let name: [String]

           private enum CodingKeys: String, CodingKey {
               case id = "학생·청년"
               case name = "중장년·노인"
           }
       }
    
    //선택한 변수 저장
    var names = Array<String>()
    var test = "asd"
    
    //카테고리 결과페이지에서 선택한 정책을 저장하는 변수
    var selectedPolicy : String = ""
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        print(names)
        print(category)
        //화면 스크롤 크기
              var screenWidth = view.bounds.width
              var screenHeight = view.bounds.height
              
        
        
        
        
        //네비게이션 바 설정
        
        
        //let navBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 40))
        //view.addSubview(navBar)
        
        //let navItem = UINavigationItem()
        
               //네비바 검색하러가기 버튼
             let SetBtn = UIButton()
        SetBtn.backgroundColor = UIColor(displayP3Red:192/255,green : 192/255, blue : 192/255, alpha: 1)
                           // Specify the position of the button.
               SetBtn.frame = CGRect(x: 0, y: 4, width: 260, height: 32)
                
        
        
              SetBtn.setTitle("☛맞춤정책 검색하러 가기", for: .normal)
        SetBtn.titleLabel?.font = .systemFont(ofSize: 12)
             SetBtn.setTitleColor(UIColor.black, for: .normal)
        
                             //화면이동 설정 (수정전)
            //  SetBtn.addTarget(self, action: #selector(SetMove), for: .touchUpInside)
                                //set frame
                        
                        //버튼 터두리 설정
                       // SetBtn.backgroundColor = .lightGray
                        SetBtn.layer.cornerRadius = 10
                        SetBtn.layer.borderWidth = 1
                SetBtn.layer.borderColor = UIColor.lightGray.cgColor
                        
             
             
        
       // navItem.titleView = SetBtn
        //let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action:#selector(selectorName))
        
        
                //검색시 사용하는 네비게이션의 텍스트 필드
                let Image = UIImage(named: "back")
                
                //navItem.leftBarButtonItem = UIBarButtonItem(image: Image, style: .done, target: self, action: nil)
                
               // navItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: nil, action: nil)
                
             
                
                
                
                var backbutton = UIButton(type: .custom)
                backbutton.frame = CGRect(x: 0, y: 0, width: 20, height: 16)
                backbutton.setImage(UIImage(named: "BackButton.png"), for: .normal) // Image can be downloaded from here below link
        backbutton.widthAnchor.constraint(equalToConstant: 16.0).isActive = true
                backbutton.heightAnchor.constraint(equalToConstant: 16.0).isActive = true
                backbutton.setTitleColor(backbutton.tintColor, for: .normal) // You can change the TitleColor
                //backbutton.addTarget(self, action: "backAction", forControlEvents: .TouchUpInside)
        //        backbutton.sizeToFit()
                //navItem.leftBarButtonItem = UIBarButtonItem(customView: backbutton)
        
        //navItem.rightBarButtonItem = doneItem

       // navBar.setItems([navItem], animated: false)

        
        //let barHeight: CGFloat = UIApplication.shared.statusBarFrame.size.height

        //let barHeight: CGFloat = (self.navigationController?.navigationBar.frame.size.height)!
        
        
        let displayWidth: CGFloat = self.view.frame.width
        let displayHeight: CGFloat = self.view.frame.height

        
        //복지정책 결과수를 보여주는 라벨
         let subTitle = UILabel(frame: CGRect(x:0, y:44, width: screenWidth, height: 90))
                                
                //subTitle.numberOfLines = 2 //줄 수
                                
                subTitle.textAlignment = .center  // 정렬
                                
                subTitle.textColor = UIColor.gray
                                
                subTitle.font = UIFont.systemFont(ofSize: 20) //font 사이즈
                                
                subTitle.text = "복지혜택 결과가 64개가 있네요"
         subTitle.backgroundColor = UIColor(displayP3Red:86/255,green : 86/255, blue : 86/255, alpha: 1)
         subTitle.textColor = UIColor.white
         subTitle.tintColor = UIColor.white
        
        //self.view.addSubview(subTitle)
        
        
        //정책결과 필터링 해주는 기능
           //필터버튼
             
        
        myTableView = UITableView(frame: CGRect(x: 0, y: 150, width: displayWidth, height: 400))
       
        
        
        //테이블뷰 레이아웃을 설정하기 위해서  Constraints을 풀어놓는다.
        myTableView.translatesAutoresizingMaskIntoConstraints = false

        //테이블 셀간의 줄 없애기
        myTableView.separatorStyle = UITableViewCell.SeparatorStyle.none

        
        //커스텀 테이블뷰를 등록
        //myTableView.register(UITableViewCell.self, forCellReuseIdentifier: "MyCell")
        myTableView.register(MainTableViewCell.self, forCellReuseIdentifier: MainTableViewCell.identifier)

        
//        myTableView.dataSource = self
//        myTableView.delegate = self
//
         myTableView.rowHeight = 100
        //myTableView.separatorStyle = UITableViewCell.SeparatorStyle.none

        self.view.addSubview(myTableView)
        
        
        //테이블 뷰 Constraints설정
        
        let guide = view.safeAreaLayoutGuide
             NSLayoutConstraint.activate([
                 myTableView.topAnchor.constraint(equalTo: guide.topAnchor),
                 myTableView.leadingAnchor.constraint(equalTo: guide.leadingAnchor),
                 myTableView.trailingAnchor.constraint(equalTo: guide.trailingAnchor),
                 myTableView.bottomAnchor.constraint(equalTo: guide.bottomAnchor),
                 ])
        
        //테이블뷰 레이아웃을 설정하기 위해서  Constraints을 다시 고정
        myTableView.translatesAutoresizingMaskIntoConstraints = true

        
        let setBtn = UIButton(type: .system)
        //setBtn.addTarget(self, action: #selector(self.filtering), for: .touchUpInside)
        setBtn.frame = CGRect(x:20, y:80, width: 50, height: 60)
        
        setBtn.setTitle("필터", for: .normal)
        setBtn.setTitleColor(UIColor.black, for: .normal)
        setBtn.backgroundColor = .clear
        setBtn.layer.cornerRadius = 5
        setBtn.layer.borderWidth = 1
        setBtn.layer.borderColor = UIColor.black.cgColor
        self.view.addSubview(setBtn)
        
        
    }


    
//    // Returns the number of sections.
//    func numberOfSections(in tableView: UITableView) -> Int { return sections.count }
//    // Returns the title of the section.
//    //func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? { return sections[section] }
//
////    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
////         //   let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 50))
////
////
////            //더 들어가기 버튼
////                     let footerView = UIButton(type: .system)
////                                  // Specify the position of the button.
////                     footerView.frame = CGRect(x: 0, y: 0, width: 100, height: 50)
////
////                     footerView.setTitle("더 보기", for: .normal)
////                     footerView.setTitleColor(UIColor(displayP3Red:86/255,green : 86/255, blue : 86/255, alpha: 1), for: .normal)
////                  // footerView.setTitleColor = UIColor(displayP3Red:86/255,green : 86/255, blue : 86/255, alpha: 1)
////
////
////                                    //add function for button
////                    // StudentBtn.addTarget(self, action: #selector(targetTapped), for: .touchUpInside)
////                                       //set frame
////
////                               //버튼 터두리 설정
////                     footerView.backgroundColor = .clear
//////                     footerView.layer.cornerRadius = 5
//////                     footerView.layer.borderWidth = 1
//////                     footerView.layer.borderColor = UIColor.systemIndigo.cgColor
////                     footerView.tag = 2
////
////
////
////            return footerView
////        }
//
//
//    //Called when Cell is selected.
//    //정책선택
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print("정책 선택")
//
//
//        for i in 0..<sections.count {
//
//            if indexPath.section == i {
//                if(i == 0){
//                print("Value: \(firstItems[indexPath.row])")
//                    selectedPolicy = (firstItems[indexPath.row])
//
//            }else if(i == 1){
//                print("Value: \(secItems[indexPath.row])")
//                   selectedPolicy = (secItems[indexPath.row])
//
//
//            }else if(i == 2){
//                print("Value: \(thirdItems[indexPath.row])")
//                  selectedPolicy = (thirdItems[indexPath.row])
//
//
//            }else if(i == 3){
//                print("Value: \(fourthItems[indexPath.row])")
//                   selectedPolicy = (fourthItems[indexPath.row])
//
//            }else if(i == 4){
//
//                print("Value: \(fifItems[indexPath.row])")
//                    selectedPolicy = (fifItems[indexPath.row])
//
//
//            }else if(i == 5){
//                print("Value: \(sixItems[indexPath.row])")
//                    selectedPolicy = (sixItems[indexPath.row])
//
//
//                } else { return }
//
//
//
//
//                guard let uvc = self.storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController         else{
//
//                              return
//
//                          }
//
//                uvc.selectedPolicy = self.selectedPolicy
//
//                                          //전환된 화면의 형태지정
//                                          uvc.modalPresentationStyle = .fullScreen
//
//
//                                          //self.navigationController?.pushViewController(uvc, animated: true)
//                                               self.present(uvc, animated: true, completion: nil)
//            }
//        }
//
//
//
//       // if indexPath.section == 0 { print("Value: \(firstItems[indexPath.row])") } else if indexPath.section == 1 { print("Value: \(secItems[indexPath.row])") } else { return }
//
//
//    }
//    // Returns the total number of arrays to display in the table.
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { if section == 0 {
//        return items[section].sd.count
//            //firstItems.count
//
//
//
//    } else if section == 1 {
//        return secItems.count
//
//    } else { return 0 } }
//    // Set a value in Cell.
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        //let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath)
//        let cell = tableView.dequeueReusableCell(withIdentifier: MainTableViewCell.identifier, for: indexPath) as! MainTableViewCell
//
//        if indexPath.section == 0 {
//
//            //cell.textLabel?.text = "\(firstItems[indexPath.row])"
//            cell.policyLank.text = String(indexPath.row)
//                 cell.policyTag.text = "#현금 #지역주민 #교육"
//
//        //} else if indexPath.section == 1 {
//          //  cell.textLabel?.text = "\(secItems[indexPath.row])"
//
//        } else { return UITableViewCell() }
//        return cell }
//
//
//    @objc func selectorName(){
//
//    }
//
//
//
//    //검색화면으로 이동하는 메소드
//    @objc private func SetMove(sender: UIBarButtonItem) {
//
//        print("검색창 이동 버튼 클릭 ")
//        //검색뷰로 이동
//        guard let uvc = self.storyboard?.instantiateViewController(withIdentifier: "SearchViewController")  else{return}
//
//        //전환된 화면의 형태지정
//        uvc.modalPresentationStyle = .fullScreen
//
//
//        //self.navigationController?.pushViewController(uvc, animated: true)
//             self.present(uvc, animated: true, completion: nil)
//
//           }
//
//    //카테고리 선택 후 필터링 화면 이동
//    @objc private func filtering(sender: UIButton) {
//
//        print("검색창 이동 버튼 클릭 ")
//        //검색뷰로 이동
//        guard let uvc = self.storyboard?.instantiateViewController(withIdentifier: "FilterViewController") as? FilterViewController         else{
//
//                                   return
//
//                               }
//        uvc.category = category
//
//        //전환된 화면의 형태지정
//        uvc.modalPresentationStyle = .fullScreen
//
//
//        //self.navigationController?.pushViewController(uvc, animated: true)
//             self.present(uvc, animated: true, completion: nil)
//
//           }
//
//
    
}
