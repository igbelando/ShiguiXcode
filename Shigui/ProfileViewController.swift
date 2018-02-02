//
//  ProfileViewController.swift
//  Shigui
//
//  Created by alumnos on 22/1/18.
//  Copyright © 2018 cev. All rights reserved.
//

import UIKit
import Alamofire
import Localize_Swift
import CDAlertView

extension UIView {
    
    @IBInspectable var cornerRadius: CGFloat {
        
        get{
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        get {
            return UIColor(cgColor: layer.borderColor!)
        }
        set {
            layer.borderColor = borderColor?.cgColor
        }
    }
}

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {

   
    @IBOutlet weak var profileLabel: UILabel!
    @IBOutlet weak var editPhotoBTN: UIButton!
    @IBOutlet weak var homeBTN: UIButton!
    @IBOutlet weak var changePasswordBTN: UIButton!
    @IBOutlet weak var saveChangesBTN: UIButton!
    @IBOutlet weak var editUserBTN: UIButton!
    @IBOutlet weak var editEmailBTN: UIButton!
    
    @IBOutlet weak var coinLbl: UILabel!
    @IBOutlet weak var profileIMG: UIImageView!
    @IBOutlet weak var nameTXF: UITextField!
    @IBOutlet weak var emailLbl: UILabel!
    var imagePath = ""
    var dataReceivedProfile: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getUser()
        
        
        
        // Do any additional setup after loading the view.
    }
    func updateText()  {
        profileLabel.text = "PROFILE".localized()
        homeBTN.setTitle("HOME".localized(), for: .normal)
        saveChangesBTN.setTitle("SAVE".localized(), for: .normal)
        changePasswordBTN.setTitle("CHANGE PASSWORD".localized(), for: .normal)
        saveChangesBTN.rounded()
        changePasswordBTN.rounded()
        nameTXF.isEnabled = false
        nameTXF.text = datas["name"]  as! String
        coinLbl.text = datas["coins"]  as! String
        emailLbl.text = datas["email"]  as! String
        //profileIMG.image =
       
        saveChangesBTN.isEnabled = false
        saveChangesBTN.backgroundColor = UIColor(red: 161/255, green: 157/255, blue: 150/255, alpha: 0.7)
        existsImage(image: datas["picture"] as! String)
      
            
     
        
        
        
       
        
    }
    @IBAction func changeScreen(_ sender: Any) {
        
        switch (sender as AnyObject).tag {
            
        
        case 8:
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
            
            self.present(vc, animated: true, completion: nil)
            break
        case 9:
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ChangePasswordViewController") as! ChangePasswordViewController
            vc.dataReceived = dataReceivedProfile
            self.present(vc, animated: true, completion: nil)
            break
        
        default:
            break
        }
    }
    
