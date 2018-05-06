//
//  NewsViewController.swift
//  UnionOfMiners
//
//  Created by talgat on 14.10.17.
//  Copyright © 2017 Akezhan. All rights reserved.
//

import UIKit
import SafariServices

class NewsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate{
    
    func emptyFunc(sender: UIRefreshControl){
        Timer.scheduledTimer(withTimeInterval: 3.0, repeats: false) { (timer) in
            sender.endRefreshing()
        }
    }
    
    @IBOutlet var tableView: UITableView!
    
    
    var elements: [[String:String]] = [[:]]
    var allElements = [[String:String]]()
    var letter = [[String:String]]()
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        let str = "Нет подписок"
        let attrs = [NSFontAttributeName: UIFont.preferredFont(forTextStyle: UIFontTextStyle.headline)]
        return NSAttributedString(string: str, attributes: attrs)
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        let str = "Добавьте хотя бы одну подписку\n"
        let attrs = [NSFontAttributeName: UIFont.preferredFont(forTextStyle: UIFontTextStyle.body)]
        return NSAttributedString(string: str, attributes: attrs)
    }
    
    func image(forEmptyDataSet scrollView: UIScrollView) -> UIImage? {
        
        let img = #imageLiteral(resourceName: "warn")
        
        return img
        
    }
    
    func fetchChosenSources(_ object: [String], _ post: [String:[[String:String]]]) -> [[String:String]]{
        
        var allResources = [[String:String]]()
        
        for name in object {
            
            for index in post[name]!{
                allResources.append(index)
            }
            
        }
        
        return allResources
    }
    
    var someArray = [[],[],[],[],[]]
    
    var refrehser = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.addSubview(refrehser)
        refrehser.addTarget(self, action: #selector(emptyFunc(sender:)), for: .valueChanged)
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        tableView.tableFooterView = UIView()
        
        if UserDefaults.standard.stringArray(forKey: "source") == nil {
            self.someArray =  [[],["Вce ресурсы"],[],["profitmaker"],[]]
        } else {
            self.someArray =  [[],["Вce ресурсы"],[],UserDefaults.standard.stringArray(forKey: "source")!,[]]
        }

        tableView.rowHeight = 200
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "us")
        
        Statistics.fetchNews(child: "SomeDataAlpha") { (result) in
            self.allElements = [[String:String]]()
            self.allElements = self.fetchChosenSources(self.someArray[3] as! [String] , result)
            
            dateFormatter.dateFormat = "MMM d, yyyy"
            
            self.letter = (self.allElements.sorted{ l, r in
                guard let ldateString = l["data"], let rdateString = r["data"],
                    let ldate = dateFormatter.date(from: ldateString), let rdate = dateFormatter.date(from: rdateString) else {
                        return false
                }
                return ldate > rdate
            })
            
            
            self.elements = self.letter
            
            self.tableView.reloadData()
            self.hideActivityIndicator()
        }
        // Do any additional setup after loading the view.
    }
    func showWebSite(index: Int) {
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let shareAction = UIAlertAction(title: "Поделиться", style: .default) { (action) -> Void in
            alert.dismiss(animated: true, completion: nil)
            let vc = UIActivityViewController(activityItems: [NSURL(string: self.letter[index]["href"]!) ?? "ok"], applicationActivities: nil)
            self.present(vc, animated: true, completion: nil)
        }
        
        let openAction = UIAlertAction(title: "Открыть", style: .default) { (action) -> Void in
            alert.dismiss(animated: true, completion: nil)
            if let url = URL(string: self.letter[index]["href"]!) {
                UIApplication.shared.open(url, options: [:])
            }
            
        }
        
        
        alert.addAction(UIAlertAction(title: "Скопировать URL публикации", style: UIAlertActionStyle.default, handler: { (action: UIAlertAction!) in
            let pasteboard = UIPasteboard.general
            pasteboard.string=self.letter[index]["href"]!
            
        }))
        
        alert.addAction(openAction)
        alert.addAction(shareAction)
        
        alert.addAction(UIAlertAction(title: "Отмена", style: UIAlertActionStyle.cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showWebSite(index:indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "news", for: indexPath) as? NewsTableViewCell
        
        cell?.backgroundColor = .white
        cell?.titleNews.text = letter[indexPath.row]["title"]
        cell?.textNews.text = letter[indexPath.row]["text"]
        cell?.sourceNes.text = letter[indexPath.row]["source"]
        cell?.dataNews.text = letter[indexPath.row]["data"]
        cell?.titleNews.textColor = .black
        cell?.sourceNes.textColor = .black
        cell?.dataNews.textColor = .black
        cell?.textNews.textColor = .black
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return letter.count
    }

}
