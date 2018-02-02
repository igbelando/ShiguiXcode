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
class HomeViewController: UIViewController {
    
    @IBOutlet weak var userImg: UIImageView!
    
    @IBOutlet weak var nameLbl: UILabel!
    
    @IBOutlet weak var ShiguiBTN: UIButton!
    @IBOutlet weak var SettingsBTN: UIButton!
    @IBOutlet weak var ProfileBTN: UIButton!
    @IBOutlet weak var FavouriteBTN: UIButton!
    @IBOutlet weak var ValuationsBTN: UIButton!
    @IBOutlet weak var ShopBTN: UIButton!
     var dataReceived: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        updateText()

        // Do any additional setup after loading the view.
    }
    
    func updateText(){
        ShiguiBTN.setTitle("SHIGUI", for: .normal)
        SettingsBTN.setTitle("SETTINGS".localized(), for: . normal)
        ProfileBTN.setTitle("PROFILE".localized(), for: .normal)
        FavouriteBTN.setTitle("FAVOURITES".localized(), for: .normal)
        ValuationsBTN.setTitle("VALUATIONS".localized(), for: .normal)
        ShopBTN.setTitle("SHOP".localized(), for: .normal)
        nameLbl.text = datas["name"]  as! String
        existsImage(image: datas["picture"] as! String)
        
   
    }
    
    @IBAction func changeScreen(_ sender: Any) {
       
        switch (sender as AnyObject).tag {
            
        
        case 1:
           /* let vc = self.storyboard?.instantiateViewController(withIdentifier: "MapViewController") as! MapViewController
            self.present(vc, animated: true, completion: nil)*/
            
            let alert = CDAlertView(title: "Oops".localized(), message: "not available".localized(), type: .error)
            let doneAction = CDAlertViewAction(title: "ok".localized())
            alert.isHeaderIconFilled = true
            alert.circleFillColor = UIColor(red: 231/255, green: 76/255, blue: 60/255, alpha: 1)
            alert.add(action: doneAction)
            
            
            alert.show()
           
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
            /*let vc = self.storyboard?.instantiateViewController(withIdentifier: "FavouritesViewController") as! FavouritesViewController
            self.present(vc, animated: true, completion: nil)*/
            let alert = CDAlertView(title: "OOPS".localized(), message: "not available".localized(), type: .error)
            let doneAction = CDAlertViewAction(title: "ok".localized())
            alert.isHeaderIconFilled = true
            alert.circleFillColor = UIColor(red: 231/255, green: 76/255, blue: 60/255, alpha: 1)
            alert.add(action: doneAction)
            
            
            alert.show()
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
            let alert = CDAlertView(title: "OOPS".localized(), message: "not available".localized(), type: .error)
            let doneAction = CDAlertViewAction(title: "ok".localized())
            alert.isHeaderIconFilled = true
            alert.circleFillColor = UIColor(red: 231/255, green: 76/255, blue: 60/255, alpha: 1)
            alert.add(action: doneAction)
            
            
            alert.show()
        default:
            break
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func getUser(){
        
    }
    func existsImage(image: String){
        if let documentsDIrectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first{
            let imageUrl = image
            let file_name = URL(fileURLWithPath: imageUrl).lastPathComponent
            print(file_name)
            let savePath = ("\(documentsDIrectory)/\(file_name)")
            userImg.image = UIImage(named: savePath)
            
            if userImg.image == nil {
                print("NO TENGO LA IMAGEN EN LOCAL ::: DESCARGO")
                //let url = URL(string: image)  else { return }
                guard let url = URL(string: image) else { return }
                let urlRequest = URLRequest(url: url)
                let task = URLSession.shared.dataTask(with: urlRequest, completionHandler: { (data, response, error)   in
                    
                    if error != nil {
                        print("Error de descarga : \(error)")
                    }
                    else{
                        DispatchQueue.main.async {
                            let imageDown = UIImage(data: data!)
                            self.userImg.image = imageDown
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
                print("NO TENGO LA IMAGEN EN LOCAL ::: DESCARGO")
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
