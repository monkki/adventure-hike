//
//  Urls.swift
//  Adventure Hike
//
//  Created by Roberto Gutierrez on 04/01/16.
//  Copyright © 2016 Roberto Gutierrez. All rights reserved.
//

import Foundation

class Urls {
    
    // Produccion 11 de Diciembre
    let RAIZ_WS = "http://intercubo.com/ah/api/"
    
    
    
    let INICIO = "archivo.php?tipo=Home"
    
    
    func getUrlLogin(telefono: String)-> String{
        let url = RAIZ_WS + INICIO + "celular=" + telefono;
        return url;
    }
    
    
    
}
  