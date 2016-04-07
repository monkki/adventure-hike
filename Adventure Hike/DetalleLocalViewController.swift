//
//  DetalleLocalViewController.swift
//  Adventure Hike
//
//  Created by Roberto Gutierrez on 03/04/16.
//  Copyright © 2016 Roberto Gutierrez. All rights reserved.
//

import UIKit

class DetalleLocalViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //Tabla
    @IBOutlet var tabla: UITableView!
    
    // Valores para obtener Eventos del Local
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
    
    //IBOutlets
    @IBOutlet var sliderFotos: UIScrollView!
    @IBOutlet var nombreLocalLabel: UILabel!
    @IBOutlet var checkInsLabel: UILabel!
    @IBOutlet var likesLabel: UILabel!
    @IBOutlet var ubicacionLabel: UILabel!
    @IBOutlet var fechaLabel: UILabel!
    @IBOutlet var horarioLabel: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabla.delegate = self
        tabla.dataSource = self
        tabla.backgroundColor = UIColor.clearColor()
        
        obtenerJson()
        
        // Iniciar Loader
        JHProgressHUD.sharedHUD.showInView(view, withHeader: "Cargando", andFooter: "Por favor espere...")

        //Slider de fotos
        sliderFotos.auk.startAutoScroll(delaySeconds: 5)
        sliderFotos.auk.settings.contentMode = UIViewContentMode.ScaleToFill
        sliderFotos.auk.settings.pageControl.visible = false
        sliderFotos.auk.settings.placeholderImage = UIImage(named: "placeholder.jpg")
        
        sliderFotos.auk.show(url: imagenRecibida)
        sliderFotos.auk.show(url: imagenRecibida)
        sliderFotos.auk.show(url: imagenRecibida)
        
        self.title = placeRecibida.uppercaseString
        nombreLocalLabel.text = placeRecibida.uppercaseString
        checkInsLabel.text = "\(checkInRecibidos)"
        likesLabel.text = "\(likenRecibida)"
        ubicacionLabel.text = placeRecibida
        fechaLabel.text = fechaRecibida
        horarioLabel.text = horarioRecibida
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Delegados de tabla
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return descripcionArrayString.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tabla.dequeueReusableCellWithIdentifier("CellLocal", forIndexPath: indexPath) as! TableViewCell
        
        cell.backgroundColor = UIColor.clearColor()
        
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            
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
                
            }
            
        }

        
        return cell
    }
    
    

    // MARK: - Obtener servicios web
    
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
                            }
                            
                            
                            for var i = 0; i < self.descripcionArrayHTML.count; i++ {
                                
                                let descripcion = self.descripcionArrayHTML[i].html2String
                                
                                self.descripcionArrayString.append(descripcion)
                                
                            }
                            
                            
                                                    
                            
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
