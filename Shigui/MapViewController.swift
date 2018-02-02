//
//  MapViewController.swift
//  Shigui
//
//  Created by alumnos on 24/1/18.
//  Copyright © 2018 cev. All rights reserved.
//

import UIKit

class MapViewController: UIViewController {

    @IBOutlet weak var myImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        existsImage( image: "http://h2744356.stratoserver.net/shigui/Shigui/public/assets/img/ce9cf504a8b1f8d092a4c5264873ec2f.jpg")

        // Do any additional setup after loading the view.
    }
    @IBAction func homeScreen(_ sender: Any) {
        
        switch (sender as AnyObject).tag {
            
            
        case 8:
            
            dismiss(animated: true, completion: nil)
            
        default:
            break
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
        
        func existsImage(image: String){
            if let documentsDIrectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first{
                let imageUrl = image
                let file_name = URL(fileURLWithPath: imageUrl).lastPathComponent
                print(file_name)
                let savePath = ("\(documentsDIrectory)/\(file_name)")
                myImage.image = UIImage(named: savePath)
                
                if myImage.image == nil {
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
                                self.myImage.image = imageDown
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
}
