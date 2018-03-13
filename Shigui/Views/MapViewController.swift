//
//  MapViewController.swift
//  Shigui
//
//  Created by alumnos on 24/1/18.
//  Copyright © 2018 cev. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Alamofire
import NVActivityIndicatorView

class MapViewController: UIViewController, MKMapViewDelegate, UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate{

    @IBOutlet weak var SearchTableView: UITableView!
    @IBOutlet weak var myImage: UIImageView!
    @IBOutlet weak var homeButton: UIButton!
    @IBOutlet weak var myMapView: MKMapView!
    var timer = Timer()
    var seconds = Int(0)
    var buscar = ""
    var dataReceived: Bool?
    var stringReceived: String?
    @IBOutlet weak var myActivity: NVActivityIndicatorView!
    
    @IBOutlet weak var lagActivity: UIActivityIndicatorView!
    
    @IBOutlet weak var SearchTextField: UITextField!
    
    @IBOutlet weak var Prueba: UIButton!
    var matchingItems: [MKMapItem] = [MKMapItem]()
    var locationManager: CLLocationManager!
    var id = 0
    var selectedMapItem: MKMapItem!
    var userLocation: CLLocation?
    var polylain: MKPolyline = MKPolyline()


    override func viewDidLoad() {
        super.viewDidLoad()
        
        
       
       
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        myMapView.delegate = self
        SearchTextField.keyboardAppearance = .dark
        SearchTextField.attributedPlaceholder = NSAttributedString(string: "shigui".localized(),
                                                                   attributes: [NSAttributedStringKey.foregroundColor: UIColor.gray])
        /*NVActivityIndicatorView(frame: nil, type: .pacman, color: UIColor.purple, padding: CGRect.c)*/
        //lagActivity.startAnimating()
        
        let color = UIColor.white
        // Initialization code
        SearchTextField.cornerRadius = 9
        SearchTextField.layer.borderWidth = 0
        SearchTextField.clipsToBounds = true
        SearchTextField.layer.borderColor = color.cgColor
        SearchTableView.backgroundColor = UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0)
        
