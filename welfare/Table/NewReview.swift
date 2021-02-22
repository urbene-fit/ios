//
//  NewReview.swift
//  welfare
//
//  Created by 김동현 on 2021/01/11.
//  Copyright © 2021 com. All rights reserved.
//

import UIKit

class NewReview: UITableViewCell {
    
    
    static let identifier = "NewReview"
    
    
    //테이블뷰 셀 프레임지정
    override open var frame: CGRect {
        get {
            return super.frame
        }
        set (newFrame) {
            var frame =  newFrame
            
            super.frame = frame
        }
        
    }
    
    
    //리뷰 작성자 닉네임
    let nickName: UILabel = {
        let nickName = UILabel()
        nickName.translatesAutoresizingMaskIntoConstraints = false
        nickName.font = UIFont(name: "jalan", size: 13  *  DeviceManager.sharedInstance.heightRatio)
        nickName.text = "작성자"
        return nickName
    }()
    
    //리뷰 평점
    let gradeView: UIView = {
        let gradeView = UIView()

        gradeView.translatesAutoresizingMaskIntoConstraints = false
        return gradeView
    }()
    
    
    
    //리뷰내용
    let content: UITextView = {
        let content = UITextView()
        content.translatesAutoresizingMaskIntoConstraints = false
        content.font = UIFont(name: "NanumBarunGothicBold", size: 14  *  DeviceManager.sharedInstance.heightRatio)
        content.isUserInteractionEnabled = false


        //content.isUserInteractionEnabled = false
        return content
    }()
    
    
    
    //작성 날짜
    let dateLabel: UILabel = {
        let dateLabel = UILabel()
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.font = UIFont(name: "jalan", size: 12.7  *  DeviceManager.sharedInstance.heightRatio)
        dateLabel.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        dateLabel.text = "1일전"
        return dateLabel
    }()
    
    
    //좋아요 버튼에 사용하는 이미지
    let ImgView : UIImageView = {
        
        
        let Img = UIImage(named: "thumb")
        var ImgView = UIImageView()
        ImgView.setImage(Img!)
        ImgView.frame = CGRect(x:0, y: 0, width: 20  *  DeviceManager.sharedInstance.widthRatio, height: 20  *  DeviceManager.sharedInstance.heightRatio)
        return ImgView
        
    }()
    
    //좋아요 버튼에 사용하는 숫자
    let numberLabel: UILabel = {
        let numberLabel = UILabel()
        numberLabel.translatesAutoresizingMaskIntoConstraints = false
        numberLabel.font = UIFont(name: "jalan", size: 12.7  *  DeviceManager.sharedInstance.heightRatio)
        numberLabel.frame  = CGRect(x:25  *  DeviceManager.sharedInstance.widthRatio, y: 0, width: 20  *  DeviceManager.sharedInstance.widthRatio, height: 20  *  DeviceManager.sharedInstance.heightRatio)
        return numberLabel
    }()
    
    //좋아요 버튼
    let thumbBtn : UIButton = {
        let thumbBtn = UIButton(type: .system)
        
        
//        thumbBtn.setImage(UIImage(named: "thumb"), for: .normal)
//        thumbBtn.contentMode = .scaleAspectFill

        thumbBtn.translatesAutoresizingMaskIntoConstraints = false
        thumbBtn.layer.borderWidth = 1
        //thumbBtn.layer.borderColor = UIColor.white.cgColor
        thumbBtn.layer.cornerRadius = 13
        
        return thumbBtn
        
    }()
    
    
    //구분선
    let border : UIView = {
    let border = UIView()

    border.layer.borderColor =  #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1).cgColor
    border.layer.borderWidth = 1
    
        return border
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addContentView()
        autoLayout()
    }
    
    
    
    public func addContentView() {
        
        //        contentView.frame = CGRect(x: 20, y: 20.7, width: 335, height: 186)
        //contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8))
        
        
        //        contentView.frame = CGRect(x: 0, y: 0, width: 500, height: 100)
        //        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8))
        contentView.addSubview(nickName)
        contentView.addSubview(gradeView)
        contentView.addSubview(content)
        contentView.addSubview(dateLabel)
       // contentView.addSubview(thumbBtn)
        contentView.addSubview(border)

        
      
        
   
    }
    
    public func autoLayout() {
        //let margin: CGFloat = 10
        
        NSLayoutConstraint.activate([
            
            
            //닉네임 배치
            
            nickName.topAnchor.constraint(equalTo: self.topAnchor, constant: 20  *  DeviceManager.sharedInstance.heightRatio),
            
            nickName.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20  *  DeviceManager.sharedInstance.widthRatio),
            
            //
            //            //별점 부분
            gradeView.topAnchor.constraint(equalTo: self.topAnchor, constant: 60  *  DeviceManager.sharedInstance.heightRatio),
            gradeView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20  *  DeviceManager.sharedInstance.widthRatio),
            
            
            
            //내용부분
            content.topAnchor.constraint(equalTo: self.gradeView.bottomAnchor, constant: 5  *  DeviceManager.sharedInstance.heightRatio),
            
            content.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20  *  DeviceManager.sharedInstance.widthRatio),
            
            
            //작성날짜
            dateLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 20  *  DeviceManager.sharedInstance.heightRatio),
            
            dateLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 300  *  DeviceManager.sharedInstance.widthRatio),
            
            //좋아요 버튼
//            thumbBtn.topAnchor.constraint(equalTo: self.topAnchor, constant: 220),
//
//            thumbBtn.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            
            //구분선
            border.topAnchor.constraint(equalTo: self.topAnchor, constant: 290  *  DeviceManager.sharedInstance.heightRatio),
            
            border.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20  *  DeviceManager.sharedInstance.widthRatio),
            
            
            
            nickName.widthAnchor.constraint(equalToConstant: 200  *  DeviceManager.sharedInstance.widthRatio),
            nickName.heightAnchor.constraint(equalToConstant: 30  *  DeviceManager.sharedInstance.heightRatio),
            gradeView.widthAnchor.constraint(equalToConstant: 300  *  DeviceManager.sharedInstance.widthRatio),
            gradeView.heightAnchor.constraint(equalToConstant: 30  *  DeviceManager.sharedInstance.heightRatio),
            content.widthAnchor.constraint(equalToConstant: 300  *  DeviceManager.sharedInstance.widthRatio),
//            content.heightAnchor.constraint(equalToConstant: 200  *  DeviceManager.sharedInstance.heightRatio),
     
            content.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.4),
            
          

            
            dateLabel.widthAnchor.constraint(equalToConstant: 50  *  DeviceManager.sharedInstance.widthRatio),
            dateLabel.heightAnchor.constraint(equalToConstant: 20  *  DeviceManager.sharedInstance.heightRatio),
//            thumbBtn.widthAnchor.constraint(equalToConstant: 60),
//            thumbBtn.heightAnchor.constraint(equalToConstant: 40),
            
            border.widthAnchor.constraint(equalToConstant: 400  *  DeviceManager.sharedInstance.widthRatio),
            border.heightAnchor.constraint(equalToConstant: 1  *  DeviceManager.sharedInstance.heightRatio),
            
            
        ])
        
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
