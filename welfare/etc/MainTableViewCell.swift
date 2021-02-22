//
//  MainTableViewCell.swift
//  welfare
//
//  Created by 김동현 on 2020/10/07.
//  Copyright © 2020 com. All rights reserved.
//

import UIKit

class MainTableViewCell: UITableViewCell {

   static let identifier = "MainTableViewCell"
      
      let policyLank: UILabel = {
          let policyLank = UILabel()
          policyLank.translatesAutoresizingMaskIntoConstraints = false
          policyLank.font = UIFont.boldSystemFont(ofSize: 50)
          return policyLank
      }()
      
      let policyName: UILabel = {
          let policyName = UILabel()
          policyName.translatesAutoresizingMaskIntoConstraints = false
          policyName.font = UIFont.boldSystemFont(ofSize: 20)
          return policyName
      }()
      
      let policyTag: UILabel = {
          let policyTag = UILabel()
          policyTag.translatesAutoresizingMaskIntoConstraints = false
          policyTag.font = UIFont.boldSystemFont(ofSize: 20)
          return policyTag
      }()
      
      override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
          super.init(style: style, reuseIdentifier: reuseIdentifier)
          
          addContentView()
          autoLayout()
      }
      
      private func addContentView() {
          contentView.addSubview(policyLank)
          contentView.addSubview(policyName)
          contentView.addSubview(policyTag)
      }
      
      private func autoLayout() {
          let margin: CGFloat = 10
          NSLayoutConstraint.activate([
              policyLank.topAnchor.constraint(equalTo: self.topAnchor),
              policyLank.leadingAnchor.constraint(equalTo: self.leadingAnchor),
              policyLank.widthAnchor.constraint(equalToConstant: 100),
              policyLank.heightAnchor.constraint(equalToConstant: 100),
              
              policyName.topAnchor.constraint(equalTo: self.topAnchor),
              policyName.leadingAnchor.constraint(equalTo: policyLank.trailingAnchor, constant: margin),
              policyName.trailingAnchor.constraint(equalTo: self.trailingAnchor),
              
              policyTag.topAnchor.constraint(equalTo: policyName.bottomAnchor),
              policyTag.leadingAnchor.constraint(equalTo: policyLank.trailingAnchor, constant: margin),
              policyTag.trailingAnchor.constraint(equalTo: self.trailingAnchor),
              policyTag.bottomAnchor.constraint(equalTo: self.bottomAnchor),
              policyTag.heightAnchor.constraint(equalTo: policyName.heightAnchor),
              ])
      }
      
      required init?(coder aDecoder: NSCoder) {
          fatalError("init(coder:) has not been implemented")
      }
}
