//
//  RegisterViewController.swift
//  Shigui
//
//  Created by alumnos on 10/1/18.
//  Copyright © 2018 cev. All rights reserved.
//

import UIKit
import Localize_Swift
import Alamofire
import CDAlertView

extension UIButton{
    func rounded(){
        self.layer.cornerRadius = self.frame.width/10
    }
}
extension UITextField{
    func roundedTxf(){
        let shighuiColor = UIColor(red: 56/255, green: 151/255, blue: 217/255, alpha: 1)
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
        self.layer.borderColor = shighuiColor.cgColor
        self.layer.borderWidth = 2
        self.textColor = .white
        
        //self.borderStyle = UITextBorderStyle.roundedRect
        //self.heightAnchor.
    }
}
extension UITextView{
    func roundedTxv(){
        self.layer.cornerRadius = 20
        self.clipsToBounds = true
    }
}

class RegisterViewController: UIViewController {
    let url = ""

    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var emailTxf: UITextField!
    @IBOutlet weak var repeatPasswordTxf: UITextField!
    @IBOutlet weak var passwordTxf: UITextField!
    @IBOutlet weak var nameTxf: UITextField!
    @IBOutlet weak var doneBtn: UIButton!
  
    override func viewDidLoad() {
        
        super.viewDidLoad()
        updateTexts()
        cancelButton.rounded()
        doneBtn.rounded()
        emailTxf.roundedTxf()
        passwordTxf.roundedTxf()
        nameTxf.roundedTxf()
        repeatPasswordTxf.roundedTxf()
        emailTxf.keyboardAppearance = .dark
        nameTxf.keyboardAppearance = .dark
        passwordTxf.keyboardAppearance = .dark
        repeatPasswordTxf.keyboardAppearance = .dark
         let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(RegisterViewController.dismissKeyboard))
     view.addGestureRecognizer(tap)
        // Do any additional setup after loading the view.
    }
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func goToApp(_ sender: Any) {
        
        if(nameTxf.text == "" || passwordTxf.text == "" || repeatPasswordTxf.text == "" || emailTxf.text == "" ){
            print("Faltan campos por rellenar")
          
            let alert = CDAlertView(title: "caution".localized(), message: "empty".localized(), type: .warning)
            let doneAction = CDAlertViewAction(title: "ok".localized())
            alert.isHeaderIconFilled = true
            alert.circleFillColor = UIColor(red: 231/255, green: 76/255, blue: 60/255, alpha: 1)
            alert.add(action: doneAction)
            alert.show()
        }
            else{
                if isValidEmail(YourEMailAddress: emailTxf.text!) {
                    print("ES VALIDO")
                
                    if(passwordTxf.text == repeatPasswordTxf.text){
                        print("Contraseñas iguales")
                        
                        if (passwordTxf.text!.count >= 6 && passwordTxf.text!.count <= 12){
                    
                        let url = URL(string:"http://h2744356.stratoserver.net/shigui/Shigui/public/index.php/users/create.json")
                        let parameters: Parameters = [
                            "name": nameTxf.text!,
                            "password":passwordTxf.text!,
                            "email": emailTxf.text!
                        ]
                    
                    //peticion = "RegisterRequest"
                    //func miLlamada(url, parameters, tipo, peticion)
                
                    Alamofire.request(url!, method: .post, parameters: parameters).responseJSON{ response in
                        
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
                                print("Registo")
                                saveDataInUserDefaults(value: "true", key: "isLogged")
                                print("DATA :: \(json["data"])")
                                token = json["data"] as! String?
                                saveDataInUserDefaults(value: token!, key: "token")
                                let alert = CDAlertView(title: "success".localized(), message:"", type: .success) 
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
                            //     print("Han habido error")
                            default:
                                
                                let alert = CDAlertView(title: "userExist".localized(), message: "", type: .warning)
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
            } else {
                    
                print("email no  VALIDO")
                let alertEmail = CDAlertView(title: "caution".localized(), message: "email fail".localized(), type: .warning)
                let doneAction = CDAlertViewAction(title: "ok".localized())
                alertEmail.isHeaderIconFilled = true
                alertEmail.circleFillColor = UIColor(red: 231/255, green: 76/255, blue: 60/255, alpha: 1)
                alertEmail.add(action: doneAction)
                alertEmail.show()
            }
        }
        //self.dismiss(animated: true, completion: nil)
    }
    //Cambiar de vista a welcome, despues de la alerta
    
    func welcome(){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "WelcomeViewController") as! WelcomeViewController
        self.present(vc, animated: true, completion: nil)
        //Descomentar, si el tap no debe interferir o cancelar otras acciones
        //tap.cancelsTouchesInView = false
        
    }
    @objc func dismissKeyboard() {
        //Las vistas y toda la jerarquía renuncia a responder, para esconder el teclado
        view.endEditing(true)
    }
    
    func updateTexts(){
        
        let shighuiColor = UIColor(red: 56/255, green: 151/255, blue: 217/255, alpha: 1)
        doneBtn.setTitle("register".localized(), for: .normal)
        cancelButton.setTitle("back".localized(), for: .normal)
        doneBtn.layer.cornerRadius = 8
        cancelButton.layer.cornerRadius = 12
        doneBtn.layer.borderWidth = 2
        doneBtn.layer.borderColor = shighuiColor.cgColor
        nameTxf.attributedPlaceholder = NSAttributedString(string: "insertUser".localized(), attributes: [NSAttributedStringKey.foregroundColor: UIColor.lightGray])
        passwordTxf.attributedPlaceholder = NSAttributedString(string: "insertPassword".localized(), attributes: [NSAttributedStringKey.foregroundColor: UIColor.lightGray])
        emailTxf.attributedPlaceholder = NSAttributedString(string: "insertEmail".localized(), attributes: [NSAttributedStringKey.foregroundColor: UIColor.lightGray])
        repeatPasswordTxf.attributedPlaceholder = NSAttributedString(string: "repeatPassword".localized(), attributes: [NSAttributedStringKey.foregroundColor: UIColor.lightGray])
        
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
