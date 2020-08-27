//
//  RegisterViewController.swift
//  PlatziTweets
//
//  Created by XCodeClub on 2020-08-26.
//  Copyright © 2020 avilamisc. All rights reserved.
//

import UIKit
import NotificationBannerSwift

class RegisterViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var namesTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var registryButton: UIButton!
    
    // MARK: - IBActions
    @IBAction func registryButtonAction() {
        view.endEditing(true)
        performRegistry()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

            setupUI()
        }
        
    
    // MARK: - Private Methods
    private func setupUI() {
        registryButton.layer.cornerRadius = 25
    }
    
    private func performRegistry(){
        guard let email = emailTextField.text, !email.isEmpty else {
            NotificationBanner(title: "Error", subtitle: "Debes especificar un correo.", style: .warning).show()
            return
        }
        
        guard let password = passwordTextField.text, !password.isEmpty else {
            NotificationBanner(title: "Error", subtitle: "Debes especificar la contraseña.", style: .warning).show()
            return
        }
        
        guard let names = namesTextField.text, !names.isEmpty else {
            NotificationBanner(title: "Error", subtitle: "Debes especificar tu nombre.", style: .warning).show()
            return
        }
        
        performSegue(withIdentifier: "showHome", sender: nil)
        
        //REGISTRAR aqui!
        
    }

}
