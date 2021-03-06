//
//  RegisterViewController.swift
//  PlatziTweets
//
//  Created by XCodeClub on 2020-08-26.
//  Copyright © 2020 avilamisc. All rights reserved.
//

import UIKit
import NotificationBannerSwift
import Simple_Networking
import SVProgressHUD

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
        
        //REGISTRAR aqui!
        let request = RegistryRequest(email: email, password: password, names: names)
        
        SVProgressHUD.show()
        
        SN.post(endpoint: Endpoints.register,
                model: request) { (response: SNResultWithEntity<LoginResponse, ErrorResponse>) in
                    switch response{
                    case .success(let user):
                        DispatchQueue.main.async {
                            NotificationBanner(subtitle: "Usuario creado \(user.user.names)", style: .success).show()
                        }
                        self.performSegue(withIdentifier: "showHome", sender: nil)
                        SimpleNetworking.setAuthenticationHeader(prefix: "", token: user.token)
                    case .error(let error):
                        NotificationBanner(title: "Error",
                                       subtitle: error.localizedDescription,
                                       style: .danger).show()
                    case .errorResult(let entity):
                        NotificationBanner(title: "Error",
                                           subtitle: entity.error,
                                           style: .warning).show()
                        SVProgressHUD.dismiss()
                    }
        }
    }

}
