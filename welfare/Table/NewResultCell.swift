//
//  NewResultCell.swift
//  welfare
//
//  Created by 김동현 on 2020/12/31.
//  Copyright © 2020 com. All rights reserved.
//

import UIKit

class NewResultCell: UITableViewCell {
    
    static let identifier = "NewResultCell"
    
    
    //테이블뷰 셀 프레임지정
    override open var frame: CGRect {
        get {
            return super.frame
        }
        
        //테이블뷰 마진 주는 부분
        set (newFrame) {
            var frame =  newFrame
            
            //셀간 간격만드는거
            frame.origin.y += (10  *  DeviceManager.sharedInstance.heightRatio)
            frame.origin.x += (20  *  DeviceManager.sharedInstance.widthRatio)
            frame.size.height -= (20  *  DeviceManager.sharedInstance.heightRatio)
            frame.size.width -= (40  *  DeviceManager.sharedInstance.widthRatio)
            
            //패딩주기
          //  contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
            super.frame = frame
        }
    }
    //하위 카테고리별 이미지
    let categoryImg: UIImageView = {
        //let plusImg = UIImageView()
        let categoryImg = UIImageView()
        categoryImg.translatesAutoresizingMaskIntoConstraints = false
        return categoryImg
    }()
    
    //정책이름
    let policyName: UILabel = {
        let policyName = UILabel()
        policyName.translatesAutoresizingMaskIntoConstraints = false
        policyName.font = UIFont(name: "Jalnan", size: 20  *  DeviceManager.sharedInstance.heightRatio)
        policyName.textColor = UIColor.white
        policyName.numberOfLines = 6
        return policyName
    }()
    
    
    //지역명
    let localName: UILabel = {
        let localName = UILabel()
        localName.translatesAutoresizingMaskIntoConstraints = false
        localName.font = UIFont(name: "Jalnan", size: 15  *  DeviceManager.sharedInstance.heightRatio)
        localName.textColor = UIColor.white
        return localName
    }()
    
    //정책 태그
    let policyTag: UILabel = {
        let policyTag = UILabel()
        policyTag.translatesAutoresizingMaskIntoConstraints = false
        policyTag.font = UIFont(name: "NanumGothic", size: 12.7  *  DeviceManager.sharedInstance.heightRatio)
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
    
    override func prepareForReuse() {
    super.prepareForReuse()
 
    }
    
    private func addContentView() {
        
//        //패딩주기 안됨
//        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
//
       contentView.addSubview(categoryImg)
        contentView.addSubview(policyName)
        contentView.addSubview(localName)

        //contentView.addSubview(policyTag)
//        contentView.addSubview(gradeImg)
//        contentView.addSubview(gradeLabel)
        
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOffset = CGSize(width: 5  *  DeviceManager.sharedInstance.heightRatio, height: 5  *  DeviceManager.sharedInstance.heightRatio) // 반경에 대해서 너무 적용이 되어서 4point 정도 ㅐ림.
        
        contentView.layer.shadowOpacity = 1
        contentView.layer.shadowRadius = 1 // 반경?
        
        contentView.layer.shadowOpacity = 0.5 // alpha값입니다.

    }
    
    private func autoLayout() {
        //let margin: CGFloat = 10
        NSLayoutConstraint.activate([
            
            
            //마진 설정하는 부분
            
            //하위 카테고리 이미지
            categoryImg.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            categoryImg.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 200  *  DeviceManager.sharedInstance.heightRatio),

            //정책이름
            policyName.topAnchor.constraint(equalTo: self.topAnchor, constant: 60  * DeviceManager.sharedInstance.widthRatio),
            policyName.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20  *  DeviceManager.sharedInstance.heightRatio),
            
            
            //지역명local
            localName.topAnchor.constraint(equalTo: self.topAnchor, constant: 20  * DeviceManager.sharedInstance.widthRatio),
            localName.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20  *  DeviceManager.sharedInstance.heightRatio),
            
            //정책태그
//            policyTag.topAnchor.constraint(equalTo: self.topAnchor, constant: 100),
//            policyTag.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            
            //별점 이미지
//            policyTag.topAnchor.constraint(equalTo: self.topAnchor, constant: 70),
//            policyTag.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
//
            
            //크기 지정하는 부분
            categoryImg.widthAnchor.constraint(equalToConstant: 200  *  DeviceManager.sharedInstance.widthRatio),
            categoryImg.heightAnchor.constraint(equalToConstant: 200  *  DeviceManager.sharedInstance.heightRatio),
            policyName.widthAnchor.constraint(equalToConstant: 200  *  DeviceManager.sharedInstance.widthRatio),
          policyName.heightAnchor.constraint(equalToConstant: 120  *  DeviceManager.sharedInstance.heightRatio),
            localName.widthAnchor.constraint(equalToConstant: 200  *  DeviceManager.sharedInstance.widthRatio),
          localName.heightAnchor.constraint(equalToConstant: 20  *  DeviceManager.sharedInstance.heightRatio),
            
          //  policyTag.widthAnchor.constraint(equalToConstant: 200),
//            policyTag.heightAnchor.constraint(equalToConstant: 20),
        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
