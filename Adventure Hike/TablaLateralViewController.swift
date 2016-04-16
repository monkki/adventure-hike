//
//  TablaLateralViewController.swift
//  Adventure Hike
//
//  Created by Roberto Gutierrez on 07/04/16.
//  Copyright © 2016 Roberto Gutierrez. All rights reserved.
//

import UIKit

class TablaLateralViewController: UITableViewController, SWRevealViewControllerDelegate {
    
    // IBOutlets
    @IBOutlet var botonMuseo: UIButton!
    @IBOutlet var botonTeatro: UIButton!
    @IBOutlet var botonDanza: UIButton!
    @IBOutlet var botonMusica: UIButton!
    @IBOutlet var botonExposiciones: UIButton!
    @IBOutlet var botonLiteratura: UIButton!
    @IBOutlet var botonCine: UIButton!
    @IBOutlet var botonMonumentos: UIButton!
    
    
    
    // Booleans
    var botonMuseoSeleccionado = true
    var botonTeatroSeleccionado = true
    var botonDanzaSeleccionado = true
    var botonMusicaSeleccionado = true
    var botonExposicionesSeleccionado = true
    var botonLiteraturaSeleccionado = true
    var botonCineSeleccionado = true
    var botonMonumentosSeleccionado = true

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        revealViewController().delegate = self
        
        if self.revealViewController() != nil {
            
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
           // self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        }
        
        //view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func botonMuseoSeleccionado(sender: AnyObject) {
        
        if botonMuseoSeleccionado == false {
            
            botonMuseoSeleccionado = true
            botonMuseo.setImage(UIImage(named: "seleccionadoBoton"), forState: UIControlState.Normal)
            
            categoriasPosibles.removeAtIndex(0)
            categoriasPosibles.insert(1, atIndex: 0)
            print(categoriasPosibles)
            
        } else {
            
            botonMuseoSeleccionado = false
            botonMuseo.setImage(UIImage(named: "deseleccionadoBoton"), forState: UIControlState.Normal)
            
            categoriasPosibles.removeAtIndex(0)
            categoriasPosibles.insert(0, atIndex: 0)
            print(categoriasPosibles)
        }
        
    }

