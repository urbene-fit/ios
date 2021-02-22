//
//  FilterViewController.swift
//  welfare
//
//  Created by 김동현 on 2020/10/07.
//  Copyright © 2020 com. All rights reserved.
//

import UIKit
import Alamofire


class FilterViewController: UIViewController {
    
    
    var screenWidth: Int = 0
    var  screenHeight : Int = 0
    
    
    //버튼들을 담을 배열
    var buttons = [UIButton]()
    
    struct Policy: Codable {
        
        
        let second_layer : [String]?
        let welfare_list : [String]?

        
        
        
        
    }
    
    //1차 카테고리
    var category = ""
    //2차 카테고리
    var category2 = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //화면 스크롤 크기
        var screenWidth = view.bounds.width
        var screenHeight = view.bounds.height
        
        
        //적용하기 버튼
        let applyBtn = UIButton(type: .system)
        
        applyBtn.addTarget(self, action: #selector(self.apply), for: .touchUpInside)
        applyBtn.frame = CGRect(x:20, y:Int(screenHeight) - 120, width: Int(screenWidth) - 40, height:  120)
        
        applyBtn.setTitle("적용하기", for: .normal)
        applyBtn.setTitleColor(UIColor.black, for: .normal)
        applyBtn.backgroundColor = .clear
        applyBtn.layer.cornerRadius = 5
        applyBtn.layer.borderWidth = 1
        applyBtn.layer.borderColor = UIColor.black.cgColor
        self.view.addSubview(applyBtn)
        
        
        
        //2차 필터링을 위한 카테고리들을 요청한다.
        //선택한 카테고리를 전송할 데이터로 파싱하여 옮긴다.
        
        let parameters = ["category1_name": category, "level" : "1"]
        //                //디바이스의 크기
        
        Alamofire.request("http://3.34.4.196/backend/ios/ios_level_select.php", method: .post, parameters: parameters)
            .validate()
            .responseJSON { response in
                
                switch response.result {
                    
                case.success(let value):
                    //print(json)
                    do {
                        let data = try JSONSerialization.data(withJSONObject: value, options: .prettyPrinted)
                        let policies = try JSONDecoder().decode(Policy.self, from: data)
                        print(policies.second_layer)
                        //필터목록을 받아 버튼으로 만든다.
                        var count : Int = policies.second_layer!.count
                        for i in 0..<count {
                            //print(policies.second_layer[i])
                            //짝홀 구분해서 버튼 배치
                            
                            //짝수
                            if(i != 0 && i%2==1){
                                print("짝수")
                                let button = UIButton(type: .system)
                                button.tag = i
                                button.addTarget(self, action: #selector(self.selected), for: .touchUpInside)
                                button.frame = CGRect(x:screenWidth/2 + 10, y:CGFloat(50 * (i - 1) + 20), width: screenWidth/2 - 40, height: 50)
                                
                                button.setTitle(policies.second_layer![i], for: .normal)
                                button.setTitleColor(UIColor.black, for: .normal)
                                button.backgroundColor = .clear
                                button.layer.cornerRadius = 5
                                button.layer.borderWidth = 1
                                button.layer.borderColor = UIColor.black.cgColor
                                self.view.addSubview(button)
                                self.buttons.append(button)
                                
                                //홀수
                            }else{
                                print("홀수")
                                
                                let button = UIButton(type: .system)
                                button.tag = i
                                button.addTarget(self, action: #selector(self.selected), for: .touchUpInside)
                                button.frame = CGRect(x:20, y:CGFloat(50 * i  + 20), width: screenWidth/2 - 40, height: 50)
                                
                                button.setTitle(policies.second_layer![i], for: .normal)
                                button.setTitleColor(UIColor.black, for: .normal)
                                button.backgroundColor = .clear
                                button.layer.cornerRadius = 5
                                button.layer.borderWidth = 1
                                button.layer.borderColor = UIColor.black.cgColor
                                self.view.addSubview(button)
                                self.buttons.append(button)
                                
                            }
                        }
                        
                        
                        
                        
                    } catch let error as NSError {
                        debugPrint("Error: \(error.description)")
                    }
                    
                    
                    
                case .failure(let error):
                    print(error)
                }
                
                
                
        }
        
        
        
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    //필터버튼 선택시
    @objc func selected(_ sender: UIButton) {
        // 원하는 대로 코드 구성
        print("버튼 클릭")
        //print(sender.tag)
        var btnCount : Int = buttons.count
        
        
        for i in 0..<btnCount {
            if(self.buttons[i] != self.buttons[sender.tag]){
                
                buttons[i].setTitleColor(UIColor.black, for: .normal)
                buttons[i].layer.borderColor = UIColor.black.cgColor
                
                //최종으로 선택된 카테고리만 체크된다.
            }else{
                buttons[sender.tag].setTitleColor(UIColor.systemIndigo, for: .normal)
                buttons[sender.tag].layer.borderColor = UIColor.systemIndigo.cgColor
           category2 = buttons[sender.tag].currentTitle!
            
            }
            
            
        }
        //            if(self.buttons[sender.tag].titleColor(for: .normal) == UIColor.systemIndigo){
        //                        buttons[sender.tag].setTitleColor(UIColor.black, for: .normal)
        //                        buttons[sender.tag].layer.borderColor = UIColor.black.cgColor
        //                print(buttons[sender.tag].currentTitle!)
        //
        //               // categorys = categorys.filter(){$0 != LabelName[sender.tag]}
        //
        //
        //                //카테고리를 추가하는 경우
        //                    }else{
        //
        //                        buttons[sender.tag].setTitleColor(UIColor.systemIndigo, for: .normal)
        //                        buttons[sender.tag].layer.borderColor = UIColor.systemIndigo.cgColor
        //                       // select = buttons[sender.tag].title(for: .normal)!
        //                       // print(LabelName[sender.tag])
        //                print(buttons[sender.tag].currentTitle!)
        //
        //
        //                  //  categorys.append(LabelName[sender.tag])
        //
        //                    }
        
        
    }
    
    //카테고리 선택 후 적용버튼을 누르면
    @objc func apply(_ sender: UIButton) {
        
        
        
        let parameters = ["category1_name": category, "category2_name": category2, "level" : "2"]
        //                //디바이스의 크기
        
        Alamofire.request("http://3.34.4.196/backend/ios/ios_level_select.php", method: .post, parameters: parameters)
            .validate()
            .responseJSON { response in
                
                switch response.result {
                    
                case.success(let value):
                    do {
                        let data = try JSONSerialization.data(withJSONObject: value, options: .prettyPrinted)
                        let policies = try JSONDecoder().decode(Policy.self, from: data)
                        print(policies.welfare_list!)
                        
                        guard let RVC = self.storyboard?.instantiateViewController(withIdentifier: "ResultViewController") as? ResultViewController         else{

                                     return
                                     
                                 }
                        RVC.category = self.category2
                        RVC.sections.append(self.category2)

                        // RVC.firstItems = policies.welfare_list!
                        RVC.modalPresentationStyle = .fullScreen
                                                    
                                          
                                                             // B 컨트롤러 뷰로 넘어간다.
                                                    //self.present(RVC, animated: true, completion: nil)

                                           
                        
                        self.present(RVC, animated: true, completion: nil)

                        
                    } catch let error as NSError {
                        debugPrint("Error: \(error.description)")
                    }
                    
                    
                    
                case .failure(let error):
                    print(error)
                }
        }
        
    }
    
    
}
