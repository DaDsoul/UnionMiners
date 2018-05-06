//
//  ProfileViewController.swift
//  UnionOfMiners
//
//  Created by talgat on 29.10.17.
//  Copyright © 2017 Akezhan. All rights reserved.
//

import UIKit
import EasyPeasy
import Kingfisher
import Charts

let blueColor = UIColor(red: 56/255.0, green: 161/255.0, blue: 197/255.0, alpha: 1.0)

class ProfileViewController: UIViewController {
    
    var tableView = UITableView()
    var user :User?
    var someLabel = UILabel()
    var profileResult: Any?
    var balance = UILabel()
    var balanceUsd = UILabel()
    var currencyCode = UILabel()
    var currencyName = UILabel()
    var profileImage = UIImageView()
    var logOut = UIButton()
    var refresh = UIButton()
    var incomeNumer = [Double]()
    var incomeTime = [String]()
    var incomesData = [[String:Any]]()
    
    func logOut(_ sender:UIButton){
        
        UserDefaults.standard.set(false, forKey: "Auth")
        navigationController?.popViewController(animated: true)
    }
    
    func refresh(_ sender:UIButton){
        
        self.showActivityIndicator()
        
        guard let profile = UserDefaults.standard.value(forKey: "header") as? [String:String] else {
            return
        }
        
        self.incomeNumer = []
        self.incomeTime = []
        self.incomesData = [[String:Any]]()
        
        Statistics.getInfo(header: profile){el in
            if let object = el as? [[String:Any]]{
                let item = object.first
                self.balanceUsd.text = String((round((item!["BalanceUsd"] as! Double)*100))/100) + "     USD"
                self.balance.text = String((round((item!["Balance"] as! Double)*100))/100) + "     ZEC"
                self.incomesData = (item!["Incomes"] as? [[String:Any]])!
                
                for element in self.incomesData{
                    self.incomeNumer.append(element["Value"] as! Double)
                    self.incomeTime.append(element["When"] as! String)
                }
                
                self.tableView.reloadData()
                self.hideActivityIndicator()
            }
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.backgroundColor = oneColor
        tableView.dataSource = self
        tableView.rowHeight = 70
        
        tableView.register(ProfileTableViewCell.self, forCellReuseIdentifier: "records")
        tableView.separatorStyle = .none
        
        self.showActivityIndicator()
        self.navigationItem.setHidesBackButton(true, animated: false)
        self.view.backgroundColor = oneColor
        
        self.view.addSubview(tableView)
        self.view.addSubview(someLabel)
        self.view.addSubview(balanceUsd)
        self.view.addSubview(balance)
        self.view.addSubview(currencyName)
        self.view.addSubview(currencyCode)
        self.view.addSubview(profileImage)
        self.view.addSubview(logOut)
        self.view.addSubview(refresh)
        
        guard let profile = UserDefaults.standard.value(forKey: "header") as? [String:String] else {
            return
        }
        
        Statistics.getInfo(header: profile){el in
            if let object = el as? [[String:Any]]{
                let item = object.first
                self.balanceUsd.text = String((round((item!["BalanceUsd"] as! Double)*100))/100) + "     USD"
                self.balance.text = String((round((item!["Balance"] as! Double)*100))/100) + "     ZEC"
                self.incomesData = (item!["Incomes"] as? [[String:Any]])!
                
                for element in self.incomesData{
                    self.incomeNumer.append(element["Value"] as! Double)
                    self.incomeTime.append(element["When"] as! String)
                }
                
                self.tableView.reloadData()
                self.hideActivityIndicator()
            }
        }
        
        Statistics.getName(header: profile){name in
            if let object = name as? [String:Any]{
                
                self.someLabel.text = (object["FirstName"] as! String) + " " + (object["LastName"] as! String)
                let url = object["ImageThumbUrl"] as! String
                
                self.profileImage.downloadedFrom(link: url)
                self.profileImage.layer.cornerRadius = 8.0
                self.profileImage.clipsToBounds = true
            }
        }
        profileImage.contentMode = .scaleToFill

        someLabel.font = UIFont(name: "Avenir Next Medium", size: 16)
        someLabel.textColor = .white
        balanceUsd.textColor = .white
        balance.textColor = .white
        currencyCode.textColor = .white
        balanceUsd.font = UIFont(name: "Avenir Next Medium", size: 14)
        balance.font = UIFont(name: "Avenir Next Medium", size: 14)
        
        logOut.backgroundColor = blueColor
        logOut.layer.cornerRadius = 6
        logOut.tintColor = .white
        logOut.setTitle("LogOut", for: .normal)
        logOut.setTitleColor(.white, for: .normal)
        logOut.setTitleColor(.gray, for: .highlighted)
        
        logOut.addTarget(self, action: #selector(logOut(_:)), for: .touchUpInside)
        
        
        refresh.backgroundColor = blueColor
        refresh.layer.cornerRadius = 6
        refresh.tintColor = .white
        refresh.setTitle("Refresh", for: .normal)
        refresh.setTitleColor(.white, for: .normal)
        refresh.setTitleColor(.gray, for: .highlighted)
        
        refresh.addTarget(self, action: #selector(refresh(_:)), for: .touchUpInside)
        
        someLabel.textAlignment = .center
        profileImage.contentMode = .scaleToFill
        
        
        profileImage  <- [TopMargin(30),Right(100),Left(100),Height(100)]
        someLabel <- [Top(20).to(profileImage),Right(50),Left(50),Height(20)]
        balance <- [Top(10).to(someLabel),Left(self.view.frame.width/2 - 40),Height(20),Width(120)]
        balanceUsd <- [Top(20).to(balance),Left(self.view.frame.width/2 - 45),Height(20),Width(140)]
        tableView <- [Top(5).to(balanceUsd), Bottom(10).to(logOut),RightMargin(20),LeftMargin(20)]
        logOut <- [BottomMargin(20),Height(50),Width(80),Left(self.view.frame.width/2 - 120)]
        refresh <- [BottomMargin(20),Height(50),Width(80),Right(self.view.frame.width/2 - 120)]

    }

}

extension ProfileViewController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return incomeNumer.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "records") as? ProfileTableViewCell
        cell?.income.text = String(round(incomeNumer[indexPath.row]*10000)/10000)
        cell?.time.text = incomeTime[indexPath.row]
        return cell!
    }
}


