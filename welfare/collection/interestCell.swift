//
//  interestCell.swift
//  welfare
//
//  Created by 김동현 on 2021/03/10.
//  Copyright © 2021 com. All rights reserved.
//

import UIKit

class interestCell: UICollectionViewCell {
    
    //관심사 선택 버튼
    let selectBtn: UIButton = {
        let selectBtn = UIButton(type: .system)
        selectBtn.translatesAutoresizingMaskIntoConstraints = false
        
        
        selectBtn.titleLabel!.font = UIFont(name: "NanumBarunGothicBold", size:16 *  DeviceManager.sharedInstance.heightRatio)
        selectBtn.setTitleColor(UIColor.black, for: .normal)

//        selectBtn.font = UIFont(name: "NanumBarunGothicBold", size: 12  *  DeviceManager.sharedInstance.heightRatio)

        selectBtn.layer.borderWidth = 1
        selectBtn.layer.borderColor = UIColor.black.cgColor
        selectBtn.layer.cornerRadius = 10 *  DeviceManager.sharedInstance.heightRatio

        
        return selectBtn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        addViews()
    }

    
    
    func addViews(){

        addSubview(selectBtn)

        
        
        //let margin: CGFloat = 10
        NSLayoutConstraint.activate([
            
            
            //마진 설정하는 부분
 

            //정책이름
            selectBtn.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            selectBtn.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            
            //버튼너비를 셀의 너비에 고정시킨다.
            selectBtn.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 1),
        
            selectBtn.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 1),

//            selectBtn.heightAnchor.constraint(equalToConstant: 40  *  DeviceManager.sharedInstance.heightRatio),
            
        ])
    }



    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var isSelected: Bool {
      didSet {
        if isSelected {
            selectBtn.backgroundColor = .blue
        } else {
            selectBtn.backgroundColor = .white
        }
      }
    }
    
}
