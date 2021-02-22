//
//  kakaoTestViewController.swift
//  welfare
//
//  Created by 김동현 on 2020/12/01.
//  Copyright © 2020 com. All rights reserved.
//

import UIKit

class kakaoTestViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        sendLinkLocation()
    }
    
    func sendLinkLocation() -> Void {
        
        // Location 타입 템플릿 오브젝트 생성
        let template = KMTLocationTemplate { (locationTemplateBuilder) in
            
            // 주소
            locationTemplateBuilder.address = "경기 성남시 분당구 판교역로 235 에이치스퀘어 N동 8층"
            locationTemplateBuilder.addressTitle = "카카오 판교오피스 카페톡"
            
            // 컨텐츠
            locationTemplateBuilder.content = KMTContentObject(builderBlock: { (contentBuilder) in
                contentBuilder.title = "신메뉴 출시❤️ 체리블라썸라떼"
                contentBuilder.desc = "이번 주는 체리블라썸라떼 1+1"
                contentBuilder.imageURL = URL(string: "http://mud-kage.kakao.co.kr/dn/bSbH9w/btqgegaEDfW/vD9KKV0hEintg6bZT4v4WK/kakaolink40_original.png")!
                contentBuilder.link = KMTLinkObject(builderBlock: { (linkBuilder) in
                    linkBuilder.mobileWebURL = URL(string: "https://developers.kakao.com")
                })
            })
            
            // 소셜
            locationTemplateBuilder.social = KMTSocialObject(builderBlock: { (socialBuilder) in
                socialBuilder.likeCount = 286
                socialBuilder.commnentCount = 45
                socialBuilder.sharedCount = 845
            })
        }
        
        // 서버에서 콜백으로 받을 정보
        let serverCallbackArgs = ["user_id": "abcd",
                                  "product_id": "1234"]
        
        // 카카오링크 실행
        KLKTalkLinkCenter.shared().sendDefault(with: template, serverCallbackArgs: serverCallbackArgs, success: { (warningMsg, argumentMsg) in
            
            // 성공
            print("warning message: \(String(describing: warningMsg))")
            print("argument message: \(String(describing: argumentMsg))")

        }, failure: { (error) in
            
            // 실패
            //UIAlertController.showMessage(error.localizedDescription)
            print("error \(error)")
            
        })
    }

}
