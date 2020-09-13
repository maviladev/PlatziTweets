//
//  MapViewController.swift
//  PlatziTweets
//
//  Created by XCodeClub on 2020-09-13.
//  Copyright © 2020 avilamisc. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    // MARK: - IBOutlets
    @IBOutlet weak var mapContainer: UIView!
    
    // MARK: - Properties
    var posts = [PostItem]()
    private var map: MKMapView?
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupMap()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    private func setupMap(){
        map = MKMapView(frame: mapContainer.bounds)
        mapContainer.addSubview(map ?? UIView())
    }
    
    private func setupMarker(){
        posts.forEach { (item) in
            let marker = MKPointAnnotation()
            marker.coordinate = CLLocationCoordinate2D(latitude: item.location?.latitude ?? 0.0,
                                                       longitude: item.location?.longitude ?? 0.0)
            marker.title = item.text
            marker.subtitle = item.author.names
            
            map?.addAnnotation(marker)
                    
        }
        
        //Buscamos el ultimo post del arreglo
        guard let lastPost = posts.last else {
            return
        }
        
        let lastPostLocation = CLLocationCoordinate2D(latitude: lastPost.location?.latitude ?? 0.0, longitude: lastPost.location?.longitude ?? 0.0)
        
        guard let heading = CLLocationDirection(exactly: 12) else {
            return
        }
        
        map?.camera = MKMapCamera(lookingAtCenter: lastPostLocation, fromDistance: 30, pitch: .zero, heading: heading)
    }
    

    

}
