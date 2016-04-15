//
//  MapaPageViewController.swift
//  Adventure Hike
//
//  Created by Roberto Gutierrez on 05/04/16.
//  Copyright © 2016 Roberto Gutierrez. All rights reserved.
//

import UIKit

class MapaPageViewController: UIViewController, EMPageViewControllerDelegate, EMPageViewControllerDataSource {
    
    var fechaArray = [String]()
    var horarioArray = [String]()
    var idArray = [Int]()
    var lugarArray = [Int]()
    var placeArray = [String]()
    var tituloArray = [String]()
    var latitudArray = [Double]()
    var longitudArray = [Double]()
    
    
    var pageViewController: EMPageViewController?
    
    var eventos = [String]()
    var locales = [String]()
    var fechas = [String]()
    var horario = [String]()
    var ubicaciones = [CLLocationCoordinate2D]()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Iniciar Loader
        JHProgressHUD.sharedHUD.showInView(view, withHeader: "Cargando", andFooter: "Por favor espere...")
        obtenerJson()
        
       
        
    }
    
    override func viewDidAppear(animated: Bool) {
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - EMPageViewController Data Source
    
    func em_pageViewController(pageViewController: EMPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        if let viewControllerIndex = self.indexOfViewController(viewController as! MapaPageItemsViewController) {
            let beforeViewController = self.viewControllerAtIndex(viewControllerIndex - 1)
            return beforeViewController
        } else {
            return nil
        }
    }
    
    func em_pageViewController(pageViewController: EMPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        if let viewControllerIndex = self.indexOfViewController(viewController as! MapaPageItemsViewController) {
            let afterViewController = self.viewControllerAtIndex(viewControllerIndex + 1)
            return afterViewController
        } else {
            return nil
        }
    }
    
    func viewControllerAtIndex(index: Int) -> MapaPageItemsViewController? {
        if (self.eventos.count == 0) || (index < 0) || (index >= self.eventos.count) {
            return nil
        }
        
        let viewController = self.storyboard!.instantiateViewControllerWithIdentifier("GreetingViewController") as! MapaPageItemsViewController
        viewController.eventos = self.eventos[index]
        viewController.local = self.locales[index]
        viewController.fecha = self.fechas[index]
        viewController.horario = self.horario[index]
        viewController.ubicacion = self.ubicaciones[index]
        viewController.index = index
        viewController.numeroDePaginas = eventos.count
        return viewController
    }
    
    func indexOfViewController(viewController: MapaPageItemsViewController) -> Int? {
        if let evento: String = viewController.eventos {
            return self.eventos.indexOf(evento)
        } else {
            return nil
        }
    }
    
    
    // MARK: - EMPageViewController Delegate
    
    func em_pageViewController(pageViewController: EMPageViewController, willStartScrollingFrom startViewController: UIViewController, destinationViewController: UIViewController) {
        
        let startGreetingViewController = startViewController as! MapaPageItemsViewController
        let destinationGreetingViewController = destinationViewController as! MapaPageItemsViewController
        
        print("Will start scrolling from \(startGreetingViewController.eventos) to \(destinationGreetingViewController.eventos).")
    }
    
    func em_pageViewController(pageViewController: EMPageViewController, isScrollingFrom startViewController: UIViewController, destinationViewController: UIViewController, progress: CGFloat) {
        let startGreetingViewController = startViewController as! MapaPageItemsViewController
        let destinationGreetingViewController = destinationViewController as! MapaPageItemsViewController
        
        // Ease the labels' alphas in and out
        let absoluteProgress = fabs(progress)
        startGreetingViewController.label.alpha = pow(1 - absoluteProgress, 2)
        destinationGreetingViewController.label.alpha = pow(absoluteProgress, 2)
        
        print("Is scrolling from \(startGreetingViewController.eventos) to \(destinationGreetingViewController.eventos) with progress '\(progress)'.")
    }
    
    func em_pageViewController(pageViewController: EMPageViewController, didFinishScrollingFrom startViewController: UIViewController?, destinationViewController: UIViewController, transitionSuccessful: Bool) {
        let startViewController = startViewController as! MapaPageItemsViewController?
        let destinationViewController = destinationViewController as! MapaPageItemsViewController
        
        // If the transition is successful, the new selected view controller is the destination view controller.
        // If it wasn't successful, the selected view controller is the start view controller
        if transitionSuccessful {
            
            if (self.indexOfViewController(destinationViewController) == 0) {
                // self.reverseButton.enabled = false
            } else {
                // self.reverseButton.enabled = true
            }
            
            if (self.indexOfViewController(destinationViewController) == self.eventos.count - 1) {
                // self.forwardButton.enabled = false
            } else {
                // self.forwardButton.enabled = true
            }
        }
        
        print("Finished scrolling from \(startViewController?.eventos) to \(destinationViewController.eventos). Transition successful? \(transitionSuccessful)")
    }
    
    
    //MARK: Obtener datos
    
    func obtenerJson() {
        
        
        let urlPath = "http://intercubo.com/ah/api/archivo.php?tipo=Ubicaciones"
        
        let url = NSURL(string: urlPath)!
        
        let session = NSURLSession.sharedSession()
        
        let task = session.dataTaskWithURL(url, completionHandler: { (data, response, error) -> Void in
            
            if let data = data {
                
                if error != nil {
                    
                    print(error)
                    
                } else {
                    
                    do {
                        
                        self.fechaArray.removeAll()
                        self.horarioArray.removeAll()
                        self.idArray.removeAll()
                        self.lugarArray.removeAll()
                        self.placeArray.removeAll()
                        self.tituloArray.removeAll()
                        self.latitudArray.removeAll()
                        self.longitudArray.removeAll()
                        
                        
                        let jsonResult = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers) as! NSArray
                        
                        print(jsonResult)
                        
                        dispatch_async(dispatch_get_main_queue()) { () -> Void in
                            
                            for json in jsonResult {
                                
                                
                                let fecha = json["fecha"] as! String
                                let horario = json["horario"] as! String
                                let id = json["id"] as! Int
                                let lugar = json["lugar"] as! Int
                                let place = json["place"] as! String
                                let titulo = json["titulo"] as! String
                                let latitud = json["latitud"] as! Double
                                let longitud = json["longitud"] as! Double
                                
                                
                                self.fechaArray.append(fecha)
                                self.horarioArray.append(horario)
                                self.idArray.append(id)
                                self.lugarArray.append(lugar)
                                self.placeArray.append(place)
                                self.tituloArray.append(titulo)
                                self.latitudArray.append(latitud)
                                self.longitudArray.append(longitud)
                                
                                self.eventos.append(titulo)
                                self.locales.append(place)
                                self.fechas.append(fecha)
                                self.horario.append(horario)
                                self.ubicaciones.append(CLLocationCoordinate2DMake(CLLocationDegrees(latitud), CLLocationDegrees(longitud)))
                                
                            }
                            
                            
                            JHProgressHUD.sharedHUD.hide()
                            
                            // Instantiate EMPageViewController and set the data source and delegate to 'self'
                            let pageViewController = EMPageViewController()
                            
                            // Or, for a vertical orientation
                            // let pageViewController = EMPageViewController(navigationOrientation: .Vertical)
                            
                            pageViewController.dataSource = self
                            pageViewController.delegate = self
                            
                            // Set the initially selected view controller
                            // IMPORTANT: If you are using a dataSource, make sure you set it BEFORE calling selectViewController:direction:animated:completion
                            let currentViewController = self.viewControllerAtIndex(0)!
                            pageViewController.selectViewController(currentViewController, direction: .Forward, animated: false, completion: nil)
                            
                            // Add EMPageViewController to the root view controller
                            self.addChildViewController(pageViewController)
                            self.view.insertSubview(pageViewController.view, atIndex: 0) // Insert the page controller view below the navigation buttons
                            pageViewController.didMoveToParentViewController(self)
                            
                            self.pageViewController = pageViewController

                        }
                        
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

    
    
}



//    var eventos: [String] = ["Armenia una herida abierta!", "Museo Parque Hundido", "Exposición Lego", "Ciudadela", "Teotihuacan"]
//    var locales: [String] = ["Museo Memoria y Tolerancia", "Parque Luis Urbina", "Museo Memoria y Tolerancia", "La Ciudadela", "Piramides de Teotihuacan"]
//    var fechas: [String] = ["3/Mayo - 15/Mayo", "4/Abril - 19/Abril", "5/Julio -22/Julio", "23/Junio - 4/Julio", "Teotihuacan"]
//    var horario: [String] = ["Martes a Domingo 8:00 - 19:00 hrs", "Martes a Domingo 8:00 - 19:00 hrs", "Martes a Domingo 8:00 - 19:00 hrs", "Martes a Domingo 8:00 - 19:00 hrs", "Martes a Domingo 8:00 - 19:00 hrs"]
//    var ubicaciones: [CLLocationCoordinate2D] = [CLLocationCoordinate2DMake(19.434619, -99.144324),CLLocationCoordinate2DMake(19.378423, -99.178747),CLLocationCoordinate2DMake(19.434619, -99.144324),CLLocationCoordinate2DMake(19.430921, -99.148773),CLLocationCoordinate2DMake(19.689870, -98.874175)]

