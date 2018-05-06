//
//  User.swift
//  UnionOfMiners
//
//  Created by talgat on 30.10.17.
//  Copyright © 2017 Akezhan. All rights reserved.
//

import Foundation
struct User{
     var balance:Int?
     var balanceUSD:Int?
     var cryptoCode:String?
     var cryptoName:String?
     var incomes: [[String:Any]]?
}
extension UIImageView {
    func downloadedFrom(url: URL, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() {
                self.image = image
            }
            }.resume()
    }
    func downloadedFrom(link: String, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloadedFrom(url: url, contentMode: mode)
    }
}
