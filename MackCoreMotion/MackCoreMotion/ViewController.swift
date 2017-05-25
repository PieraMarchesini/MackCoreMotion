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
    @IBOutlet var distance: UIView!
    
    let manager: CMMotionManager = CMMotionManager()
    let locationManager: CLLocationManager = CLLocationManager()
    let range = 10
    
    //var roll: Double = 0
    //var pitch: Double = 0
    var yaw: Double = 0
    
    var point1: CLLocation = CLLocation(latitude: -23.54776382, longitude: -46.65116501)
    var point2 = CLLocation(latitude: -23.54786682, longitude: -46.65027237)
    var point3 = CLLocation(latitude: -23.547436460274149, longitude: -46.651246968901958)
    var currentLocalization: CLLocation? = nil
    
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
                        
                        //Deixa tudo positivo de 0 grau até 360 graus
                        if self.yaw < 0 {
                            self.yaw = (self.yaw * 0) + 180 + (180+self.yaw)
                            self.yawLabel.text = "Yaw: \(self.yaw) degrees"
                        }
                        
                        if self.yaw < 358 && self.yaw > 280 {
                            self.label.text = "TV da frente"
                        } else {
                            self.label.text = "Tudo mudou"
                        }
                    }
                }
            })
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocalization = manager.location
        
        print("Latitude %.6f", currentLocalization?.coordinate.latitude)
        print("Longitude %.6f", currentLocalization?.coordinate.longitude)
        
        let distanceMeters = currentLocalization?.distance(from: point3)
        infoLabel.text = "\(Double((distanceMeters)!))"
        
        if ((Double(distanceMeters!)) > Double(meters)){
            view.backgroundColor = .red
        }else{
            view.backgroundColor = .green
        }
        //print(distanceMeters)
    }
    
    
}

