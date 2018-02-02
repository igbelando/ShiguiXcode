//
//  myAppTools.swift
//  Shigui
//
//  Created by alumnos on 10/1/18.
//  Copyright © 2018 cev. All rights reserved.
//

import Foundation


let defaults = UserDefaults.standard
var userRegistered:[String:String] = [:]
var isUserRegistered:Bool?



func isValidEmail(YourEMailAddress: String) -> Bool {
    let REGEX: String
    REGEX = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
    return NSPredicate(format: "SELF MATCHES %@", REGEX).evaluate(with: YourEMailAddress)
}
var token: String?
var datas: [String:Any] = [:]


    
    

