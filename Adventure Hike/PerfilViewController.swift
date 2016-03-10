//
//  PerfilViewController.swift
//  Adventure Hike
//
//  Created by Roberto Gutierrez on 07/01/16.
//  Copyright © 2016 Roberto Gutierrez. All rights reserved.
//

import UIKit
import GaugeKit
import FBSDKCoreKit
import FBSDKShareKit
import FBSDKLoginKit
import CoreLocation

class PerfilViewController: UIViewController, CLLocationManagerDelegate {
    
    var locationManager: CLLocationManager!
    
    @IBOutlet var experienciaLabel: UICountingLabel!
    @IBOutlet var nivelLabel: UICountingLabel!
    @IBOutlet var checkInLabel: UICountingLabel!
    
    @IBOutlet var gaugeAzul: Gauge!
    @IBOutlet var gaugeRojo: Gauge!
    
    // Outlets info de Usuario
    @IBOutlet var nicknameLabel: UILabel!
    @IBOutlet var nombreCompletoLabel: UILabel!
    @IBOutlet var ciudadLabel: UILabel!
    @IBOutlet var fotoUsuario: UIImageView!
    
    
    
    // NSUserDefaults Variables
    let token = NSUserDefaults.standardUserDefaults().objectForKey("tokenServer")
    let fbid = NSUserDefaults.standardUserDefaults().objectForKey("fbid")
    let idUsuario = NSUserDefaults.standardUserDefaults().objectForKey("idUsuario")
    let nombreCompleto = NSUserDefaults.standardUserDefaults().objectForKey("nombre")

    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Imagen de perfil
        fotoUsuario.layer.borderWidth = 1
        fotoUsuario.layer.masksToBounds = false
        fotoUsuario.layer.borderColor = UIColor.lightGrayColor().CGColor
        fotoUsuario.layer.cornerRadius = fotoUsuario.frame.height/2
        fotoUsuario.clipsToBounds = true
        
        //Pintar imagen de perfil
        if (FBSDKAccessToken.currentAccessToken() != nil) {
        
            var documentsDirectory:String?
            
            var paths:[AnyObject] = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
            
            if paths.count > 0 {
                
                documentsDirectory = paths[0] as? String
                
                if let savePath: String = documentsDirectory! + "/imagenPerfil.jpg" {
                    
                    self.fotoUsuario.image = UIImage(named: savePath)
                    
                   // print(savePath)
                    
                }
                
            }
        
        } else {
            
            self.fotoUsuario.image = UIImage(named: "fotoPlaceholder")
            
        }
        
        
        
