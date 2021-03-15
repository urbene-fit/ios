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
        createListUI()
    }
    
    // 테마 키워드 카테고리 버튼 누를 경우 실행
    @objc func move(_ sender: UIButton) {
        debugPrint("검색화면 - move() 실헹, 결과페이지로 이동하는 버튼 클릭")
    }
    
    
    // 홈 화면 네비게이션 바 생성
    // 참고 : https://developer.apple.com/documentation/uikit/uinavigationcontroller/customizing_your_app_s_navigation_bar
    // 참고: https://philosopher-chan.tistory.com/1083?category=903020
    func createNavUI() {
        debugPrint("ThemeListViewController의 setBarButton")
        
        
        // 네비게이션 윗쪽 이름 수정
        self.navigationItem.prompt = NSLocalizedString("혜택모아", comment: "")
        
        
        
        // 네비게이션 아래쪽 이름 수정
        self.navigationItem.title = "테마별 혜택"
//        self.navigationController?.navigationBar.barTintColor = UIColor(displayP3Red:242/255,green : 182/255, blue : 157/255, alpha: 1)
//        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationBar.largeTitleTextAttributes = [ NSAttributedString.Key.font: UIFont(name: "Jalnan", size: 20)! ]
        
        
        // 네비게이션 오른쪽 이미지 설정
        let add = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(addTapped))
        // let playButton = UIButton(type: .custom)
        // playButton.setImage(UIImage(named: "alramIcon"), for: .normal)
        // playButton.addTarget(self, action: #selector(playTapped), for: .touchUpInside)
        // playButton.frame = CGRect(x: 0, y: 0, width: 10, height: 10)
        // let barButton = UIBarButtonItem(customView: playButton)
        // navigationItem.rightBarButtonItems = [add, barButton]
        self.navigationItem.rightBarButtonItems = [add]
        
        self.navigationController?.navigationBar.barTintColor = UIColor(displayP3Red:242/255,green : 182/255, blue : 157/255, alpha: 1)
        // self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(displayP3Red:242/255,green : 182/255, blue : 157/255, alpha: 1)]
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(displayP3Red:242/255,green : 182/255, blue : 157/255, alpha: 1)]
        
        
    }
    
    
    @objc func addTapped() {
        debugPrint("addTapped 함수 실행")
    }
    
    
    // 테마 키워드 - 카테고리 버튼 UI 생성
    func createListUI() {
        for i in 0..<12 {
            let xInt = i % 3
            //            let yInt = ceil(Double((i)/3))
            
            let button = UIButton(type: .system)
            button.frame = CGRect(x: CGFloat((20 + (130 * xInt)))  * DeviceManager.sharedInstance.widthRatio,
                                  // y: CGFloat(240 + (60 * yInt))  * DeviceManager.sharedInstance.heightRatio,
                                  y: 0,
                                  width: 110 * DeviceManager.sharedInstance.widthRatio, height: 40 * DeviceManager.sharedInstance.heightRatio)
            buttons.append(button)
            
            button.tag = i
            button.setTitle("# \(LabelName[i])", for: .normal)
            button.tintColor = UIColor(displayP3Red:242/255,green : 182/255, blue : 157/255, alpha: 1)
            button.titleLabel?.font = UIFont(name: "Jalnan", size: 12 *  DeviceManager.sharedInstance.heightRatio)!
            button.backgroundColor = UIColor.white
            
            button.setTitleColor(UIColor(displayP3Red:242/255,green : 182/255, blue : 157/255, alpha: 1), for: .normal)
            button.layer.cornerRadius = 17 *  DeviceManager.sharedInstance.heightRatio
            button.layer.borderWidth = 2
            button.layer.borderColor = UIColor(displayP3Red:242/255,green : 182/255, blue : 157/255, alpha: 1).cgColor
            
            //카테고리 선택시 선택한 카테고리를 저장해주는 메소드
            button.addTarget(self, action: #selector(self.move), for: .touchUpInside)
            
            //카테고리에 사용되는 뷰들을 리스트로 관리해서 선택됫을경우 선탟된 카테고리의 뷰들에 대해 변형해준다.
            self.view.addSubview(button)
        }
    }
}
