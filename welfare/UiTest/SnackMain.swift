//
//  SnackMain.swift
//  welfare
//
//  Created by 김동현 on 2020/11/09.
//  Copyright © 2020 com. All rights reserved.
//

import UIKit
import Alamofire

class SnackMain: UIViewController {
    
    //파싱 자료구조
    struct snackList: Decodable {
        var question : String
        var choice_1 : String
        var choice_2 : String
        var choice_1_country : String
        var choice_2_country : String
        var snack_image : String

    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //화면 스크롤 크기
        var screenWidth = Int(view.bounds.width)
        var screenHeight = Int(view.bounds.height)
        
        print(screenWidth)
        print(screenHeight)
        
        for family: String in UIFont.familyNames
        {
            print(family)
            for names: String in UIFont.fontNames(forFamilyName: family)
            {
                print("== \(names)")
            }
        }
        
        //화면구성
        //타이틀 라벨
        let titleLabel = UILabel()
        titleLabel.frame = CGRect(x: 0, y: 99, width: screenWidth, height: Int(33.7))
        titleLabel.textAlignment = .center
        //titleLabel.textColor = UIColor(displayP3Red: 93/255.0, green: 33/255.0, blue: 210/255.0, alpha: 1)
        //폰트지정 추가
        
        titleLabel.text = "복지국가 궁합 테스트"
        titleLabel.font = UIFont(name: "TTCherryblossomR", size: 34)
        
        self.view.addSubview(titleLabel)
        
        
        
        //서브 타이틀 라벨
        let subLabel = UILabel()
        subLabel.frame = CGRect(x: 0, y: Int(136.7), width: screenWidth , height: Int(20.7))
        subLabel.textAlignment = .center
        subLabel.textColor = UIColor(displayP3Red: 125/255.0, green: 125/255.0, blue: 125/255.0, alpha: 1)
        //폰트지정 추가
        
        subLabel.text = "나는 어떤 나라의 복지와 잘 맞을까?"
        subLabel.font = UIFont(name: "TTCherryblossomR", size: 24)
        
        self.view.addSubview(subLabel)
        
        
        //메인 이미지뷰
        let imgView = UIImageView()
        let img = UIImage(named: "SnackMain")
        imgView.setImage(img!)
        imgView.frame = CGRect(x: 30, y: 198, width: Double(screenWidth - 60), height: 266)
        
        self.view.addSubview(imgView)
        
        
        
        //버튼(버튼이벤트)
        var button = UIButton(type: .system)
        var label = UILabel()
        
        
        //카테고리 선택시 선택한 카테고리를 저장해주는 메소드
        
        
        
        
        
        button.setTitle("시작하기", for: .normal)
        button.frame = CGRect(x: 25, y: 528, width: screenWidth - 50, height: Int(53.7))
        
        button.titleLabel!.font = UIFont(name: "TTCherryblossomR", size:28)
        button.setTitleColor( UIColor.white, for: .normal)
        button.backgroundColor = UIColor(displayP3Red: 125/255.0, green: 125/255.0, blue: 125/255.0, alpha: 1)
        
        button.layer.cornerRadius = 6.3
        button.layer.borderWidth = 1.3
        button.layer.borderColor =  UIColor(displayP3Red: 125/255.0, green: 125/255.0, blue: 125/255.0, alpha: 1).cgColor
        //선택결과 페이지로 이동하는 메소드
        button.addTarget(self, action: #selector(self.selected), for: .touchUpInside)
        
        self.view.addSubview(button)
        
        
        
        
        
        
    }
    
    //테스트 시작버튼 클릭시
    @objc func selected(_ sender: UIButton) {
        print("테스트 시작")
        
        
        guard let RVC = self.storyboard?.instantiateViewController(withIdentifier: "SnackQuestion") as? SnackQuestion         else{
            
            return
            
        }
        
        
        let parameters = ["problemIndex": 1]
        
        
        Alamofire.request("http://3.34.4.196/backend/android/and_snack_contents.php", method: .post, parameters: parameters)
            .validate()
            .responseJSON { response in
                
                switch response.result {
                case .success(let value):
                    
                    //스낵컨텐츠 질문페이지에서 사용할 내용들을 받아온다.
                    do {
                        let data = try JSONSerialization.data(withJSONObject: value, options: .prettyPrinted)
                        let list = try JSONDecoder().decode(snackList.self, from: data)
                        RVC.question = list.question
                        RVC.choice = list.choice_1
                        RVC.sec_choice = list.choice_2
                        RVC.nation = list.choice_1_country
                        RVC.sec_nation = list.choice_2_country
                        RVC.imgurl = list.snack_image
//                        RVC.sec_nation = "북한"

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
                    
                    //뷰 이동
                    RVC.modalPresentationStyle = .fullScreen
                    
                    // 질문 페이지로 이동
                   // self.present(RVC, animated: true, completion: nil)
                    self.navigationController?.pushViewController(RVC, animated: true)
                    
                case .failure(let error):
                    print(error)
                }
                
                
                
        }
        
        
        
        
    }
}




