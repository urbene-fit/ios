//
//  ResultTableCell.swift
//  welfare
//
//  Created by 김동현 on 2020/08/14.
//  Copyright © 2020 com. All rights reserved.
//

import UIKit

class ResultTableCell: UITableViewCell {
    
    static let identifier = "ResultTableCell"


      let policyImg = UIImageView()
        let policyName = UILabel()
        let policyDeadLine = UILabel()
        //let salary = UILabel()
        
        override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            
            policyImg.translatesAutoresizingMaskIntoConstraints = false
            policyName.translatesAutoresizingMaskIntoConstraints = false
            policyDeadLine.translatesAutoresizingMaskIntoConstraints = false
            
            contentView.addSubview(policyImg)
            contentView.addSubview(policyName)
            contentView.addSubview(policyDeadLine)
            
            
            let views = [
                "image" : policyImg,
                "name"  : policyName,
                "deadline" : policyDeadLine,
              
                ]
            
          let margin: CGFloat = 10
              NSLayoutConstraint.activate([
                  policyImg.topAnchor.constraint(equalTo: self.topAnchor),
                  policyImg.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                  policyImg.widthAnchor.constraint(equalToConstant: 100),
                  policyImg.heightAnchor.constraint(equalToConstant: 100),
                      
                  policyName.topAnchor.constraint(equalTo: self.topAnchor),
                  policyName.leadingAnchor.constraint(equalTo: policyImg.trailingAnchor, constant: margin),
                  policyName.trailingAnchor.constraint(equalTo: self.trailingAnchor),
                      
                  policyDeadLine.topAnchor.constraint(equalTo: policyName.bottomAnchor),
                  policyDeadLine.leadingAnchor.constraint(equalTo: policyImg.trailingAnchor, constant: margin),
                  policyDeadLine.trailingAnchor.constraint(equalTo: self.trailingAnchor),
                  policyDeadLine.bottomAnchor.constraint(equalTo: self.bottomAnchor),
                  policyDeadLine.heightAnchor.constraint(equalTo: policyName.heightAnchor),
                  ])
            
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override func setSelected(_ selected: Bool, animated: Bool) {
            super.setSelected(selected, animated: animated)
        }
        
    }

