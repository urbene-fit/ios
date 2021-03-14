//
//  ThemeListViewController.swift
//  welfare
//
//  Created by 너의혜택은 on 2021/03/14.
//  Copyright © 2021 com. All rights reserved.
//

import Foundation
import UIKit
import Alamofire



class ThemeListViewController: UIViewController {
    
    //버튼들을 담을 배열
    var buttons = [UIButton]()
    
    
    //카테고리명들
    var LabelName = ["취업·창업","청년","주거","육아·임신","아기·어린이","문화·생활","기업·자영업자",
                     "저소득층","중장년·노인","장애인","다문화","법률"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 네비게이션 UI 생성
        createNavUI()
        
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
    
    // 테마 키워드 카테고리 버튼 누를 경우 실행
    @objc func move(_ sender: UIButton) {
        debugPrint("검색화면 - move() 실헹, 결과페이지로 이동하는 버튼 클릭")
    }
    
    
    // 홈 화면 네비게이션 바 생성
    private func createNavUI() {
        debugPrint("ThemeListViewController의 setBarButton")
        
        // 네비게이션바 색 변경 - 참고: https://hyerios.tistory.com/46
//        self.navigationController?.navigationBar.barTintColor = UIColor(displayP3Red:242/255,green : 182/255, blue : 157/255, alpha: 1)
//        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(displayP3Red:242/255,green : 182/255, blue : 157/255, alpha: 1)]
//        self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(displayP3Red:242/255,green : 182/255, blue : 157/255, alpha: 1)]
        
        
        let naviLabel = UILabel()
        naviLabel.frame = CGRect(x: 0  *  DeviceManager.sharedInstance.heightRatio, y: 235.4  *  DeviceManager.sharedInstance.heightRatio, width: 118  *  DeviceManager.sharedInstance.heightRatio, height: 17.3  *  DeviceManager.sharedInstance.heightRatio)
        naviLabel.textAlignment = .left
        naviLabel.textColor = .white
        naviLabel.text = "혜택모아"
        naviLabel.font = UIFont(name: "Jalnan", size: 25  *  DeviceManager.sharedInstance.heightRatio)
        self.navigationController?.navigationBar.topItem?.titleView = naviLabel
    }
}
