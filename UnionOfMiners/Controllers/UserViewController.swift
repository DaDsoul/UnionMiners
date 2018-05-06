//
//  UserViewController.swift
//  UnionOfMiners
//
//  Created by talgat on 28.10.17.
//  Copyright © 2017 Akezhan. All rights reserved.
//

import UIKit
import EasyPeasy

class UserViewController: UIViewController, UITextFieldDelegate{
    
    var passwordInput = UITextField()
    var loginInput = UITextField()
    var password: String?
    var login: String?
    var acceptButton = UIButton()
    var checker = UserDefaults.standard.bool(forKey: "Auth")
    var logoImage = UIImageView()
    var warningLabel = UILabel()
    
    func clicker(_ sender: UIButton){
       
        guard let login = loginInput.text, let password = passwordInput.text else {
            warningLabel.text = "Nothing is inserted\nPlease try again"
            return
        }
        
        self.showActivityIndicator()
        
        Statistics.authorize(name: login, password: password){(auth, result,error) in
            UserDefaults.standard.set(auth, forKey: "Auth")
            if (auth == true){
                UserDefaults.standard.set(result, forKey: "header")
                let vc = ProfileViewController()
                self.navigationController?.pushViewController(vc, animated: true)
                self.warningLabel.text = error
            } else {
                self.warningLabel.text = error
            }
        }
        
        self.hideActivityIndicator()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        self.loginInput.text = ""
        self.passwordInput.text = ""
        self.warningLabel.text = ""
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        if UserDefaults.standard.bool(forKey: "Auth") == true{
            let vc = ProfileViewController()
            self.navigationController?.pushViewController(vc, animated: false)
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginInput.delegate = self
        passwordInput.delegate = self
        
        loginInput.tag = 0
        passwordInput.tag = 1
        
        passwordInput.isSecureTextEntry = true
        
        self.view.addSubview(acceptButton)
        self.view.addSubview(loginInput)
        self.view.addSubview(passwordInput)
        self.view.addSubview(logoImage)
        self.view.addSubview(warningLabel)
        
        self.view.backgroundColor = oneColor
        
        loginInput.tintColor = .black
        passwordInput.tintColor = .black
        
        loginInput.autocapitalizationType = .words
        passwordInput.autocapitalizationType = .words
        
        loginInput.backgroundColor = .white
        passwordInput.backgroundColor = .white
        
        loginInput.placeholder = "email"
        passwordInput.placeholder = "password"
        
        loginInput.borderStyle = .roundedRect
        passwordInput.borderStyle = .roundedRect
        
        acceptButton.setTitle("Accept", for: .normal)
        acceptButton.setTitleColor(.white, for: .normal)
        acceptButton.setTitleColor(.gray, for: .highlighted)
        acceptButton.backgroundColor = blueColor
        acceptButton.layer.cornerRadius = 6
        acceptButton.addTarget(self, action: #selector(clicker(_:)), for: .touchUpInside)
        
        warningLabel.textColor = .red
        warningLabel.font = UIFont(name: "Avenir Next Medium", size: 16)
        warningLabel.contentMode = .right
        logoImage.image = UIImage(named:"logo")
        
        
        logoImage <- [TopMargin(80),LeftMargin(30),RightMargin(30),Height(150)]
        loginInput <- [Left(80),Right(80),Top(20).to(logoImage),Height(50)]
        passwordInput <- [Left(100),Right(100),Top(30).to(loginInput),Height(50)]
        warningLabel <- [Left(100),Right(100),Top(40).to(passwordInput),Height(70)]
        acceptButton <- [Left(100),Right(100),Top(20).to(warningLabel),Height(50)]
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        login = loginInput.text!
//        password = passwordInput.text!
        
        loginInput.resignFirstResponder()
        passwordInput.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

//        if textField.tag == 0 {
//            login = textField.text!
//        } else {
//            password = textField.text!
//        }

        textField.resignFirstResponder()

        return true
    }
    
    
}
