//
//  ViewController.swift
//  UnionOfMiners
//
//  Created by talgat on 21.09.17.
//  Copyright © 2017 Akezhan. All rights reserved.
//

import UIKit
import EasyPeasy
import Firebase
import Kingfisher
import Alamofire

let oneColor = UIColor(red: 47/255.0, green: 55/255.0, blue: 68/255.0, alpha: 1.0)

class ViewController: UIViewController {
    
   
    let descrption = UIView()

    func emptyFunc(sender: UIRefreshControl){
        Timer.scheduledTimer(withTimeInterval: 3.0, repeats: false) { (timer) in
            self.refresher.endRefreshing()
        }
    }
    
    let searchControl = UISearchController(searchResultsController: nil)
    
    let refresher = UIRefreshControl()

    var cryptoElements = [[String:Any]]()
    var filteredCryptoElements = [[String:Any]]()
    
    let titleLabel = UILabel()
    
    @IBOutlet var tableView: UITableView!

    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.descrption.isHidden = true
        self.searchControl.searchBar.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.searchControl.searchBar.isHidden = false
        self.descrption.isHidden = false
    }
    
    func showSearch(sender:UIButton){
    
        searchControl.hidesNavigationBarDuringPresentation = false
        searchControl.searchBar.keyboardType = UIKeyboardType.asciiCapable
        
        // Make this class the delegate and present the search
        self.searchControl.searchBar.delegate = self
        present(searchControl, animated: true, completion: nil)
    }
    


    override func viewDidLoad() {
        super.viewDidLoad()
        
//        Statistics.authorize(name: "sdm.mail+miner@gmail.com", password: "cC13iI03") { (elem) in
//            print(elem)
//        }
        
        self.searchControl.searchBar.showsCancelButton = false
        
        searchControl.searchBar.barTintColor = oneColor
        searchControl.searchBar.delegate = self
        searchControl.searchResultsUpdater = self
        searchControl.dimsBackgroundDuringPresentation = false
        definesPresentationContext = false
        
        let searchBarItem = UIButton()
        searchBarItem.setImage(#imageLiteral(resourceName: "search (1)-1"), for: .normal)
        searchBarItem.addTarget(self, action: #selector(showSearch(sender:)), for: .touchUpInside)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: searchBarItem)
        
        searchControl.hidesNavigationBarDuringPresentation = false
        searchControl.searchBar.placeholder = "Search"
        searchControl.searchBar.layer.borderWidth = 0.1
        
        let coinName = UILabel()
        let capital = UILabel()
        let price = UILabel()
        
        descrption.addSubview(coinName)
        descrption.addSubview(capital)
        descrption.addSubview(price)
        
        descrption.backgroundColor = oneColor
        descrption.layer.shadowOffset = .zero
        descrption.layer.shadowOpacity = 1
        
        self.navigationController?.navigationBar.addSubview(descrption)
        
        descrption <- [Right(0),Left(0),TopMargin((self.navigationController?.navigationBar.frame.height)!),Height(20)]
        
        coinName <- [LeftMargin(50),TopMargin(5),BottomMargin(5),Width(90)]
        capital <- [Left(self.view.frame.width*0.427),TopMargin(5),BottomMargin(5),Width(100)]
        price <- [RightMargin(20),TopMargin(5),BottomMargin(5),Width(70)]
        
        price.text = "Цена"
        coinName.text = "Монета"
        
        price.font = UIFont(name: "Avenir Next Medium", size: 10)
        capital.font = UIFont(name: "Avenir Next Medium", size: 10)
        coinName.font = UIFont(name: "Avenir Next Medium", size: 10)
        price.textColor = .white
        coinName.textColor = .white
        
        
        self.tableView.backgroundColor = UIColor(red: 213/255, green: 213/255, blue: 213/255, alpha: 1)
        
        tableView.addSubview(refresher)
        
        refresher.addTarget(self, action: #selector(emptyFunc(sender:)), for: .valueChanged)
        refresher.backgroundColor = UIColor(red: 213/255, green: 213/255, blue: 213/255, alpha: 1.0)
        
        self.tableView.tag = 0
        self.navigationController?.navigationBar.barTintColor = oneColor
        self.navigationController?.navigationBar.isTranslucent = false 
        self.navigationController?.navigationBar.topItem?.title = "UnionMiners"
        self.navigationController?.navigationBar.titleTextAttributes =  [
            NSForegroundColorAttributeName: UIColor.white,
            NSFontAttributeName: UIFont.boldSystemFont(ofSize: 16)
        ]
        
        self.navigationController?.navigationBar.layer.borderColor = oneColor.cgColor
        
        Statistics.fetchElement(child:"NewStatistics", callback: { (result) in
            
            self.cryptoElements = result
            self.tableView.reloadData()
        })
        
        
    }
    
}


extension ViewController:  UITableViewDataSource,UITableViewDelegate{
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toCharts"{
            let view = segue.destination as? ChartsViewController
            let indexPath = sender as? Int
            
            if isFiltering() != true {
                let name = cryptoElements[indexPath!]["short"] as! String
                view?.coinNameShort = name
                view?.coinName = name
                view?.coinNameFull = cryptoElements[indexPath!]["name"] as? String
                view?.coinImageUrl = cryptoElements[indexPath!]["picture"] as? String
            } else {
                let name = filteredCryptoElements[indexPath!]["short"] as! String
                view?.coinNameShort = name
                view?.coinName = name
                view?.coinNameFull = filteredCryptoElements[indexPath!]["name"] as? String
                view?.coinImageUrl = filteredCryptoElements[indexPath!]["picture"] as? String
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView.tag == 0{
            
            tableView.rowHeight = 90
            
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "identifier5", for: indexPath) as? CoinTableViewCell
            
            if isFiltering(){
                cell?.nameCryptoCurrencyLabel.text = filteredCryptoElements[indexPath.row]["name"] as? String
                cell?.capitalCryptoCurrencyLabel.text = filteredCryptoElements[indexPath.row]["short"] as? String
                cell?.priceCryptoCurrencyLabel.text = "$ " + String(describing: round((filteredCryptoElements[indexPath.row]["price"]! as! Double)*100)/100)
                let url = URL(string: filteredCryptoElements[indexPath.row]["picture"] as! String)
                cell?.iconCryptoCurrency.kf.setImage(with:  url)
            }else{
                cell?.nameCryptoCurrencyLabel.text = cryptoElements[indexPath.row]["name"] as? String
                cell?.capitalCryptoCurrencyLabel.text = cryptoElements[indexPath.row]["short"] as? String
                cell?.priceCryptoCurrencyLabel.text = "$ " + String(describing: round((cryptoElements[indexPath.row]["price"]! as! Double)*100)/100)
                let url = URL(string: cryptoElements[indexPath.row]["picture"] as! String)
                cell?.iconCryptoCurrency.kf.setImage(with:  url)
            }
            
            
            (cell?.iconCryptoCurrency)! <- [TopMargin(28),LeftMargin(10),Width(40),BottomMargin(20)]
            
            cell?.nameCryptoCurrencyLabel.font = UIFont(name: "Avenir Next Medium", size: 20)
            cell?.nameCryptoCurrencyLabel.font = UIFont.boldSystemFont(ofSize: 20)
            
            (cell?.nameCryptoCurrencyLabel)! <- [TopMargin(28),Left(10).to((cell?.iconCryptoCurrency)!),Width(120)]
            
            cell?.capitalCryptoCurrencyLabel.font = UIFont(name: "Avenir Next Medium", size: 16)
            
            cell?.priceCryptoCurrencyLabel.font = UIFont(name: "Avenir Next Medium", size: 21)
            
            (cell?.priceCryptoCurrencyLabel)! <- [TopMargin(28),RightMargin(15),Width(100)]
            (cell?.capitalCryptoCurrencyLabel)! <- [TopMargin(52),Left(10).to((cell?.iconCryptoCurrency)!),Width(120)]
            
            cell?.selectionStyle = UITableViewCellSelectionStyle.none
            
            cell?.lineView.layer.shadowOffset = CGSize.zero
            cell?.lineView.layer.shouldRasterize = true
            
            return cell!
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
//        cell.alpha = 0
        
        if isFiltering(){
            
                let transform = CATransform3DTranslate(CATransform3DIdentity, -250, 20, 0)
                cell.layer.transform = transform
                
                UIView.animate(withDuration: Double((indexPath.row + 1))*0.2 , delay: 0, options: UIViewAnimationOptions.allowUserInteraction, animations: { () -> Void in
                    cell.layer.transform = CATransform3DIdentity
                }, completion: nil)
            
        }
        
//        cell.layer.transform = CATransform3DMakeScale(0.1,0.1,1)
//        UIView.animate(withDuration: 0.3, animations: {
//            cell.layer.transform = CATransform3DMakeScale(1.05,1.05,1)
//        },completion: { finished in
//            UIView.animate(withDuration: 0.1, animations: {
//                cell.layer.transform = CATransform3DMakeScale(1,1,1)
//            })
//        })
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      performSegue(withIdentifier: "toCharts", sender: indexPath.row)
    }
    
//    func scrollViewDidScroll(scrollView: UIScrollView) {
//        let scrollDiff = scrollView.contentOffset.y - self.previousScrollOffset
//        let isScrollingDown = scrollDiff > 0
//        let isScrollingUp = scrollDiff < 0
//    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag == 0{
            if isFiltering(){
                return filteredCryptoElements.count
            } else{
                return cryptoElements.count
            }
        }
        return 2
    }
    
    
}

extension ViewController: UISearchResultsUpdating,UISearchBarDelegate{
    
    
    func searchBarIsEmpty() -> Bool{
        return searchControl.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All"){
        
        if cryptoElements.isEmpty == false {
            filteredCryptoElements = cryptoElements.filter({(element: [String:Any]) -> Bool in
                
                let someText = element["name"] as? String
                
                guard let text = someText else {
                    print("SomeProblem")
                    return false
                }
                
                return text.lowercased().contains(searchText.lowercased())
                
            })
            
        }
        tableView.reloadData()
        
    }
    
    
    func updateSearchResults(for searchController: UISearchController) {
        
        filterContentForSearchText(searchController.searchBar.text!)
        
    }
    
    func isFiltering() -> Bool{
        return searchControl.isActive && !searchBarIsEmpty()
    }
    

}

