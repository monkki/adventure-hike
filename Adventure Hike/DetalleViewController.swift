//
//  DetalleViewController.swift
//  Adventure Hike
//
//  Created by Roberto Gutierrez on 04/01/16.
//  Copyright © 2016 Roberto Gutierrez. All rights reserved.
//

import UIKit
import DOFavoriteButton
import CoreLocation
import Social
import TKSwarmAlert

class DetalleViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextViewDelegate, CLLocationManagerDelegate {
    
    var locationManager: CLLocationManager!
    
    //Valores recibidos
    var imagenRecibida: String!
    var descripcionRecibida: String!
    var fechaRecibida: String!
    var horarioRecibida: String!
    var idRecibida: Int!
    var likedRecibida: Int!
    var likenRecibida: Int!
    var lugarRecibida: Int!
    var placeRecibida: String!
    var tituloRecibida: String!
    var latitudRecibida: Double!
    var longitudRecibida: Double!
    var checkInRecibidos: Int!
    
    // NSUserDefaults Variables
    let token = NSUserDefaults.standardUserDefaults().objectForKey("tokenServer")
    let fbid = NSUserDefaults.standardUserDefaults().objectForKey("fbid")
    let idUsuario = NSUserDefaults.standardUserDefaults().objectForKey("idUsuario")
    let nombreCompleto = NSUserDefaults.standardUserDefaults().objectForKey("nombre")

    //IBOutlets
    @IBOutlet var imagenDetalle: UIImageView!
    @IBOutlet var descripcionLabel: UILabel!
    @IBOutlet var tituloLabel: UILabel!
    @IBOutlet var ubicacionLabel: UILabel!
    @IBOutlet var corazonLabel: UILabel!
    @IBOutlet var ubicacionDescripcionLabel: UILabel!
    @IBOutlet var fechaLabel: UILabel!
    @IBOutlet var horarioLabel: UILabel!
    @IBOutlet var tablaComentarios: UITableView!
    @IBOutlet var comentarioTextView: UITextView!
    @IBOutlet var distanciaMetrosLabel: UILabel!
    
    // Fotos Usuario
    @IBOutlet var fotoUsuario: UIImageView!
    
    // UIImage convertida
    var image = UIImage()
    
    
    //Boton Corazon Like
    @IBOutlet var botonCorazon: DOFavoriteButton!
    
    
    
    //ARRAYS DE COMENTS
    var usuariosArray = [String]()
    var comentariosArray = [String]()
    var imagenArray = [String]()
    var fechaArray = [String]()
    var idEventoArray = [Int]()
    var idComentarioArray = [Int]()
    var idUsuarioArray = [Int]()
    var fbidArray = [AnyObject]()
    
    // UBICACION USUARIO
    var latitude: CLLocationDegrees!
    var longitude: CLLocationDegrees!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Foto Usuario
        fotoUsuario.layer.borderWidth = 1
        fotoUsuario.layer.masksToBounds = false
        fotoUsuario.layer.borderColor = UIColor.lightGrayColor().CGColor
        fotoUsuario.layer.cornerRadius = fotoUsuario.frame.height/2
        fotoUsuario.clipsToBounds = true
        
        //Foto Usuario 
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

        
        
        //Localizacion
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        tablaComentarios.delegate = self
        tablaComentarios.dataSource = self
        
        comentarioTextView.delegate = self
        
        self.tituloLabel.text = self.tituloRecibida
        self.ubicacionLabel.text = "\(self.checkInRecibidos)"
        self.corazonLabel.text = "\(self.likenRecibida)"
        self.ubicacionDescripcionLabel.text = self.placeRecibida
        self.fechaLabel.text = self.fechaRecibida
        self.horarioLabel.text = self.horarioRecibida
        self.descripcionLabel.text = descripcionRecibida
        
        
        // Iniciar Loader
        JHProgressHUD.sharedHUD.showInView(view, withHeader: "Cargando", andFooter: "Por favor espere...")

