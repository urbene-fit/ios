//
//  SelectTableViewCell.swift
//  welfare
//
//  Created by 김동현 on 2020/11/17.
//  Copyright © 2020 com. All rights reserved.
//

import UIKit

class SelectTableViewCell: UITableViewCell {

    
    static let identifier = "SelectTableViewCell"

    //테이블뷰 셀 프레임지정
    override open var frame: CGRect {
        get {
            return super.frame
        }
        set (newFrame) {
            var frame =  newFrame
            frame.origin.y += 20.7
            frame.origin.x += 20
            frame.size.height -= 20.7
            frame.size.width -= 40
            super.frame = frame
        }
    }
    
    
    //질문지 내용
    let questionLabel: UILabel = {
        let questionLabel = UILabel()
        questionLabel.translatesAutoresizingMaskIntoConstraints = false
        //questionLabel.font = UIFont(name: "jalan", size: 18.7)
        
        
        
        questionLabel.numberOfLines = 2
        return questionLabel
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
         super.init(style: style, reuseIdentifier: reuseIdentifier)
         
         addContentView()
         autoLayout()
     }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
        private func addContentView() {
            
    //        contentView.frame = CGRect(x: 20, y: 20.7, width: 335, height: 186)
            //contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8))

            contentView.addSubview(questionLabel)
        }
        
    private func autoLayout() {
    //let margin: CGFloat = 10
    NSLayoutConstraint.activate([
    
//            //마진 설정하는 부분
//            questionLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 26.3),
//            questionLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 30),

        
        //마진 설정하는 부분
        questionLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 33),
        questionLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 45),
        
        ])
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
