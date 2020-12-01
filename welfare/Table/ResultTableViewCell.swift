//
//  ResultTableViewCell.swift
//  welfare
//
//  Created by 김동현 on 2020/10/19.
//  Copyright © 2020 com. All rights reserved.
//

import UIKit

class ResultTableViewCell: UITableViewCell {
    
    static let identifier = "ResultTableViewCell"
    
    
    //테이블뷰 셀 프레임지정 
    override open var frame: CGRect {
        get {
            return super.frame
        }
        
        //테이블뷰 마진 주는 부분
        set (newFrame) {
            var frame =  newFrame
            frame.origin.y += 20.7
            frame.origin.x += 20
            frame.size.height -= 20.7
            frame.size.width -= 40
            super.frame = frame
        }
    }
    //우측상단 로고
    let plusImg: UIImageView = {
        //let plusImg = UIImageView()
        let plusImg = UIImageView(image:UIImage(named:"addBtn"))
        plusImg.translatesAutoresizingMaskIntoConstraints = false
        return plusImg
    }()
    
    //정책이름
    let policyName: UILabel = {
        let policyName = UILabel()
        policyName.translatesAutoresizingMaskIntoConstraints = false
        policyName.font = UIFont(name: "NanumGothic", size: 18.7)
        return policyName
    }()
    
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addContentView()
        autoLayout()
    }
    
    override func prepareForReuse() {
    super.prepareForReuse()
    // 초기화 할 코드 예시
//         if (backgroundColor != UIColor(red: 111/255.0, green: 82/255.0, blue: 232/255.0, alpha: 1.0)){
        
//        ResultUIViewController.
//
//        backgroundColor = UIColor.white
//        policyName.textColor = UIColor.black
//        plusImg.tintColor = UIColor.black
//       plusImg.image = plusImg.image?.withRenderingMode(.alwaysTemplate)
//        //}
    }
    
    private func addContentView() {
        
//        contentView.frame = CGRect(x: 20, y: 20.7, width: 500, height: 186)
//        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8))

        contentView.addSubview(plusImg)
        contentView.addSubview(policyName)
    }
    
    private func autoLayout() {
        //let margin: CGFloat = 10
        NSLayoutConstraint.activate([
            //                             plusImg.topAnchor.constraint(equalTo: self.topAnchor),
            //                             plusImg.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            //                             plusImg.widthAnchor.constraint(equalToConstant: 278.7),
            //                             plusImg.heightAnchor.constraint(equalToConstant: 26.3),
            //
            //            policyName.topAnchor.constraint(equalTo: self.topAnchor),
            //            policyName.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            //     policyName.trailingAnchor.constraint(equalTo: 30),
            //                               policyName.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            //크기를 나타내는 듯
            //마진을 나타내는게 아닌듯 좀더 생각해보자
            //            policyName.topAnchor.constraint(equalTo: self.topAnchor, constant: 91),
            //            policyName.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 30), //left
            //policyName.heightAnchor.constraint(equalTo: self.heightAnchor,  multiplier:2.0),
            //     policyName.trailingAnchor.constraint(equalTo: 30),
            //                               policyName.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            
            
            
            //마진 설정하는 부분
            plusImg.topAnchor.constraint(equalTo: self.topAnchor, constant: 26.3),
            plusImg.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 278.8),

            
            policyName.topAnchor.constraint(equalTo: self.topAnchor, constant: 91),
            //policyName.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 100.7),
            //policyName.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 36.7),
            policyName.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 30),
            
            //크기 지정하는 부분
            plusImg.widthAnchor.constraint(equalToConstant: 29.7),
            plusImg.heightAnchor.constraint(equalToConstant: 30.3),
            policyName.widthAnchor.constraint(equalToConstant: 204.3),
            policyName.heightAnchor.constraint(equalToConstant: 58.3),
        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
