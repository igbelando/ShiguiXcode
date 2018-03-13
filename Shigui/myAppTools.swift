//
//  myAppTools.swift
//  Shigui
//
//  Created by alumnos on 10/1/18.
//  Copyright © 2018 cev. All rights reserved.
//

import Foundation
import UIKit
import MapKit

let defaults = UserDefaults.standard
var indexComment:Int = 0

func saveDataInUserDefaults(value:String, key:String){
    
    if defaults.object(forKey: "userRegistered") == nil {
        defaults.set(userRegistered, forKey: "userRegistered")
    }
    userRegistered = defaults.object(forKey: "userRegistered") as! [String:String]
    userRegistered.updateValue(value, forKey: key)
    
    defaults.set(userRegistered, forKey: "userRegistered")
    defaults.synchronize()
    
}

func getDataInUserDefaults(key:String) -> String?{
    
    if defaults.object(forKey: "userRegistered") != nil{
        userRegistered = defaults.object(forKey: "userRegistered") as! [String:String]
        
        return userRegistered[key]
    }else{
        return nil
    }
    
}
func clearUserDefaults(){
    defaults.set(nil, forKey: "userRegistered")
}

var userRegistered:[String:String] = [:]
var isUserRegistered:Bool?



func isValidEmail(YourEMailAddress: String) -> Bool {
    let REGEX: String
    REGEX = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
    return NSPredicate(format: "SELF MATCHES %@", REGEX).evaluate(with: YourEMailAddress)
}
var token: String?
var datas: [String:Any] = [:]
var datasPlace: [String:Any] = [:]
var coordinates_X = Double(0)
var coordinates_Y = Double(0)
var selectedMapItem: MKMapItem!
var id_maps = ""


func existsImageTools(image: String, view: UIImageView){
    if let documentsDIrectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first{
        print("image :: \(image)")
        let imageUrl = image
        let file_name = URL(fileURLWithPath: imageUrl).lastPathComponent
        print(file_name)
        let savePath = ("\(documentsDIrectory)/\(file_name)")
        view.image = UIImage(named: savePath)
        
        if view.image == nil {
            
            print("ES NULO!ª!ª!!!! NO TENGO LA IMAGEN EN LOCAL ::: DESCARGO")
            //let url = URL(string: image)  else { return }
            let url = URL(string: image)
            let urlRequest = URLRequest(url: url!)
            print("urlReqeust :: \(urlRequest)")
            let task = URLSession.shared.dataTask(with: urlRequest, completionHandler: { (data, response, error)   in
                print("INSIE")
                if error != nil {
                    print("Error de descarga : \(error)")
                }
                else{
                    DispatchQueue.main.async {
                        let imageDown = UIImage(data: data!)
                        view.image = imageDown
                        print("LA IMAGEN HA SIDO DESCARGADA")
                        FileManager.default.createFile(atPath:
                            savePath, contents: data, attributes:
                            nil)
                        print("LA IMAGEN HA SIDO GAURDADA")
                    }
                }
            })
            task.resume()
            
        }
        else{
            print("YA LA TENGO")
        }
    }
}
func getCountries() -> [String]{
    var countries: [String] = []
    for code in NSLocale.isoCountryCodes as [String] {
        let id = NSLocale.localeIdentifier(fromComponents: [NSLocale.Key.countryCode.rawValue: code])
        let name = NSLocale(localeIdentifier: "en_UK").displayName(forKey: NSLocale.Key.identifier, value: id) ?? "Country not found for code: \(code)"
        countries.append(name)
    }
    return (countries)
    
}

//ENDPOINTS


//CREAR LUGAR
/*
let url = "http://h2744356.stratoserver.net/shigui/Shigui/public/index.php/places/create.json

let parameters = [
"id_maps" = json["id"],
"name" =  json["name"],
"coordinates_X" =  json["coordinates_X"],
"coordinates_Y" =  json["coordinates_Y"],
"picture" = imagepath



]
let headers [
 "Authorization":  getDataInUserDefaults(key: "token")!
]


Alamofire.request(url,parameters: parameters, method: .post, headers: headers).responseJSON{ response in
    
    print("(--------------------------")
    print("Request        :: \(response.request)")
    print("Request Result :: \(response.result)")
    print("Request Value  :: \(response.result.value)")
    print("Request StatusCode :: \(response.response?.statusCode)")
    print("url:" + url)
    
    switch response.result
    {
    case .success:
        print("La peticion ha ido bien")
        
        
        
        
        
        let json = response.result.value as! Dictionary<String, Any>
        if   json["code"]  != nil {
            
            let myCode = json["code"] as! Int
            print(json)
            
            switch myCode {
            case 200:
                
                token = json["data"] as! String?

        
                
                // showAlert(json["message"])
                // Accion de login -> Guardar en defaults -> Controller
                // case 400:
            //     print("Han habido error")
            default:
                
                let alert = CDAlertView(title: "caution".localized(), message: "failLogin".localized(), type: .warning)
                let doneAction = CDAlertViewAction(title: "ok".localized())
                alert.isHeaderIconFilled = true
                alert.circleFillColor = UIColor(red: 231/255, green: 76/255, blue: 60/255, alpha: 1)
                alert.add(action: doneAction)
                
                
                alert.show()
                print("default")
            }
        }
        
        /*  let jsonReturn = [
         "code": 200,
         "data": [
         "username":"EL nkmbre",
         "token":"dsfbdksufhkufghdksjgjfgdsjk",
         "rol":"premium"
         ],
         "message":"Loginn Correcto"
         ]*/
        
    case .failure:
        print("La peticion no ha funcionado")
    }
}
*/




    
    

