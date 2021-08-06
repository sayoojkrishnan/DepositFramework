//
//  LoginViewController.swift
//  Deposits
//
//  Created by Biswajit Palei on 28/07/21.
//

import UIKit

class LoginViewController: UIViewController {
    class func build() -> LoginViewController {
        return LoginViewController(nibName: "LoginViewController", bundle: Bundle(for: LoginViewController.self))
    }
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    func BindData(){
        
    }
    
    @IBAction func loginButtonAction(_ sender: Any) {
    
    }
}
