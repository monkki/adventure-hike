//
//  Mapa2ViewController.swift
//  Adventure Hike
//
//  Created by Roberto Gutierrez on 14/04/16.
//  Copyright © 2016 Roberto Gutierrez. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class Mapa2ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    //Datos a Recibir de Json
    var imagenesArray = [String]()
    var imagenesArrayUIImageViews = [UIImage]()
    var descripcionArrayHTML = [String]()
    var descripcionArrayString = [String]()
    var fechaArray = [String]()
    var horarioArray = [String]()
    var idArray = [Int]()
    var likedArray = [Int]()
    var likenArray = [Int]()
    var lugarArray = [Int]()
    var placeArray = [String]()
    var tituloArray = [String]()
    var latitudArray = [Double]()
    var longitudArray = [Double]()
    var checkInArray = [Int]()
    var comentariosArray = [Int]()
    var categoriasArray = [Int]()
    
    var tituloDelPin: String!

    // Localizacion usuario
    var locationManager: CLLocationManager!
    
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
        
        self.map.delegate = self
        
        if (CLLocationManager.locationServicesEnabled())
        {
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
        }
        
        obtenerJson()
        
        // Iniciar Loader
        JHProgressHUD.sharedHUD.showInView(view, withHeader: "Cargando", andFooter: "Por favor espere...")
        
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations.last! as CLLocation
        
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2))
        
        
        self.map.showsUserLocation = true
        self.map.setRegion(region, animated: true)
        locationManager.stopUpdatingLocation()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func obtenerJson() {
        
        let idUsuario = NSUserDefaults.standardUserDefaults().objectForKey("idUsuario") as! Int
        
        let urlPath = "http://intercubo.com/ah/api/archivo.php?tipo=Home" + "&u=" + "\(idUsuario)"
        
        let url = NSURL(string: urlPath)!
        
        let session = NSURLSession.sharedSession()
        
        let task = session.dataTaskWithURL(url, completionHandler: { (data, response, error) -> Void in
            
            if let data = data {
                
                if error != nil {
                    
                    print(error)
                    
                } else {
                    
                    do {
                        
                        self.imagenesArray.removeAll()
                        self.descripcionArrayHTML.removeAll()
                        self.fechaArray.removeAll()
                        self.horarioArray.removeAll()
                        self.idArray.removeAll()
                        self.likedArray.removeAll()
                        self.likenArray.removeAll()
                        self.lugarArray.removeAll()
                        self.placeArray.removeAll()
                        self.tituloArray.removeAll()
                        self.latitudArray.removeAll()
                        self.longitudArray.removeAll()
                        self.checkInArray.removeAll()
                        
                        let jsonResult = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers) as! NSArray
                        
                        print(jsonResult)
                        
                        dispatch_async(dispatch_get_main_queue()) { () -> Void in
                            
                            for json in jsonResult {
                                
                                let imagen = json["imagen"] as! String
                                let descripcion = json["descripcion"] as! String
                                let fecha = json["fecha"] as! String
                                let horario = json["horario"] as! String
                                let id = json["id"] as! Int
                                let liked = json["liked"] as! Int
                                let liken = json["liken"] as! Int
                                let lugar = json["lugar"] as! Int
                                let place = json["place"] as! String
                                let titulo = json["titulo"] as! String
                                let latitud = json["latitud"] as! Double
                                let longitud = json["longitud"] as! Double
                                let checkins = json["checkins"] as! Int
                                let comentarios = json["comentarios"] as! Int
                                let categoria = json["categoria"] as! Int
                                
                                self.imagenesArray.append(imagen)
                                self.descripcionArrayHTML.append(descripcion)
                                self.fechaArray.append(fecha)
                                self.horarioArray.append(horario)
                                self.idArray.append(id)
                                self.likedArray.append(liked)
                                self.likenArray.append(liken)
                                self.lugarArray.append(lugar)
                                self.placeArray.append(place)
                                self.tituloArray.append(titulo)
                                self.latitudArray.append(latitud)
                                self.longitudArray.append(longitud)
                                self.checkInArray.append(checkins)
                                self.comentariosArray.append(comentarios)
                                self.categoriasArray.append(categoria)
                                
                            }
                            
                            
                            for i in 0 ..< self.descripcionArrayHTML.count {
                                
                                let descripcion = self.descripcionArrayHTML[i].html2String
                                
                                self.descripcionArrayString.append(descripcion)
                                
                            }
                            
                            
                            
                        }
                        
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            
                            for i in 0 ..< self.latitudArray.count {
                                
                                let localizacionLugar: CLLocationCoordinate2D = CLLocationCoordinate2DMake(CLLocationDegrees(self.latitudArray[i]), CLLocationDegrees(self.longitudArray[i]))
                               
                                let point1 = MKPointAnnotation()
                                
                                point1.coordinate = localizacionLugar
                                point1.title = self.tituloArray[i]
                                point1.subtitle = "Adventure Hike"
                                self.map.addAnnotation(point1)
                                
                            }
                            
                            JHProgressHUD.sharedHUD.hide()
                            
                        })
                        
                        
                    } catch {
                        
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            print("Hubo un error al obtener los datos")
                            JHProgressHUD.sharedHUD.hide()
                            self.mostraMSJ("Hubo un problema con su conexion a internet, por favor intente de nuevo mas tarde")
                            
                        })
                        
                    }
                    
                }
                
            } else {
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    print("Hubo un error al obtener los datos")
                    JHProgressHUD.sharedHUD.hide()
                    self.mostraMSJ("Hubo un problema con su conexion a internet, por favor intente de nuevo mas tarde")
                    
                })
                
            }
            
        })
        
        task.resume()
        
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation is MKUserLocation {
            //return nil so map view draws "blue dot" for standard user location
            return nil
        }
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.animatesDrop = true
            pinView!.pinColor = .Purple
            
            let btn = UIButton(type: .DetailDisclosure)
            pinView!.rightCalloutAccessoryView = btn
            let leftIconView = UIImageView(frame: CGRectMake(0, 0, 53, 23))
            
            
            leftIconView.image = UIImage(named: "ahLogoInicio")
            pinView!.leftCalloutAccessoryView = leftIconView
    
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        print("Tocaste el Pin")
        tituloDelPin = (view.annotation?.title)!
        self.performSegueWithIdentifier("detalleEventoSegue", sender: self)
        
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "detalleEventoSegue" {
            
            for i in 0..<tituloArray.count {
                
                
                if tituloArray[i] == tituloDelPin {
                    
                    let destinoVC = segue.destinationViewController as! DetalleViewController
                    destinoVC.imagenRecibida = imagenesArray[i]
                    destinoVC.descripcionRecibida = descripcionArrayString[i]
                    destinoVC.fechaRecibida = fechaArray[i]
                    destinoVC.horarioRecibida = horarioArray[i]
                    destinoVC.idRecibida = idArray[i]
                    destinoVC.likedRecibida = likedArray[i]
                    destinoVC.likenRecibida = likenArray[i]
                    destinoVC.lugarRecibida = lugarArray[i]
                    destinoVC.placeRecibida = placeArray[i]
                    destinoVC.tituloRecibida = tituloArray[i]
                    destinoVC.latitudRecibida = latitudArray[i]
                    destinoVC.longitudRecibida = longitudArray[i]
                    destinoVC.checkInRecibidos = checkInArray[i]
    
                }
                
            }
            
            
        }
    }


    
    func mostraMSJ(msj: String){
        
        let alerta = UIAlertController(title: "Adventure Hike", message: msj, preferredStyle: UIAlertControllerStyle.Alert)
        alerta.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil))
        self.presentViewController(alerta, animated: true, completion: nil)
        
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
