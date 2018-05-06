//
//  TabBarViewController.swift
//  UnionOfMiners
//
//  Created by talgat on 15.10.17.
//  Copyright © 2017 Akezhan. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let almostWhite = UIColor(red: 213/255.0, green: 213/255.0, blue: 213/255.0, alpha: 1)
        
        self.tabBar.barTintColor = oneColor
        self.tabBar.tintColor = .white
        
        self.tabBar.unselectedItemTintColor = almostWhite
        
        let titles = ["Курс", "Новости","Профиль"]
        
        for (index, item) in (self.tabBar.items?.enumerated())! {
            item.title = titles[index]
        }
        
        let images = [#imageLiteral(resourceName: "stata"),#imageLiteral(resourceName: "news"),#imageLiteral(resourceName: "user")]
        
        for (index2, item) in (self.tabBar.items?.enumerated())!{
            item.image = images[index2]
            
        }
        
    }
}
