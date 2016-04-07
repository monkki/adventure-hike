//
//  MapaPageItemsViewController.swift
//  Adventure Hike
//
//  Created by Roberto Gutierrez on 05/04/16.
//  Copyright © 2016 Roberto Gutierrez. All rights reserved.
//

import UIKit
import MapKit

class MapaPageItemsViewController: UIViewController, MKMapViewDelegate {
    
    //IBOUTLETS
    @IBOutlet weak var label: UILabel!
    @IBOutlet var localLabel: UILabel!
    @IBOutlet var fechasLabel: UILabel!
    @IBOutlet var horariosLabel: UILabel!
    
    @IBOutlet var mapa: MKMapView!
    
    var eventos: String!
    var local: String!
    var fecha: String!
    var horario: String!
    var ubicacion:  CLLocationCoordinate2D!
    var index: Int!
    var numeroDePaginas: Int!
    
    @IBOutlet var controladorPagina: UIPageControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.label.text = eventos.uppercaseString
        localLabel.text = local
        fechasLabel.text = fecha
        horariosLabel.text = horario
        
        self.controladorPagina.currentPage = index
        self.controladorPagina.numberOfPages = numeroDePaginas
        
        //Mapa
        let point = MKPointAnnotation()
        
        
        point.coordinate = ubicacion
        point.title = eventos
        point.subtitle = local
        mapa.addAnnotation(point)
        
        mapa.delegate = self
        
        
        let latDelta = 0.005
        let lonDelta = 0.005
        
        let region = MKCoordinateRegion(center: ubicacion, span: MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: lonDelta))
        
        //Span of the map
        mapa.setRegion(region, animated: true)

        
        

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        print("viewWillAppear: \(self.eventos) animated: \(animated)")
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        print("viewDidAppear: \(self.eventos) animated: \(animated)")
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        print("viewWillDisappear: \(self.eventos) animated: \(animated)")
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        print("viewDidDisappear: \(self.eventos) animated: \(animated)")
    }
    
    deinit {
        print("deinit: \(self.eventos)")
    }
    
}
