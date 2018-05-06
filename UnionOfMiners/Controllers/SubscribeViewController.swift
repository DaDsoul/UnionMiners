//
//  SubscribeViewController.swift
//  UnionOfMiners
//
//  Created by talgat on 15.10.17.
//  Copyright © 2017 Akezhan. All rights reserved.
//

import UIKit
import EasyPeasy

class SubscribeViewController: UIViewController {
    
    var tableView = UITableView()
    
    let sites = ["profitmaker","newscryptocoin","forklog"]
    let images = [#imageLiteral(resourceName: "Profitmaker"),#imageLiteral(resourceName: "Ncc"),#imageLiteral(resourceName: "forkLog")]
    
    let defaults = UserDefaults.standard
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.title = "Подписки"
        
        self.navigationController?.navigationBar.titleTextAttributes =  [
            NSForegroundColorAttributeName: UIColor.white
        ]
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       tableView.rowHeight = 200
    
    }
    
}


extension SubscribeViewController:UITableViewDataSource,UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "news", for: indexPath) as? SubscribeTableViewCell
        
        tableView.rowHeight = 120
        
        let nameSource = defaults.value(forKey: "source") as? [String]
        
        cell?.newsTitle.text = sites[indexPath.row].capitalized
        
        cell?.selectButton.isSelected = false
        
        var checker = false
        
        if let notEmptySources = nameSource {
                checker = notEmptySources.contains(sites[indexPath.row])
        }
        
        cell?.selectButton.isSelected = checker
        
        cell?.selectButton.setBackgroundImage(#imageLiteral(resourceName: "click"), for: .normal)
        cell?.selectButton.setBackgroundImage(#imageLiteral(resourceName: "clicked"), for: .selected)
        cell?.selectButton.imageView?.contentMode = .scaleAspectFit
        
        cell?.cellAction = { button in
            
            guard !checker else {
                self.deleteFromUserDefaults(name: self.sites[indexPath.row])
                tableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
                return
            }
            self.saveToUserDefaults(name: self.sites[indexPath.row])
            tableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
        }
        
        cell?.newsTitle.font = UIFont(name: "Avenir Next Medium", size: 20)
        cell?.selectionStyle = .none
        
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func saveToUserDefaults(name: String){
        var emptyArray = [String]()
        
        if let checkArray = defaults.stringArray(forKey: "source"){
            emptyArray = checkArray
        }
        
        emptyArray.append(name)
        defaults.set(emptyArray, forKey: "source")
    }
    
    
    
    func deleteFromUserDefaults(name: String){
        var num = 0
        if var array = self.defaults.stringArray(forKey: "source"){
            for i in array {
                if i == name {
                    array.remove(at: num)
                    self.defaults.removeObject(forKey: "source")
                    self.defaults.set(array, forKey: "source")
                    break
                }
                num += 1
            }
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sites.count
    }
    

}
