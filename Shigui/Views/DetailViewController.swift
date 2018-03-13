//
//  DetailViewController.swift
//  Shigui
//
//  Created by alumnos on 22/2/18.
//  Copyright © 2018 cev. All rights reserved.
//

import UIKit
import Alamofire
import CDAlertView
import CoreLocation
import NVActivityIndicatorView

class DetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var comentView: UIView!
    @IBOutlet weak var valueBTN: UIButton!
    @IBOutlet weak var valuateLbl: UILabel!
    
    @IBOutlet weak var comentaryLbl: UILabel!
    @IBOutlet weak var averageFive: UIImageView!
    @IBOutlet weak var averageFour: UIImageView!
    @IBOutlet weak var averageThree: UIImageView!
    @IBOutlet weak var averageTwo: UIImageView!
    @IBOutlet weak var averageOne: UIImageView!
    @IBOutlet weak var averageLBL: UILabel!
    @IBOutlet weak var favouriteTableView: UITableView!
    @IBOutlet weak var send: UIButton!
    @IBOutlet weak var favorites: UIButton!
    @IBOutlet weak var namelbl: UILabel!
    @IBOutlet weak var fiveStars: UIButton!
    @IBOutlet weak var fourStars: UIButton!
    @IBOutlet weak var threeStars: UIButton!
    @IBOutlet weak var twoStars: UIButton!
    @IBOutlet weak var oneStars: UIButton!
    var dataReceived: Int?
    var isPlaying = true
    var valuation = 0
    var datasFavorite: Array<Any> = []
    var userImg = UIImageView.self
    var average = 0.0
    var datasAverage: Array<Any> = []
    
    @IBOutlet weak var myActivity: NVActivityIndicatorView!
    
    
    @IBOutlet weak var commentTXV: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        

     
        

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        getPlace()
        myActivity.startAnimating()
        
        commentTXV.borderColor = UIColor.red
        commentTXV.borderWidth = 1
        getValuation()
        getValuations()
        getValuationAverage()
        valuateLbl.text = "valueThis".localized()
        comentaryLbl.text = "coment".localized()
        comentView.isHidden = true
        valueBTN.setTitle("comen".localized(), for: .normal)
        valueBTN.backgroundColor = UIColor(red: 231/255, green: 76/255, blue: 60/255, alpha: 1)
        let color = UIColor(red: 231/255, green: 76/255, blue: 60/255, alpha: 1)
        // Initialization code
        comentView.layer.borderWidth = 3
        comentView.clipsToBounds = true
        comentView.layer.borderColor = color.cgColor
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(MapViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
           namelbl.text! = (datasPlace["name"] as! String?)!
        coordinates_X = Double(datasPlace["coordinates_X"] as! String)!
        coordinates_Y = Double(datasPlace["coordinates_Y"] as! String)!
        

       
        
        

        
    }
    
 
    @IBAction func comment(_ sender: Any) {
        comentView.isHidden = false
        valueBTN.isEnabled = false
        back.isEnabled = false
        
        
    }
    @objc func dismissKeyboard() {
        //Las vistas y toda la jerarquía renuncia a responder, para esconder el teclado
        view.endEditing(true)
    }
    
  
  
    @IBAction func deleteComment(_ sender: Any) {
        comentView.isHidden = true
        valueBTN.isEnabled = true
        back.isEnabled = true
        
    }
    
    @IBAction func goToAR(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "DeleteMeViewController") as! DeleteMeViewController
     
        self.present(vc, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBOutlet weak var back: UIButton!
    @IBAction func back(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func favourite(_ sender: Any) {
             isPlaying = !isPlaying
        if isPlaying {
            favorites.setImage(UIImage(named: "Star"), for: .normal)
            createFavorite()
           ()
        }else{
            favorites.setImage(UIImage(named: "AddToFav"), for: .normal)
            deleteFavorite()
          
            
        }
   
    }
    
    func getPlace(){
        
        let url = URL(string:"http://h2744356.stratoserver.net/shigui/Shigui/public/index.php/favorites/favorite.json?id=\((datasPlace ["id"] as! String))")
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
                    
                    print(json)
                //    datasFavorite = json["data"]  as! Dictionary<String, Any>
                    
                    var datasFavorite =  json["message"] as! String
                    if (datasFavorite == "No hay favoritos que mostrar")
                    {
                        self.favorites.setImage(UIImage(named: "AddToFav"), for: .normal)
                        self.isPlaying = false
                        
                    }
                    else{
                        self.favorites.setImage(UIImage(named: "Star"), for: .normal)
                        
                    }
                   
                    
                    
                    
                 
                    
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
    
    
    
    
    func createFavorite()
    {
        let url = URL(string:"http://h2744356.stratoserver.net/shigui/Shigui/public/index.php/favorites/create.json")
        let parameters: Parameters = [
            
            "id_maps":datasPlace ["id_maps"] as! String,
          
            
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
                    let alertDifferentPassTwo = CDAlertView(title: "favoriteCreate".localized(), message: "", type: .success)
                    let doneAction = CDAlertViewAction(title: "ok".localized())
                    alertDifferentPassTwo.isHeaderIconFilled = true
                    alertDifferentPassTwo.circleFillColor = UIColor(red: 56/255, green: 151/255, blue: 217/255, alpha: 1)
                    alertDifferentPassTwo.add(action: doneAction)
                    alertDifferentPassTwo.show()
                    
                   
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
    func deleteFavorite()
    {
        
        let url = URL(string:"http://h2744356.stratoserver.net/shigui/Shigui/public/index.php/favorites/delete.json")
        let parameters: Parameters = [
            
            "id":datasPlace ["id"] as! String,
            
            
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
    
    @IBAction func illuminateStars(_ sender: Any) {
         switch (sender as AnyObject).tag {
         case 1:
            valuation = 1
              oneStars.setImage(UIImage(named: "Star"), for: .normal)
             twoStars.setImage(UIImage(named: "EmptyStar"), for: .normal)
             threeStars.setImage(UIImage(named: "EmptyStar"), for: .normal)
             fourStars.setImage(UIImage(named: "EmptyStar"), for: .normal)
             fiveStars.setImage(UIImage(named: "EmptyStar"), for: .normal)
            
        
            break
            
        case 2:
            valuation = 2
            oneStars.setImage(UIImage(named: "Star"), for: .normal)
            twoStars.setImage(UIImage(named: "Star"), for: .normal)
             threeStars.setImage(UIImage(named: "EmptyStar"), for: .normal)
             fourStars.setImage(UIImage(named: "EmptyStar"), for: .normal)
             fiveStars.setImage(UIImage(named: "EmptyStar"), for: .normal)
            
            break
        case 3:
            valuation = 3
            oneStars.setImage(UIImage(named: "Star"), for: .normal)
            twoStars.setImage(UIImage(named: "Star"), for: .normal)
            threeStars.setImage(UIImage(named: "Star"), for: .normal)
            fourStars.setImage(UIImage(named: "EmptyStar"), for: .normal)
            fiveStars.setImage(UIImage(named: "EmptyStar"), for: .normal)
            
            break
        case 4:
            valuation = 4
            oneStars.setImage(UIImage(named: "Star"), for: .normal)
            twoStars.setImage(UIImage(named: "Star"), for: .normal)
            threeStars.setImage(UIImage(named: "Star"), for: .normal)
            fourStars.setImage(UIImage(named: "Star"), for: .normal)
            fiveStars.setImage(UIImage(named: "EmptyStar"), for: .normal)
            
            break
        case 5:
            valuation = 5
            oneStars.setImage(UIImage(named: "Star"), for: .normal)
            twoStars.setImage(UIImage(named: "Star"), for: .normal)
            threeStars.setImage(UIImage(named: "Star"), for: .normal)
            fourStars.setImage(UIImage(named: "Star"), for: .normal)
            fiveStars.setImage(UIImage(named: "Star"), for: .normal)
            
            break
            
        default:
            
            break
            
        }
    }
    
    @IBAction func send(_ sender: Any) {
        view.endEditing(true)

        if(valuation == 0){
            let alertDifferentPassTwo = CDAlertView(title: "caution".localized(), message: "valueZero".localized(), type: .warning)
            let doneAction = CDAlertViewAction(title: "ok".localized())
            alertDifferentPassTwo.isHeaderIconFilled = true
            alertDifferentPassTwo.circleFillColor = UIColor(red: 231/255, green: 76/255, blue: 60/255, alpha: 1)
            alertDifferentPassTwo.add(action: doneAction)
            alertDifferentPassTwo.show()
        }
        else if (commentTXV.text.count > 150){
            let alertDifferentPassTwo = CDAlertView(title: "caution".localized(), message: "comentLong".localized(), type: .warning)
            let doneAction = CDAlertViewAction(title: "ok".localized())
            alertDifferentPassTwo.isHeaderIconFilled = true
            alertDifferentPassTwo.circleFillColor = UIColor(red: 231/255, green: 76/255, blue: 60/255, alpha: 1)
            alertDifferentPassTwo.add(action: doneAction)
            alertDifferentPassTwo.show()
        }
        else{
            back.isEnabled = true
            createValuation()
            
        }
        
    }
    func createValuation(){
        
        print(getDataInUserDefaults(key: "token")!)
        print(valuation)
        print(datasPlace ["id_maps"] as! String)
        
                
        let url = URL(string:"http://h2744356.stratoserver.net/shigui/Shigui/public/index.php/valuations/create.json")
        let parameters: Parameters = [
            
            "id_maps":datasPlace ["id_maps"] as! String,
            "value":valuation,
            "comentary":commentTXV.text!,
            
            
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
                print(json)
                switch myCode {
                case 200:
                    self.myActivity.startAnimating()
                    
                    
                  
                    self.getValuation()
                    self.getValuations()
                    self.getValuationAverage()
                    let alertDifferentPassTwo = CDAlertView(title: "valueCorrect".localized(), message: "", type: .success)
                    let doneAction = CDAlertViewAction(title: "ok".localized())
                    alertDifferentPassTwo.isHeaderIconFilled = true
                    alertDifferentPassTwo.circleFillColor = UIColor(red: 56/255, green: 151/255, blue: 217/255, alpha: 1)
                    alertDifferentPassTwo.add(action: doneAction)
                    alertDifferentPassTwo.show()
                    
                    
                    //self.id = json["id"] as! Int
                    //print("\(json["data"] as! String)")
                    self.comentView.isHidden = true
                    
                    
                    
                    
                    // showAlert(json["message"])
                    // Accion de login -> Guardar en defaults -> Controller
                    // case 400:
                //     print("Han habido error")
                default:
                    print("")
                    
                }
                
            case .failure:
                print("La peticion no ha funcionado")
            }
        }
    }
    
    func getValuation()  {
        let url = URL(string:"http://h2744356.stratoserver.net/shigui/Shigui/public/index.php/valuations/valuation.json?id_maps=\((datasPlace ["id_maps"] as! String))")
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
                    
                   self.valueBTN.isHidden = true
                    //    datasFavorite = json["data"]  as! Dictionary<String, Any>
                    
                    /*var datasFavorite =  json["message"] as! String
                    if (datasFavorite == "No hay favoritos que mostrar")
                    {
                        self.favorites.setImage(UIImage(named: "AddToFav"), for: .normal)
                        self.isPlaying = false
                        
                    }
                    else{
                        self.favorites.setImage(UIImage(named: "Star"), for: .normal)
                        
                    }*/
                    
                    
                    
                    
                    
                    
                    // datas = json["data"] as! Array<Any>.Type
                    //  print(datas)
                    
                    //self.dataReceived = json["name"] as! String
                    // showAlert(json["message"])
                    // Accion de login -> Guardar en defaults -> Controller
                    // case 400:
                //     print("Han habido error")
                case 400:
                    self.oneStars.isHidden = false
                    self.twoStars.isHidden = false
                    self.threeStars.isHidden = false
                    self.fourStars.isHidden = false
                    self.fiveStars.isHidden = false
                    self.commentTXV.isHidden = false
                    self.send.isHidden = false
                    
                default:
                    print(json)
                    
                }
                
            case .failure:
                
                print("La peticion no ha funcionado")
            }
        }
        
    }
    
    func getValuationAverage()  {
        let url = URL(string:"http://h2744356.stratoserver.net/shigui/Shigui/public/index.php/valuations/valuationsAverage.json?id_maps=\((datasPlace ["id_maps"] as! String))")
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
                  
                    if (json["message"] as! String != "No hay media disponible")
                    {
                        //self.datasAverage = json["data"] as! Array<Any>
                        var holis = json["data"]!
                        

                        self.average = Double(holis as! Float)
                        self.averageLBL.text! = String(format: "%.2f", self.average)
                        
                        self.averageStars()
                  
                     
                    }
                    else{
                        self.averageLBL.text! = "N/V"
                         self.averageStars()
                        
                    }
                    
                
                    
                default:
                    print(json)
                    
                }
                
            case .failure:
                
                print("La peticion no ha funcionado")
            }
        }
        
    }
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("-----------------------------> cell")
        print(datasFavorite.count)
        return datasFavorite.count
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
       
 
       
        
       
       
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as! TempTableViewCell
        let item = datasFavorite[indexPath.row] as! Dictionary<String, Any>
       

        if (!item.isEmpty)
        {
             print("Iiiiiiiiiiiiiiiiiiiiiiitem")
            print(item["user"] as! String!)
            cell.user.text = item["user"] as! String!
            
          
            cell.comentary.text = item["comentary"] as! String!
            existsImageTools(image: item["user_picture"] as! String!, view:  cell.backgroundImgView)
            
            switch(item["value"] as! String!){
            case "1":
                cell.one.image = UIImage(named: "Star")
                cell.two.image = UIImage(named: "EmptyStar")
                cell.three.image = UIImage(named: "EmptyStar")
                cell.four.image = UIImage(named: "EmptyStar")
                cell.five.image = UIImage(named: "EmptyStar")
                
                break
            case "2":
                cell.one.image = UIImage(named: "Star")
                cell.two.image = UIImage(named: "Star")
                cell.three.image = UIImage(named: "EmptyStar")
                cell.four.image = UIImage(named: "EmptyStar")
                cell.five.image = UIImage(named: "EmptyStar")
                break
            case "3":
                cell.one.image = UIImage(named: "Star")
                cell.two.image = UIImage(named: "Star")
                cell.three.image = UIImage(named: "Star")
                cell.four.image = UIImage(named: "EmptyStar")
                cell.five.image = UIImage(named: "EmptyStar")
                break
            case "4":
                cell.one.image = UIImage(named: "Star")
                cell.two.image = UIImage(named: "Star")
                cell.three.image = UIImage(named: "Star")
                cell.four.image = UIImage(named: "Star")
                cell.five.image = UIImage(named: "EmptyStar")
                
                break
            case "5":
                cell.one.image = UIImage(named: "Star")
                cell.two.image = UIImage(named: "Star")
                cell.three.image = UIImage(named: "Star")
                cell.four.image = UIImage(named: "Star")
                cell.five.image = UIImage(named: "Star")
                
                break
            default:
                break
            }

            
        }
        
       
        
 
        
        
        return cell
        
    }
    

    
    func averageStars(){
        switch average {
        case (1...1.25):
            averageOne.image = UIImage(named: "Star")
            averageTwo.image = UIImage(named: "EmptyStar")
            averageThree.image = UIImage(named: "EmptyStar")
            averageFour.image = UIImage(named: "EmptyStar")
            averageFive.image = UIImage(named: "EmptyStar")
            break
        case (1.250000001...1.749999999):
            averageOne.image = UIImage(named: "Star")
            averageTwo.image = UIImage(named: "halfStar")
            averageThree.image = UIImage(named: "EmptyStar")
            averageFour.image = UIImage(named: "EmptyStar")
            averageFive.image = UIImage(named: "EmptyStar")
            break
        case (1.75...2.25):
            averageOne.image = UIImage(named: "Star")
            averageTwo.image = UIImage(named: "Star")
            averageThree.image = UIImage(named: "EmptyStar")
            averageFour.image = UIImage(named: "EmptyStar")
            averageFive.image = UIImage(named: "EmptyStar")
            break
        case (2.250000001...2.749999999):
            averageOne.image = UIImage(named: "Star")
            averageTwo.image = UIImage(named: "Star")
            averageThree.image = UIImage(named: "HalfStar")
            averageFour.image = UIImage(named: "EmptyStar")
            averageFive.image = UIImage(named: "EmptyStar")
            break

        case (2.75...3.25):
            averageOne.image = UIImage(named: "Star")
            averageTwo.image = UIImage(named: "Star")
            averageThree.image = UIImage(named: "Star")
            averageFour.image = UIImage(named: "EmptyStar")
            averageFive.image = UIImage(named: "EmptyStar")
            break
        case (3.250000001...3.749999999):
            averageOne.image = UIImage(named: "Star")
            averageTwo.image = UIImage(named: "Star")
            averageThree.image = UIImage(named: "Star")
            averageFour.image = UIImage(named: "HalfStar")
            averageFive.image = UIImage(named: "EmptyStar")
            break

        case (3.75...4.25):
            averageOne.image = UIImage(named: "Star")
            averageTwo.image = UIImage(named: "Star")
            averageThree.image = UIImage(named: "Star")
            averageFour.image = UIImage(named: "Star")
            averageFive.image = UIImage(named: "EmptyStar")
            break
        case (4.250000001...4.749999999):
            averageOne.image = UIImage(named: "Star")
            averageTwo.image = UIImage(named: "Star")
            averageThree.image = UIImage(named: "Star")
            averageFour.image = UIImage(named: "Star")
            averageFive.image = UIImage(named: "HalfStar")
            break

        case (4.75...5):
            averageOne.image = UIImage(named: "Star")
            averageTwo.image = UIImage(named: "Star")
            averageThree.image = UIImage(named: "Star")
            averageFour.image = UIImage(named: "Star")
            averageFive.image = UIImage(named: "Star")
            break
        default:
            averageOne.image = UIImage(named: "EmptyStar")
            averageTwo.image = UIImage(named: "EmptyStar")
            averageThree.image = UIImage(named: "EmptyStar")
            averageFour.image = UIImage(named: "EmptyStar")
            averageFive.image = UIImage(named: "EmptyStar")
        }
    }
    
    
    
    
    func getValuations()  {
        let url = URL(string:"http://h2744356.stratoserver.net/shigui/Shigui/public/index.php/valuations/valuations.json?id_maps=\((datasPlace ["id_maps"] as! String))")
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
                switch myCode {
                    case 200:
                        
                      print(json)
                      if (json["message"] as! String != "No hay valoraciones que mostrar")
                      {
                        self.datasFavorite =  json["data"] as! Array<Any>
                        print("-----------------------------> datasFavorite")
                        print(self.datasFavorite)
                        
                        
                      }
                      self.favouriteTableView.reloadData()
                      self.favouriteTableView.sizeToFit()
                      if self.myActivity.isAnimating{
                        self.myActivity.stopAnimating()
                      }
                    
                  
                    
                        //    datasFavorite = json["data"]  as! Dictionary<String, Any>
                    
                        /*var datasFavorite =  json["message"] as! String
                         if (datasFavorite == "No hay favoritos que mostrar")
                         {
                         self.favorites.setImage(UIImage(named: "AddToFav"), for: .normal)
                         self.isPlaying = false
                     
                         }
                         else{
                         self.favorites.setImage(UIImage(named: "Star"), for: .normal)
                     
                         }*/
                    
                    
                    
                    
                    
                    
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
