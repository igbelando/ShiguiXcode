//
//  Artwork.swift
//  Shigui
//
//  Created by alumnos on 19/2/18.
//  Copyright © 2018 cev. All rights reserved.
//

import UIKit
import MapKit


class MapElement: NSObject, MKAnnotation {
    let title: String?
    let locationName: String
    let discipline: String
    let coordinate: CLLocationCoordinate2D
    
    init(title: String, locationName: String, discipline: String, coordinate: CLLocationCoordinate2D){
        self.title  = title
        self.locationName = locationName
        self.discipline = discipline
        self.coordinate = coordinate
        super.init()
    }
    var subtitle: String? {
        return locationName
    }
}

class Artwork: NSObject, MKAnnotation {
    let title: String?
    let locationName: String
    let discipline: String
    let coordinate: CLLocationCoordinate2D
    var artworks: [Artwork] = []
  
    
    init(title: String, locationName: String, discipline: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.locationName = locationName
        self.discipline = discipline
        self.coordinate = coordinate
     
        
        
        super.init()
    }
    init?(json: [Any]) {
        // 1
        self.title = json[16] as? String ?? "No Title"
        self.locationName = json[12] as! String
        self.discipline = json[15] as! String
        print(json[15] as! String)
        // 2
        if let latitude = Double(json[18] as! String),
            let longitude = Double(json[19] as! String) {
            self.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        } else {
            self.coordinate = CLLocationCoordinate2D()
        }

    }
    
    func loadInitialData() {
        // 1
        guard let fileName = Bundle.main.path(forResource: "PublicArt", ofType: "json")
            else { return }
        let optionalData = try? Data(contentsOf: URL(fileURLWithPath: fileName))
        
        guard
            let data = optionalData,
            // 2
            let json = try? JSONSerialization.jsonObject(with: data),
            // 3
            let dictionary = json as? [String: Any],
            // 4
            let works = dictionary["data"] as? [[Any]]
            else { return }
        // 5
        let validWorks = works.flatMap { Artwork(json: $0) }
        artworks.append(contentsOf: validWorks)
    }
    
    var markerTintColor: UIColor  {
        let cultureColor = UIColor(red: 56/255, green: 151/255, blue: 217/255, alpha: 1)
        let defaultColor = UIColor(red: 231/255, green: 76/255, blue: 60/255, alpha: 1)
        
        switch discipline {
        case "Monument":
            return defaultColor
        case "Mural":
            return defaultColor
        case "Plaque":
            return defaultColor
        case "Sculpture":
            return defaultColor
        default:
            return cultureColor
        }
    }
    func mapItem() -> MKMapItem {
 
        let placemark = MKPlacemark(coordinate: coordinate)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = title
        return mapItem
    }

    
    var subtitle: String? {
        return locationName
    }
}
