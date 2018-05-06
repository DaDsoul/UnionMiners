//
//  SubscribeTableViewCell.swift
//  UnionOfMiners
//
//  Created by talgat on 15.10.17.
//  Copyright © 2017 Akezhan. All rights reserved.
//

import UIKit

class SubscribeTableViewCell: UITableViewCell {

    @IBOutlet var selectButton: UIButton!
    
    
    @IBOutlet var newsTitle: UILabel!
    
    var cellAction: (UIButton) -> Void = {_ in}
    
    func savePostDidTap(sender: UIButton) {
        cellAction(sender)
    }
    
    @IBAction func signAction(_ sender: UIButton) {
        savePostDidTap(sender: sender)
    }
}
