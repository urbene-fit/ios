//
//  YtbCell.swift
//  welfare
//
//  Created by 김동현 on 2021/01/12.
//  Copyright © 2021 com. All rights reserved.
//

import UIKit

class YtbCell: UITableViewCell {

    static let identifier = "YtbCell"
    
    
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
    
    
    //영상 제목
    let title: UILabel = {
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.font = UIFont(name: "NanumBarunGothicBold", size: 16  *  DeviceManager.sharedInstance.heightRatio)
        title.numberOfLines = 10
        return title
    }()
    
    //유튜버 이름
//    let name: UILabel = {
//        let name = UILabel()
//        name.translatesAutoresizingMaskIntoConstraints = false
//        name.font = UIFont(name: "jalan", size: 12 *  DeviceManager.sharedInstance.heightRatio)
//        name.textColor = UIColor.lightGray
//        return name
//    }()
    

    
    
   
    
    
    //영상 썸네일
    let thumbnail : UIImageView = {
        
        
        var thumbnail = UIImageView()
        thumbnail.translatesAutoresizingMaskIntoConstraints = false

        return thumbnail
        
    }()
    
   
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addContentView()
        autoLayout()
    }
    
    
    
    public func addContentView() {
        
     
        //contentView.addSubview(name)
        contentView.addSubview(title)
        contentView.addSubview(thumbnail)
   
   
        
   
    }
    
    public func autoLayout() {
        //let margin: CGFloat = 10
        
        NSLayoutConstraint.activate([
            
            
            //썸네일
            thumbnail.topAnchor.constraint(equalTo: self.topAnchor, constant: 20 *  DeviceManager.sharedInstance.heightRatio),
            thumbnail.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20 *  DeviceManager.sharedInstance.widthRatio),

//
            //영상제목
            title.topAnchor.constraint(equalTo: self.topAnchor, constant: 0 *  DeviceManager.sharedInstance.heightRatio),
            title.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 250 *  DeviceManager.sharedInstance.widthRatio),
            
            //유튜버 이름
//            name.topAnchor.constraint(equalTo: self.topAnchor, constant: 120 *  DeviceManager.sharedInstance.heightRatio),
//            name.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 230 *  DeviceManager.sharedInstance.heightRatio),
            

            
            
            thumbnail.widthAnchor.constraint(equalToConstant: 200 *  DeviceManager.sharedInstance.widthRatio),
            thumbnail.heightAnchor.constraint(equalToConstant: 150 *  DeviceManager.sharedInstance.heightRatio),
                      
            
            title.widthAnchor.constraint(equalToConstant: 170 *  DeviceManager.sharedInstance.widthRatio),
            title.heightAnchor.constraint(equalToConstant: 200 *  DeviceManager.sharedInstance.heightRatio),
            
//            name.widthAnchor.constraint(equalToConstant: 200 *  DeviceManager.sharedInstance.heightRatio),
//            name.heightAnchor.constraint(equalToConstant: 20 *  DeviceManager.sharedInstance.heightRatio),
//
            
            
        ])
        
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
