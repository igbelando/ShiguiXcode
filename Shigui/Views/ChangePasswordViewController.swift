//
//  ChangePasswordViewController.swift
//  Shigui
//
//  Created by alumnos on 24/1/18.
//  Copyright © 2018 cev. All rights reserved.
//

import UIKit
import CDAlertView
import Alamofire

class ChangePasswordViewController: UIViewController {
    @IBOutlet weak var passwordTxf: UITextField!
    @IBOutlet weak var passwordLbl: UILabel!
    @IBOutlet weak var repeatPasswordTxf: UITextField!
    @IBOutlet weak var backBTN: UIButton!
    @IBOutlet weak var saveBTN: UIButton!
    let shighuiColor = UIColor(red: 56/255, green: 151/255, blue: 217/255, alpha: 1)
    var dataReceived: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateTexts()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(RegisterViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        passwordTxf.keyboardAppearance = .dark
        repeatPasswordTxf.keyboardAppearance = .dark
        
        
        // Do any additional setup after loading the view.
    }
    
    @objc func dismissKeyboard() {
        //Las vistas y toda la jerarquía renuncia a responder, para esconder el teclado
        view.endEditing(true)
    }
    
    @IBAction func changeScreen(_ sender: Any) {
        
         dismiss(animated: true, completion: nil)
       
    }
    
    @IBAction func saveNewPassword(_ sender: Any) {
        
        if (passwordTxf!.text == "" || repeatPasswordTxf.text! == "") {
            let alert = CDAlertView(title: "empty".localized(), message: "".localized(), type: .warning)
            let doneAction = CDAlertViewAction(title: "ok".localized())
            alert.isHeaderIconFilled = true
            alert.circleFillColor = UIColor(red: 231/255, green: 76/255, blue: 60/255, alpha: 1)
            alert.add(action: doneAction)
            alert.show()
            
        }else{
            if(passwordTxf.text! == repeatPasswordTxf.text!){
              
                let url = URL(string:"http://h2744356.stratoserver.net/shigui/Shigui/public/index.php/users/changePassword.json")
                
                let parameters: Parameters = [
                    "password": passwordTxf.text!
                ]
                let headers: HTTPHeaders = [
                    "Authorization": getDataInUserDefaults(key: "token")!
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
                                let customAction = CDAlertViewAction(title: "ok".localized(), font: .systemFont(ofSize: 16) , textColor: .white , backgroundColor: UIColor(red: 56/255, green: 151/255, blue: 217/255, alpha: 1) , handler: {action in
                                    self.welcome()
                                })
                                
                                alert.isHeaderIconFilled = true
                                alert.circleFillColor = UIColor(red: 56/255, green: 151/255, blue: 217/255, alpha: 1)
                                alert.add(action: customAction)
                                alert.show()
                            
                                // showAlert(json["message"])
                                // Accion de login -> Guardar en defaults -> Controller
                                // case 400:
                                // print("Han habido error")
                            default:
                                
                                let alert = CDAlertView(title: "ERROR", message: "failServer".localized(), type: .warning)
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
            
                    if(passwordTxf.text! != repeatPasswordTxf.text!){
                        print("No has puesto la contraseña igual")
                        let alertDifferentPass = CDAlertView(title: "caution".localized(), message: "pass fail".localized(), type: .warning)
                        let doneAction = CDAlertViewAction(title: "ok".localized())
                        alertDifferentPass.isHeaderIconFilled = true
                        alertDifferentPass.circleFillColor = UIColor(red: 231/255, green: 76/255, blue: 60/255, alpha: 1)
                        alertDifferentPass.add(action: doneAction)
                        alertDifferentPass.show()
                    }
                    else if (passwordTxf.text!.count <= 6){
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
        }
    
    func welcome(){
        self.dismiss(animated: true, completion: nil)
    }

    func updateTexts(){
    
        passwordLbl.text = "passLBL".localized()
        passwordTxf.placeholder = "insertPassword".localized()
        repeatPasswordTxf.placeholder = "repeatPassword".localized()
        
        saveBTN.setTitle("changeBTN".localized(), for: .normal)
        backBTN.setTitle("back".localized(), for: .normal)
        saveBTN.layer.cornerRadius = 10
        backBTN.layer.cornerRadius = 12
        passwordTxf.attributedPlaceholder = NSAttributedString(string: "insertPassword".localized(), attributes: [NSAttributedStringKey.foregroundColor: UIColor.lightGray])

        repeatPasswordTxf.attributedPlaceholder = NSAttributedString(string: "repeatPassword".localized(), attributes: [NSAttributedStringKey.foregroundColor: UIColor.lightGray])
        saveBTN.layer.borderWidth = 2
        saveBTN.layer.borderColor = shighuiColor.cgColor
        repeatPasswordTxf.roundedTxf()
        passwordTxf.roundedTxf()
        passwordTxf.autocorrectionType = .no
        repeatPasswordTxf.autocorrectionType = .no
        
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
