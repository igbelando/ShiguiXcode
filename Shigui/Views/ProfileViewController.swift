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

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITableViewDataSource, UITableViewDelegate  {

    @IBOutlet weak var myTableView: UITableView!
    @IBOutlet weak var logOutButton: UIButton!
   
    @IBOutlet weak var editPhotoBTN: UIButton!
    @IBOutlet weak var homeBTN: UIButton!
    @IBOutlet weak var changePasswordBTN: UIButton!
    @IBOutlet weak var saveChangesBTN: UIButton!
    @IBOutlet weak var editUserBTN: UIButton!
    @IBOutlet weak var editEmailBTN: UIButton!

    @IBOutlet weak var comentaryLbl: UILabel!
    @IBOutlet weak var profileIMG: UIImageView!
    @IBOutlet weak var commentImg: UIImageView!
    @IBOutlet weak var commentNameLbl: UITextField!
    @IBOutlet weak var nameTXF: UITextField!
    @IBOutlet weak var emailTXF: UITextField!
    var datasFavorite: Array<Any> = []
    var imagePath = ""
    var dataReceivedProfile: String?
    
     let shighuiColor = UIColor(red: 56/255, green: 151/255, blue: 217/255, alpha: 1)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getUser()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(RegisterViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        nameTXF.keyboardAppearance = .dark
        emailTXF.keyboardAppearance = .dark
        getValuations()
        comentaryLbl.text = "coment".localized()
        myTableView.backgroundColor = UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0)
        
        //MARK:-  Notification
        NotificationCenter.default.addObserver(self, selector: #selector(self.deleteComment(_:)), name: Notification.Name("NotificationDeleteComment"), object: nil)
        
        // Do any additional setup after loading the view.
    }
    override func awakeFromNib() {
        getValuations()
        getUser()
    }
    
    @objc func deleteComment(_ notification: Notification){
        
        print("Borro el Comentario con Index \(indexComment)")
        // Añadir endpoint
        let d = datasFavorite[indexComment] as! Dictionary<String, Any>
        
        print(d["id_place"]!)
        let usa = d["id_place"]! as! String
        print(usa)
        borrarComent(id_placemt: usa)
    }
    
    func borrarComent(id_placemt:Any)
    {
        
        let url = URL(string:"http://h2744356.stratoserver.net/shigui/Shigui/public/index.php/valuations/delete.json")
        let parameters: Parameters = [
            
            "id": id_placemt
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
                    let alertDifferentPassTwo = CDAlertView(title: "valuationDelete".localized(), message: "", type: .success)
                    let doneAction = CDAlertViewAction(title: "ok".localized())
                    alertDifferentPassTwo.isHeaderIconFilled = true
                    alertDifferentPassTwo.circleFillColor = UIColor(red: 56/255, green: 151/255, blue: 217/255, alpha: 1)
                    alertDifferentPassTwo.add(action: doneAction)
                    alertDifferentPassTwo.show()
                    self.getValuations()
                    
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
    
    @objc func dismissKeyboard() {
        //Las vistas y toda la jerarquía renuncia a responder, para esconder el teclado
        view.endEditing(true)
    }
    
    func updateText()  {
        
        //profileLabel.text = "PROFILE".localized()
    
        saveChangesBTN.setTitle("SAVE".localized(), for: .normal)
        changePasswordBTN.setTitle("CHANGE PASSWORD".localized(), for: .normal)
        
       // changePasswordBTN.rounded()
        nameTXF.isEnabled = false
        nameTXF.text = datas["name"]  as! String
        
        emailTXF.text = datas["email"]  as! String
        changePasswordBTN.layer.borderColor = shighuiColor.cgColor
        logOutButton.layer.borderColor = shighuiColor.cgColor
        saveChangesBTN.isEnabled = false
        saveChangesBTN.backgroundColor = UIColor(red: 161/255, green: 157/255, blue: 150/255, alpha: 0.7)
        existsImageTools(image: datas["picture"] as! String, view: profileIMG)

        logOutButton.setTitle("logout".localized(), for: .normal)
        emailTXF.backgroundColor = UIColor(red: 56/255, green: 151/255, blue: 217/255, alpha: 0)
        emailTXF.textColor = UIColor.white
        emailTXF.isEnabled = false
       
    }
    
    @IBAction func changeScreen(_ sender: Any) {
        
        switch (sender as AnyObject).tag {
        case 7:
            
           dismiss(animated: true, completion: nil)
            
            break
            
            case 8:
                
                clearUserDefaults()
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
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
        
        if(nameTXF.text! != "" || emailTXF.text! != "" ){
            
                let url = URL(string:"http://h2744356.stratoserver.net/shigui/Shigui/public/index.php/users/modifyUser.json")
                let parameters: Parameters = [
                    "name": nameTXF.text!,
                    "email":emailTXF.text!
                ]
                let headers: HTTPHeaders = [
                    "Authorization":  getDataInUserDefaults(key: "token")!
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
                            self.emailTXF.backgroundColor = UIColor(red: 56/255, green: 151/255, blue: 217/255, alpha: 0)
                            self.emailTXF.textColor = UIColor.white
                            self.emailTXF.isEnabled = false
                            self.updatePicture()
                        
                        
                        
                        
                    // showAlert(json["message"])
                    // Accion de login -> Guardar en defaults -> Controller
                    // case 400:
                   //  print("Han habido error")
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
            }}
    
            
        else{
        
            let alertUserExist = CDAlertView(title: "emptyUser".localized(), message: "".localized(), type: .warning)
            let veryverydoneAction = CDAlertViewAction(title: "ok".localized())
            
            alertUserExist .isHeaderIconFilled = true
            alertUserExist .circleFillColor = UIColor(red: 56/255, green: 151/255, blue: 217/255, alpha: 1)
            alertUserExist .add(action: veryverydoneAction)
            alertUserExist.show()
        }
        
        
        
    }
    
    @IBAction func editUserName(_ sender: Any) {
        
        saveChangesBTN.isEnabled = true
        saveChangesBTN.backgroundColor = UIColor(red: 56/255, green: 151/255, blue: 217/255, alpha: 1)
        nameTXF.backgroundColor = UIColor.white
        nameTXF.textColor = UIColor.black
        nameTXF.isEnabled = true
        emailTXF.isEnabled = true
        emailTXF.backgroundColor = UIColor.white
        emailTXF.textColor = UIColor.black
    }
    
     func changePhoto() {
        
        saveChangesBTN.isEnabled = true
        saveChangesBTN.backgroundColor = UIColor(red: 56/255, green: 151/255, blue: 217/255, alpha: 1)
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
            
        }
    }
    func openCameraAction() {
        
        saveChangesBTN.isEnabled = true
        saveChangesBTN.backgroundColor = UIColor(red: 56/255, green: 151/255, blue: 217/255, alpha: 1)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        } else {
            print("NO HAY CÁMARA DISPONIBLE")
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
    func updatePicture(){
        
        let urlphoto = URL(string:"http://h2744356.stratoserver.net/shigui/Shigui/public/index.php/users/uploadImage.json")
        let parametersphoto: Parameters = [
            "picture": imagePath
        ]
        let headersphoto: HTTPHeaders = [
            "Authorization":  getDataInUserDefaults(key: "token")!
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
            
            to: urlphoto!,
            headers: headersphoto,
            encodingCompletion: { encodingResult in
                
                switch encodingResult {
                case .success:
                    print("--ENCODINGRESULT---------------------------->")
                    print(encodingResult)
                    print("------------------------------>")
                    existsImageTools(image: datas["picture"] as! String, view: self.profileIMG)
                    
                    
                    //                        print("La peticion ha ido bien")
                    //                        let json = encodingResult.value as! Dictionary<String, Any>
                    //                        let myCode = json["code"] as! Int
                    //                        print(json)
                    
                case .failure:
                    print("La peticion no ha funcionado")
                }
        }
        )
        let alert = CDAlertView(title: "successChanges".localized(), message: "", type: .success)
        let doneAction = CDAlertViewAction(title: "ok".localized())
        
        alert.isHeaderIconFilled = true
        alert.circleFillColor = UIColor(red: 56/255, green: 151/255, blue: 217/255, alpha: 1)
        alert.add(action: doneAction)
        alert.show()
        nameTXF.isEnabled = false
        nameTXF.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0)
        nameTXF.textColor = UIColor.white
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
    
    
    @IBAction  func camera(){
        
        let alert = CDAlertView(title: "".localized(), message:"library".localized(), type: .notification)
        let customAction = CDAlertViewAction(title: "Open camera", font: .systemFont(ofSize: 16) , textColor: .white , backgroundColor: UIColor(red: 56/255, green: 151/255, blue: 217/255, alpha: 1) , handler: {action in
            self.openCameraAction()
        })
        let customAction2 = CDAlertViewAction(title: "Open library", font: .systemFont(ofSize: 16) , textColor: .white , backgroundColor: UIColor(red: 56/255, green: 151/255, blue: 217/255, alpha: 1) , handler: {action in
            self.changePhoto()
        })
        
        alert.isHeaderIconFilled = true
        alert.circleFillColor = UIColor(red: 56/255, green: 151/255, blue: 217/255, alpha: 1)
        alert.add(action: customAction)
        alert.add(action: customAction2)
        alert.show()
    }
    
    func getValuations()  {
        let url = URL(string:"http://h2744356.stratoserver.net/shigui/Shigui/public/index.php/valuations/userValuations.json")
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
                print(json)
                
                switch myCode {
                    case 200:
                        
                      
                        if (json["message"] as! String != "No hay valoraciones que mostrar")
                        {
                            self.datasFavorite =  json["data"] as! Array<Any>
                            print("-----------------------------> datasFavorite")
                            print(self.datasFavorite)
                            
                           
                        }
                        self.myTableView.reloadData()
                        self.myTableView.sizeToFit()
                    
                    
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as! myTempTableViewCell
        let item = datasFavorite[indexPath.row] as! Dictionary<String, Any>
        
        
        if (!item.isEmpty)
        {
            print("Iiiiiiiiiiiiiiiiiiiiiiitem")
            print(item["user"] as! String!)
            cell.placeLbl.text = item["place"] as! String!
            
            cell.comentaryUser.text = item["comentary"] as! String!
            existsImageTools(image: item["user_picture"] as! String!, view:  cell.valuationIMG)
            
            cell.commentIndexPath = indexPath.row
            
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}
