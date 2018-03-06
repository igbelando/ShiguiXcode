//
//  LoginViewController.swift
//  Shigui
//
//  Created by alumnos on 10/1/18.
//  Copyright © 2018 cev. All rights reserved.
//

import UIKit
import Localize_Swift
import Alamofire
import CDAlertView

class LoginViewController: UIViewController {

    @IBOutlet weak var guestBtn: UIButton!
    @IBOutlet weak var rememberPasswordBtn: UIButton!
    @IBOutlet weak var registerBtn: UIButton!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var passwordTxf: UITextField!

    @IBOutlet weak var usernameTxf: UITextField!
    let shighuiColor = UIColor(red: 56/255, green: 151/255, blue: 217/255, alpha: 1)
    override func viewDidLoad() {
        super.viewDidLoad()
        //Localize.setCurrentLanguage("es")
        
        print("username".localized())
       
        loginBtn.setTitle("login".localized(), for: .normal)
        rememberPasswordBtn.setTitle("rememberPassword".localized(), for: .normal)
        
        registerBtn.setTitle("register".localized(), for: .normal)
        registerBtn.rounded()
        loginBtn.rounded()
        usernameTxf.roundedTxf()
        passwordTxf.roundedTxf()
        loginBtn.layer.borderColor = shighuiColor.cgColor
        loginBtn.layer.borderWidth = 2
        registerBtn.layer.borderWidth = 2
        registerBtn.layer.borderColor = shighuiColor.cgColor
        usernameTxf.attributedPlaceholder = NSAttributedString(string: "insertUser".localized(), attributes: [NSAttributedStringKey.foregroundColor: UIColor.lightGray])
        passwordTxf.attributedPlaceholder = NSAttributedString(string: "insertPassword".localized(), attributes: [NSAttributedStringKey.foregroundColor: UIColor.lightGray])
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(RegisterViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        usernameTxf.keyboardAppearance = .dark
        passwordTxf.keyboardAppearance = .dark

        // Do any additional setup after loading the view.
    }
    @objc func dismissKeyboard() {
        //Las vistas y toda la jerarquía renuncia a responder, para esconder el teclado
        view.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if defaults.object(forKey: "userRegistered") != nil {
            print("USUARIO REGISTRADO")
            if getDataInUserDefaults(key: "isLogged") == "true"{
                 gotoMenu()
            }
        } else {
            print("USUARIO NO REGISTRADO")
        }
    }
    
    func gotoMenu(){
        
        print("LANZANDO AL MENU INICIAL")
        DispatchQueue.main.async {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    @IBAction func goToApp(_ sender: Any) {
        
        if(usernameTxf.text == "" || passwordTxf.text == ""){
            print("Faltan campos por rellenar")
            let alert = CDAlertView(title: "caution".localized(), message: "empty".localized(), type: .warning)
            let doneAction = CDAlertViewAction(title: "ok".localized())
            alert.isHeaderIconFilled = true
            alert.circleFillColor = UIColor(red: 231/255, green: 76/255, blue: 60/255, alpha: 1)
            alert.add(action: doneAction)
            alert.show()
        }
        else{
            
            let url = "http://h2744356.stratoserver.net/shigui/Shigui/public/index.php/users/login.json?name=" + usernameTxf.text! + "&password=" + passwordTxf.text!
            
           /* let parameters = [
                "name": usernameTxf.text,
                "password": passwordTxf.text
            ]*/
            //peticion = "RegisterRequest"
            //func miLlamada(url, parameters, tipo, peticion)
            
            Alamofire.request(url, method: .get).responseJSON{ response in
                
                print("(--------------------------")
                print("Request        :: \(response.request)")
                print("Request Result :: \(response.result)")
                print("Request Value  :: \(response.result.value)")
                print("Request StatusCode :: \(response.response?.statusCode)")
                print("url:" + url)

                switch response.result
                {
                case .success:
                    print("La peticion ha ido bien")

                    let json = response.result.value as! Dictionary<String, Any>
                    if   json["code"]  != nil {
                        
                        let myCode = json["code"] as! Int
                        print(json)
                        
                    switch myCode {
                        case 200:
                        
                            token = json["data"] as! String?
                            saveDataInUserDefaults(value: token!, key: "token")
                            let alert = CDAlertView(title: "successLogin".localized(), message: "".localized(), type: .success)
                            
                            let customAction = CDAlertViewAction(title: "ok".localized(), font: .systemFont(ofSize: 16) , textColor: .white , backgroundColor: UIColor(red: 56/255, green: 151/255, blue: 217/255, alpha: 1) , handler: {action in
                                saveDataInUserDefaults(value: "true", key: "isLogged")
                                
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
                            
                            let alert = CDAlertView(title: "caution".localized(), message: "failLogin".localized(), type: .warning)
                            let doneAction = CDAlertViewAction(title: "ok".localized())
                            alert.isHeaderIconFilled = true
                            alert.circleFillColor = UIColor(red: 231/255, green: 76/255, blue: 60/255, alpha: 1)
                            alert.add(action: doneAction)
                            alert.show()
                            print("default")
                    }
                }
                        
                 /*  let jsonReturn = [
                        "code": 200,
                        "data": [
                            "username":"EL nkmbre",
                            "token":"dsfbdksufhkufghdksjgjfgdsjk",
                            "rol":"premium"
                        ],
                        "message":"Loginn Correcto"
                    ]*/
                    
                case .failure:
                    print("La peticion no ha funcionado")
                }
            }
        }
    }
    
    func welcome(){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        
        print("token: " + token!)
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func goToRegister(_ sender: Any) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "RegisterViewController") as! RegisterViewController
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func goToForgotPassword(_ sender: Any) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ForgotPasswordViewController") as! ForgotPasswordViewController
        self.present(vc, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func guest(_ sender: Any) {
        
        let alert = CDAlertView(title: "Oops".localized(), message: "not available".localized(), type: .error)
        let doneAction = CDAlertViewAction(title: "ok".localized())
        alert.isHeaderIconFilled = true
        alert.circleFillColor = UIColor(red: 231/255, green: 76/255, blue: 60/255, alpha: 1)
        alert.add(action: doneAction)
        alert.show()
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
