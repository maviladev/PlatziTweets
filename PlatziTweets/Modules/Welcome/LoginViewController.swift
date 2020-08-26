//
//  LoginViewController.swift
//  PlatziTweets
//
//  Created by XCodeClub on 2020-08-26.
//  Copyright © 2020 avilamisc. All rights reserved.
//

import UIKit
import NotificationBannerSwift

class LoginViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    // MARK: - IBActions
    @IBAction func loginButtonAction(){
        performLogin()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
        
    private func setupUI() {
        loginButton.layer.cornerRadius = 25
    }
    
    // MARK: - Private Methods
    private func performLogin(){
        guard let email = emailTextField.text, !email.isEmpty else {
            NotificationBanner(title: "Error", subtitle: "Debes especificar un correo.", style: .warning).show()
            return
        }
    }

}
