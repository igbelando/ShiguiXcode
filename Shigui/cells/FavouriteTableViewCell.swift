//
//  FavouriteTableViewCell.swift
//  Shigui
//
//  Created by alumnos on 2/3/18.
//  Copyright © 2018 cev. All rights reserved.
//

import UIKit

class FavouriteTableViewCell: UITableViewCell {
     var valuationIndexPath:Int = 0

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let color = UIColor.lightGray
        // Initialization code
        self.layer.borderWidth = 0.3
        self.clipsToBounds = true
        self.layer.borderColor = color.cgColor
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func deleteComentary(_ sender: Any) {
        indexComment = valuationIndexPath
        print("Mi indexPAth es \(valuationIndexPath)")
        NotificationCenter.default.post(name: Notification.Name("NotificationDeleteFavorite"), object: nil)
    }
   
    
    

}
