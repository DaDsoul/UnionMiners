//
//  ProfileTableViewCell.swift
//  UnionOfMiners
//
//  Created by talgat on 01.11.17.
//  Copyright © 2017 Akezhan. All rights reserved.
//

import UIKit
import EasyPeasy

class statistics: UITableViewCell {
    
    let time = UILabel()
    let income = UILabel()
    let payInLabel = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: "records")
        
        self.selectionStyle = .none
        self.contentView.backgroundColor = oneColor
        
        payInLabel.textColor = .white
        time.textColor = .white
        income.textColor = .white
        payInLabel.text = "Pay In"
        
        
        time.font = UIFont(name:"Helvetica Neue", size: 12)
        income.font = UIFont(name:"Helvetica Neue", size: 16)
        payInLabel.font = UIFont(name:"Helvetica Neue", size: 18)
        
        self.contentView.addSubview(time)
        self.contentView.addSubview(income)
        self.contentView.addSubview(payInLabel)
        
        time <- [TopMargin(5),LeftMargin(5),Width(150)]
        income <- [TopMargin(20),RightMargin(0),Width(60)]
        payInLabel <- [TopMargin(25),LeftMargin(5),Width(100)]
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
