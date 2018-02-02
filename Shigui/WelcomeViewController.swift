//
//  MainViewController.swift
//  Shigui
//
//  Created by alumnos on 17/1/18.
//  Copyright © 2018 cev. All rights reserved.
//

import UIKit
import Alamofire
import CDAlertView
import AlamofireImage


class WelcomeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
    @IBOutlet weak var goHomeBTN: UIButton!
    
    @IBOutlet weak var profileIMG: UIImageView!
    var dataReceived = ""
    var imagePath = ""
    var isEditingPhoto = false
    
    
    
    @IBOutlet weak var nameLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getUser()
   
        
        print("datareceived: \(dataReceived)")
        

        // Do any additional setup after loading the view.
    }

    func updateText(){
        goHomeBTN.setTitle("GO!".localized(), for: .normal)
        //nameLbl.text = dataReceived
    
        print("MY NAME IS :::: \(datas["name"]  as! String)")
       nameLbl.text = datas["name"]  as! String
        if (  datas["picture"] as! String != ""){
      existsImage(image: datas["picture"] as! String)
        }

        
    }
    
    
    @IBAction func goToHome(_ sender: Any) {
        
        
        
        
                print("------------------------------>")
                print("token: " + token!)
                print(imagePath)
                
                print("<-----------------------------")
                
                
                
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
                            let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
                         
                            self.present(vc, animated: true, completion: nil)
                        
                        
//                        print("La peticion ha ido bien")
//                        let json = encodingResult.value as! Dictionary<String, Any>
//                        let myCode = json["code"] as! Int
//                        print(json)
                        
                        
                    case .failure:
                        print("La peticion no ha funcionado")
                    }
                    
                    }
                
                

    )}
                
                
        
    
    @IBAction func changePhoto(_ sender: Any) {
        isEditingPhoto = true
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
        
        let fileManager = FileManager.default
        
         imagePath = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent("myjpg.jpg")
        print("imagepath: \(imagePath)")
        
        fileManager.createFile(atPath: imagePath as String, contents: UIImageJPEGRepresentation(profileIMG.image!, 1.0))
    }
        
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func getUser(){
        
        let url = URL(string:"http://h2744356.stratoserver.net/shigui/Shigui/public/index.php/users/user.json")
        
        let headers: HTTPHeaders = [
            "Authorization": token!,
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
                    print("algo")
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