        // Procesar imagen de String a UIImage
        let image_url = NSURL(string: imagenRecibida)
        
        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        dispatch_async(dispatch_get_global_queue(priority, 0)) {
            // do some task
            let image_data = NSData(contentsOfURL: image_url!)
            
            if let image_data = image_data {
                
                dispatch_async(dispatch_get_main_queue()) {
                    // update some UI
                    self.image = UIImage(data: image_data)!
                    self.imagenDetalle.image = self.image
                    // Iniciar Loader
                    self.recibirComentarios(String(self.idRecibida))
                    JHProgressHUD.sharedHUD.hide()
                }
                
            } else {
                
                self.mostraMSJ("No hay conexion a internet, intente nuevamente mas tarde")
                JHProgressHUD.sharedHUD.hide()
                
            }
            
        }

        // Propiedades del boton like
        botonCorazon.imageColorOn = UIColor(red: 254/255, green: 110/255, blue: 111/255, alpha: 1.0)
        botonCorazon.circleColor = UIColor(red: 254/255, green: 110/255, blue: 111/255, alpha: 1.0)
        botonCorazon.lineColor = UIColor(red: 226/255, green: 96/255, blue: 96/255, alpha: 1.0)
        botonCorazon.addTarget(self, action: Selector("likeButton:"), forControlEvents: UIControlEvents.TouchUpInside)
        
