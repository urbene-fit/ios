//
//  recommendCell.swift
//  welfare
//
//  Created by 김동현 on 2021/03/09.
//  Copyright © 2021 com. All rights reserved.
//

import UIKit
import Lottie

class recommendCell: UICollectionViewCell  {
    
    
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
        policyName.font = UIFont(name: "NanumBarunGothicBold", size: 20  *  DeviceManager.sharedInstance.heightRatio)
        policyName.textColor = UIColor.white
        policyName.textAlignment = .center
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
    
    //애니메이션
    let animationView: AnimationView = {
        let animationView = AnimationView(name:"present")
        animationView.translatesAutoresizingMaskIntoConstraints = false
        animationView.contentMode = .scaleAspectFit
        animationView.backgroundColor = .clear
        return animationView
    }()
  



    override init(frame: CGRect) {
        super.init(frame: frame)

        addViews()
    }




    func addViews(){

        addSubview(animationView)
        addSubview(policyName)
        addSubview(localName)
        
        
        //let margin: CGFloat = 10
        NSLayoutConstraint.activate([
            
            
            //마진 설정하는 부분
            
            //하위 카테고리 이미지
//            categoryImg.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
//            categoryImg.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 200  *  DeviceManager.sharedInstance.heightRatio),

            //정책이름
            policyName.topAnchor.constraint(equalTo: self.topAnchor, constant: 60  * DeviceManager.sharedInstance.widthRatio),
            policyName.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20  *  DeviceManager.sharedInstance.heightRatio),
            
            
            //지역명local
            localName.topAnchor.constraint(equalTo: self.topAnchor, constant: 20  * DeviceManager.sharedInstance.widthRatio),
            localName.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20  *  DeviceManager.sharedInstance.heightRatio),
            
            //애니메이션뷰
            animationView.topAnchor.constraint(equalTo: self.topAnchor, constant: 160  * DeviceManager.sharedInstance.widthRatio),
            animationView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 40  *  DeviceManager.sharedInstance.heightRatio),
            
            
            
            //정책태그
//            policyTag.topAnchor.constraint(equalTo: self.topAnchor, constant: 100),
//            policyTag.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            
            //별점 이미지
//            policyTag.topAnchor.constraint(equalTo: self.topAnchor, constant: 70),
//            policyTag.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
//
            
            //크기 지정하는 부분
//            categoryImg.widthAnchor.constraint(equalToConstant: 200  *  DeviceManager.sharedInstance.widthRatio),
//            categoryImg.heightAnchor.constraint(equalToConstant: 200  *  DeviceManager.sharedInstance.heightRatio),
            policyName.widthAnchor.constraint(equalToConstant: 160  *  DeviceManager.sharedInstance.widthRatio),
          policyName.heightAnchor.constraint(equalToConstant: 120  *  DeviceManager.sharedInstance.heightRatio),
            localName.widthAnchor.constraint(equalToConstant: 160  *  DeviceManager.sharedInstance.widthRatio),
          localName.heightAnchor.constraint(equalToConstant: 20  *  DeviceManager.sharedInstance.heightRatio),
            animationView.widthAnchor.constraint(equalToConstant: 120  *  DeviceManager.sharedInstance.widthRatio),
            animationView.heightAnchor.constraint(equalToConstant: 120  *  DeviceManager.sharedInstance.heightRatio),
            
          //  policyTag.widthAnchor.constraint(equalToConstant: 200),
//            policyTag.heightAnchor.constraint(equalToConstant: 20),
        ])
    }



    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
