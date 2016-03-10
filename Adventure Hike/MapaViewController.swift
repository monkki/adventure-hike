//
//  MapaViewController.swift
//  Adventure Hike
//
//  Created by Roberto Gutierrez on 25/01/16.
//  Copyright © 2016 Roberto Gutierrez. All rights reserved.
//

import UIKit
import MapKit


class MapaViewController: UIViewController, MKMapViewDelegate {
    
    //Datos Recibibos
    var latitudRecibida: CLLocationDegrees!
    var longituRecibida: CLLocationDegrees!
    var tituloRecibida: String!
    
     var myRoute : MKRoute?
    
    // UBICACION USUARIO
    var latitude: CLLocationDegrees!
    var longitude: CLLocationDegrees!
    
    @IBOutlet weak var map: MKMapView!

    override func viewDidLoad() {
        super.viewDidLoad()

        let latitud: CLLocationDegrees = CLLocationDegrees(latitudRecibida)
        let longitud: CLLocationDegrees = CLLocationDegrees(longituRecibida)
//        
//        let span: MKCoordinateSpan = MKCoordinateSpanMake(0.06, 0.06)
        let localizacionLugar: CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitud, longitud)
//        let region: MKCoordinateRegion = MKCoordinateRegionMake(localizacionLugar, span)
//        map.setRegion(region, animated: true)
//        
//        let annotation = MKPointAnnotation()
//        annotation.coordinate = localizacionLugar
//        annotation.title = tituloRecibida
//        annotation.subtitle = "Adventure Hike"
//        map.addAnnotation(annotation)
        let point1 = MKPointAnnotation()
        let point2 = MKPointAnnotation()
        
        point1.coordinate = localizacionLugar
        point1.title = tituloRecibida
        point1.subtitle = "Adventure Hike"
        map.addAnnotation(point1)
        
        point2.coordinate = CLLocationCoordinate2DMake(latitude, longitude)
        point2.title = "Ubicacion"
        point2.subtitle = ""
        map.addAnnotation(point2)
        map.centerCoordinate = point2.coordinate
        map.delegate = self
        
        
        let latDelta = abs(point2.coordinate.latitude - point1.coordinate.latitude) * 2 + 0.005
        let lonDelta = abs(point2.coordinate.longitude - point1.coordinate.longitude) * 2 + 0.005
        
        let region = MKCoordinateRegion(center: point2.coordinate, span: MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: lonDelta))
        
        //Span of the map
        map.setRegion(region, animated: true)
        
        let directionsRequest = MKDirectionsRequest()
        let markTaipei = MKPlacemark(coordinate: CLLocationCoordinate2DMake(point1.coordinate.latitude, point1.coordinate.longitude), addressDictionary: nil)
        let markChungli = MKPlacemark(coordinate: CLLocationCoordinate2DMake(point2.coordinate.latitude, point2.coordinate.longitude), addressDictionary: nil)
        
        directionsRequest.source = MKMapItem(placemark: markChungli)
        directionsRequest.destination = MKMapItem(placemark: markTaipei)
        directionsRequest.transportType = MKDirectionsTransportType.Automobile
        let directions = MKDirections(request: directionsRequest)
        
        directions.calculateDirectionsWithCompletionHandler { (response, error) -> Void in
            if error == nil {
                self.myRoute = response!.routes[0]
                self.map.addOverlay((self.myRoute?.polyline)!)
            }
        }
        
    }
    
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        
        let myLineRenderer = MKPolylineRenderer(polyline: (myRoute?.polyline)!)
        myLineRenderer.strokeColor = UIColor(red:0.098, green:0.427, blue:1, alpha:1)
        myLineRenderer.lineWidth = 3
        return myLineRenderer
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