        if likedRecibida == 0 {
            botonCorazon.deselect()
        } else {
            botonCorazon.select()
        }
        print("Likes recibidos son \(likenRecibida)")
        
    
        // Textview Comentar
        comentarioTextView.text = "Escribe una opinion..."
        comentarioTextView.textColor = UIColor.lightGrayColor()
        
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        
    }
    
    // ENLACE PARA OBTENER COMMENTS  http://intercubo.com/ah/api/archivo.php?tipo=Comments&id=1
    
    // ENLACE PARA OBTENER COMMENTS  http://intercubo.com/ah/api/comenta.php?e=1&u=5&c=rober

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // METODO PARA RECIBIR LOS COMENTARIOS
    
    func recibirComentarios(idEvento: String) {
        
        let urlString = "http://intercubo.com/ah/api/archivo.php?tipo=Comments&id=" +  idEvento
        let url: NSURL = NSURL(string: urlString)!
        
        if let url2: NSURL = url {
            
            let task = NSURLSession.sharedSession().dataTaskWithURL(url2) { (data, response, error) -> Void in
                
                if error != nil {
                    
                    print(error?.localizedDescription)
                    
                }
                    
                if let data = data {
                    
                    do {
                        
                        let jsonResponse = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers) as! NSMutableArray
                        
                       // print(jsonResponse)
                        
                        self.usuariosArray.removeAll()
                        self.comentariosArray.removeAll()
                        self.imagenArray.removeAll()
                        self.fechaArray.removeAll()
                        self.idEventoArray.removeAll()
                        self.idComentarioArray.removeAll()
                        self.idUsuarioArray.removeAll()
                        self.fbidArray.removeAll()
                        
                        for json in jsonResponse {
                            
                            let usuario = json["nombreusuario"] as! String
                            let comentario = json["comentario"] as! String
                            let imagenUsuario = json["displayusuario"] as! String
                            let fecha = json["fecha"] as! String
                            let idEvento = json["evento"] as! Int
                            let idComentario = json["id"] as! Int
                            let idUsuario = json["usuario"] as! Int
                            let fbid = json["fbid"] as AnyObject
                           // print(idUsuario)
                            
                            self.usuariosArray.append(usuario)
                            self.comentariosArray.append(comentario)
                            self.imagenArray.append(imagenUsuario)
                            self.fechaArray.append(fecha)
                            self.idEventoArray.append(idEvento)
                            self.idComentarioArray.append(idComentario)
                            self.idUsuarioArray.append(idUsuario)
                            self.fbidArray.append(fbid)
                            
                        }
                        
                        
                       // print(self.fbidArray)
                        
                        
                    } catch {
                        
                    }
                    
                    
                }
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.tablaComentarios.reloadData()
                })
                
            }
            
            task.resume()
            
        } else {
            
            print("Hay un problema al armar el URL")
        
        }
        
        
    }
    
    // METODO PARA POSTEAR COMENTARIOS
    
    func postearComentario(evento: String, usuario: String, comentario: String) {
        
        let customAllowedSet = NSCharacterSet.URLQueryAllowedCharacterSet()
        
        let comentario = comentario.stringByAddingPercentEncodingWithAllowedCharacters(customAllowedSet)!
        
        let urlString = "http://intercubo.com/ah/api/comenta.php?e=" + evento + "&u=" + usuario + "&c=" + comentario
        
        let url = NSURL(string: urlString)
        
        if let url = url {
            
            let task = NSURLSession.sharedSession().dataTaskWithURL(url) { (data, response, error) -> Void in
                
                if error != nil {
                    
                    print(error?.localizedDescription)
                    
                }
                
                if let data = data {
                    
                    
                    do {
                        
                        let jsonResponse = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers) as! NSMutableArray
                        
                        print(jsonResponse)
                        
                        if jsonResponse.count > 0 {
                            
                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                JHProgressHUD.sharedHUD.hide()
                                self.comentarioTextView.text = nil
                                self.comentarioTextView.resignFirstResponder()
                                self.recibirComentarios(String(self.idRecibida))
                            })
                            
                        }
                        
                        
                    } catch {
                    
                    }
                    
                    
                }
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.tablaComentarios.reloadData()
                })

            }
            
            task.resume()
            
            
        } else {
            
            print("Hay un problema al armar el URL")
            JHProgressHUD.sharedHUD.hide()
            
        }
        
    }
    
    
    
    // METODO DE TABLA COMENTARIOS
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usuariosArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tablaComentarios.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! ComentariosTableViewCell
        
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            
            // OBTENER FOTOS PARA COMENTARIOS
            if self.imagenArray.count > 0 {
                
                let imagenURL = "http://www.intercubo.com/ah/display/" + self.imagenArray[indexPath.row]
                
                if let image_url = NSURL(string: imagenURL) {
                    
                    let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
                    dispatch_async(dispatch_get_global_queue(priority, 0)) {
                        // do some task
                        if let image_data = NSData(contentsOfURL: image_url) {
                            
                            dispatch_async(dispatch_get_main_queue()) {
                                // update some UI
                                let image = UIImage(data: image_data)
                                
                                if image == nil {
                                    //779814947
                                    let imagenURL = "https://graph.facebook.com/" + "\(self.fbidArray[indexPath.row])" + "/picture?type=normal"
                                    
                                    let image_url = NSURL(string: imagenURL)
                                    
                                    let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
                                    dispatch_async(dispatch_get_global_queue(priority, 0)) {
                                        // do some task
                                        let image_data = NSData(contentsOfURL: image_url!)
                                        
                                        dispatch_async(dispatch_get_main_queue()) {
                                            // update some UI
                                            let image = UIImage(data: image_data!)
                                            
                                            if image == nil {
                                                
                                                cell.imagenUsuario.image = UIImage(named: "fotoPlaceholder")
                                                
                                            } else {
                                                
                                                cell.imagenUsuario.image = image
                                            }
                                        }
                                        
                                    }
                                    
                                } else {
                                    
                                    cell.imagenUsuario.image = image
                                }
                                
                              //  print(image)
                            }

                        } else {
                            
                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                cell.imagenUsuario.image = UIImage(named: "fotoPlaceholder")
                            })
                            
                        }
                        
                    }
                    
                } else {
                    
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        cell.imagenUsuario.image = UIImage(named: "fotoPlaceholder")
                    })
                    
                }
                
            }

        }
        
        
        cell.nombreLabel.text = self.usuariosArray[indexPath.row]
        cell.fechaLabel.text = self.fechaArray[indexPath.row]
        cell.comentarioLabel.text = self.comentariosArray[indexPath.row]
        
        
        //Foto Usuario
        cell.imagenUsuario.layer.borderWidth = 1
        cell.imagenUsuario.layer.masksToBounds = false
        cell.imagenUsuario.layer.borderColor = UIColor.lightGrayColor().CGColor
        cell.imagenUsuario.layer.cornerRadius = cell.imagenUsuario.frame.height/2
        cell.imagenUsuario.clipsToBounds = true
        
        return cell
    }
    
    
    // BOTON PARA INSERTAR COMENTARIO
    
    @IBAction func botonComentar(sender: AnyObject) {
        
        let id = idUsuario as! Int
        
        comentarioTextView.resignFirstResponder()
        // Iniciar Loader
        JHProgressHUD.sharedHUD.showInView(view, withHeader: "Enviando comentario", andFooter: "Por favor espere...")
        
        let comentario = comentarioTextView.text
        
        postearComentario(String(idRecibida), usuario: String(id), comentario: comentario)
        
    }
    
    
    // BOTON PARA VER TODAS LAS OPINIONES
    
    @IBAction func botonVerTodasOpiniones(sender: AnyObject) {
        
        self.recibirComentarios(String(idRecibida))
        
    }
    
    
    // METODO BOTON CORAZON/LIKE
    
    func likeButton(sender: DOFavoriteButton) {
        if sender.selected {
            // deselect
            sender.deselect()
            print("Like se ha deseleccionado")
            self.likes()
            
        } else {
            // select with animation
            sender.select()
            print("Like se ha seleccionado")
            self.likes()
        }
    }

    func likeButton2(sender: DOFavoriteButton) {
        if sender.selected {
            // deselect
            sender.deselect()
            print("Like se ha deseleccionado")
            
            
        } else {
            // select with animation
            sender.select()
            print("Like se ha seleccionado")
    
        }
    }

    
    // Metodos del Textview comentar
    
    func textViewDidBeginEditing(textView: UITextView) {
        if textView.textColor == UIColor.lightGrayColor() {
            textView.text = nil
            textView.textColor = UIColor.blackColor()
        }
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Escribe una opinion..."
            textView.textColor = UIColor.lightGrayColor()
        }
    }
    
    
    // METODO PARA OBTENER LATITUD Y LONGITUD
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        latitude = (locationManager.location?.coordinate.latitude)!
        longitude = (locationManager.location?.coordinate.longitude)!
        
       // locationManager.stopUpdatingLocation()
        
        let userLocation:CLLocation = CLLocation(latitude: latitude, longitude: longitude)
        let eventoLocation:CLLocation = CLLocation(latitude: latitudRecibida , longitude: longitudRecibida)
        let distancia :CLLocationDistance = userLocation.distanceFromLocation(eventoLocation)
        
        let metros = Int(distancia)
        
        distanciaMetrosLabel.text = "\(metros) Mts."
        
        //print(metros)
        //print(String(latitude))
        //print(String(longitude))
        
    }
    
    // COMPARTIR CON FACEBOOK
    
    @IBAction func compartirFacebook(sender: AnyObject) {
        
        if SLComposeViewController.isAvailableForServiceType(SLServiceTypeFacebook) {
            
            let vc = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
            vc.setInitialText("Adventure Hike! Disfruta de este excelente lugar \(tituloRecibida)")
            vc.addImage(image)
            vc.addURL(NSURL(string: "http://adventure-hike.com"))
            presentViewController(vc, animated: true, completion: nil)
            
        } else {
            
            self.mostraMSJ("Facebook no configurado en su telefono, porfavor intente nuevamente una vez configurado")
            
        }
        
    }
    
    func mostraMSJ(msj: String){
        
        let alerta = UIAlertController(title: "Adventure Hike", message: msj, preferredStyle: UIAlertControllerStyle.Alert)
        alerta.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil))
        self.presentViewController(alerta, animated: true, completion: nil)
        
    }
    
    
    // BOTON CHECK IN

    @IBAction func checkInBoton(sender: AnyObject) {
        
        // Iniciar Loader
        JHProgressHUD.sharedHUD.showInView(view, withHeader: "Haciendo Check In", andFooter: "Por favor espere...")
        
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        
        let customAllowedSet = NSCharacterSet.URLQueryAllowedCharacterSet()
        
        let latitudLugar = String(latitudRecibida)
        let longitudLugar = String(longitudRecibida)
        
        let latitudUsuario = String(latitude)
        let longitudUsuario = String(longitude)
        
        let latitud1 = latitudLugar.stringByAddingPercentEncodingWithAllowedCharacters(customAllowedSet)!
        let longitud1 = longitudLugar.stringByAddingPercentEncodingWithAllowedCharacters(customAllowedSet)!
        
        let latitud2 = latitudUsuario.stringByAddingPercentEncodingWithAllowedCharacters(customAllowedSet)!
        let longitud2 = longitudUsuario.stringByAddingPercentEncodingWithAllowedCharacters(customAllowedSet)!
        
        let id = String(NSUserDefaults.standardUserDefaults().objectForKey("idUsuario") as! Int)
        
        let idUsua = id.stringByAddingPercentEncodingWithAllowedCharacters(customAllowedSet)!
        
        let urlString = "http://intercubo.com/ah/api/checkin.php?lat1=" + latitud1 + "&lon1=" + longitud1 + "&lat2=" + latitud2 + "&lon2=" + longitud2 + "&u=" + idUsua + "&e=" + String(idRecibida)
        
        let url = NSURL(string: urlString)
        
        if let urlCreada: NSURL = url {
            
            let task = NSURLSession.sharedSession().dataTaskWithURL(urlCreada, completionHandler: { (data, response, error) -> Void in
                
                if error != nil {
                    print(error?.localizedDescription)
                }
                
                if let data = data {
                   
                    let datastring = NSString(data: data, encoding: NSUTF8StringEncoding)! as NSString
                    print(datastring)
                    
                    if datastring == "0" {
                        

                        UIApplication.sharedApplication().endIgnoringInteractionEvents()
                        
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            JHProgressHUD.sharedHUD.hide()
                            self.showError()
                        })
                        
                    } else if datastring == "check in" {
                        
                
                        UIApplication.sharedApplication().endIgnoringInteractionEvents()
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            self.checkInRecibidos = self.checkInRecibidos + 1
                            self.ubicacionLabel.text = "\(self.checkInRecibidos)"
                            JHProgressHUD.sharedHUD.hide()
                            self.showSuccess()
                        })
                        
                    } else  {
                        
                        
                        UIApplication.sharedApplication().endIgnoringInteractionEvents()
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            JHProgressHUD.sharedHUD.hide()
                            self.showError2()
                        })
                    }
                    
                    
                } else {
                    
                    UIApplication.sharedApplication().endIgnoringInteractionEvents()
                    print("Ha habido un error al obtener los datos")
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        JHProgressHUD.sharedHUD.hide()
                        self.showError2()
                    })
                    
                }
                
            })
            
            task.resume()
            
        } else {
            
            
            UIApplication.sharedApplication().endIgnoringInteractionEvents()
            print("Ha habido un error al crear la URL")
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                JHProgressHUD.sharedHUD.hide()
                self.showError2()
            })
            
        }
        
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "mapaSegue" {
            
            let destinoVC = segue.destinationViewController as! MapaViewController
            destinoVC.latitudRecibida = latitudRecibida
            destinoVC.longituRecibida = longitudRecibida
            destinoVC.tituloRecibida = tituloRecibida
            destinoVC.latitude = latitude
            destinoVC.longitude = longitude
        
        }
        
    }

    
    // METODO PARA AGREGAR O QUITAR LIKE
    
    func likes() {
        
        let idUsuario = NSUserDefaults.standardUserDefaults().objectForKey("idUsuario") as! Int
        let idEvento = "\(idRecibida)"
        
        let urlString = "http://www.intercubo.com/ah/api/like.php?p=" + idEvento + "&u=" + "\(idUsuario)"
        
        let url = NSURL(string: urlString)
        
        if let url = url {
            
            let task = NSURLSession.sharedSession().dataTaskWithURL(url) { (data, response, error) -> Void in
                
                if let data = data {
                    
                    do {
                        
                        let jsonResponse = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers) as! NSArray
                        
                        print(jsonResponse)
                        
                        if jsonResponse.count > 0 {
                            
                            for json in jsonResponse {
                                
                                let liken = json["liken"] as! Int
                                let liked = json["liked"] as! Int
                                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                    
                                    self.corazonLabel.text = "\(liken)"
                                    
                                    if liked == 0 {
                                        
                                        self.botonCorazon.deselect()
                                        
                                    } else if liked == 1 {
                                        
                                        self.botonCorazon.select()
                                        
                                    }
                                    
                                })
                                
                            }
                            
                        }
                        
                    } catch {
                        
                    }
                    
                } else {
                    print("Ha ocurrido un problema al obtener Data")
                    
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.likeButton2(self.botonCorazon)
                        self.mostraMSJ("Hubo un problema al dar like, verifique su conexión a internet e intente nuevamente")
                    })
                    
                }
                
            }
            task.resume()
            
        } else {
            
            print("Ha ocurrido un problema al crear la URL")
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.likeButton2(self.botonCorazon)
                self.mostraMSJ("Hubo un problema al dar like, verifique su conexión a internet e intente nuevamente")
            })
            
        }
        
        
        
    }
    
    func showSuccess() {
        
        let fallView = UIView()
        fallView.backgroundColor = UIColor.clearColor()
        fallView.frame = CGRect(x: 100, y: 100, width: 200, height: 200)
        fallView.center = view.center
        
        let alert = TKSwarmAlert()
        alert.show(type: TKSWBackgroundType.BrightBlur, views: [fallView])
        
            
        let alertView = SCLAlertView()
        alertView.showCloseButton = false
        alertView.addButton("Aceptar") { () -> Void in
                
            alert.spawn([fallView])
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    
                alert.didDissmissAllViews = {
                    print("didDissmissAllViews")
                        
                }
                    
            })
                
        }
            
        alertView.showSuccess("Felicidades", subTitle: "Ha hecho su Check in exitosamente  le agradece su presencia")
        
    }
    
    func showError() {
        
        let fallView = UIView()
        fallView.backgroundColor = UIColor.clearColor()
        fallView.frame = CGRect(x: 100, y: 100, width: 200, height: 200)
        fallView.center = self.view.center
        
        let alert = TKSwarmAlert()
        alert.show(type: TKSWBackgroundType.BrightBlur, views: [fallView])
        
        let alertView = SCLAlertView()
        alertView.showCloseButton = false
        alertView.addButton("Aceptar") { () -> Void in
               
            alert.spawn([fallView])
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    
                alert.didDissmissAllViews = {
                    print("didDissmissAllViews")
                        
                }
                    
            })
                
        }
        alertView.showError("Error Check In", subTitle: "No se encuentra dentro del rango, por lo tanto no se pudo realizar el Check In")

    }

    func showError2() {
        
        let fallView = UIView()
        fallView.backgroundColor = UIColor.clearColor()
        fallView.frame = CGRect(x: 100, y: 100, width: 200, height: 200)
        fallView.center = view.center
        
        let alert = TKSwarmAlert()
        alert.show(type: TKSWBackgroundType.BrightBlur, views: [fallView])
        
        let alertView = SCLAlertView()
        alertView.showCloseButton = false
        alertView.addButton("Aceptar") { () -> Void in
                
            alert.spawn([fallView])
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    
                alert.didDissmissAllViews = {
                    print("didDissmissAllViews")
                        
                }
                    
            })
                
        }
        alertView.showError("Error ", subTitle: "Porfavor verifique su conexion a internet")
    
    }
    

}
