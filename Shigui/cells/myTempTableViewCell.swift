//
//  myTempTableViewCell.swift
//  Shigui
//
//  Created by alumnos on 1/3/18.
//  Copyright © 2018 cev. All rights reserved.
//

import UIKit
import Alamofire
import CDAlertView

class myTempTableViewCell: UITableViewCell {
    @IBOutlet weak var trashBtn: UIButton!
    
    @IBOutlet weak var comentaryUser: UILabel!
    @IBOutlet weak var comentaryLbl: UILabel!
    @IBOutlet weak var placeLbl: UILabel!
    @IBOutlet weak var five: UIImageView!
    @IBOutlet weak var four: UIImageView!
    @IBOutlet weak var three: UIImageView!
    @IBOutlet weak var two: UIImageView!
    @IBOutlet weak var valuationIMG: UIImageView!
    @IBOutlet weak var one: UIImageView!
    
    var commentIndexPath:Int = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        comentaryLbl.text = "comentary".localized()
        self.borderWidth = 2
        let color = UIColor.lightGray
        // Initialization code
        self.layer.borderWidth = 1
        self.clipsToBounds = true
        self.layer.borderColor = color.cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        

        // Configure the view for the selected state
    }
    @IBAction func deleteComentary(_ sender: Any) {
        indexComment = commentIndexPath
        print("Mi indexPAth es \(commentIndexPath)")
        NotificationCenter.default.post(name: Notification.Name("NotificationDeleteComment"), object: nil)
    }
   
    
}
