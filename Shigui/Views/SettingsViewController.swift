//
//  SettingsViewController.swift
//  Shigui
//
//  Created by alumnos on 22/1/18.
//  Copyright © 2018 cev. All rights reserved.
//

import UIKit
import Localize_Swift
import CDAlertView


class SettingsViewController:UIViewController,UIPickerViewDelegate,UIPickerViewDataSource  {
   
    
    @IBOutlet weak var languageLbl: UILabel!
    
    @IBOutlet weak var countryPicker: UIPickerView!
 
    @IBOutlet weak var saveBtn: UIButton!
    
    @IBOutlet weak var settingsLbl: UILabel!
    var countries: [String] = [String]()
    var array = ["1","2","3","4","5","6"]
    var languages:[String] = [String]()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        countryPicker.tintColor = UIColor.white
         languages = Localize.availableLanguages()
        
       
        
        countries = getCountries()
        
        settingsLbl.text! = "SETTINGS".localized()
        languageLbl.text! = "language".localized()
        
        //countries = array
       
        
        if (getDataInUserDefaults(key: "userCountry") != nil){
            print(getDataInUserDefaults(key: "userCountry")!)
            let countryIndex = countries.index(of: getDataInUserDefaults(key: "userCountry")!)
            
            
            countryPicker.selectRow(countryIndex!, inComponent: 0, animated: false)
        }
       
        // Do any additional setup after loading the view.
    }
    
    
    //MARK: - PICKER DATA
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return languages.count - 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return languages[row + 1].localized()
        
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print("He seleccionado \(languages[row + 1])")
        Localize.setCurrentLanguage(languages[row + 1])
        
        settingsLbl.text! = "SETTINGS".localized()
        languageLbl.text! = "language".localized()
        
        let alertDifferentPassTwo = CDAlertView(title: "languageModified".localized(), message: "", type: .success)
        let doneAction = CDAlertViewAction(title: "ok".localized())
        alertDifferentPassTwo.isHeaderIconFilled = true
        alertDifferentPassTwo.circleFillColor = UIColor(red: 56/255, green: 151/255, blue: 217/255, alpha: 1)
        alertDifferentPassTwo.add(action: doneAction)
        alertDifferentPassTwo.show()
        saveDataInUserDefaults(value: languages[row + 1] , key: "language")
        
    }
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        
        
        return NSAttributedString(string: languages[row + 1], attributes: [NSAttributedStringKey.foregroundColor: UIColor.white, NSAttributedStringKey.font: UIFont(name: "Papyrus", size: 40.0)])
    }
   /* func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView!) -> UIView {
        
        var pickerLabel = view as? UILabel;
        
        if (pickerLabel == nil)
        {
            pickerLabel = UILabel()
            
            pickerLabel?.font = UIFont(name: "Montserrat", size: 16)
            pickerLabel?.textAlignment = NSTextAlignment.center
        }
        
        pickerLabel?.text = fetchLabelForRowNumber(row)
        
        return pickerLabel!;
    }*/
    
   
    
    
    

  
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
    
    
    
    
    
    @IBAction func homeScreen(_ sender: Any) {
        
        switch (sender as AnyObject).tag {
            
            case 8:
                
                dismiss(animated: true, completion: nil)
            
            default:
                break
        }

        func didReceiveMemoryWarning() {
            
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
}
