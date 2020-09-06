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
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getPosts()        
    }
    
    private func setupUI(){
        // 1. Asignar datasource
        // 2. Registrar celda
        
        tableView.delegate = self
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
    private func deletePostAt(indexPath: IndexPath){
        // 1. Indicar carga al usuario
        SVProgressHUD.show()
        
        // 2. Obtener el ID del post que vamos a borrar
        let postId = dataSource[indexPath.row].id
        
        // 3. Preparar el endpoint
        let endpoint = Endpoints.delete.replacingOccurrences(of: "{ID_DEL_POST}", with: postId)
        
        // 4. Consumir el servicio para borrar el post
        SN.delete(endpoint: endpoint)
        { (result: SNResultWithEntity<GeneralResponse, ErrorResponse>) in
            switch result {
            case .success:
               // 1. Borrar el post del datasource
                self.dataSource.remove(at: indexPath.row)
               // 2. Borrar la celda de la tabla
                self.tableView.deleteRows(at: [indexPath], with: .left)
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



extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deletAction = UITableViewRowAction(style: .destructive, title: "Borrar") { (_, _) in
            //Aqui borramos el tweet
            self.deletePostAt(indexPath: indexPath)
            
        }
        return [deletAction]
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // TODO: Guardar correo en los userDefaults para validar aqui
        return dataSource[indexPath.row].author.email != "" //Solo tweets que sean del usuario
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
