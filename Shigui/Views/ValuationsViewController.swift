//
//  ValuationsViewController.swift
//  Shigui
//
//  Created by alumnos on 22/1/18.
//  Copyright © 2018 cev. All rights reserved.
//

import UIKit

class ValuationsViewController: UIViewController {

    @IBOutlet weak var homeBTN: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateText()
        // Do any additional setup after loading the view.
    }
    
    func updateText()  {
        
        homeBTN.setTitle("HOME".localized(), for: .normal)

    }
    
    @IBAction func homeScreen(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
        
    }
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
