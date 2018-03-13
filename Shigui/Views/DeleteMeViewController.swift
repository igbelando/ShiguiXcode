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
import SceneKit
import ARKit

class DeleteMeViewController: UIViewController, CLLocationManagerDelegate, ARSCNViewDelegate{
    
    var place: String!
    var locationManager = CLLocationManager()
    var sceneLocationView = SceneLocationView()
    var animations = [String: CAAnimation]()
    var idle:Bool = true
    
    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        self.title = self.place
        
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.startUpdatingLocation()
        print("-------------------------MyLocation---------------------------")
        print(self.locationManager.location?.coordinate)
        
        findNearPlaces()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let scene = SCNScene()
        
        // Set the scene to the view
        sceneLocationView.scene = scene
        sceneLocationView.run()
        self.view.addSubview(sceneLocationView)
        self.view.sendSubview(toBack: sceneLocationView)

        
        //MARK:- 2.2
        loadAnimations()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        sceneLocationView.frame = self.view.bounds
    }
    
    @IBAction func backBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func findNearPlaces(){
        let location = self.locationManager.location
      
        var region = MKCoordinateRegion()
        region.center = CLLocationCoordinate2D(latitude: (location?.coordinate.latitude)!, longitude: (location?.coordinate.longitude)!)
        let locationPlace = CLLocation(latitude: coordinates_X, longitude: coordinates_Y)
       // print(locationPlace)
       
        let placeAnnotationNode = PlaceAnnotationNode(location: locationPlace, title: (datasPlace ["name"] as! String))
        print(locationPlace.altitude)
        
        
        DispatchQueue.main.async{
            self.sceneLocationView.addLocationNodeWithConfirmedLocation(locationNode: placeAnnotationNode)
        }
        
        
        
    }
    func loadAnimations(){
        guard let idleScene = SCNScene(named: "art.scnassets/Idle.dae") else {
            print("NO EXISTE")
            return
            
        }
        let node = SCNNode()
        for child in idleScene.rootNode.childNodes {
            node.addChildNode(child)
        }
        print("XxxXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX")
        print((locationManager.location?.coordinate.latitude)!)
        print(coordinates_X)
        print((locationManager.location?.coordinate.longitude)!)
        print(coordinates_Y)
        print("\((locationManager.location?.coordinate.latitude)!-coordinates_X)),\((locationManager.location?.coordinate.longitude)!-coordinates_Y))")
        print("\(((locationManager.location?.coordinate.latitude)!-coordinates_X)*10),\(((locationManager.location?.coordinate.longitude)!-coordinates_Y)*10)")
        
        print("\((coordinates_X-(locationManager.location?.coordinate.longitude)!)*10),\((coordinates_Y-(locationManager.location?.coordinate.latitude)!)*10)")
        
        
    node.position = SCNVector3(((locationManager.location?.coordinate.longitude)!-coordinates_X)*10, -1, ((locationManager.location?.coordinate.latitude)!-coordinates_Y)*10)
        
        node.scale = SCNVector3(0.1, 0.1, 0.1)
        sceneLocationView.scene.rootNode.addChildNode(node)
        //loadAnimation(withKey: "walking", sceneName: "art.scnassets/Strut Walking", animationIdentifier: "GSFixed-1")
    }
    
    
    //MARK:- 2.3
    func loadAnimation(withKey: String, sceneName:String, animationIdentifier:String) {
        let sceneURL = Bundle.main.url(forResource: sceneName, withExtension: "dae")
        let sceneSource = SCNSceneSource(url: sceneURL!, options: nil)
        if let animationObject = sceneSource?.entryWithIdentifier(animationIdentifier, withClass: CAAnimation.self) {
            animationObject.repeatCount = 1
            animationObject.fadeInDuration = CGFloat(1)
            animationObject.fadeOutDuration = CGFloat(0.5)
            animations[withKey] = animationObject
        }
    }
    
    //MARK:- 2.4
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let location = touches.first!.location(in: sceneLocationView)
        
        // Let's test if a 3D Object was touch
        var hitTestOptions = [SCNHitTestOption: Any]()
        hitTestOptions[SCNHitTestOption.boundingBoxOnly] = true
        
        let hitResults: [SCNHitTestResult]  = sceneView.hitTest(location, options: hitTestOptions)
        print("PULSADO")
        
        if hitResults.first != nil {
            if(idle) {
                playAnimation(key: "walking")
            } else {
                stopAnimation(key: "walking")
            }
            idle = !idle
            return
        }
    }
    
    //MARK:- 2.5
    func playAnimation(key: String) {
        sceneLocationView.scene.rootNode.addAnimation(animations[key]!, forKey: key)
        //MARK:- 4.4
       
        
    }
    
    //MARK:- 2.6
    func stopAnimation(key: String) {
        sceneLocationView.scene.rootNode.removeAnimation(forKey: key, blendOutDuration: CGFloat(0.5))
     
        //MARK:- 4.4
      
    }
    
   
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneLocationView.session.pause()
    }

}
