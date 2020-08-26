//
//  WelcomeViewController.swift
//  PlatziTweets
//
//  Created by XCodeClub on 2020-08-26.
//  Copyright © 2020 avilamisc. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {
    // MARK: - Outlets
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    private func setupUI() {
        loginButton.layer.cornerRadius = 25
    }

}
