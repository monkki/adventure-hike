//
//  DetalleLocalViewController.swift
//  Adventure Hike
//
//  Created by Roberto Gutierrez on 03/04/16.
//  Copyright © 2016 Roberto Gutierrez. All rights reserved.
//

import UIKit

class DetalleLocalViewController: UIViewController {
    
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
