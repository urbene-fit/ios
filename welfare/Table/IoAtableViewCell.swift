//
//  IoAtableViewCell.swift
//  welfare
//
//  Created by 김동현 on 2020/11/29.
//  Copyright © 2020 com. All rights reserved.
//

import UIKit

class IoAtableViewCell: UITableViewCell {

    
    static let identifier = "IoAtableViewCell"

    
    //테이블뷰 셀 프레임지정
    override open var frame: CGRect {
        get {
            return super.frame
        }
        
        //테이블뷰 마진 주는 부분
        set (newFrame) {
            var frame =  newFrame
//            frame.origin.y += 20.7
//            frame.origin.x += 20
//            frame.size.height -= 20.7
//            frame.size.width -= 40
            super.frame = frame
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //관심지역 삭제 버튼
    let deleteBtn: UIButton = {
        //let plusImg = UIImageView()
        let Img = UIImageView(image:UIImage(named:"remove"))
        Img.frame = CGRect(x:0, y: 0, width: 20, height: 20)
        let deleteBtn = UIButton(type: .system)
        deleteBtn.addSubview(Img)
        deleteBtn.backgroundColor = .white
        deleteBtn.translatesAutoresizingMaskIntoConstraints = false
        return deleteBtn
    }()
    
    //관심지역 내용
    let IoAname: UILabel = {
        let IoAname = UILabel()
        IoAname.translatesAutoresizingMaskIntoConstraints = false
        IoAname.font = UIFont(name: "Jalnan", size: 12.7)
        return IoAname
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addContentView()
        autoLayout()
    }

    private func addContentView() {
        
//        contentView.frame = CGRect(x: 20, y: 20.7, width: 500, height: 186)
//        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8))

        contentView.addSubview(deleteBtn)
        contentView.addSubview(IoAname)
    }
    
    private func autoLayout() {
        //let margin: CGFloat = 10
        NSLayoutConstraint.activate([
       
            
            
            //마진 설정하는 부분
            deleteBtn.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            deleteBtn.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 360),

            
            IoAname.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
         
            IoAname.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            
            //크기 지정하는 부분
            deleteBtn.widthAnchor.constraint(equalToConstant: 25),
            deleteBtn.heightAnchor.constraint(equalToConstant: 25),
            IoAname.widthAnchor.constraint(equalToConstant: 200),
            IoAname.heightAnchor.constraint(equalToConstant: 25),
        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    



}
