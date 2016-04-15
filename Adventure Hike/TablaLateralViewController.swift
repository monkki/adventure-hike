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
            
        } else {
            
            botonMuseoSeleccionado = false
            botonMuseo.setImage(UIImage(named: "deseleccionadoBoton"), forState: UIControlState.Normal)
            
        }
        
    }

    @IBAction func botonTeatroSeleccionado(sender: AnyObject) {
        
        if botonTeatroSeleccionado == false {
            
            botonTeatroSeleccionado = true
            botonTeatro.setImage(UIImage(named: "seleccionadoBoton"), forState: UIControlState.Normal)
            
        } else {
            
            botonTeatroSeleccionado = false
            botonTeatro.setImage(UIImage(named: "deseleccionadoBoton"), forState: UIControlState.Normal)
            
        }
        
    }

    
    @IBAction func botonDanzaSeleccionado(sender: AnyObject) {
        
        if botonDanzaSeleccionado == false {
            
            botonDanzaSeleccionado = true
            botonDanza.setImage(UIImage(named: "seleccionadoBoton"), forState: UIControlState.Normal)
            
        } else {
            
            botonDanzaSeleccionado = false
            botonDanza.setImage(UIImage(named: "deseleccionadoBoton"), forState: UIControlState.Normal)
            
        }
        
    }

    
    @IBAction func botonMusicaSeleccionado(sender: AnyObject) {
        
        if botonMusicaSeleccionado == false {
            
            botonMusicaSeleccionado = true
            botonMusica.setImage(UIImage(named: "seleccionadoBoton"), forState: UIControlState.Normal)
            
        } else {
            
            botonMusicaSeleccionado = false
            botonMusica.setImage(UIImage(named: "deseleccionadoBoton"), forState: UIControlState.Normal)
            
        }
        
    }

    
    @IBAction func botonExposicionesSeleccionado(sender: AnyObject) {
        
        if botonExposicionesSeleccionado == false {
            
            botonExposicionesSeleccionado = true
            botonExposiciones.setImage(UIImage(named: "seleccionadoBoton"), forState: UIControlState.Normal)
            
        } else {
            
            botonExposicionesSeleccionado = false
            botonExposiciones.setImage(UIImage(named: "deseleccionadoBoton"), forState: UIControlState.Normal)
            
        }
        
    }

    
    @IBAction func botonLiteraturaSeleccionado(sender: AnyObject) {
        
        if botonLiteraturaSeleccionado == false {
            
            botonLiteraturaSeleccionado = true
            botonLiteratura.setImage(UIImage(named: "seleccionadoBoton"), forState: UIControlState.Normal)
            
        } else {
            
            botonLiteraturaSeleccionado = false
            botonLiteratura.setImage(UIImage(named: "deseleccionadoBoton"), forState: UIControlState.Normal)
            
        }
        
    }

    
    @IBAction func botonCineSeleccionado(sender: AnyObject) {
        
        if botonCineSeleccionado == false {
            
            botonCineSeleccionado = true
            botonCine.setImage(UIImage(named: "seleccionadoBoton"), forState: UIControlState.Normal)
            
        } else {
            
            botonCineSeleccionado = false
            botonCine.setImage(UIImage(named: "deseleccionadoBoton"), forState: UIControlState.Normal)
            
        }
        
    }

    
    @IBAction func botonMonumentosSeleccionado(sender: AnyObject) {
        
        if botonMonumentosSeleccionado == false {
            
            botonMonumentosSeleccionado = true
            botonMonumentos.setImage(UIImage(named: "seleccionadoBoton"), forState: UIControlState.Normal)
            
        } else {
            
            botonMonumentosSeleccionado = false
            botonMonumentos.setImage(UIImage(named: "deseleccionadoBoton"), forState: UIControlState.Normal)
            
        }
        
    }
    
    func revealController(revealController: SWRevealViewController!, didMoveToPosition position: FrontViewPosition) {
        
        if position == FrontViewPosition.Left {
             print("Ey You")
            NSNotificationCenter.defaultCenter().postNotificationName("load", object: nil)
        }
       
    }

}
