//  NewResultCell.swift
//  welfare
//
//  Created by 김동현 on 2020/12/31.
//  Copyright © 2020 com. All rights reserved.

import UIKit


class NewResultCell: UITableViewCell {
    
    static let identifier = "NewResultCell"
    
    
    // 테이블뷰 셀 프레임지정
    override open var frame: CGRect {
        get {
            return super.frame
        }
        
        // 테이블뷰 마진 주는 부분
        set (newFrame) {
            var frame =  newFrame
            
            // 셀간 간격만드는거
            frame.origin.y += (10  *  DeviceManager.sharedInstance.heightRatio)
            frame.origin.x += (20  *  DeviceManager.sharedInstance.widthRatio)
            frame.size.height -= (20  *  DeviceManager.sharedInstance.heightRatio)
            frame.size.width -= (40  *  DeviceManager.sharedInstance.widthRatio)
            
            // 패딩주기
            // contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
            super.frame = frame
        }
    }
    
    
    //정책이름
    let policyName: UILabel = {
        let policyName = UILabel()
        policyName.translatesAutoresizingMaskIntoConstraints = false
//        policyName.font = UIFont(name: "Jalnan", size: 20  *  DeviceManager.sharedInstance.heightRatio)
        policyName.lineBreakMode = .byWordWrapping
        policyName.textColor = UIColor.black
        policyName.numberOfLines = 6 // 최대 몇줄로 표시할 수 있는지에 대한 설정
        policyName.textAlignment = .center
        return policyName
    }()
    
    
    //지역명
    let localName: UILabel = {
        let localName = UILabel()
        localName.translatesAutoresizingMaskIntoConstraints = false
        localName.font = UIFont(name: "Jalnan", size: 15  *  DeviceManager.sharedInstance.heightRatio)
        localName.textColor = UIColor(displayP3Red:242/255,green : 182/255, blue : 157/255, alpha: 1)
        return localName
    }()
    
    
    //정책 태그
    let policyTag: UILabel = {
        let policyTag = UILabel()
        policyTag.translatesAutoresizingMaskIntoConstraints = false
        policyTag.font = UIFont(name: "NanumGothic", size: 12.7  *  DeviceManager.sharedInstance.heightRatio)
        policyTag.textColor = UIColor(displayP3Red:242/255,green : 182/255, blue : 157/255, alpha: 1)
        return policyTag
    }()
    
    
    //별점 이미지
    let gradeImg: UIImageView = {
        //let plusImg = UIImageView()
        let gradeImg = UIImageView(image:UIImage(named:"Grade"))
        
        gradeImg.translatesAutoresizingMaskIntoConstraints = false
        return gradeImg
    }()
    
    
    //별점 수치
    let gradeLabel: UILabel = {
        let gradeLabel = UILabel()
        gradeLabel.translatesAutoresizingMaskIntoConstraints = false
        gradeLabel.font = UIFont(name: "NanumGothic", size: 12.7  *  DeviceManager.sharedInstance.heightRatio)
        return gradeLabel
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addContentView()
        autoLayout()
    }
    
    
    private func addContentView() {
        contentView.addSubview(policyName)
        contentView.addSubview(localName)
    }
    
    
    // 제약 조건 설정
    func autoLayout() {
        NSLayoutConstraint.activate([
            
            // 정책이름
            policyName.topAnchor.constraint(equalTo: self.topAnchor, constant: 40  * DeviceManager.sharedInstance.widthRatio),
            policyName.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20  *  DeviceManager.sharedInstance.heightRatio),
            policyName.trailingAnchor.constraint(equalTo: self.trailingAnchor,constant: -20  *  DeviceManager.sharedInstance.heightRatio),
            policyName.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20  *  DeviceManager.sharedInstance.heightRatio),
            policyName.heightAnchor.constraint(equalToConstant: 120  *  DeviceManager.sharedInstance.heightRatio),
            
            
            // 지역명
            localName.topAnchor.constraint(equalTo: self.topAnchor, constant: 20  * DeviceManager.sharedInstance.widthRatio),
            localName.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20  *  DeviceManager.sharedInstance.heightRatio),
            localName.widthAnchor.constraint(equalToConstant: 200  *  DeviceManager.sharedInstance.widthRatio),
            localName.heightAnchor.constraint(equalToConstant: 20  *  DeviceManager.sharedInstance.heightRatio),
        ])
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
