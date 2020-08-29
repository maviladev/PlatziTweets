//
//  LoginViewController.swift
//  PlatziTweets
//
//  Created by XCodeClub on 2020-08-26.
//  Copyright © 2020 avilamisc. All rights reserved.
//

import UIKit
import NotificationBannerSwift
import Simple_Networking
import SVProgressHUD

class LoginViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    // MARK: - IBActions
    @IBAction func loginButtonAction(){
        //view.endEditing(true)
        performLogin()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    // MARK: - Private Methods
    private func setupUI() {
        loginButton.layer.cornerRadius = 25
    }
    
    private func performLogin(){
        guard let email = emailTextField.text, !email.isEmpty else {
            NotificationBanner(title: "Error", subtitle: "Debes especificar un correo.", style: .warning).show()
            return
        }
        
        guard let passwrod = passwordTextField.text, !passwrod.isEmpty else {
            NotificationBanner(title: "Error", subtitle: "Debes especificar la contraseña.", style: .warning).show()
            return
        }
        //INICIAR sesion aqui
        
        //Crear request
        let request = LoginRequest(email: email, password: passwrod)
        
        //Iniciamos la carga
        SVProgressHUD.show()
        
        //Llamar a libreria de red
        SN.post(endpoint: Endpoints.login,
                model: request) { (response: SNResultWithEntity<LoginResponse, ErrorResponse>) in
            switch response {
            case .success(let user):
                DispatchQueue.main.async {
                    NotificationBanner(subtitle: "Bienvenido \(user.user.names)", style: .success).show()
                }
                
                self.performSegue(withIdentifier: "showHome", sender: nil)
            case .error(let error):
                NotificationBanner(title: "Error",
                                   subtitle: error.localizedDescription, style: .danger).show()
            case .errorResult(let entity):
                NotificationBanner(title: "Error",
                                   subtitle: entity.error,
                                   style: .warning).show()
            }
        }
    }

}
