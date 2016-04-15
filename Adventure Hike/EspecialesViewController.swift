//
//  EspecialesViewController.swift
//  Adventure Hike
//
//  Created by Roberto Gutierrez on 04/01/16.
//  Copyright © 2016 Roberto Gutierrez. All rights reserved.
//

import UIKit

class EspecialesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    @IBOutlet var tabla: UITableView!
    
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
    
    @IBOutlet var filtrarButton:UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(EspecialesViewController.loadList(_:)),name:"load", object: nil)
        
        if revealViewController() != nil {
            
            revealViewController().rightViewRevealWidth = 290
            filtrarButton.target = revealViewController()
            filtrarButton.action = "rightRevealToggle:"
            
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        self.view.backgroundColor = UIColor.lightGrayColor()
        self.tabla.backgroundColor = UIColor.clearColor()
        
        obtenerJson()
        
        tabla.delegate = self
        
        // Iniciar Loader
        JHProgressHUD.sharedHUD.showInView(view, withHeader: "Cargando", andFooter: "Por favor espere...")
        
        
        
    }
    
    override func viewDidAppear(animated: Bool) {
        print("Pagina load")
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
                        
                        
                            for var i = 0; i < self.descripcionArrayHTML.count; i++ {
                            
                                let descripcion = self.descripcionArrayHTML[i].html2String
                            
                                self.descripcionArrayString.append(descripcion)
                            
                            }
                            
                            
//                            for var i = 0; i < self.imagenesArray.count; i++ {
//                                
//                                let image_url = NSURL(string: self.imagenesArray[i])
//                                
//                                let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
//                                dispatch_async(dispatch_get_global_queue(priority, 0)) {
//                                    // do some task
//                                    let image_data = NSData(contentsOfURL: image_url!)
//                                    
//                                    dispatch_async(dispatch_get_main_queue()) {
//                                        // update some UI
//                                        let image = UIImage(data: image_data!)
//                                        self.imagenesArrayUIImageViews.append(image!)
//                                    }
//                                }
//
//                                
//                            }

                            
                            
                        }
                        
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                           self.tabla.reloadData()
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
    
    override func viewWillAppear(animated: Bool) {
        print("Hola")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // Delegados de TableView
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return descripcionArrayString.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tabla.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! TableViewCell
        
        if indexPath.row == 0 {
            
            let vistaDestacado = UIImage(named: "eventoDeLaSemana.png")
            let vista = UIImageView()
            vista.image = vistaDestacado
            vista.frame = CGRectMake(0, 10, 180, 30)
            
            cell.addSubview(vista)
            
        }
        
            
        if self.descripcionArrayString.count > 0 {
                
            let image_url = NSURL(string: self.imagenesArray[indexPath.row])
                
            let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
            dispatch_async(dispatch_get_global_queue(priority, 0)) {
                // do some task
                if let image_data = NSData(contentsOfURL: image_url!) {
                        
                    dispatch_async(dispatch_get_main_queue()) {
                        // update some UI
                        let image = UIImage(data: image_data)
                        cell.imagenCelda.image = image
                        JHProgressHUD.sharedHUD.hide()
                    }
                        
                } else {
                    print("Hubo un error al obtener image data")
                }
                    
            }
                
            cell.tituloLabel.text = self.tituloArray[indexPath.row].uppercaseString
            cell.checkInLabel.text = "\(self.checkInArray[indexPath.row])"
            cell.likesLabel.text = "\(self.likenArray[indexPath.row])"
            cell.descripcionLabel.text = self.descripcionArrayString[indexPath.row]
            cell.comentariosLabel.text = "\(self.comentariosArray[indexPath.row])"
                
        }
            
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 280
        }
        
        return 145
    }


    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "detalleSegue" {
            let indexPath = tabla.indexPathForSelectedRow
            let destinoVC = segue.destinationViewController as! DetalleViewController
            destinoVC.imagenRecibida = imagenesArray[(indexPath?.row)!]
            destinoVC.descripcionRecibida = descripcionArrayString[(indexPath?.row)!]
            destinoVC.fechaRecibida = fechaArray[(indexPath?.row)!]
            destinoVC.horarioRecibida = horarioArray[(indexPath?.row)!]
            destinoVC.idRecibida = idArray[(indexPath?.row)!]
            destinoVC.likedRecibida = likedArray[(indexPath?.row)!]
            destinoVC.likenRecibida = likenArray[(indexPath?.row)!]
            destinoVC.lugarRecibida = lugarArray[(indexPath?.row)!]
            destinoVC.placeRecibida = placeArray[(indexPath?.row)!]
            destinoVC.tituloRecibida = tituloArray[(indexPath?.row)!]
            destinoVC.latitudRecibida = latitudArray[(indexPath?.row)!]
            destinoVC.longitudRecibida = longitudArray[(indexPath?.row)!]
            destinoVC.checkInRecibidos = checkInArray[(indexPath?.row)!]
        }
    }
    
    func mostraMSJ(msj: String){
        
        let alerta = UIAlertController(title: "Adventure Hike", message: msj, preferredStyle: UIAlertControllerStyle.Alert)
        alerta.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil))
        self.presentViewController(alerta, animated: true, completion: nil)
        
    }
    
    func loadList(notification: NSNotification){
        //load data here
        print("Hola putitos")
    }
    

}

// Extension para convertir HTML a String
extension String {
    
    var html2AttributedString: NSAttributedString? {
        guard
            let data = dataUsingEncoding(NSUTF8StringEncoding)
            else { return nil }
        do {
            return try NSAttributedString(data: data, options: [NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType,NSCharacterEncodingDocumentAttribute:NSUTF8StringEncoding], documentAttributes: nil)
        } catch let error as NSError {
            print(error.localizedDescription)
            return  nil
        }
    }
    var html2String: String {
        return html2AttributedString?.string ?? ""
    }
}

// Extension para convertir URL a ImageView
extension UIImageView {
    func downloadedFrom(link link:String, contentMode mode: UIViewContentMode) {
        guard
            let url = NSURL(string: link)
            else {return}
        contentMode = mode
        NSURLSession.sharedSession().dataTaskWithURL(url, completionHandler: { (data, _, error) -> Void in
            guard
                let data = data where error == nil,
                let image = UIImage(data: data)
                else { return }
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                self.image = image
            }
        }).resume()
    }
}
