//
//  ViewController.swift
//  TrashMapper
//
//  Created by Jacob Case on 5/13/22.
//

import UIKit
import CoreLocation
import CoreLocationUI

class CurrentLocationViewController: UIViewController, CLLocationManagerDelegate {
    
    //create location manager object
    let locationManager = CLLocationManager()
    var updatingLocation = false
    var locationError: Error?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print("view load")
        
        if updatingLocation {
            stopLocationManager()
        } else {
            locationError = nil
        }
        getStatus()
        
    }

    @IBAction func getLocation(_ sender: Any) {
        let authStatus = locationManager.authorizationStatus
        if authStatus == .notDetermined {
            print("Auth status not determined")
            locationManager.requestWhenInUseAuthorization()
            return
        } else if authStatus == .restricted {
            print("restricted")
        }
        print("Update Location")
        startLocationManager()
    }
    
    @IBAction func stopLocation(_ sender: Any) {
        print("Stop Upating Location")
        stopLocationManager()
        getStatus()
    }
    
    func startLocationManager() {
        if CLLocationManager.locationServicesEnabled() {
            getStatus()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
            updatingLocation = true
        }
    }
    
    func stopLocationManager() {
        if updatingLocation {
            locationManager.stopUpdatingLocation()
            locationManager.delegate = nil
            updatingLocation = false
        }
    }
    

    func getStatus() {
        let statusMessage: String
        
        if let error = locationError as NSError? {
            if error.domain == kCLErrorDomain && error.code == CLError.denied.rawValue {
                statusMessage = "Location Services Disabled"
            } else {
                statusMessage = "Error Getting Location"
            }
        } else if !CLLocationManager.locationServicesEnabled() {
            statusMessage = "Location Services Disabled"
        } else if updatingLocation {
            statusMessage = "Searching..."
        } else {
            statusMessage = "Tap 'Get Location' to Start"
        }
        
        print(statusMessage)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("didFailWithError \(error.localizedDescription)")
        
        if let error = (error as? NSError) {
            print(error._domain)
            print(error._code)
        }
        
        if (error as NSError).code == CLError.locationUnknown.rawValue {
            print("Location Unknown")
            return
        }
        
        locationError = error
        stopLocationManager()
        getStatus()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let newLocation = locations.last!
        print("didUpdateLocations \(newLocation)")
        locationError = nil
 
    }

}



