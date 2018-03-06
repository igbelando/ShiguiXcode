//
//  TempTableViewCell.swift
//  Shigui
//
//  Created by alumnos on 27/2/18.
//  Copyright © 2018 cev. All rights reserved.
//

import UIKit



class TempTableViewCell: UITableViewCell {
    
    
   @IBOutlet weak var backgroundImgView: UIImageView!
    
    @IBOutlet weak var one: UIImageView!
    
    @IBOutlet weak var two: UIImageView!
    @IBOutlet weak var four: UIImageView!
    
    @IBOutlet weak var five: UIImageView!
    @IBOutlet weak var three: UIImageView!
    @IBOutlet weak var user: UILabel!
    @IBOutlet weak var comentary: UILabel!
    @IBOutlet weak var value: UILabel!
    
    @IBOutlet weak var nameLBl: UILabel!
    @IBOutlet weak var comentaryLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        nameLBl.text = "name".localized()
        comentaryLbl.text = "comentary".localized()
        self.borderWidth = 2
        let color = UIColor.lightGray
        // Initialization code
        self.layer.borderWidth = 1
        self.clipsToBounds = true
        self.layer.borderColor = color.cgColor
        // Configure the view for the selected state
    }
    

/*
 // MARK: - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
 // Get the new view controller using segue.destinationViewController.
 // Pass the selected object to the new view controller.
 }*/
    
}

