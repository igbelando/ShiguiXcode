//
//  HomeViewController.swift
//  Shigui
//
//  Created by alumnos on 24/1/18.
//  Copyright © 2018 cev. All rights reserved.
//

import UIKit
import CDAlertView
import Localize_Swift
import Alamofire
import NVActivityIndicatorView

class HomeViewController: UIViewController {
    
    @IBOutlet weak var userImg: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var ShiguiBTN: UIButton!
    @IBOutlet weak var SettingsBTN: UIButton!
    @IBOutlet weak var ProfileBTN: UIButton!
    @IBOutlet weak var FavouriteBTN: UIButton!
    @IBOutlet weak var ShopBTN: UIButton!
    
    @IBOutlet weak var activityView: NVActivityIndicatorView!
    @IBOutlet weak var myActivity: UIActivityIndicatorView!
    
    var dataReceived: String?
    
    let shighuiColor = UIColor(red: 56/255, green: 151/255, blue: 217/255, alpha: 1)
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        getUser()
        
        ShiguiBTN.layer.borderColor = shighuiColor.cgColor
        SettingsBTN.layer.borderColor = shighuiColor.cgColor
        ProfileBTN.layer.borderColor = shighuiColor.cgColor
        FavouriteBTN.layer.borderColor = shighuiColor.cgColor
       

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getUser()
        activityView.startAnimating()
        //activityView.startAnimating()
    }
    
    func updateText(){
        
        ShiguiBTN.setTitle("SHIGUI", for: .normal)
        SettingsBTN.setTitle("SETTINGS".localized(), for: . normal)
        ProfileBTN.setTitle("PROFILE".localized(), for: .normal)
        FavouriteBTN.setTitle("FAVOURITES".localized(), for: .normal)
        
        nameLbl.text = datas["name"]  as? String
        existsImageTools(image: datas["picture"] as! String, view: userImg)
        print("datas ::: \(datas)")
        
    }
    
    @IBAction func changeScreen(_ sender: Any) {
       
        switch (sender as AnyObject).tag {
            
            case 1:
                //IR a busqueda
               /* let vc = self.storyboard?.instantiateViewController(withIdentifier: "MapViewController") as! MapViewController
                self.present(vc, animated: true, completion: nil)*/
                
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "MapViewController") as! MapViewController
                self.present(vc, animated: true, completion: nil)
                            /*
                let alert = CDAlertView(title: "Oops".localized(), message: "not available".localized(), type: .error)
                let doneAction = CDAlertViewAction(title: "ok".localized())
                alert.isHeaderIconFilled = true
                alert.circleFillColor = UIColor(red: 231/255, green: 76/255, blue: 60/255, alpha: 1)
                alert.add(action: doneAction)
                alert.show()
               */
            case 2:
                /*let vc = self.storyboard?.instantiateViewController(withIdentifier: "ShopViewController") as! ShopViewController
                self.present(vc, animated: true, completion: nil)*/
                
                let alert = CDAlertView(title: "OOPS".localized(), message: "not available".localized(), type: .error)
                let doneAction = CDAlertViewAction(title: "ok".localized())
                alert.isHeaderIconFilled = true
                alert.circleFillColor = UIColor(red: 231/255, green: 76/255, blue: 60/255, alpha: 1)
                alert.add(action: doneAction)
                alert.show()
            
            case 3:
                //IR a favoritos
                /*let vc = self.storyboard?.instantiateViewController(withIdentifier: "FavouritesViewController") as! FavouritesViewController
                self.present(vc, animated: true, completion: nil)*/
                
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "FavouritesViewController") as! FavouritesViewController
                self.present(vc, animated: true, completion: nil)
            
            case 4:
                  /*let vc = self.storyboard?.instantiateViewController(withIdentifier: "ValuationsViewController") as! ValuationsViewController
                self.present(vc, animated: true, completion: nil)*/
                
                let alert = CDAlertView(title: "OOPS".localized(), message: "not available".localized(), type: .error)
                let doneAction = CDAlertViewAction(title: "ok".localized())
                alert.isHeaderIconFilled = true
                alert.circleFillColor = UIColor(red: 231/255, green: 76/255, blue: 60/255, alpha: 1)
                alert.add(action: doneAction)
                alert.show()
            
            case 5:
                
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
                vc.dataReceivedProfile = dataReceived
                self.present(vc, animated: true, completion: nil)
            
            case 6:
                 /*let vc = self.storyboard?.instantiateViewController(withIdentifier: "SettingsViewController") as! SettingsViewController
                self.present(vc, animated: true, completion: nil)*/
                
                
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "SettingsViewController") as! SettingsViewController
                self.present(vc, animated: true, completion: nil)
            default:
                break
        }
    }
    
    
    
    func getUser(){
        
        let url = URL(string:"http://h2744356.stratoserver.net/shigui/Shigui/public/index.php/users/user.json")
        var token = ""
        if getDataInUserDefaults(key: "token")  != nil {
            print("token :: \(getDataInUserDefaults(key: "token"))")
            token = getDataInUserDefaults(key: "token")!
        }
        
        let headers: HTTPHeaders = [
            "Authorization": token,
            "Content-Type": "multipart/form-data"
        ]
        
        //peticion = "RegisterRequest"
        
        Alamofire.request(url!,method: .get, headers: headers).responseJSON{ response in
            
            switch response.result {
            case .success:
                
                print("La peticion ha ido bien")
                let json = response.result.value as! Dictionary<String, Any>
                let myCode = json["code"] as! Int
                switch myCode {
                case 200:

                    datas = json["data"]  as! Dictionary<String, Any>
                    self.updateText()
                    if(self.activityView.isAnimating){
                        self.activityView.stopAnimating()
                    }
                    
                default:
                    
                    let alert = CDAlertView(title: "Code ".localized() + "\(myCode)", message: "failServer".localized(), type: .warning)
                    let doneAction = CDAlertViewAction(title: "ok".localized())
                    alert.isHeaderIconFilled = true
                    alert.circleFillColor = UIColor(red: 231/255, green: 76/255, blue: 60/255, alpha: 1)
                    alert.add(action: doneAction)
                    
                    alert.show()
                    print("default")
                }
                
            case .failure:
                print("La peticion no ha funcionado")
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
