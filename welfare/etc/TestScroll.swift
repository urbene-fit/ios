//
//  TestScroll.swift
//  welfare
//
//  Created by 김동현 on 2020/08/26.
//  Copyright © 2020 com. All rights reserved.
//

import UIKit
import SnapKit

class TestScroll: UIViewController {
    
    let scrollView = UIScrollView()
     let contentView = UIView()
     
     let view1 = UIView()
     let view2 = UIView()
     let view3 = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //좋아요,공유하기 버튼
                let button = UIButton.init(type: .system)
                        //set image for button
                button.setTitle("공유하기", for: .normal)
                button.setTitleColor(UIColor.black, for: .normal)
        
                        //add function for button
                        button.addTarget(self, action: #selector(targetTapped), for: .touchUpInside)
                        //set frame
                        button.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        
                //버튼 터두리 설정
                button.backgroundColor = .clear
                button.layer.cornerRadius = 5
                button.layer.borderWidth = 1
                button.layer.borderColor = UIColor.black.cgColor
        
        
                //m_Scrollview.addSubview(button)
        
        
        
        
        self.view.addSubview(scrollView) // 메인뷰에
        
        scrollView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview() // 스크롤뷰가 표현될 영역
        }
        
        scrollView.addSubview(contentView)
        
        contentView.snp.makeConstraints { (make) in
            make.width.equalToSuperview()
            make.centerX.top.bottom.equalToSuperview()
        }
        
        _ = [view1, view2, view3].map { self.contentView.addSubview($0)}
        
        view1.backgroundColor = .red
        view2.backgroundColor = .black
        view3.backgroundColor = .blue
        
        
        view1.snp.makeConstraints { (make) in
            
            make.leading.top.trailing.equalToSuperview()
            make.height.equalTo(300)
        }
        
        view2.snp.makeConstraints { (make) in
            
            make.top.equalTo(view1.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(300)
        }
        
        view3.snp.makeConstraints { (make) in
            
            make.top.equalTo(view2.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(300)
            make.bottom.equalToSuperview() // 이것이 중요함
            
        
        }
        view3.addSubview(button)
        //view3.bringSubviewToFront(button)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    //맞춤선택라러가기 버튼클릭 이벤트
        @IBAction func targetTapped(sender: UIBarButtonItem) {
              
            
                view3.snp.makeConstraints { (make) in
                    
                    make.top.equalTo(view2.snp.bottom)
                    make.leading.trailing.equalToSuperview()
                    make.height.equalTo(700)
                    make.bottom.equalToSuperview() // 이것이 중요함
                    
                
                }
              print("크기변화 선택!")
          }

}
