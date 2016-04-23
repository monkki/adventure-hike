//
//  EspecialesViewController.swift
//  Adventure Hike
//
//  Created by Roberto Gutierrez on 04/01/16.
//  Copyright © 2016 Roberto Gutierrez. All rights reserved.
//

import UIKit

var categoriasPosibles = [1,2,3,4,5,6,7,8]
var nuevasCategorias = [1,2,3,4,5,6,7,8]

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
    
    // Filtradas
    var imagenesArrayFiltrado = [String]()
    var imagenesArrayUIImageViewsFiltrado = [UIImage]()
    var descripcionArrayHTMLFiltrado = [String]()
    var descripcionArrayStringFiltrado = [String]()
    var fechaArrayFiltrado = [String]()
    var horarioArrayFiltrado = [String]()
    var idArrayFiltrado = [Int]()
    var likedArrayFiltrado = [Int]()
    var likenArrayFiltrado = [Int]()
    var lugarArrayFiltrado = [Int]()
    var placeArrayFiltrado = [String]()
    var tituloArrayFiltrado = [String]()
    var latitudArrayFiltrado = [Double]()
    var longitudArrayFiltrado = [Double]()
    var checkInArrayFiltrado = [Int]()
    var comentariosArrayFiltrado = [Int]()
    var categoriasArrayFiltrado = [Int]()
    
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
                                
                                self.imagenesArrayFiltrado.append(imagen)
                                self.descripcionArrayHTMLFiltrado.append(descripcion)
                                self.fechaArrayFiltrado.append(fecha)
                                self.horarioArrayFiltrado.append(horario)
                                self.idArrayFiltrado.append(id)
                                self.likedArrayFiltrado.append(liked)
                                self.likenArrayFiltrado.append(liken)
                                self.lugarArrayFiltrado.append(lugar)
                                self.placeArrayFiltrado.append(place)
                                self.tituloArrayFiltrado.append(titulo)
                                self.latitudArrayFiltrado.append(latitud)
                                self.longitudArrayFiltrado.append(longitud)
                                self.checkInArrayFiltrado.append(checkins)
                                self.comentariosArrayFiltrado.append(comentarios)
                                self.categoriasArrayFiltrado.append(categoria)
                                
                            }
                        
                        
                            for var i = 0; i < self.descripcionArrayHTML.count; i++ {
                            
                                let descripcion = self.descripcionArrayHTML[i].html2String
                            
                                self.descripcionArrayString.append(descripcion)
                                self.descripcionArrayStringFiltrado.append(descripcion)
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
        return descripcionArrayStringFiltrado.count
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
        
            
        if self.descripcionArrayStringFiltrado.count > 0 {
                
            let image_url = NSURL(string: self.imagenesArrayFiltrado[indexPath.row])
                
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
                
            cell.tituloLabel.text = self.tituloArrayFiltrado[indexPath.row].uppercaseString
            cell.checkInLabel.text = "\(self.checkInArrayFiltrado[indexPath.row])"
            cell.likesLabel.text = "\(self.likenArrayFiltrado[indexPath.row])"
            cell.descripcionLabel.text = self.descripcionArrayStringFiltrado[indexPath.row]
            cell.comentariosLabel.text = "\(self.comentariosArrayFiltrado[indexPath.row])"
                
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
 
/*
        if imagenesArrayFiltrado.count > 0 {
            
            self.imagenesArrayFiltrado.removeLast()
            self.descripcionArrayHTMLFiltrado.removeLast()
            self.fechaArrayFiltrado.removeLast()
            self.horarioArrayFiltrado.removeLast()
            self.idArrayFiltrado.removeLast()
            self.likedArrayFiltrado.removeLast()
            self.likenArrayFiltrado.removeLast()
            self.lugarArrayFiltrado.removeLast()
            self.placeArrayFiltrado.removeLast()
            self.tituloArrayFiltrado.removeLast()
            self.latitudArrayFiltrado.removeLast()
            self.longitudArrayFiltrado.removeLast()
            self.checkInArrayFiltrado.removeLast()
            self.comentariosArrayFiltrado.removeLast()
            self.categoriasArrayFiltrado.removeLast()
            self.descripcionArrayStringFiltrado.removeLast()
            
        }
 */
        print("Nuevas categorias es \(categoriasPosibles)")
        filtrarCategorias()
        
        tabla.reloadData()
        
    }
    
    func filtrarCategorias() -> Void {
        
        self.imagenesArrayFiltrado.removeAll()
        self.descripcionArrayHTMLFiltrado.removeAll()
        self.fechaArrayFiltrado.removeAll()
        self.horarioArrayFiltrado.removeAll()
        self.idArrayFiltrado.removeAll()
        self.likedArrayFiltrado.removeAll()
        self.likenArrayFiltrado.removeAll()
        self.lugarArrayFiltrado.removeAll()
        self.placeArrayFiltrado.removeAll()
        self.tituloArrayFiltrado.removeAll()
        self.latitudArrayFiltrado.removeAll()
        self.longitudArrayFiltrado.removeAll()
        self.checkInArrayFiltrado.removeAll()
        self.comentariosArrayFiltrado.removeAll()
        self.categoriasArrayFiltrado.removeAll()
        self.descripcionArrayStringFiltrado.removeAll()
        
        print("Categorias array filtrado \(categoriasArray)")
        
        for i in 0 ..< categoriasArray.count {
            
            
            if categoriasArray[i] == categoriasPosibles[0] {
                
                self.imagenesArrayFiltrado.append(imagenesArray[i])
                self.descripcionArrayHTMLFiltrado.append(descripcionArrayHTML[i])
                self.fechaArrayFiltrado.append(fechaArray[i])
                self.horarioArrayFiltrado.append(horarioArray[i])
                self.idArrayFiltrado.append(idArray[i])
                self.likedArrayFiltrado.append(likedArray[i])
                self.likenArrayFiltrado.append(likenArray[i])
                self.lugarArrayFiltrado.append(lugarArray[i])
                self.placeArrayFiltrado.append(placeArray[i])
                self.tituloArrayFiltrado.append(tituloArray[i])
                self.latitudArrayFiltrado.append(latitudArray[i])
                self.longitudArrayFiltrado.append(longitudArray[i])
                self.checkInArrayFiltrado.append(checkInArray[i])
                self.comentariosArrayFiltrado.append(comentariosArray[i])
                self.categoriasArrayFiltrado.append(categoriasArray[i])
                self.descripcionArrayStringFiltrado.append(descripcionArrayString[i])
                
                
               // nuevasCategorias.append(categoriasArray[i])
               /// categoriaComplemento2.append(categoriaComplemento[i])
                
                
            } else if categoriasArray[i] == categoriasPosibles[1] {
                
                
                self.imagenesArrayFiltrado.append(imagenesArray[i])
                self.descripcionArrayHTMLFiltrado.append(descripcionArrayHTML[i])
                self.fechaArrayFiltrado.append(fechaArray[i])
                self.horarioArrayFiltrado.append(horarioArray[i])
                self.idArrayFiltrado.append(idArray[i])
                self.likedArrayFiltrado.append(likedArray[i])
                self.likenArrayFiltrado.append(likenArray[i])
                self.lugarArrayFiltrado.append(lugarArray[i])
                self.placeArrayFiltrado.append(placeArray[i])
                self.tituloArrayFiltrado.append(tituloArray[i])
                self.latitudArrayFiltrado.append(latitudArray[i])
                self.longitudArrayFiltrado.append(longitudArray[i])
                self.checkInArrayFiltrado.append(checkInArray[i])
                self.comentariosArrayFiltrado.append(comentariosArray[i])
                self.categoriasArrayFiltrado.append(categoriasArray[i])
                self.descripcionArrayStringFiltrado.append(descripcionArrayString[i])
                
                
                // nuevasCategorias.append(categoriasArray[i])
                /// categoriaComplemento2.append(categoriaComplemento[i])
                
            } else if categoriasArray[i] == categoriasPosibles[2] {
                
                
                self.imagenesArrayFiltrado.append(imagenesArray[i])
                self.descripcionArrayHTMLFiltrado.append(descripcionArrayHTML[i])
                self.fechaArrayFiltrado.append(fechaArray[i])
                self.horarioArrayFiltrado.append(horarioArray[i])
                self.idArrayFiltrado.append(idArray[i])
                self.likedArrayFiltrado.append(likedArray[i])
                self.likenArrayFiltrado.append(likenArray[i])
                self.lugarArrayFiltrado.append(lugarArray[i])
                self.placeArrayFiltrado.append(placeArray[i])
                self.tituloArrayFiltrado.append(tituloArray[i])
                self.latitudArrayFiltrado.append(latitudArray[i])
                self.longitudArrayFiltrado.append(longitudArray[i])
                self.checkInArrayFiltrado.append(checkInArray[i])
                self.comentariosArrayFiltrado.append(comentariosArray[i])
                self.categoriasArrayFiltrado.append(categoriasArray[i])
                self.descripcionArrayStringFiltrado.append(descripcionArrayString[i])
                
                
                // nuevasCategorias.append(categoriasArray[i])
                /// categoriaComplemento2.append(categoriaComplemento[i])
                
            } else if categoriasArray[i] == categoriasPosibles[3] {
                
                
                self.imagenesArrayFiltrado.append(imagenesArray[i])
                self.descripcionArrayHTMLFiltrado.append(descripcionArrayHTML[i])
                self.fechaArrayFiltrado.append(fechaArray[i])
                self.horarioArrayFiltrado.append(horarioArray[i])
                self.idArrayFiltrado.append(idArray[i])
                self.likedArrayFiltrado.append(likedArray[i])
                self.likenArrayFiltrado.append(likenArray[i])
                self.lugarArrayFiltrado.append(lugarArray[i])
                self.placeArrayFiltrado.append(placeArray[i])
                self.tituloArrayFiltrado.append(tituloArray[i])
                self.latitudArrayFiltrado.append(latitudArray[i])
                self.longitudArrayFiltrado.append(longitudArray[i])
                self.checkInArrayFiltrado.append(checkInArray[i])
                self.comentariosArrayFiltrado.append(comentariosArray[i])
                self.categoriasArrayFiltrado.append(categoriasArray[i])
                self.descripcionArrayStringFiltrado.append(descripcionArrayString[i])
                
                
                // nuevasCategorias.append(categoriasArray[i])
                /// categoriaComplemento2.append(categoriaComplemento[i])
                
            } else if categoriasArray[i] == categoriasPosibles[4] {
                
                
                self.imagenesArrayFiltrado.append(imagenesArray[i])
                self.descripcionArrayHTMLFiltrado.append(descripcionArrayHTML[i])
                self.fechaArrayFiltrado.append(fechaArray[i])
                self.horarioArrayFiltrado.append(horarioArray[i])
                self.idArrayFiltrado.append(idArray[i])
                self.likedArrayFiltrado.append(likedArray[i])
                self.likenArrayFiltrado.append(likenArray[i])
                self.lugarArrayFiltrado.append(lugarArray[i])
                self.placeArrayFiltrado.append(placeArray[i])
                self.tituloArrayFiltrado.append(tituloArray[i])
                self.latitudArrayFiltrado.append(latitudArray[i])
                self.longitudArrayFiltrado.append(longitudArray[i])
                self.checkInArrayFiltrado.append(checkInArray[i])
                self.comentariosArrayFiltrado.append(comentariosArray[i])
                self.categoriasArrayFiltrado.append(categoriasArray[i])
                self.descripcionArrayStringFiltrado.append(descripcionArrayString[i])
                
                
                // nuevasCategorias.append(categoriasArray[i])
                /// categoriaComplemento2.append(categoriaComplemento[i])
                
            } else if categoriasArray[i] == categoriasPosibles[5] {
                
                
                self.imagenesArrayFiltrado.append(imagenesArray[i])
                self.descripcionArrayHTMLFiltrado.append(descripcionArrayHTML[i])
                self.fechaArrayFiltrado.append(fechaArray[i])
                self.horarioArrayFiltrado.append(horarioArray[i])
                self.idArrayFiltrado.append(idArray[i])
                self.likedArrayFiltrado.append(likedArray[i])
                self.likenArrayFiltrado.append(likenArray[i])
                self.lugarArrayFiltrado.append(lugarArray[i])
                self.placeArrayFiltrado.append(placeArray[i])
                self.tituloArrayFiltrado.append(tituloArray[i])
                self.latitudArrayFiltrado.append(latitudArray[i])
                self.longitudArrayFiltrado.append(longitudArray[i])
                self.checkInArrayFiltrado.append(checkInArray[i])
                self.comentariosArrayFiltrado.append(comentariosArray[i])
                self.categoriasArrayFiltrado.append(categoriasArray[i])
                self.descripcionArrayStringFiltrado.append(descripcionArrayString[i])
                
                
                // nuevasCategorias.append(categoriasArray[i])
                /// categoriaComplemento2.append(categoriaComplemento[i])
                
            } else if categoriasArray[i] == categoriasPosibles[6] {
                
                
                self.imagenesArrayFiltrado.append(imagenesArray[i])
                self.descripcionArrayHTMLFiltrado.append(descripcionArrayHTML[i])
                self.fechaArrayFiltrado.append(fechaArray[i])
                self.horarioArrayFiltrado.append(horarioArray[i])
                self.idArrayFiltrado.append(idArray[i])
                self.likedArrayFiltrado.append(likedArray[i])
                self.likenArrayFiltrado.append(likenArray[i])
                self.lugarArrayFiltrado.append(lugarArray[i])
                self.placeArrayFiltrado.append(placeArray[i])
                self.tituloArrayFiltrado.append(tituloArray[i])
                self.latitudArrayFiltrado.append(latitudArray[i])
                self.longitudArrayFiltrado.append(longitudArray[i])
                self.checkInArrayFiltrado.append(checkInArray[i])
                self.comentariosArrayFiltrado.append(comentariosArray[i])
                self.categoriasArrayFiltrado.append(categoriasArray[i])
                self.descripcionArrayStringFiltrado.append(descripcionArrayString[i])
                
                
                // nuevasCategorias.append(categoriasArray[i])
                /// categoriaComplemento2.append(categoriaComplemento[i])
                
            } else if categoriasArray[i] == categoriasPosibles[7] {
                
                
                self.imagenesArrayFiltrado.append(imagenesArray[i])
                self.descripcionArrayHTMLFiltrado.append(descripcionArrayHTML[i])
                self.fechaArrayFiltrado.append(fechaArray[i])
                self.horarioArrayFiltrado.append(horarioArray[i])
                self.idArrayFiltrado.append(idArray[i])
                self.likedArrayFiltrado.append(likedArray[i])
                self.likenArrayFiltrado.append(likenArray[i])
                self.lugarArrayFiltrado.append(lugarArray[i])
                self.placeArrayFiltrado.append(placeArray[i])
                self.tituloArrayFiltrado.append(tituloArray[i])
                self.latitudArrayFiltrado.append(latitudArray[i])
                self.longitudArrayFiltrado.append(longitudArray[i])
                self.checkInArrayFiltrado.append(checkInArray[i])
                self.comentariosArrayFiltrado.append(comentariosArray[i])
                self.categoriasArrayFiltrado.append(categoriasArray[i])
                self.descripcionArrayStringFiltrado.append(descripcionArrayString[i])
                
                
                // nuevasCategorias.append(categoriasArray[i])
                /// categoriaComplemento2.append(categoriaComplemento[i])
            } else {
                
                //        let index: Int = i
                //        categoriaComplemento.removeAtIndex(i)
                
            }
            
        }
        
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