        // Localizacion
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        nicknameLabel.text = nombreCompleto as? String
        nombreCompletoLabel.text = nombreCompleto as? String

//        experienciaLabel.countFrom(0, endValue: 12390, duration: 1.5)
//        nivelLabel.countFrom(0, endValue: 12, duration: 1.5)
//        checkInLabel.countFrom(0, endValue: 14, duration: 1.5)
//        
//        
//        NSTimer.scheduledTimerWithTimeInterval(1.5, target: self, selector: "sumarAlGauge", userInfo: nil, repeats: false)
        
    }
    
    func sumarAlGauge() {
        gaugeAzul.rate = 3
        gaugeRojo.rate = 9
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        print("Pantalla Seleccionada")
        
        datosDelPerfil()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        gaugeAzul.rate = 0
        gaugeRojo.rate = 0
    }
    
    override func viewWillDisappear(animated: Bool) {
        gaugeAzul.rate = 0
        gaugeRojo.rate = 0
    }

    
    @IBAction func logOutBoton(sender: AnyObject) {
        
        NSUserDefaults.standardUserDefaults().removeObjectForKey("tokenServer")
        NSUserDefaults.standardUserDefaults().removeObjectForKey("fbid")
        NSUserDefaults.standardUserDefaults().removeObjectForKey("idUsuario")
        NSUserDefaults.standardUserDefaults().removeObjectForKey("nombre")
        
        let loginManager = FBSDKLoginManager()
        loginManager.logOut()
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(0.1 * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), { () -> Void in
            self.performSegueWithIdentifier("logoutSegue", sender: self)
        })
        
    }
    
    // METODOS DE LOCALIZACION
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let latitude = (locationManager.location?.coordinate.latitude)! as Double
        let longitude = (locationManager.location?.coordinate.longitude)! as Double
        
        print(String(latitude))
        print(String(longitude))

        
        if let ubicacion = manager.location {
            
            CLGeocoder().reverseGeocodeLocation(ubicacion, completionHandler: {(placemarks, error)-> Void in
                if (error != nil) {
                    
                    print("Geocoder fallo, error: " + error!.localizedDescription)
                    return
                    
                }
                
                if placemarks!.count > 0 {
                    
                    let pm = placemarks![0] as CLPlacemark
                    self.displayLocationInfo(pm)
                    
                } else {
                    
                    print("Hay un problema con los datos recibidos")
                    
                }
                
            })
            
        }
        
    }
    
    func displayLocationInfo(placemark: CLPlacemark) {
        
        locationManager.stopUpdatingLocation()
        
        let ciudadInfo = placemark.locality! as String
        let estadoInfo = placemark.administrativeArea! as String
        let colonia = placemark.addressDictionary!["SubLocality"] as? String
        let direccion = placemark.addressDictionary!["Street"] as? String
        
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            
            if let ciudad: String = ciudadInfo {
                
                self.ciudadLabel.text = ciudad + ", " + estadoInfo
                
                if let direccion = direccion {
                    
                    print(direccion)
                    print(colonia)
                    print(estadoInfo)
                    
//                    self.direccion = direccion
//                    self.colonia = colonia
//                    self.direccionLabel.text = direccion + ", " + colonia
//                    self.ciudadLabel.text = "\(ciudadInfo)" + " | " + "\(estadoInfo)"
                    
                }
            }
            
            
        }
        
    }
    
    // OBTENER LOS DATOS DEL PERFIL
    
    func datosDelPerfil() {
        
        let id = idUsuario as! Int
        
        let urlString = "http://intercubo.com/ah/api/archivo.php?tipo=Perfil&u=" + "\(id)"
        
        let url = NSURL(string: urlString)
        
        if let url = url {
            
            let task = NSURLSession.sharedSession().dataTaskWithURL(url, completionHandler: { (data, response, error) -> Void in
                
                if error != nil {
                    
                    print(error?.localizedDescription)
                    
                }
                
                if let data = data {
                    
                    do {
                        
                        let jsonResponse = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers) as! NSArray
                        
                        //print(jsonResponse)
                        
                        var checkIns: CGFloat!
                        var puntos: CGFloat!
                        
                        for json in jsonResponse {
                            
                            checkIns = json["checkins"] as! CGFloat
                            puntos = json["puntos"] as! CGFloat
                            
                            print("Check Ins son \(checkIns)")
                            print("Puntos son \(puntos)")
                            
                        }
                        
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            
                            let nivel = puntos / 100
                            
                            self.experienciaLabel.countFrom(0, endValue: puntos, duration: 1.5)
                            self.nivelLabel.countFrom(0, endValue: nivel, duration: 1.5)
                            self.checkInLabel.countFrom(0, endValue: checkIns, duration: 1.5)
                            
                            
                            //NSTimer.scheduledTimerWithTimeInterval(1.5, target: self, selector: "sumarAlGauge", userInfo: nil, repeats: false)
                            
                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(1.5 * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), { () -> Void in
                                self.gaugeAzul.rate = nivel
                                self.gaugeRojo.rate = checkIns
                            })
                            
                            
                        })

                        
                    } catch {
                        
                    }
                    
                } else {
                    
                    print("Hubo un problema al obtener los datos")
                    
                }
                
            })
            task.resume()
        
        } else {
            
            print("Hubo un problema al crear la URL")
            
        }
        
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
