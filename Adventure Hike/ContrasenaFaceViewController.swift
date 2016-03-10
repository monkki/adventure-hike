//
//  ContrasenaFaceViewController.swift
//  Adventure Hike
//
//  Created by Roberto Gutierrez on 19/01/16.
//  Copyright © 2016 Roberto Gutierrez. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKShareKit
import FBSDKLoginKit


class ContrasenaFaceViewController: UIViewController {
    
    @IBOutlet var bienvenidoLabel: UILabel!
    @IBOutlet var contraseñaTextfield: UITextField!
    @IBOutlet var reescribeContraseñaTextfield: UITextField!
    
    //Datos recibidos
    var nombreCompletoFacebook: String!
    var idFacebook: String!
    var emailFacebook: String!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        bienvenidoLabel.text = "Bienvenido \(nombreCompletoFacebook)"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func botonRegistrar(sender: AnyObject) {
        
        if contraseñaTextfield.text != reescribeContraseñaTextfield.text {
            mostraMSJ("Las contraseñas deben coincidir")
        } else {
            
            let contraseña = contraseñaTextfield.text! as String
            registrarConFacebook(nombreCompletoFacebook, idFacebook: idFacebook, emailFacebookM: emailFacebook, contraseña: contraseña)
            
        }
        
        
        
    }
    
    func registrarConFacebook(var nombreCompleto: String, var idFacebook: String, var emailFacebookM: String, var contraseña: String) {
        
        // Iniciar Loader
        JHProgressHUD.sharedHUD.showInView(self.view, withHeader: "Registrando usuario", andFooter: "Por favor espere...")

        
        let customAllowedSet = NSCharacterSet.URLQueryAllowedCharacterSet()
        
        nombreCompleto = nombreCompleto.stringByAddingPercentEncodingWithAllowedCharacters(customAllowedSet)!
        idFacebook = idFacebook.stringByAddingPercentEncodingWithAllowedCharacters(customAllowedSet)!
        emailFacebookM = emailFacebookM.stringByAddingPercentEncodingWithAllowedCharacters(customAllowedSet)!
        contraseña = contraseña.stringByAddingPercentEncodingWithAllowedCharacters(customAllowedSet)!
        
        let urlString = "http://intercubo.com/ah/api/registra.php?n=" + nombreCompleto + "&c=" + emailFacebookM + "&fbid=" + idFacebook + "&p=" + contraseña
        
        let url = NSURL(string: urlString)
        
        if let url = url {
            
            let task = NSURLSession.sharedSession().dataTaskWithURL(url, completionHandler: { (data, response, error) -> Void in
                
                if error != nil {
                    
                    print(error?.localizedDescription)
                    
                }
                
                if let data = data {
                    
                    do {
                        
                        
                        if let errorResult = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers) as? NSDictionary {
                            
                            let error = errorResult["error"] as! String
                            
                            print(error)
                            
                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                // Iniciar Loader
                                JHProgressHUD.sharedHUD.hide()
                                let loginManager = FBSDKLoginManager()
                                loginManager.logOut()
                                
                               let alerta = UIAlertController(title: "Adventure Hike", message: "Ya existe una cuenta registrada con ese correo", preferredStyle: UIAlertControllerStyle.Alert)
                                alerta.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
                                    
                                    self.performSegueWithIdentifier("inicioALogin", sender: self)
                                    
                                }))
                                
                                self.presentViewController(alerta, animated: true, completion: nil)
                                
                                //self.mostraMSJ("Ya existe una cuenta registrada con ese correo")
                                
                            })
                            
                            
                            
                        } else {
                            
                            let jsonResult = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers) as! NSArray
                            
                            //print(jsonResult)
                            
                            for json in jsonResult {
                                
                                let correo = json["correo"] as! String
                                let display = json["display"] as! String
                                let fbid = json["fbid"] as! Int
                                let fechaNac = json["fecha_nac"] as! String
                                let idUsuario = json["id"] as! Int
                                let nickname = json["nickname"] as! String
                                let nombre = json["nombre"] as! String
                                let token = json["token"] as! NSString
                                
                                print(correo)
                                print(display)
                                print(fbid)
                                print(fechaNac)
                                print(String(idUsuario))
                                print(nickname)
                                print(nombre)
                                print(token)
                                
                                NSUserDefaults.standardUserDefaults().setObject(token, forKey: "tokenServer")
                                NSUserDefaults.standardUserDefaults().setObject(fbid, forKey: "fbid")
                                NSUserDefaults.standardUserDefaults().setObject(idUsuario, forKey: "idUsuario")
                                NSUserDefaults.standardUserDefaults().setObject(nombre, forKey: "nombre")
                                NSUserDefaults.standardUserDefaults().synchronize()
                                
                            }
                            
                            
                            
                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                // Iniciar Loader
                                JHProgressHUD.sharedHUD.hide()
                                self.performSegueWithIdentifier("inicio", sender: self)
                                
                            })
                            
                            
                        }
                        
                        
                    } catch {
                        
                        
                    }
                    
                    
                    
                }
            })
            
            task.resume()
            
        }
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