        self.resizeTableView()
        /*let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(MapViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)*/
        determineCurrentLocation()
        if (dataReceived == true) {
            print("coordenad_X: \(coordinates_X)")
            
          
      
           
           
            //4selectedMapItem
            
            //annotation.coordinate = item.placemark.coordinate
            // annotation.title = item.name
            
            
            let request = MKLocalSearchRequest()
            request.naturalLanguageQuery = "\(stringReceived!)"
            
            request.region = myMapView.region
            let search = MKLocalSearch(request: request)
            search.start(completionHandler: {(response, error) in
                if error != nil {
                    print("Error in search:\(error!.localizedDescription)")
                } else if response!.mapItems.count == 0 {
                    print("No hay coincidencias")
                } else {
                    print("HAY COINCIDENCIAS -------------------------------->")
                    // print(response!.mapItems)
                    
                    for item in response!.mapItems {
                        //self.SearchTableView.reloadData()
                        self.matchingItems.append(item as MKMapItem)
                     
                    }
                    print("MatchingItems = \(self.matchingItems.count)")
                    DispatchQueue.main.async {
                        self.favoritesSearh()
                    }
                }
            })
            
           
            
            
            
            
            //selectedMapItem = 
        
            
            
            
            
            //drawRoutes()
            
        }
    }
    @objc func dismissKeyboard() {
        //Las vistas y toda la jerarquía renuncia a responder, para esconder el teclado
        view.endEditing(true)
    }
    
    func favoritesSearh(){
        let item = matchingItems[0]
        print("-aaaaa---------------------------------->")
        print(item)
        print("<aaaaaa----------------------------------")
        let annotation =  MapElement(title: stringReceived!, locationName: "", discipline: "", coordinate: CLLocationCoordinate2D(latitude: item.placemark.coordinate.latitude, longitude: item.placemark.coordinate.longitude))
        
        //annotation.coordinate = item.placemark.coordinate
        // annotation.title = item.name
        
        
        self.myMapView.addAnnotation(annotation)
        
        
        
        
        
        selectedMapItem = item
        drawRoutes()
        
    
    }
    
    
    
    @IBAction func drawRoutes() {
        myActivity.startAnimating()

       // myMapView.showsUserLocation = true
        //locationManager.desiredAccuracy = kCLLocationAccuracyBest
        //locationManager.delegate = self
       // locationManager.requestLocation()
         myMapView.remove(polylain)
     
        
        let request = MKDirectionsRequest()
        request.source = MKMapItem.forCurrentLocation()
        request.destination = selectedMapItem
        request.transportType = .automobile
        request.requestsAlternateRoutes = false
        var distanceBetweenLocations = Double()
        let directions = MKDirections(request: request)
        print("directions: \(directions)")
        
        directions.calculate(completionHandler: {(response, error) in
            if error != nil {
                print("Error getting directions: \(String(describing: error))")
                if self.myActivity.isAnimating{
                    self.myActivity.stopAnimating()
                }

            } else {
                print("response: \(String(describing: response!))")
                self.showRoutes(response: response!)
                distanceBetweenLocations = (response?.routes[0].distance)!
               
                
            }
 
            
            
        })
     
        
     // let center = CLLocationCoordinate2D(latitude: selectedMapItem.placemark.coordinate.latitude, longitude: selectedMapItem.placemark.coordinate.longitude)
        
        //let distance = userLocation?.distanceFromLocation(request.destination)
     // let centerCalculated = CLLocationCoordinate2D(latitude: <#T##CLLocationDegrees#>, longitude: <#T##CLLocationDegrees#>)
      //let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: distanceBetweenLocations/1000, longitudeDelta: distanceBetweenLocations/1000))
     // myMapView.setRegion(region, animated: true)
        print("------------------------------DATARECEIVED------------------------------")
        print(dataReceived!)
  
        if(dataReceived!){
            let url = URL(string:"http://h2744356.stratoserver.net/shigui/Shigui/public/index.php/places/create.json")
            let parameters: Parameters = [
                
                "name": stringReceived!,
                "id_maps": id_maps,
                "coordinates_X": coordinates_X,
                "coordinates_Y": coordinates_Y,
                ]
            
            
            Alamofire.request(url!, method: .post, parameters: parameters).responseJSON{ response in
                
                print("(--------------------------")
                print("Request        :: \(response.request)")
                print("Request Result :: \(response.result)")
                print("Request Value  :: \(response.result.value)")
                print("Request StatusCode :: \(response.response?.statusCode)")
                
                switch response.result {
                    
                case .success:
                    
                    print("La peticion ha ido bien")
                    let json = response.result.value as! Dictionary<String, Any>
                    let myCode = json["code"] as! Int
                    switch myCode {
                    case 200:
                        datasPlace = json["data"]  as! Dictionary<String, Any>
                        //self.id = json["id"] as! Int
                        //print("\(json["data"] as! String)")
                        
                        
                        
                        
                        // showAlert(json["message"])
                        // Accion de login -> Guardar en defaults -> Controller
                        // case 400:
                    //     print("Han habido error")
                    default:
                        datasPlace = json["data"]  as! Dictionary<String, Any>
                    }
                    
                case .failure:
                    print("La peticion no ha funcionado")
                }
            }
          
            
            
        }
        else{
            let url = URL(string:"http://h2744356.stratoserver.net/shigui/Shigui/public/index.php/places/create.json")
            let parameters: Parameters = [
                
                "name": selectedMapItem.placemark.name!,
                "id_maps":"\(selectedMapItem.placemark.coordinate.latitude)\(selectedMapItem.placemark.coordinate.longitude)",
                "coordinates_X": selectedMapItem.placemark.coordinate.latitude,
                "coordinates_Y": selectedMapItem.placemark.coordinate.longitude,
                ]
            
            
            Alamofire.request(url!, method: .post, parameters: parameters).responseJSON{ response in
                
                print("(--------------------------")
                print("Request        :: \(response.request)")
                print("Request Result :: \(response.result)")
                print("Request Value  :: \(response.result.value)")
                print("Request StatusCode :: \(response.response?.statusCode)")
                
                switch response.result {
                    
                case .success:
                    
                    print("La peticion ha ido bien")
                    let json = response.result.value as! Dictionary<String, Any>
                    let myCode = json["code"] as! Int
                    switch myCode {
                    case 200:
                        datasPlace = json["data"]  as! Dictionary<String, Any>
                        
                       
                        //self.id = json["id"] as! Int
                        //print("\(json["data"] as! String)")
                        
                        
                        
                        
                        // showAlert(json["message"])
                        // Accion de login -> Guardar en defaults -> Controller
                        // case 400:
                    //     print("Han habido error")
                    default:
                        datasPlace = json["data"]  as! Dictionary<String, Any>
                    }
                    
                case .failure:
                    print("La peticion no ha funcionado")
                }
            }
            
        }
          dataReceived = false
        
       
    }
        
        func showRoutes(response: MKDirectionsResponse){
            print("----------------------------------POLYLINE-------------------------------------")
           
           
            
            
           
            for route in response.routes{
                
             
             
                polylain = route.polyline
             
                myMapView.add(polylain, level: MKOverlayLevel.aboveRoads)
                
                 
                /*for step in route.steps {
                    //print(step.instructions)
                     print(polyline)
                   
                   
                    
                }*/
            }
            if myActivity.isAnimating{
                myActivity.stopAnimating()
            }
        }
    
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
         let renderer = MKPolylineRenderer(overlay:overlay)
            if overlay is MKPolyline {
           
                renderer.strokeColor = .orange
                renderer.lineWidth = 2
                
        }
        return renderer
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        
        let location = locations.first!
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, 500, 500)
        myMapView.setRegion(coordinateRegion, animated: true)
        locationManager?.stopUpdatingLocation()
        locationManager = nil
        
        
