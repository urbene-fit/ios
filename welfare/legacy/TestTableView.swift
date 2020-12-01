//
//  TestTableView.swift
//  welfare
//
//  Created by 김동현 on 2020/08/25.
//  Copyright © 2020 com. All rights reserved.
//

import UIKit

class TestTableView : UIViewController, UITableViewDelegate, UITableViewDataSource {

    private let myArray: NSArray = ["국가 유공자 보철구 지급","국가 유공자 보철구 지급2","국가 유공자 보철구 지급3","국가 유공자 보철구 지급4","국가 유공자 보철구 지급5","재난재해 피해 지원금 지원6","재난재해 피해 지원금 지원7","재난재해 피해 지원금 지원8","재난재해 피해 지원금 지원9","재난재해 피해 지원금 지원10"]
    private var myTableView: UITableView!
    
    // Define the array to use in the Table.
    private let iOSItems: [String] = ["국가 유공자 보철구 지급","국가유공자 등 보상금","국가유공자 등 생활조정수당","무공영예수당","애국지사 특별예우금"]
    private let AOSItems: [String] = ["저소득층 기저귀·조제분유 지원","기초생활수급자를 위한 요금감면제도","영구임대주택 공급","국민임대주택 공급"]
    // Define the array to be used in Section.
    private let sections: [String] = ["국가 유공자", "저소득층"]

   
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        
        //화면 스크롤 크기
              var screenWidth = view.bounds.width
              var screenHeight = view.bounds.height
              
        
        
        

        
        //let barHeight: CGFloat = UIApplication.shared.statusBarFrame.size.height

        let barHeight: CGFloat = (self.navigationController?.navigationBar.frame.size.height)!
        
        
        let displayWidth: CGFloat = self.view.frame.width
        let displayHeight: CGFloat = self.view.frame.height

        
        //복지정책 결과수를 보여주는 라벨
         let subTitle = UILabel(frame: CGRect(x:0, y:barHeight, width: screenWidth, height: 90))
                                
                //subTitle.numberOfLines = 2 //줄 수
                                
                subTitle.textAlignment = .center  // 정렬
                                
                subTitle.textColor = UIColor.gray
                                
                subTitle.font = UIFont.systemFont(ofSize: 20) //font 사이즈
                                
                subTitle.text = "복지혜택 결과가 64개가 있네요"
         subTitle.backgroundColor = UIColor(displayP3Red:86/255,green : 86/255, blue : 86/255, alpha: 1)
         subTitle.textColor = UIColor.white
         subTitle.tintColor = UIColor.white
        
        self.view.addSubview(subTitle)
        
        
        myTableView = UITableView(frame: CGRect(x: 0, y: 150, width: displayWidth, height: displayHeight - 150))
        myTableView.register(UITableViewCell.self, forCellReuseIdentifier: "MyCell")
        myTableView.dataSource = self
        myTableView.delegate = self
        //myTableView.separatorStyle = UITableViewCell.SeparatorStyle.none

        self.view.addSubview(myTableView)
    }

//    //셀 클릭 벤트
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print("Num: \(indexPath.row)")
//        print("Value: \(myArray[indexPath.row])")
//    }
//
//    //테이블뷰에 들어가는 총 숫자
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 5
//    }
//
//    //셀에 데이터 배치
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath as IndexPath)
//        cell.textLabel!.text = "\(myArray[indexPath.row])"
//        return cell
//    }
//
//       //no of sections for the list
//    //섹션숫자
//         func numberOfSections(in tableView: UITableView) -> Int {
//             return 2
//         }
//
//        //no of sections for the list
//
//
//        //테이블뷰 색션 나눠주는 부분
//         //section heading
//         func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//             if section < 5 {
//                 return "섹션"
//             }
//             return nil
//         }
//
//
//
//
//
//
//
//        //테이블뷰 색션 나눠주는 부분
//    //섹션을 반복해서 설정해주는 부분
//    //섹션 해더부분 설정
//         //section heading
////         func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
////             if section < 5{
////                 return "섹션"
////             }
////             return nil
////         }
//
//
//
//    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//     //   let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 50))
//
//
//        //학생
//                 let footerView = UIButton(type: .system)
//                              // Specify the position of the button.
//                 footerView.frame = CGRect(x: 0, y: 0, width: 100, height: 50)
//
//                 footerView.setTitle("학생", for: .normal)
//                 footerView.setTitleColor(UIColor.white, for: .normal)
//
//
//
//                                //add function for button
//                // StudentBtn.addTarget(self, action: #selector(targetTapped), for: .touchUpInside)
//                                   //set frame
//
//                           //버튼 터두리 설정
//                 footerView.backgroundColor = .systemIndigo
//                 footerView.layer.cornerRadius = 5
//                 footerView.layer.borderWidth = 1
//                 footerView.layer.borderColor = UIColor.systemIndigo.cgColor
//                 footerView.tag = 2
//
//
//
//        return footerView
//    }
//
//    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        return 2
//    }
//
//
    
    // Returns the number of sections.
    func numberOfSections(in tableView: UITableView) -> Int { return sections.count }
    // Returns the title of the section.
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? { return sections[section] }
    
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
        if indexPath.section == 0 { print("Value: \(iOSItems[indexPath.row])") } else if indexPath.section == 1 { print("Value: \(AOSItems[indexPath.row])") } else { return } }
    // Returns the total number of arrays to display in the table.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { if section == 0 { return iOSItems.count } else if section == 1 { return AOSItems.count } else { return 0 } }
    // Set a value in Cell.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath)
        if indexPath.section == 0 { cell.textLabel?.text = "\(iOSItems[indexPath.row])" } else if indexPath.section == 1 { cell.textLabel?.text = "\(AOSItems[indexPath.row])" } else { return UITableViewCell() }
        return cell }


    
    
}
