//
//  alramTableViewCell.swift
//  welfare
//
//  Created by 김동현 on 2020/12/06.
//  Copyright © 2020 com. All rights reserved.
//

import UIKit

class alramTableViewCell: UITableViewCell {

    static let identifier = "alramTableViewCell"
    
    
    //테이블뷰 셀 프레임지정
    override open var frame: CGRect {
        get {
            return super.frame
        }
        
        //테이블뷰 마진 주는 부분
        set (newFrame) {
            var frame =  newFrame
            frame.origin.y += 20.7 * DeviceManager.sharedInstance.heightRatio
            frame.origin.x += 10 * DeviceManager.sharedInstance.widthRatio
            frame.size.height -= 20.7 * DeviceManager.sharedInstance.heightRatio
            frame.size.width -= 20 * DeviceManager.sharedInstance.widthRatio
            super.frame = frame
        }
    }
    //좌측 썸네일
    let thumbnail: UIImageView = {
        //let plusImg = UIImageView()
        //let img = UIImage(named:"docs")
       // let thumbnail = UILabel()

        let thumbnail = UIImageView(image:UIImage(named:"docs"))
//        imgView.frame = CGRect(x: 10, y: 10, width: 40, height: 40)
//        imgView.sizeToFit()
       // thumbnail.addSubview(imgView)
        thumbnail.translatesAutoresizingMaskIntoConstraints = false
        //thumbnail.layer.cornerRadius = thumbnail.frame.height/2
        thumbnail.layer.cornerRadius = 13
        
        thumbnail.tintColor = UIColor.purple
        thumbnail.image = thumbnail.image?.withRenderingMode(.alwaysTemplate)
       // thumbnail.backgroundColor = UIColor.gray
        //thumbnail.layer.borderWidth = 1
//       thumbnail.layer.borderColor = UIColor.clear.cgColor
        //thumbnail.sizeToFit()
        thumbnail.clipsToBounds = true
        
        return thumbnail
    }()
    
    //알림 제목
    let alramName: UILabel = {
        let alramName = UILabel()
        alramName.translatesAutoresizingMaskIntoConstraints = false
        alramName.font = UIFont(name: "Jalnan", size: 13 * DeviceManager.sharedInstance.heightRatio)

        return alramName
    }()
    
    //알림 내용
    let alramContent: UILabel = {
        let alramContent = UILabel()
        alramContent.translatesAutoresizingMaskIntoConstraints = false
        alramContent.font = UIFont(name: "Jalnan", size: 10 * DeviceManager.sharedInstance.heightRatio)
        alramContent.numberOfLines = 2
        alramContent.textColor = UIColor(displayP3Red: 125/255.0, green: 125/255.0, blue: 125/255.0, alpha: 1)

        return alramContent
    }()

    //알림 송신날짜
    let date: UILabel = {
        let date = UILabel()
        date.translatesAutoresizingMaskIntoConstraints = false
        date.font = UIFont(name: "NanumBarunGothicBold", size: 14 * DeviceManager.sharedInstance.heightRatio)
        date.textColor = UIColor(displayP3Red: 125/255.0, green: 125/255.0, blue: 125/255.0, alpha: 1)

        return date
    }()
    
    
    //구분선
    let border : UIView = {
    let border = UIView()

    border.layer.borderColor = UIColor(displayP3Red: 125/255.0, green: 125/255.0, blue: 125/255.0, alpha: 1).cgColor
    border.layer.borderWidth = 10
    
        return border
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

        //contentView.addSubview(thumbnail)
        contentView.addSubview(alramName)
        contentView.addSubview(alramContent)
        contentView.addSubview(date)
        contentView.addSubview(border)


    }
    
    private func autoLayout() {
        //let margin: CGFloat = 10
        NSLayoutConstraint.activate([
       
            
            
            //마진 설정하는 부분
            
            //썸네일
//            thumbnail.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
//            thumbnail.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),

            
            alramName.topAnchor.constraint(equalTo: self.topAnchor, constant: 18 * DeviceManager.sharedInstance.heightRatio),
            alramName.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20 * DeviceManager.sharedInstance.widthRatio),
            
            
            //내용
            alramContent.topAnchor.constraint(equalTo: self.topAnchor, constant: 38 * DeviceManager.sharedInstance.heightRatio),
            alramContent.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20 * DeviceManager.sharedInstance.widthRatio),
            
            
            //날짜
            date.topAnchor.constraint(equalTo: self.topAnchor, constant: 18 * DeviceManager.sharedInstance.heightRatio),
            date.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 320 * DeviceManager.sharedInstance.widthRatio),
            
            //하단테두리
            border.topAnchor.constraint(equalTo: self.topAnchor, constant: 60 * DeviceManager.sharedInstance.heightRatio),
            border.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20 * DeviceManager.sharedInstance.widthRatio),

            //크기 지정하는 부분
//            thumbnail.widthAnchor.constraint(equalToConstant: 52),
//            thumbnail.heightAnchor.constraint(equalToConstant: 52),
            alramName.widthAnchor.constraint(equalToConstant: 350 * DeviceManager.sharedInstance.widthRatio),
            alramName.heightAnchor.constraint(equalToConstant: 30 * DeviceManager.sharedInstance.heightRatio),
            alramContent.widthAnchor.constraint(equalToConstant: 250  * DeviceManager.sharedInstance.widthRatio),
            alramContent.heightAnchor.constraint(equalToConstant: 40 * DeviceManager.sharedInstance.heightRatio),
            date.widthAnchor.constraint(equalToConstant: 80 * DeviceManager.sharedInstance.widthRatio),
            date.heightAnchor.constraint(equalToConstant: 30 * DeviceManager.sharedInstance.heightRatio),
            border.widthAnchor.constraint(equalToConstant: 400 * DeviceManager.sharedInstance.widthRatio),
            border.heightAnchor.constraint(equalToConstant: 20 * DeviceManager.sharedInstance.heightRatio),
        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
