//
//  MyTableViewCell.swift
//  welfare
//
//  Created by 김동현 on 2020/08/05.
//  Copyright © 2020 com. All rights reserved.
//

import UIKit

class MyTableViewCell: UITableViewCell {
    
    let employeeImage = UIImageView()
    let employeeName = UILabel()
    let yearsInService = UILabel()
    let salary = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        employeeImage.translatesAutoresizingMaskIntoConstraints = false
        employeeName.translatesAutoresizingMaskIntoConstraints = false
        yearsInService.translatesAutoresizingMaskIntoConstraints = false
        salary.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(employeeImage)
        contentView.addSubview(employeeName)
        contentView.addSubview(yearsInService)
        contentView.addSubview(salary)
        
        let views = [
            "image" : employeeImage,
            "name"  : employeeName,
            "years" : yearsInService,
            "salary": salary,
            ]
        
        var allConstraints: [NSLayoutConstraint] = []
        allConstraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-[image(50)]", options: [], metrics: nil, views: views)
        allConstraints += NSLayoutConstraint.constraints(withVisualFormat: "V:[salary]-|", options: [], metrics: nil, views: views)
        allConstraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-[name]-[years]-|", options: [], metrics: nil, views: views)
        allConstraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-[image(50)]-[name]-|", options: [], metrics: nil, views: views)
        allConstraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-[image]-[years]-[salary]-|", options: [], metrics: nil, views: views)
        
         NSLayoutConstraint.activate(allConstraints)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