    @IBAction func botonTeatroSeleccionado(sender: AnyObject) {
        
        if botonTeatroSeleccionado == false {
            
            botonTeatroSeleccionado = true
            botonTeatro.setImage(UIImage(named: "seleccionadoBoton"), forState: UIControlState.Normal)
            
            categoriasPosibles.removeAtIndex(1)
            categoriasPosibles.insert(2, atIndex: 1)
            print(categoriasPosibles)
            
        } else {
            
            botonTeatroSeleccionado = false
            botonTeatro.setImage(UIImage(named: "deseleccionadoBoton"), forState: UIControlState.Normal)
            
            categoriasPosibles.removeAtIndex(1)
            categoriasPosibles.insert(0, atIndex: 1)
            print(categoriasPosibles)
        }
        
    }

    
    @IBAction func botonDanzaSeleccionado(sender: AnyObject) {
        
        if botonDanzaSeleccionado == false {
            
            botonDanzaSeleccionado = true
            botonDanza.setImage(UIImage(named: "seleccionadoBoton"), forState: UIControlState.Normal)
            
            categoriasPosibles.removeAtIndex(2)
            categoriasPosibles.insert(3, atIndex: 2)
            print(categoriasPosibles)
            
        } else {
            
            botonDanzaSeleccionado = false
            botonDanza.setImage(UIImage(named: "deseleccionadoBoton"), forState: UIControlState.Normal)
            
            categoriasPosibles.removeAtIndex(2)
            categoriasPosibles.insert(0, atIndex: 2)
            print(categoriasPosibles)
            
        }
        
    }

    
    @IBAction func botonMusicaSeleccionado(sender: AnyObject) {
        
        if botonMusicaSeleccionado == false {
            
            botonMusicaSeleccionado = true
            botonMusica.setImage(UIImage(named: "seleccionadoBoton"), forState: UIControlState.Normal)
            
            categoriasPosibles.removeAtIndex(3)
            categoriasPosibles.insert(4, atIndex: 3)
            print(categoriasPosibles)
            
        } else {
            
            botonMusicaSeleccionado = false
            botonMusica.setImage(UIImage(named: "deseleccionadoBoton"), forState: UIControlState.Normal)
            
            categoriasPosibles.removeAtIndex(3)
            categoriasPosibles.insert(0, atIndex: 3)
            print(categoriasPosibles)
            
        }
        
    }

    
    @IBAction func botonExposicionesSeleccionado(sender: AnyObject) {
        
        if botonExposicionesSeleccionado == false {
            
            botonExposicionesSeleccionado = true
            botonExposiciones.setImage(UIImage(named: "seleccionadoBoton"), forState: UIControlState.Normal)
            
            categoriasPosibles.removeAtIndex(4)
            categoriasPosibles.insert(5, atIndex: 4)
            print(categoriasPosibles)
            
        } else {
            
            botonExposicionesSeleccionado = false
            botonExposiciones.setImage(UIImage(named: "deseleccionadoBoton"), forState: UIControlState.Normal)
            
            categoriasPosibles.removeAtIndex(4)
            categoriasPosibles.insert(0, atIndex: 4)
            print(categoriasPosibles)
            
        }
        
    }

    
    @IBAction func botonLiteraturaSeleccionado(sender: AnyObject) {
        
        if botonLiteraturaSeleccionado == false {
            
            botonLiteraturaSeleccionado = true
            botonLiteratura.setImage(UIImage(named: "seleccionadoBoton"), forState: UIControlState.Normal)
            
            categoriasPosibles.removeAtIndex(5)
            categoriasPosibles.insert(6, atIndex: 5)
            print(categoriasPosibles)
            
        } else {
            
            botonLiteraturaSeleccionado = false
            botonLiteratura.setImage(UIImage(named: "deseleccionadoBoton"), forState: UIControlState.Normal)
            
            categoriasPosibles.removeAtIndex(5)
            categoriasPosibles.insert(0, atIndex: 5)
            print(categoriasPosibles)
        }
        
    }

    
    @IBAction func botonCineSeleccionado(sender: AnyObject) {
        
        if botonCineSeleccionado == false {
            
            botonCineSeleccionado = true
            botonCine.setImage(UIImage(named: "seleccionadoBoton"), forState: UIControlState.Normal)
            
            categoriasPosibles.removeAtIndex(6)
            categoriasPosibles.insert(7, atIndex: 6)
            print(categoriasPosibles)
            
        } else {
            
            botonCineSeleccionado = false
            botonCine.setImage(UIImage(named: "deseleccionadoBoton"), forState: UIControlState.Normal)
            
            categoriasPosibles.removeAtIndex(6)
            categoriasPosibles.insert(0, atIndex: 6)
            print(categoriasPosibles)
        }
        
    }

    
    @IBAction func botonMonumentosSeleccionado(sender: AnyObject) {
        
        if botonMonumentosSeleccionado == false {
            
            botonMonumentosSeleccionado = true
            botonMonumentos.setImage(UIImage(named: "seleccionadoBoton"), forState: UIControlState.Normal)
            
            categoriasPosibles.removeAtIndex(7)
            categoriasPosibles.insert(8, atIndex: 7)
            print(categoriasPosibles)
            
        } else {
            
            botonMonumentosSeleccionado = false
            botonMonumentos.setImage(UIImage(named: "deseleccionadoBoton"), forState: UIControlState.Normal)
            
            categoriasPosibles.removeAtIndex(7)
            categoriasPosibles.insert(0, atIndex: 7)
            print(categoriasPosibles)
        }
        
    }
    
    func revealController(revealController: SWRevealViewController!, didMoveToPosition position: FrontViewPosition) {
        
        if position == FrontViewPosition.Left {
             print("Ey You")
            NSNotificationCenter.defaultCenter().postNotificationName("load", object: nil)
        }
       
    }

}
