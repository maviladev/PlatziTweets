//
//  HomeViewController.swift
//  PlatziTweets
//
//  Created by XCodeClub on 2020-09-03.
//  Copyright © 2020 avilamisc. All rights reserved.
//

import UIKit
import Simple_Networking
import SVProgressHUD
import NotificationBannerSwift

class HomeViewController: UIViewController {
    // MARK: - Properties
    private let cellId = "TweetTableViewCell"
    private var dataSource = [PostItem]()

    // MARK: - IBOulets
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        getPosts()
    }
    
    private func setupUI(){
        // 1. Asignar datasource
        // 2. Registrar celda
        
        tableView.dataSource = self
        tableView.register(UINib(nibName: cellId, bundle: nil), forCellReuseIdentifier: cellId)
    }
    
    private func getPosts(){
        // 1. Indicar carga al usuario
        SVProgressHUD.show()
        
        // 2. Consumir el servicio
        
        SN.get(endpoint: Endpoints.posts) { (result: SNResultWithEntity<[PostItem], ErrorResponse>) in
            switch result {
            case .success(let posts):
                self.dataSource = posts
                self.tableView.reloadData()
                
            case .error(let error):
                NotificationBanner(title: "Error",
                                   subtitle: error.localizedDescription, style: .danger).show()
            case .errorResult(let entity):
                NotificationBanner(title: "Error",
                                   subtitle: entity.error,
                                   style: .warning).show()
            }
            //Cerramos el indicador de carga
            SVProgressHUD.dismiss()
        }
    }
}

extension HomeViewController: UITableViewDataSource {
    // Número total de celdas
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    // Configurar celda deseada
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        if let cell = cell as? TweetTableViewCell{
            //Configurar la celda
            cell.setupCellWith(post: dataSource[indexPath.row])
        }
        return cell
    }
}
