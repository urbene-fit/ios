//
//  Review(nonImg&nonBtn)Cell.swift
//  welfare
//
//  Created by 김동현 on 2020/12/23.
//  Copyright © 2020 com. All rights reserved.
//

import UIKit

class Review_nonImg_nonBtn_Cell: UITableViewCell {

    
    static let identifier = "Review_nonImg_nonBtn_Cell"
    
    
    //테이블뷰 셀 프레임지정
    override open var frame: CGRect {
        get {
            return super.frame
        }
        
        //테이블뷰 마진 주는 부분
        set (newFrame) {
            var frame =  newFrame
            frame.origin.y += 20.7
//            frame.origin.x += 20
          frame.size.height -= 20.7
//            frame.size.width -= 40
            super.frame = frame
        }
    }
    
    
    //리뷰 작성자 닉네임
    let nickName: UILabel = {
        let nickName = UILabel()
        nickName.translatesAutoresizingMaskIntoConstraints = false
        nickName.font = UIFont(name: "jalan", size: 12.7)
        nickName.text = "작성자"
        return nickName
    }()
    
    //리뷰 평점
    let gradeView: UIView = {
        let gradeView = UIView()
        //let plusImg = UIImageView(image:UIImage(named:"addBtn"))
        //별점 이미지
        for i in 0..<5 {
            let starImg = UIImage(named: "star_off")
            var starImgView = UIImageView()
            starImgView.setImage(starImg!)
            starImgView.frame = CGRect(x:(i * 10) + 10, y: 0, width: 10, height: 10)
            starImgView.image = starImgView.image?.withRenderingMode(.alwaysOriginal)
            gradeView.addSubview(starImgView)
        }
        gradeView.translatesAutoresizingMaskIntoConstraints = false
        return gradeView
    }()
    

    
    //리뷰내용
    let content: UITextView = {
        let content = UITextView()
        content.translatesAutoresizingMaskIntoConstraints = false
        content.font = UIFont(name: "jalan", size: 10.7)
        return content
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
    
    public func addContentView() {
        
//        contentView.frame = CGRect(x: 20, y: 20.7, width: 335, height: 186)
        //contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8))

        
        contentView.frame = CGRect(x: 20, y: 20.7, width: 500, height: 100)
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8))
        contentView.addSubview(nickName)
        contentView.addSubview(gradeView)
        contentView.addSubview(content)
        
        //하단줄 추가
        let bottomBorder = CALayer()
                bottomBorder.frame = CGRect(x: 0.0, y: 199, width: 500, height: 1.0)
                bottomBorder.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        contentView.layer.addSublayer(bottomBorder)
        
        
        
    }
    
    public func autoLayout() {
        //let margin: CGFloat = 10
        
        NSLayoutConstraint.activate([
          
            
            //닉네임 배치
            
//            nickName.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
//
//            nickName.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
//
//
//            //별점 부분
//            gradeView.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
//            gradeView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 120),
//
//
//
//
//            content.topAnchor.constraint(equalTo: self.topAnchor, constant: 50),
//
//            content.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
//
//            //크기 지정하는 부분
//            nickName.widthAnchor.constraint(equalToConstant: 80),
//            nickName.heightAnchor.constraint(equalToConstant: 20),
//            gradeView.widthAnchor.constraint(equalToConstant: 20),
//            gradeView.heightAnchor.constraint(equalToConstant: 20),
//
//            content.widthAnchor.constraint(equalToConstant: 400),
//            content.heightAnchor.constraint(equalToConstant: 100),
            
            
            //닉네임 배치
            
            nickName.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
     
            nickName.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            
            
            //별점 부분
            gradeView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            gradeView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 80),

            
            
            content.topAnchor.constraint(equalTo: self.topAnchor, constant: 100),
   
            content.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            
            //크기 지정하는 부분
//            nickName.widthAnchor.constraint(equalToConstant: 60),
//            nickName.heightAnchor.constraint(equalToConstant: 20),
//            gradeView.widthAnchor.constraint(equalToConstant: 20),
//            gradeView.heightAnchor.constraint(equalToConstant: 20),
//            plusImg.widthAnchor.constraint(equalToConstant: 370),
//            plusImg.heightAnchor.constraint(equalToConstant: 270),
//            content.widthAnchor.constraint(equalToConstant: 400),
//            content.heightAnchor.constraint(equalToConstant: 100),
            
                        nickName.widthAnchor.constraint(equalToConstant: 30),
                        nickName.heightAnchor.constraint(equalToConstant: 30),
                        gradeView.widthAnchor.constraint(equalToConstant: 30),
                        gradeView.heightAnchor.constraint(equalToConstant: 30),
                     
                        content.widthAnchor.constraint(equalToConstant: 30),
                        content.heightAnchor.constraint(equalToConstant: 30),
                        
        
          
        ])
          
    }
    
  
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