//        userLocation = locations[0]
//        let region = MKCoordinateRegionMakeWithDistance(userLocation!.coordinate, 2000, 2000)
//        myMapView.setRegion(region, animated: true)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
        
    
    func runTimer() {
        SearchTableView.isHidden = false
        timer.invalidate()
        seconds = 0
        timer = Timer.scheduledTimer(timeInterval: 0.25, target: self,   selector: (#selector(MapViewController.updateTimer)), userInfo: nil, repeats: true)
        
        
    }
    
    @objc func updateTimer() {
        
        
        seconds += 1
        print("seconds: \(seconds)")
        if ( seconds == 1){
              searchItems(searchField:  buscar)
            timer.invalidate()
        }
      
        
    }
    
    
    func determineCurrentLocation(){
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        
        
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
    }
    
  
    
   
    
   
    
    @IBAction func homeScreen(_ sender: Any) {
            	
            dismiss(animated: true, completion: nil)
            
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   
    
    func addAnnotation(sender:UILongPressGestureRecognizer){
        
       dismiss(animated: true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */


    // 1
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        // 2
        let identifier = "myPin"
        var view: MKPinAnnotationView
        if let annotation = annotation as? MapElement {
            if let dqView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView{
                view = dqView
                return view
            } else {
                view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                view.isEnabled = true
                view.canShowCallout = true
                view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure) as UIView
                view.tag = 18
                view.pinTintColor = .blue
                return view
            }
        }
        return nil
    }
  
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView,
                 calloutAccessoryControlTapped control: UIControl) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        self.present(vc, animated: true, completion: nil)
    }
    
    // MARK:- TableView Settings
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(matchingItems.count)
        if(matchingItems.count > 6){
            return 6
        }
        else{
            return matchingItems.count
        }
        
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
   
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchCell", for: indexPath) as! MapTableViewCell
        cell.nameLbl.text = matchingItems[indexPath.row].name
        return cell
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
          self.myMapView.removeAnnotations(self.myMapView.annotations )
        

        let item = matchingItems[indexPath.row]
        SearchTableView.isHidden = true
        print("-aaaaa---------------------------------->")
        print(item)
         print("<aaaaaa----------------------------------")
        let annotation =  MapElement(title: item.name!, locationName: "", discipline: "", coordinate: CLLocationCoordinate2D(latitude: item.placemark.coordinate.latitude, longitude: item.placemark.coordinate.longitude))
       // coordinates_X = item.placemark.coordinate.latitude
       // coordinates_Y = item.placemark.coordinate.longitude
        
        //annotation.coordinate = item.placemark.coordinate
       // annotation.title = item.name
        
        
        self.myMapView.addAnnotation(annotation)
        view.endEditing(true)

        
        matchingItems.removeAll()
        self.resizeTableView()
        
   
        
        selectedMapItem = item
        dataReceived = false
        drawRoutes()
        
        //peticion = "RegisterRequest"
        //func miLlamada(url, parameters, tipo, peticion)
        
       
    }
    
    @IBAction func searchChanges(_ sender: UITextField) {
        
        matchingItems.removeAll()
       
        
       
        self.myMapView.removeAnnotations(self.myMapView.annotations )
        if sender.text!.count >= 3 {
          
            buscar = sender.text!
            runTimer()
            
          
        } else {
            self.resizeTableView()
        }
    } 
    
    @IBAction func textFieldShouldReturn(_ textField: UITextField)  {   //
        textField.resignFirstResponder()
        }
   
    
    func searchItems(searchField: String){
        
       
        
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = searchField
        request.region = myMapView.region
        let search = MKLocalSearch(request: request)
        search.start(completionHandler: {(response, error) in
            if error != nil {
                print("Error in search:\(error!.localizedDescription)")
            } else if response!.mapItems.count == 0 {
                print("No hay coincidencias")
            } else {
                print("HAY COINCIDENCIAS -------------------------------->")
               // print(response!.mapItems)
             
                for item in response!.mapItems {
                    //self.SearchTableView.reloadData()
                   self.matchingItems.append(item as MKMapItem)
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = item.placemark.coordinate
                    annotation.title = item.name
                    self.myMapView.addAnnotation(annotation)
                }
               print("MatchingItems = \(self.matchingItems.count)")
                DispatchQueue.main.async {
                    self.resizeTableView()
                }
            }
        })
    }
  
    func resizeTableView(){
        print("REPINTO")
        SearchTableView.reloadData()
        var tableFrame = SearchTableView.frame
        tableFrame.size.height = SearchTableView.contentSize.height
        SearchTableView.frame = tableFrame
    }
    
    // MARK:- LOCATION MANAGER
    
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        let userLocation: CLLocation = locations[0] as CLLocation
//        locationManager.stopUpdatingLocation()
//        let center = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
//        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
//        myMapView.setRegion(region, animated: true)
//
////        let userAnnotation : MKPointAnnotation = MKPointAnnotation()
////        userAnnotation.coordinate = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
////        userAnnotation.title = "Current location"
////        myMapView.addAnnotation(userAnnotation)
//    }
}
