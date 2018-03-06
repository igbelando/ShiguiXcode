//
//  SearchTableViewCell.swift
//  Shigui
//
//  Created by alumnos on 12/2/18.
//  Copyright © 2018 cev. All rights reserved.
//

import UIKit

class SearchTableView: UITableViewController {
    
    let places = ["Coffee", "Bars", "Banks", "Hospitals", "Pharmacies"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return places.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath)
        cell.textLabel?.text = places[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("SELECTED")
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "DeleteMeViewController") as! DeleteMeViewController
        vc.place = self.places[indexPath.row]
        self.present(vc, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
