//
//  ViewController.swift
//  MackCoreMotion
//
//  Created by Piera Marchesini on 25/05/17.
//  Copyright © 2017 Piera Marchesini. All rights reserved.
//

import UIKit
import CoreMotion
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var rollLabel: UILabel!
    @IBOutlet weak var pitchLabel: UILabel!
    @IBOutlet weak var yawLabel: UILabel!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var distance: UILabel!
    
    
    let manager: CMMotionManager = CMMotionManager()
    let locationManager: CLLocationManager = CLLocationManager()
    let range = 8
    
    //var roll: Double = 0
    //var pitch: Double = 0
    var yaw: Double = 0
    
    var point1: CLLocation = CLLocation(latitude: -23.54776382, longitude: -46.65116501)
    var point2 = CLLocation(latitude: -23.54791260, longitude: -46.65043259)
    var point3 = CLLocation(latitude: -23.54767609, longitude: -46.65094376)
    var currentLocalization: CLLocation? = nil
    
    var foundPoint1: Bool = false
    var foundPoint2: Bool = false
    var foundPoint3: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Location
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        //Device Motion
        if manager.isDeviceMotionAvailable {
            manager.deviceMotionUpdateInterval = 0.5
            manager.startDeviceMotionUpdates(using: .xTrueNorthZVertical, to: .main, withHandler: {
                (deviceMotionData, error) in
                if error != nil {
                    print("Problems while reading Device Motion data")
                } else {
                    if let data = deviceMotionData {
                        //self.roll = data.attitude.roll * 180 / Double.pi
                        //self.pitch = data.attitude.pitch * 180 / Double.pi
                        
                        self.yaw = data.attitude.yaw * 180 / Double.pi
                        self.yawLabel.text = "Yaw: \(self.yaw) degrees"
                        
                        //Deixa tudo positivo de 0 grau até 360 graus
                        if self.yaw < 0 {
                            self.yaw = (self.yaw * 0) + 180 + (180+self.yaw)
                            self.yawLabel.text = "Yaw: \(self.yaw) degrees"
                        }
                        
                        if self.foundPoint1 {
                            if self.yaw < 290 && self.yaw > 190 {
                                self.label.text = "Prédio 33"
                            } else {
                                self.label.text = "Oh no! Jim is dead"
                            }
                        }
                        
                        if self.foundPoint2 {
                            if self.yaw < 150 && self.yaw > 97 {
                                self.label.text = "Entrada Consolação"
                            } else {
                                self.label.text = "Oh no! Jim is dead"
                            }
                        }
                        
                        if self.foundPoint3 {
                            if self.yaw < 330 && self.yaw > 250 {
                                self.label.text = "Mr. Cheney"
                            } else {
                                self.label.text = "Oh no! Jim is dead"
                            }
                        }
                    }
                }
            })
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocalization = manager.location
        
        let distanceMeters = currentLocalization?.distance(from: point1)
        let distanceMeters2 = currentLocalization?.distance(from: point2)
        let distanceMeters3 = currentLocalization?.distance(from: point3)
        
        self.view.backgroundColor = .red
        
        
        if ((Double(distanceMeters!)) < Double(range)){
            //Point 1
            self.foundPoint1 = true
            view.backgroundColor = .green
            distance.text = "c\(Double((distanceMeters)!))"
            
            self.foundPoint2 = false
            self.foundPoint3 = false
            
        } else if ((Double(distanceMeters2!)) < Double(range)){
            //Point 2
            self.foundPoint2 = true
            view.backgroundColor = .green
            distance.text = "Distance: \(Double((distanceMeters2)!))"
            
            self.foundPoint1 = false
            self.foundPoint3 = false
            
        } else if ((Double(distanceMeters3!)) < Double(range)) {
            //Point 3
            self.foundPoint3 = true
            view.backgroundColor = .green
            distance.text = "Distance: \(Double((distanceMeters3)!))"
            
            self.foundPoint1 = false
            self.foundPoint2 = false
        }
        
        
    }
    
    
}

