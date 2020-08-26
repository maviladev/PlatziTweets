//
//  RegisterViewController.swift
//  PlatziTweets
//
//  Created by XCodeClub on 2020-08-26.
//  Copyright © 2020 avilamisc. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var registryButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

            setupUI()
        }
        
        private func setupUI() {
            registryButton.layer.cornerRadius = 25
        }

}