    @IBAction func saveChanges(_ sender: Any) {
        
        
        if(nameTXF.text! != ""){
            
            if(nameTXF.text! != datas["name"] as! String){
                
            
        
        
        let url = URL(string:"http://h2744356.stratoserver.net/shigui/Shigui/public/index.php/users/modifyUser.json")
        let parameters: Parameters = [
            "name": nameTXF.text!
        ]
        let headers: HTTPHeaders = [
            "Authorization": token!
        ]
        
        //peticion = "RegisterRequest"
        
        //func miLlamada(url, parameters, tipo, peticion)
        
        Alamofire.request(url!,method: .post, parameters: parameters, headers: headers).responseJSON{ response in
            
            switch response.result {
            case .success:
                
                
                print("La peticion ha ido bien")
                let json = response.result.value as! Dictionary<String, Any>
                let myCode = json["code"] as! Int
                switch myCode {
                case 200:
                    
                    
                    
                   
                    
                    self.nameTXF.backgroundColor = UIColor(red: 56/255, green: 151/255, blue: 217/255, alpha: 0)
                    self.nameTXF.textColor = UIColor.white
                    self.nameTXF.isEnabled = false
                    
                    self.getUser()
                    
                
                    // showAlert(json["message"])
                    // Accion de login -> Guardar en defaults -> Controller
                    // case 400:
                //     print("Han habido error")
                default:
                    
                    let alert = CDAlertView(title: "userExists".localized(), message: "", type: .warning)
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
            else{
                print("El nombre no ha cambiado")
                saveChangesBTN.isEnabled = false
                saveChangesBTN.backgroundColor = UIColor(red: 161/255, green: 157/255, blue: 150/255, alpha: 0.7)
            }
        
        
        
            
            let url = URL(string:"http://h2744356.stratoserver.net/shigui/Shigui/public/index.php/users/uploadImage.json")
            let parameters: Parameters = [
                "picture": imagePath
            ]
            let headers: HTTPHeaders = [
                "Authorization": token!,
                
                ]
            let imageToUploadURL = Bundle.main.url(forResource: imagePath, withExtension: "jpg")
            
            //peticion = "RegisterRequest"
            
            //func miLlamada(url, parameters, tipo, peticion)
            
            
            Alamofire.upload(
                multipartFormData: { multipartFormData in
                    // On the PHP side you can retrive the image using $_FILES["image"]["tmp_name"]
                    // multipartFormData.append(imageToUploadURL!, withName: "image")
                    var dataImage = UIImageJPEGRepresentation(self.profileIMG.image!, 0.1)
                    if self.profileIMG != nil{
                        multipartFormData.append(dataImage!, withName: "image", fileName: "photo.jpeg", mimeType: "image/jpeg")
                    }
            },
                to: url!,
                headers: headers,
                
                
                encodingCompletion: { encodingResult in
                    
                    switch encodingResult {
                    case .success:
                        print("--ENCODINGRESULT---------------------------->")
                        print(encodingResult)
                        print("------------------------------>")
                       
                        
                        
                        //                        print("La peticion ha ido bien")
                        //                        let json = encodingResult.value as! Dictionary<String, Any>
                        //                        let myCode = json["code"] as! Int
                        //                        print(json)
                        
                        
                    case .failure:
                        print("La peticion no ha funcionado")
                    }
                    
            }
                
                
                
            )
        
        
        
        
        
        }
        else{
        
        
           
       
       
        let alertUserExist = CDAlertView(title: "emptyUser".localized(), message: "".localized(), type: .warning)
        let veryverydoneAction = CDAlertViewAction(title: "ok".localized())
        
        alertUserExist .isHeaderIconFilled = true
        alertUserExist .circleFillColor = UIColor(red: 56/255, green: 151/255, blue: 217/255, alpha: 1)
        alertUserExist .add(action: veryverydoneAction)
        alertUserExist.show()
        }
        
        let alert = CDAlertView(title: "successChanges".localized(), message: "", type: .success)
        let doneAction = CDAlertViewAction(title: "ok".localized())
        
        alert.isHeaderIconFilled = true
        alert.circleFillColor = UIColor(red: 56/255, green: 151/255, blue: 217/255, alpha: 1)
        alert.add(action: doneAction)
        
        
        
        
        alert.show()
       
        
    }
    
    @IBAction func editUserName(_ sender: Any) {
        saveChangesBTN.isEnabled = true
        saveChangesBTN.backgroundColor = UIColor(red: 231/255, green: 76/255, blue: 60/255, alpha: 1)
        
        
        
        nameTXF.backgroundColor = UIColor.white
        nameTXF.textColor = UIColor.black
        nameTXF.isEnabled = true
       
        
        
    }
    
    
    @IBAction func changePhoto(_ sender: Any) {
        saveChangesBTN.isEnabled = true
        saveChangesBTN.backgroundColor = UIColor(red: 231/255, green: 76/255, blue: 60/255, alpha: 1)
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
            
        }
        
        
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        profileIMG.image = image
       
        dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    func getUser(){
        
        let url = URL(string:"http://h2744356.stratoserver.net/shigui/Shigui/public/index.php/users/user.json")
        
        let headers: HTTPHeaders = [
            "Authorization": token!
        ]
        
        //peticion = "RegisterRequest"
        
        //func miLlamada(url, parameters, tipo, peticion)
        
        Alamofire.request(url!,method: .get, headers: headers).responseJSON{ response in
            
            switch response.result {
            case .success:
                
                
                print("La peticion ha ido bien")
                let json = response.result.value as! Dictionary<String, Any>
                let myCode = json["code"] as! Int
                switch myCode {
                case 200:
                  
                    print(json["data"])
                    datas = json["data"]  as! Dictionary<String, Any>
                    
                    self.updateText()
                    
                    // datas = json["data"] as! Array<Any>.Type
                    //  print(datas)
                    
                    //self.dataReceived = json["name"] as! String
                    
                    
                    
                    
                    // showAlert(json["message"])
                    // Accion de login -> Guardar en defaults -> Controller
                    // case 400:
                //     print("Han habido error")
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
    
    
    func existsImage(image: String){
        if let documentsDIrectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first{
            let imageUrl = image
            let file_name = URL(fileURLWithPath: imageUrl).lastPathComponent
            print(file_name)
            let savePath = ("\(documentsDIrectory)/\(file_name)")
            profileIMG.image = UIImage(named: savePath)
            
            if profileIMG.image == nil {
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
                            self.profileIMG.image = imageDown
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

