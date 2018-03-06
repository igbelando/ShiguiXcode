//
//  MapTableViewCell.swift
//  Shigui
//
//  Created by alumnos on 2/3/18.
//  Copyright © 2018 cev. All rights reserved.
//

import UIKit

class MapTableViewCell: UITableViewCell {
    @IBOutlet weak var nameLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
      
        let color = UIColor.lightGray
        // Initialization code
        self.layer.borderWidth = 0.5
        self.clipsToBounds = true
        self.layer.borderColor = color.cgColor
        nameLbl.textColor = UIColor.white
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
