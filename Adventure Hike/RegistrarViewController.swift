//
//  RegistrarViewController.swift
//  Adventure Hike
//
//  Created by Roberto Gutierrez on 13/01/16.
//  Copyright © 2016 Roberto Gutierrez. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKShareKit
import FBSDKLoginKit


class RegistrarViewController: UIViewController, FBSDKLoginButtonDelegate, UITextFieldDelegate {
    
    // TEXTFIELDS REGISTRAR
    @IBOutlet var nicknameTextfield: UITextField!
    @IBOutlet var nombreTextfield: UITextField!
    @IBOutlet var fechaNacimientoTextfield: UITextField!
    @IBOutlet var emailTextfield: UITextField!
    @IBOutlet var contraseñaTextfield: UITextField!
    @IBOutlet var reescribeContraseñaTextfield: UITextField!
    
    var nickname = ""
    var nombre = ""
    var fecha = ""
    var email = ""
    var contraseña = ""
    var reescribeContraseña = ""

    
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
        
        nicknameTextfield.delegate = self
        nombreTextfield.delegate = self
        fechaNacimientoTextfield.delegate = self
        emailTextfield.delegate = self
        contraseñaTextfield.delegate = self
        reescribeContraseñaTextfield.delegate = self
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)

        if (FBSDKAccessToken.currentAccessToken() != nil) {

            
            
        } else {
            
            botonLoginFacebook.readPermissions = ["public_profile", "email", "user_friends"]
            botonLoginFacebook.delegate = self
            
        }
        
        // Toolbar de DatePicker (Fecha de nacimiento)
        
        let toolBar = UIToolbar(frame: CGRectMake(0, self.view.frame.size.height/6, self.view.frame.size.width, 40.0))
        toolBar.layer.position = CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height-20.0)
        toolBar.barStyle = UIBarStyle.BlackTranslucent
        toolBar.tintColor = UIColor.whiteColor()
        toolBar.backgroundColor = UIColor.darkGrayColor()
        let todayBtn = UIBarButtonItem(title: "Cancelar", style: UIBarButtonItemStyle.Plain, target: self, action: "donePressed:")
        let okBarBtn = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: "donePressed:")
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: self, action: nil)
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width / 3, height: self.view.frame.size.height))
        label.font = UIFont(name: "Helvetica", size: 10)
        label.backgroundColor = UIColor.clearColor()
        label.textColor = UIColor.whiteColor()
        label.text = "Fecha de nacimiento"
        label.textAlignment = NSTextAlignment.Center
        let textBtn = UIBarButtonItem(customView: label)
        toolBar.setItems([todayBtn,flexSpace,textBtn,flexSpace,okBarBtn], animated: true)
        
        fechaNacimientoTextfield.inputAccessoryView = toolBar

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
                
                
            }
            
            self.returnUserData()
            
        }
        
    }
    
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        print("Usuario ha salido")
    }
    
    
    func returnUserData() {
        
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
            
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(0.4 * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), { () -> Void in
                self.performSegueWithIdentifier("contrasenaSegue", sender: self)
            })
            
                //self.registrarConFacebook(self.nombreCompletoFacebook, idFacebook: self.idFacebook, emailFacebookM: self.emailFacebook)
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
    
    
    // BOTON REGISTRAR

    @IBAction func RegistrarBoton(sender: AnyObject) {
        
        nickname = nicknameTextfield.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        nombre = nombreTextfield.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        fecha = fechaNacimientoTextfield.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        email = emailTextfield.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        contraseña = contraseñaTextfield.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        reescribeContraseña = reescribeContraseñaTextfield.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        
        
        
        if(nickname == "" || nombre == "" || fecha == "" || email == "" || contraseña == "" || reescribeContraseña == ""){
            
            mostraMSJ("Favor de completar los datos!")
            
            
        } else if(contraseña != reescribeContraseña) {
            
            mostraMSJ("Las contraseñas deben de coincidir!")
            
        } else if(!isValidEmail(email)) {
            
            mostraMSJ("Favor de escribir un correo válido!")
            
        } else if(contraseña.characters.count < 7) {
            
            mostraMSJ("Favor de escribir una contraseña con más de 7 dígitos!")
            
        } else {
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                // Iniciar Loader
                JHProgressHUD.sharedHUD.showInView(self.view, withHeader: "Registrando usuario", andFooter: "Por favor espere...")
            })
            registrarUsuario();
            //print("Nickname es: \(nickname), nombre es \(nombre), fecha es \(fecha), email es \(email), contraseña es \(contraseña), reescribe contraseña es \(reescribeContraseña)")
            
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

    
    // FUNCION PARA REGISTRAR USUARIO
    
    func registrarUsuario() {
        
        let customAllowedSet = NSCharacterSet.URLQueryAllowedCharacterSet()
        
        nickname = nickname.stringByAddingPercentEncodingWithAllowedCharacters(customAllowedSet)!
        nombre = nombre.stringByAddingPercentEncodingWithAllowedCharacters(customAllowedSet)!
        fecha = fecha.stringByAddingPercentEncodingWithAllowedCharacters(customAllowedSet)!
        email = email.stringByAddingPercentEncodingWithAllowedCharacters(customAllowedSet)!
        contraseña = contraseña.stringByAddingPercentEncodingWithAllowedCharacters(customAllowedSet)!
        
        let urlString = "http://intercubo.com/ah/api/registra.php?n=" + nombre + "&c=" + email + "&p=" + contraseña + "&nickname=" + nickname + "&fecha=" + fecha
        
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
                                self.mostraMSJ("Ya existe una cuenta registrada con ese correo")
                                
                            })

                            
                            
                        } else {
                            
                            let jsonResult = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers) as! NSArray
                            
                            //print(jsonResult)
                            
                            for json in jsonResult {
                                
                                let correo = json["correo"] as! String
                                let display = json["display"] as! String
                                let fbid = json["fbid"] as! String
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
                                self.performSegueWithIdentifier("inicioSegue", sender: self)
                                
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
    
    
    
    // METODOS DE FECHA DE NACIMIENTO TEXTFIELD
    
    @IBAction func fechaDeNacimientoTextfield(sender: UITextField) {
        
        let datePickerView: UIDatePicker = UIDatePicker()
        
        datePickerView.datePickerMode = UIDatePickerMode.Date
        
        sender.inputView = datePickerView
        
        datePickerView.addTarget(self, action: Selector("datePickerValueChanged:"), forControlEvents: UIControlEvents.ValueChanged)
        
    }
    
    func datePickerValueChanged(sender: UIDatePicker) {
        
        let dateFormatter = NSDateFormatter()
        
        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
        
        dateFormatter.timeStyle = NSDateFormatterStyle.NoStyle
        
        fechaNacimientoTextfield.text = dateFormatter.stringFromDate(sender.date)
        
    }
    
    func donePressed(sender: UIBarButtonItem) {
        
        fechaNacimientoTextfield.resignFirstResponder()
        
    }
    
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "contrasenaSegue" {
            
            let destinoVC = segue.destinationViewController as! ContrasenaFaceViewController
            destinoVC.nombreCompletoFacebook = nombreCompletoFacebook
            destinoVC.emailFacebook = emailFacebook
            destinoVC.idFacebook = idFacebook
            
        }
    }
    
    
    
    
    
    
    
    
    

}
