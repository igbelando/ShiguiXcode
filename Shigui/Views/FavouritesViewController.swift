//
//  FavouritesViewController.swift
//  Shigui
//
//  Created by alumnos on 22/1/18.
//  Copyright © 2018 cev. All rights reserved.
//

import UIKit
import Alamofire
import CDAlertView

class FavouritesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var favouriteTableView: UITableView!
    @IBOutlet weak var homeBTN: UIButton!
    var datasFavorite: Array<Any> = []
    var datasPla: Array<Any> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getFavorites()
        NotificationCenter.default.addObserver(self, selector: #selector(self.deleteComment(_:)), name: Notification.Name("NotificationDeleteFavorite"), object: nil)
       
        // Do any additional setup after loading the view.
    }
    @objc func deleteComment(_ notification: Notification){
        
        print("Borro el Favorito con Index \(indexComment)")
        // Añadir endpoint
        let d = datasFavorite[indexComment] as! Dictionary<String, Any>
        
        print(d["id_place"]!)
        let usa = d["id_place"]! as! String
        print(usa)
        deleteFavorite(id_placement: usa)
    }
    
    @IBAction func goPlace(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "MapViewController") as! MapViewController
        self.present(vc, animated: true, completion: nil)
        print("---------------------------------------------->")
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datasFavorite.count
    }
    
    func deleteFavorite(id_placement: Any)
    {
        
        let url = URL(string:"http://h2744356.stratoserver.net/shigui/Shigui/public/index.php/favorites/delete.json")
        let parameters: Parameters = [
            
            "id":id_placement,
            ]
        let headers: HTTPHeaders = [
            "Authorization":  getDataInUserDefaults(key: "token")!
        ]
        
        //peticion = "RegisterRequest"
        //func miLlamada(url, parameters, tipo, peticion)
        
        Alamofire.request(url!, method: .post, parameters: parameters,headers: headers).responseJSON{ response in
            
            switch response.result {
                
                case .success:
                    
                    print("La peticion ha ido bien")
                    let json = response.result.value as! Dictionary<String, Any>
                    let myCode = json["code"] as! Int
                    switch myCode {
                        case 200:
                            print("")
                            let alertDifferentPassTwo = CDAlertView(title: "favoriteDelete".localized(), message: "", type: .success)
                            let doneAction = CDAlertViewAction(title: "ok".localized())
                            alertDifferentPassTwo.isHeaderIconFilled = true
                            alertDifferentPassTwo.circleFillColor = UIColor(red: 56/255, green: 151/255, blue: 217/255, alpha: 1)
                            alertDifferentPassTwo.add(action: doneAction)
                            alertDifferentPassTwo.show()
                            self.getFavorites()
                        
                            //self.id = json["id"] as! Int
                            //print("\(json["data"] as! String)")
                        
                            // showAlert(json["message"])
                            // Accion de login -> Guardar en defaults -> Controller
                            // case 400:
                        //     print("Han habido error")
                        default:
                            print(json)
                        }
                
                case .failure:
                    print("La peticion no ha funcionado")
                }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as! FavouriteTableViewCell
        let item = datasFavorite[indexPath.row] as! Dictionary<String, Any>
        
        cell.textLabel?.text = item["place"] as? String
        cell.valuationIndexPath = indexPath.row
       
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print("He pulsado")
        print(indexPath.row)
        let item = datasFavorite[indexPath.row] as! Dictionary<String, Any>
        print(item["id_place"] as! String)
        getPlace(id: item["id_place"] as! String )
        
        
        
    }
    
    func getPlace(id: String){
        
        let url = URL(string:"http://h2744356.stratoserver.net/shigui/Shigui/public/index.php/places/place.json?id=\(id)")
        let headers: HTTPHeaders = [
            "Authorization":  getDataInUserDefaults(key: "token")!
        ]
        
        
        //peticion = "RegisterRequest"
        //func miLlamada(url, parameters, tipo, peticion)
        
        Alamofire.request(url!,method: .get,headers: headers).responseJSON{ response in
            
            switch response.result {
            case .success:
                
                print("La peticion ha ido bien")
                let json = response.result.value as! Dictionary<String, Any>
                let myCode = json["code"] as! Int
                switch myCode {
                case 200:
                    print("11111111111111111111111111111111111111")
                    
                    print(json)
                    print("2222222222222222222222222222222222222")
                    var datasFavorit: [String:Any] = [:]
                    datasFavorit = json["data"] as! [String : Any]
                  
                    coordinates_X =  Double(datasFavorit["coordinates_X"] as! String)!
                    coordinates_Y = Double(datasFavorit["coordinates_Y"] as! String)!
                    id_maps = datasFavorit["id_maps"] as! String
                    
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "MapViewController") as! MapViewController
                     vc.dataReceived = true
                    vc.stringReceived = datasFavorit["name"] as! String
                    
                     self.present(vc, animated: true, completion: nil)
                    
                    //self.datasPla = json["data"] as! Array<Any>
                    //print(self.datasPlace as! String)
                    //    datasFavorite = json["data"]  as! Dictionary<String, Any>
                    
                
                    
                    
                    
                    
                    
                    
                    // datas = json["data"] as! Array<Any>.Type
                    //  print(datas)
                    
                    //self.dataReceived = json["name"] as! String
                    // showAlert(json["message"])
                    // Accion de login -> Guardar en defaults -> Controller
                    // case 400:
                //     print("Han habido error")
                default:
                    print(json)
                    
                }
                
            case .failure:
                
                print("La peticion no ha funcionado")
            }
        }
    }
    
    
    @IBAction func homeScreen(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
        }
    
    func getFavorites(){
        
        let url = URL(string:"http://h2744356.stratoserver.net/shigui/Shigui/public/index.php/favorites/favorites.json?")
        let headers: HTTPHeaders = [
            "Authorization":  getDataInUserDefaults(key: "token")!
        ]
        
        //peticion = "RegisterRequest"
        //func miLlamada(url, parameters, tipo, peticion)
        
        Alamofire.request(url!,method: .get,headers: headers).responseJSON{ response in
            self.datasFavorite.removeAll()
            switch response.result {
                case .success:
                    
                    print("La peticion ha ido bien")
                    let json = response.result.value as! Dictionary<String, Any>
                    let myCode = json["code"] as! Int
                    print("myCode  ---- \(myCode)")
                    switch myCode {
                        case 200:
                            
                            //    datasFavorite = json["data"]  as! Dictionary<String, Any>
                            if(json["message"] as! String != "No hay favoritos que mostrar")
                            {
                                self.datasFavorite =  json["data"] as! Array<Any>
                            }
                            print("-----------------------------> datasFavorite")
                            print(self.datasFavorite)
        
                            self.favouriteTableView.reloadData()
                            self.favouriteTableView.sizeToFit()
                        
                            // datas = json["data"] as! Array<Any>.Type
                            //  print(datas)
                        
                            //self.dataReceived = json["name"] as! String
                            // showAlert(json["message"])
                            // Accion de login -> Guardar en defaults -> Controller
                            // case 400:
                        //     print("Han habido error")
                        default:
                            print(json)
                        }
                
                case .failure:
                    
                print("La peticion no ha funcionado")
            }
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}
