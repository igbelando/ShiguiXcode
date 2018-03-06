//
//  DeleteMeViewController.swift
//  Shigui
//
//  Created by alumnos on 26/2/18.
//  Copyright © 2018 cev. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
import ARCL

class DeleteMeViewController: UIViewController, CLLocationManagerDelegate{
    
    var place: String!
    var locationManager = CLLocationManager()
    var sceneLocationView = SceneLocationView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = self.place
        
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.startUpdatingLocation()
        print(self.locationManager.location?.coordinate)
        
        sceneLocationView.run()
        self.view.addSubview(sceneLocationView)
        
    }
    func findNearPlaces(){
        let location = self.locationManager.location
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = place
        var region = MKCoordinateRegion()
        region.center = CLLocationCoordinate2D(latitude: (location?.coordinate.latitude)!, longitude:
            (location?.coordinate.longitude)!)
        request.region = region
        let search = MKLocalSearch(request: request)
        search.start { response, error in
            if error != nil {
                return
            }
            /*for item in (response?.mapItems)! {
                print(item.placemark)
                let placeLocation = (item.placemark.location)!
            }*/
            for item in (response?.mapItems)! {
                print(item.placemark)
                let placeLocation = (item.placemark.location)!
                let image = UIImage(named:"pin")
                let placeAnnotationNode = PlaceAnnotationNode(location: placeLocation, title: item.placemark.name!)
               // placeAnnotationNode.scaleRelativeToDistance = false
                DispatchQueue.main.async{
                    self.sceneLocationView.addLocationNodeWithConfirmedLocation(locationNode: placeAnnotationNode)
                }
            }
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
