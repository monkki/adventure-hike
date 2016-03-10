//
//  AgendaViewController.swift
//  Adventure Hike
//
//  Created by Roberto Gutierrez on 07/01/16.
//  Copyright © 2016 Roberto Gutierrez. All rights reserved.
//

import UIKit
import AVFoundation
import TKSwarmAlert


class AgendaViewController: UIViewController, KTKBluetoothManagerDelegate, MAActivityIndicatorViewDelegate {
    
    // Beacons
    let bluetoothManager : KTKBluetoothManager = KTKBluetoothManager();
    
    // Sonido
    var player: AVAudioPlayer = AVAudioPlayer()
    
    // Loader
    @IBOutlet var viewForActivity1: UIView!
    @IBOutlet var buscandoBeacon: UILabel!
    
    var indicatorView1 : MAActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Propiedades de Sonido
        let audioPath = NSBundle.mainBundle().pathForResource("notificacion", ofType: "mp3")!
        
        do {
            
            try player = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: audioPath))
            player.volume = 3.0
            
        } catch {
            
            // Process error here
            
        }
        
        
        // Propiedades de Beacons
        bluetoothManager.delegate = self
        
        
        // Propiedades de Loader
        // dispatch async is used in order to have the frame OK (else you have to declare this in viewDidAppear() )
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            
            self.indicatorView1 = MAActivityIndicatorView(frame: self.viewForActivity1.frame)
            self.indicatorView1.defaultColor = UIColor.redColor()
            self.indicatorView1.animationDuration    = 1
            self.indicatorView1.numberOfCircles      = 6
            self.indicatorView1.maxRadius            = 17
            self.indicatorView1.delegate = self
            // self.indicatorView1.backgroundColor = UIColor.lightGrayColor()
            self.indicatorView1.startAnimating()
            self.view.addSubview(self.indicatorView1)
            
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        
        //player.play()
        self.bluetoothManager.startFindingDevices()
    }
    
    func firstButton() {
        print("Hola")
        
    }
    
    override func viewDidDisappear(animated: Bool) {
        self.bluetoothManager.stopFindingDevices()
    }
    
    
    // MARK: - KTKBluetoothManagerDelegate
    
    func bluetoothManager(bluetoothManager: KTKBluetoothManager!, didChangeDevices devices: Set<NSObject>!) {
        print("There are \(devices.count) Kontakt iBeacons in range")
        
    }
    
    func bluetoothManager(bluetoothManager: KTKBluetoothManager!, didChangeEddystones eddystones: Set<NSObject>!) {
        print("There are \(eddystones.count) Eddystones in range")
        
    }
    
    func bluetoothManager(bluetoothManager: KTKBluetoothManager!, didDiscoverEddystone eddystone: KTKEddystoneDevice!) {
        print("Se ha encontrado Eddystone")
        
        
        
        print(eddystone.eddystoneUID.instanceID.description)
        
        if eddystone.eddystoneUID.instanceID.description == "<31756842 4f32>" {
            
            showEdit()
            player.play()
            self.indicatorView1.stopAnimating()
            self.buscandoBeacon.hidden = true
            
        } else if eddystone.eddystoneUID.instanceID.description == "<416d786e 4e41>" {
            
            showEdit()
            player.play()
            self.indicatorView1.stopAnimating()
            self.buscandoBeacon.hidden = true
            
        }
        
    }
    
    func bluetoothManager(bluetoothManager: KTKBluetoothManager!, didLoseEddystone eddystone: KTKEddystoneDevice!) {
        print("Ha salido del rango de Eddystone")
        
    }
    
    //MARK: - MAActivityIndicatorViewDelegate protocol conformance
    
    func activityIndicatorView(activityIndicatorView: MAActivityIndicatorView, circleBackgroundColorAtIndex index: NSInteger) -> UIColor {
        
        // let R = CGFloat(arc4random() % 256)/255
        // let G = CGFloat(arc4random() % 256)/255
        // let B = CGFloat(arc4random() % 256)/255
        
        //return UIColor(red: R, green: G, blue: B, alpha: 1)
        return UIColor.whiteColor()
    }
    

    func showEdit() {
        
        let fallView = UIView()
        fallView.backgroundColor = UIColor.clearColor()
        fallView.frame = CGRect(x: 100, y: 100, width: 200, height: 200)
        fallView.center = view.center
        
        let alert = TKSwarmAlert()
        alert.show(type: TKSWBackgroundType.BrightBlur, views: [fallView])
        
        
        let alertView = SCLAlertView()
        alertView.showCloseButton = false
        let txt = alertView.addTextField("Respuesta")
        alertView.addButton("Contestar") {
            print("Text value: \(txt.text)")
            self.indicatorView1.startAnimating()
            self.buscandoBeacon.hidden = false
            
            alert.spawn([fallView])
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                
                alert.didDissmissAllViews = {
                    print("didDissmissAllViews")
                    
                }
                
            })

        }
        
        alertView.showEdit("Beacon Encontrado!", subTitle: "¿Donde se encuentran ubicadas las piramides de Teotihuacan?")
        
    }
    
    

}
