//
//  LoginViewController.swift
//  Adventure Hike
//
//  Created by Roberto Gutierrez on 14/01/16.
//  Copyright © 2016 Roberto Gutierrez. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKShareKit
import FBSDKLoginKit

class LoginViewController: UIViewController, FBSDKLoginButtonDelegate, UITextFieldDelegate {
    
    // TEXTFIELDS REGISTRAR
    @IBOutlet var emailTextfield: UITextField!
    @IBOutlet var contraseñaTextfield: UITextField!
    
    var email = ""
    var contraseña = ""
     
    let tokenRecibido = ""
    
    // BOTONES DE LOGIN
    @IBOutlet var botonLoginFacebook: FBSDKLoginButton!
    
    // DATOS RECIBIDOS DE FACEBOOK
    var nombreCompletoFacebook: String!
    var idFacebook: String!
    var emailFacebook: String!
    var nombreFacebook: String!
    var apellidoFacebook: String!
    var imagenFacebook: UIImage!


    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTextfield.delegate = self
        contraseñaTextfield.delegate = self

        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)

        
        if (FBSDKAccessToken.currentAccessToken() != nil) {
            
            
        } else {
            
            botonLoginFacebook.readPermissions = ["public_profile", "email", "user_friends"]
            botonLoginFacebook.delegate = self
            
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // METODOS TEXTFIELD
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }

    // METODOS DE FACEBOOK
    // Facebook Delegate Methods
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        print("User Logged In")
        
        if ((error) != nil) {
            // Process error
            
        } else if result.isCancelled {
            // Handle cancellations
            
        } else {
            // If you ask for multiple permissions at once, you
            // should check if specific permissions missing
            if result.grantedPermissions.contains("email") {
                
                //                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(1 * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), { () -> Void in
                //                    self.performSegueWithIdentifier("inicioSegue", sender: self)
                //                })
                
            }
            
            self.returnUserData()
            
        }
        
    }
    
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        print("Usuario ha salido")
    }
    
    
    func returnUserData() {
        
        JHProgressHUD.sharedHUD.showInView(self.view, withHeader: "Logeando usuario", andFooter: "Por favor espere...")
        
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "email, name, picture.type(large), first_name, last_name"])
        graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
            
            if ((error) != nil) {
                // Process error
                print("Error: \(error)")
                
            } else {
                
                //Obtener nombre de facebook
                print("Usuario es: \(result)")
                if let userName : NSString = result.valueForKey("name") as? NSString {
                    self.nombreCompletoFacebook = userName as String
                    print("Nombre de usuario es : \(userName)")
                }
                
                //Obtener id de facebook
                if let id : NSString = result.valueForKey("id") as? NSString {
                    self.idFacebook = id as String
                    //                    NSUserDefaults.standardUserDefaults().setObject(self.idFacebook, forKey: "idFacebookDefaults")
                    //                    NSUserDefaults.standardUserDefaults().synchronize()
                    print("id de usuario es: \(id)")
                    
                }
                
                //Obtener email de facebook
                if let userEmail : NSString = result.valueForKey("email") as? NSString {
                    self.emailFacebook = userEmail as String
                    print("Email de usuario es: \(userEmail)")
                    
                }
                
                //Obtener email de facebook
                if let nombre : NSString = result.valueForKey("first_name") as? NSString {
                    self.nombreFacebook = nombre as String
                    print("nombre es: \(nombre)")
                    
                }
                
                //Obtener email de facebook
                if let apellido : NSString = result.valueForKey("last_name") as? NSString {
                    self.apellidoFacebook = apellido as String
                    print("Apellido es: \(apellido)")
                    
                }
                
                //Obtener imagen de facebook
                if let picture : NSDictionary = result.valueForKey("picture") as? NSDictionary {
                    if let data = picture["data"] as? NSDictionary {
                        if let imagen = data["url"] as? String {
                            if let url  = NSURL(string: imagen),
                                data = NSData(contentsOfURL: url){
                                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                        self.imagenFacebook = UIImage(data: data)
                                    })
                            }
                        }
                    }
                    
                }
                
            }
            
            self.returnUserProfileImage(self.idFacebook)
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.loginConFacebook(self.emailFacebook, idFacebook: self.idFacebook)
            })
            
        })
    }
    
    
    // accessToken is your Facebook id
    func returnUserProfileImage(accessToken: String) {
        let userID = accessToken as String
        let facebookProfileUrl = NSURL(string: "http://graph.facebook.com/\(userID)/picture?type=large")
        
        if let data = NSData(contentsOfURL: facebookProfileUrl!) {
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                
                let imagenGrandeFace = UIImage(data: data)
                print("La imagen grande de facebbok es \(imagenGrandeFace)")
                
                var documentsDirectory:String?
                
                var paths:[AnyObject] = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
                
                if paths.count > 0 {
                    
                    documentsDirectory = paths[0] as? String
                    
                    let savePath = documentsDirectory! + "/imagenPerfil.jpg"
                    
                    NSFileManager.defaultManager().createFileAtPath(savePath, contents: data, attributes: nil)
                    
                }

                
            })
        }
        
    }

    
    
    
    // BOTONES
    
    @IBAction func olvideContraseña(sender: AnyObject) {
        
    }
    
    @IBAction func loginBoton(sender: AnyObject) {
        
        email = emailTextfield.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        contraseña = contraseñaTextfield.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        
        
        
        
        if (email == "" || contraseña == ""){
            
            mostraMSJ("Favor de completar los datos!")
            
            
        } else if(!isValidEmail(email)) {
            
            mostraMSJ("Favor de escribir un correo válido!")
            
        } else if(contraseña.characters.count < 7) {
            
            mostraMSJ("Favor de escribir una contraseña con más de 7 dígitos!")
            
        } else {
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                // Iniciar Loader
                JHProgressHUD.sharedHUD.showInView(self.view, withHeader: "Logeando usuario", andFooter: "Por favor espere...")
            })
            
            loginUsuario()
            //print("Nickname es: \(nickname), nombre es \(nombre), fecha es \(fecha), email es \(email), contraseña es \(contraseña), reescribe contraseña es \(reescribeContraseña)")
            
        }

        
    }
    
    // FUNCION PARA LOGEAR USUARIO MANUALMENTE
    
    func loginUsuario() {
        
        let customAllowedSet = NSCharacterSet.URLQueryAllowedCharacterSet()
        
        email = email.stringByAddingPercentEncodingWithAllowedCharacters(customAllowedSet)!
        contraseña = contraseña.stringByAddingPercentEncodingWithAllowedCharacters(customAllowedSet)!
        
        let urlString = "http://intercubo.com/ah/api/login.php?c=" + email + "&p=" + contraseña
        
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
                                self.mostraMSJ("Correo o contraseña incorrectos")
                                
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
                                self.performSegueWithIdentifier("inicioSegue3", sender: self)
                                
                            })
                            
                            
                        }
                        
                    } catch {
                        
                    }
                    
                    
                } else {
                    
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        // Iniciar Loader
                        JHProgressHUD.sharedHUD.hide()
                    })
                    print("Hubo un problema con la URL")
                    
                }
                
            })
            task.resume()
            
            
        } else {
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                // Iniciar Loader
                JHProgressHUD.sharedHUD.hide()
            })
            print("Hubo un problema con la URL")
            
        }

        
    }
    
    // FUNCION PARA LOGEAR USUARIO FACEBOOK
    
    func loginConFacebook(var emailFacebookM: String, var idFacebook: String) {
        
        let customAllowedSet = NSCharacterSet.URLQueryAllowedCharacterSet()
        
        idFacebook = idFacebook.stringByAddingPercentEncodingWithAllowedCharacters(customAllowedSet)!
        emailFacebookM = emailFacebookM.stringByAddingPercentEncodingWithAllowedCharacters(customAllowedSet)!
        
        let urlString = "http://intercubo.com/ah/api/login.php?c=" + emailFacebookM + "&fbid=" + idFacebook
        
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
                                self.mostraMSJ("Error al hacer login con Facebook, intente nuevamente mas tarde")
                                
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
                                self.performSegueWithIdentifier("inicioSegue3", sender: self)
                                
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
    
    
    func isValidEmail(testStr:String) -> Bool {
        // println("validate calendar: \(testStr)")
        let emailRegEx = "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluateWithObject(testStr)
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
