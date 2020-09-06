//
//  AddPostViewController.swift
//  PlatziTweets
//
//  Created by XCodeClub on 2020-09-05.
//  Copyright © 2020 avilamisc. All rights reserved.
//

import UIKit
import Simple_Networking
import SVProgressHUD
import NotificationBannerSwift

class AddPostViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var postTextView: UITextView!
    
    // MARK: - IBActions
    @IBAction func addPostAction(){
        savePost()
    }
    @IBAction func dismissAction(){
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    private func savePost(){
        // 1. Crear request
        let request = PostRequest(text: postTextView.text, imageUrl: nil, videoUrl: nil, location: nil)
        
        // 2. Indicar carga al usuario
        SVProgressHUD.show()
        
        // 3. Llamar al servicio del post
        SN.post(endpoint: Endpoints.posts, model: request) { (result: SNResultWithEntity<PostItem, ErrorResponse>) in
                        
            switch result {
            case .success:
                self.dismiss(animated: true, completion: nil)
                
            case .error(let error):
                NotificationBanner(title: "Error",
                                   subtitle: error.localizedDescription, style: .danger).show()
            case .errorResult(let entity):
                NotificationBanner(title: "Error",
                                   subtitle: entity.error,
                                   style: .warning).show()
            }
            // 4. Cerramos el indicador de carga
            SVProgressHUD.dismiss()
        }
        
    }
}
