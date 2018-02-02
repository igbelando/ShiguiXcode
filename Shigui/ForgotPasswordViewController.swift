//
//  ForgotPasswordViewController.swift
//  Shigui
//
//  Created by alumnos on 18/1/18.
//  Copyright © 2018 cev. All rights reserved.
//

import UIKit

import Localize_Swift
import Alamofire
import CDAlertView

class ForgotPasswordViewController: UIViewController {

    @IBOutlet weak var emailIMG: UIImageView!
    @IBOutlet weak var repeatPassIMG: UIImageView!
    @IBOutlet weak var passIMG: UIImageView!
    @IBOutlet weak var backBTN: UIButton!
    @IBOutlet weak var okPasswordLbl: UILabel!
    @IBOutlet weak var okEmailLbl: UILabel!
    @IBOutlet weak var passwordBtn: UIButton!
    @IBOutlet weak var emailBtn: UIButton!
    @IBOutlet weak var repeatPasswordTxf: UITextField!
    @IBOutlet weak var passwordTxf: UITextField!
    @IBOutlet weak var rememberEmailTxf: UITextField!
    var token = ""
    override func viewDidLoad() {
        
        super.viewDidLoad()
        updateTexts()
        
        passwordTxf.isHidden = true
        repeatPasswordTxf.isHidden = true
        passwordBtn.isHidden = true
        okPasswordLbl.isHidden = true
        passIMG.isHidden = true
        repeatPassIMG.isHidden = true

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func updateTexts(){
        
        
       
        okEmailLbl.text = "email".localized()
        okPasswordLbl.text = "password".localized()
        passwordTxf.placeholder = "insertPassword".localized()
        
        repeatPasswordTxf.placeholder = "repeatPassword".localized()
        
        rememberEmailTxf.placeholder = "insertEmail".localized()
     

        passwordBtn.setTitle("changePassword".localized(), for: .normal)
        emailBtn.setTitle("ok".localized(), for: .normal)
        backBTN.setTitle("back".localized(), for: .normal)
        
     
        emailBtn.rounded()
        passwordBtn.rounded()
        
        backBTN.layer.cornerRadius = 10
        
    }
    @IBAction func backl(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func validateEmail(_ sender: Any) {
        
      
     
        if (rememberEmailTxf.text! == "") {
            let alert = CDAlertView(title: "cautionForgot".localized(), message: "".localized(), type: .warning)
            let doneAction = CDAlertViewAction(title: "ok".localized())
            alert.isHeaderIconFilled = true
            alert.circleFillColor = UIColor(red: 231/255, green: 76/255, blue: 60/255, alpha: 1)
            alert.add(action: doneAction)
            
            
            alert.show()
            
           
        }else {
            if(isValidEmail(YourEMailAddress: rememberEmailTxf.text!)){
                
                let url = "http://h2744356.stratoserver.net/shigui/Shigui/public/index.php/users/recoveryPassword.json"
                
                let parameters: Parameters = [
                    "email": rememberEmailTxf.text!
                ]
                
              
                
                //peticion = "RegisterRequest"
                
                //func miLlamada(url, parameters, tipo, peticion)
                
                
                 Alamofire.request(url, method: .post, parameters: parameters).responseJSON{ response in
                    
                    switch response.result {
                    case .success:
                        
                        
                        print("La peticion ha ido bien")
                        let json = response.result.value as! Dictionary<String, Any>
                        let myCode = json["code"] as! Int
                        switch myCode {
                        case 200:
                          
                            
                            
                            let alert = CDAlertView(title: "verifiedEmail".localized(), message: "", type: .success)
                            let doneAction = CDAlertViewAction(title: "ok".localized())
                            
                            alert.isHeaderIconFilled = true
                            alert.circleFillColor = UIColor(red: 56/255, green: 151/255, blue: 217/255, alpha: 1)
                            alert.add(action: doneAction)
                            self.token = (json["data"] as! String?)!
                            
                            print("token: " + self.token)
                            
                            alert.show()
                            self.passwordTxf.isHidden = false
                            self.repeatPasswordTxf.isHidden = false
                            self.passwordBtn.isHidden = false
                            self.okPasswordLbl.isHidden = false
                            self.passIMG.isHidden = false
                            self.repeatPassIMG.isHidden = false
                            self.emailIMG.isHidden = true
                            self.emailBtn.isHidden = true
                            self.okEmailLbl.isHidden = true
                            self.rememberEmailTxf.isHidden = true
                            
                            
                           
                            // showAlert(json["message"])
                            // Accion de login -> Guardar en defaults -> Controller
                            // case 400:
                        //     print("Han habido error")
                        default:
                            
                            let alert = CDAlertView(title: "Error", message: "emailNotExist".localized(), type: .warning)
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
                
                
            } else {
                let alertEmail = CDAlertView(title: "caution".localized(), message: "email fail".localized(), type: .warning)
                let doneAction = CDAlertViewAction(title: "ok".localized())
                alertEmail.isHeaderIconFilled = true
                alertEmail.circleFillColor = UIColor(red: 231/255, green: 76/255, blue: 60/255, alpha: 1)
                alertEmail.add(action: doneAction)
                
                
                alertEmail.show()
               
            }
            
        }
        
        
    }
    

    @IBAction func changePassword(_ sender: Any) {
        if (passwordTxf!.text == "" || repeatPasswordTxf.text! == "") {
            let alert = CDAlertView(title: "empty".localized(), message: "".localized(), type: .warning)
            let doneAction = CDAlertViewAction(title: "ok".localized())
            alert.isHeaderIconFilled = true
            alert.circleFillColor = UIColor(red: 231/255, green: 76/255, blue: 60/255, alpha: 1)
            alert.add(action: doneAction)
            
            
            alert.show()
            
            
        }else {
        
        
        if(passwordTxf.text! == repeatPasswordTxf.text!){
            print("Contraseñas iguales")
            if (passwordTxf.text!.count >= 6 && passwordTxf.text!.count <= 12){
                let url = URL(string:"http://h2744356.stratoserver.net/shigui/Shigui/public/index.php/users/changePassword.json")
                let parameters: Parameters = [
                    
                    
                    "password": passwordTxf.text!
                ]
                let headers: HTTPHeaders = [
                    "Authorization": token
                ]
                
                
                //peticion = "RegisterRequest"
                
                //func miLlamada(url, parameters, tipo, peticion)
                
                Alamofire.request(url!,method: .post, parameters: parameters,  headers: headers).responseJSON{ response in
                    print("(--------------------------")
                    print("Request        :: \(response.request)")
                    print("Request Result :: \(response.result)")
                    print("Request Value  :: \(response.result.value)")
                    print("Request StatusCode :: \(response.response?.statusCode)")
                    
                    switch response.result {
                    case .success:
                        
                        
                        print("La peticion ha ido bien")
                        let json = response.result.value as! Dictionary<String, Any>
                        let myCode = json["code"] as! Int
                        switch myCode {
                        case 200:
                            
                            
                            let alert = CDAlertView(title: "successPassword".localized(), message: "", type: .success)
                            let doneAction = CDAlertViewAction(title: "ok".localized())
                            
                            alert.isHeaderIconFilled = true
                            alert.circleFillColor = UIColor(red: 56/255, green: 151/255, blue: 217/255, alpha: 1)
                            alert.add(action: doneAction)
                            
                            
                            alert.show()
                            
                            
                            self.dismiss(animated: true, completion: nil)
                            // showAlert(json["message"])
                            // Accion de login -> Guardar en defaults -> Controller
                            // case 400:
                        //     print("Han habido error")
                        default:
                            
                            let alert = CDAlertView(title: "Error", message: "emailNotExist".localized(), type: .warning)
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
                if (passwordTxf.text!.count <= 6){
                    print("contraseña corta")
                    let alertDifferentPass = CDAlertView(title: "caution".localized(), message: "pass short".localized(), type: .warning)
                    let doneAction = CDAlertViewAction(title: "ok".localized())
                    alertDifferentPass.isHeaderIconFilled = true
                    alertDifferentPass.circleFillColor = UIColor(red: 231/255, green: 76/255, blue: 60/255, alpha: 1)
                    alertDifferentPass.add(action: doneAction)
                    alertDifferentPass.show()
                }
                else{
                    print("contraseña larga")
                    let alertDifferentPassTwo = CDAlertView(title: "caution".localized(), message: "pass long".localized(), type: .warning)
                    let doneAction = CDAlertViewAction(title: "ok".localized())
                    alertDifferentPassTwo.isHeaderIconFilled = true
                    alertDifferentPassTwo.circleFillColor = UIColor(red: 231/255, green: 76/255, blue: 60/255, alpha: 1)
                    alertDifferentPassTwo.add(action: doneAction)
                    alertDifferentPassTwo.show()
                    
                }
            }
            
            
        }
        else{
            print("No has puesto la contraseña igual")
            let alertDifferentPass = CDAlertView(title: "caution".localized(), message: "pass fail".localized(), type: .warning)
            let doneAction = CDAlertViewAction(title: "ok".localized())
            alertDifferentPass.isHeaderIconFilled = true
            alertDifferentPass.circleFillColor = UIColor(red: 231/255, green: 76/255, blue: 60/255, alpha: 1)
            alertDifferentPass.add(action: doneAction)
            alertDifferentPass.show()
            
        
            
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
