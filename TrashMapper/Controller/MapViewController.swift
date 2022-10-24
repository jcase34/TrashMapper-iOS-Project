//
//  MapViewController.swift
//  TrashMapper
//
//  Created by Jacob Case on 5/27/22.
//

import UIKit
import CoreLocation
import CoreLocationUI
import MapKit
import CoreData

class MapViewController: UIViewController  {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var goToUserLocation: UIBarButtonItem!
    
    var locationManager = CLLocationManager()
    var location: CLLocation? = nil {
        didSet {
            print("valid location found")
            zoomUserLocation()
        }
    }
    var timer: Timer?
    var locationError: Error?
    var updatingLocation: Bool = false
    
    
    var mapAnnotation : [MKAnnotation] = [] {
        didSet {
            print("map annotations updated")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        print("At mapviewcontroller")

        //set the current view controller as the delegate for mapView
        mapView.delegate = self
        getLocation()
        
        //register TaggedView
        mapView.register(TaggedLocationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        
        //add sample map annotation
        mapView.addAnnotations(mapAnnotation)
    }
        
    
    //MARK: - Helper Methods
    func showLocationServicesDeniedAlert() {
        let ac = UIAlertController(title: "Location Services Disable", message: "Please enable location services for this app in Settings.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        ac.addAction(okAction)
        
        present(ac, animated: true, completion: nil)
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard location != nil else {return}
        print("prepping for segue, identifier = \(String(describing: segue.identifier))")
        if segue.identifier == "AddLocation" {
            let destinationVC = segue.destination as! CreatePostViewController
            destinationVC.coordinate = location!.coordinate
            //possible error on not getting current location vs changing to other tab
      }
    }
}

//MARK: - MapViewDelegate
extension MapViewController : MKMapViewDelegate {
   
}



//MARK: - CLLocationManagerDelegate
extension MapViewController : CLLocationManagerDelegate {
    /*
     To Do:
     Separate out authorization vs start receiving location
     Check for a valid location before enabling other buttons on screen, performing segue, zoom
     or any other functionality
     
     */
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("didFailWithError \(error.localizedDescription)")
        
        //Unable to get location right now, try again later
        if (error as NSError).code == CLError.locationUnknown.rawValue {
            print("Location Unknown")
            return
        }
        
        //store error
        locationError = error
        stopLocationManager()
        getStatus()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let newLocation = locations.last!
        print("didUpdateLocations \(newLocation)")
        
        //Last location is old/cached, ignore and continue search
        if newLocation.timestamp.timeIntervalSinceNow < -5 {
            return
        }
        
        //ignore invalid accuracies
        if newLocation.horizontalAccuracy < 0 {
            return
        }
        
        //If there was no previous location, or the accuracy is larger than the most recent one, adopt new location
        if location == nil || location!.horizontalAccuracy > newLocation.horizontalAccuracy {
            //new location to be used, clear error
            locationError = nil
            location = newLocation
        }
        
        //current location and new location accuracy the same, stop updating location
        if newLocation.horizontalAccuracy <= locationManager.desiredAccuracy {
            print("locations similar")
            stopLocationManager()
        }
        getStatus()
 
    }
    
    func stopLocationManager() {
        if updatingLocation {
            locationManager.stopUpdatingLocation()
            locationManager.delegate = nil
            updatingLocation = false
            
            if let timer = timer {
                timer.invalidate()
            }
            
        }
        print("Stop updating location")
        getStatus()
    }
    
    //need to clean up this function, breakout authorization with status, etc.
    func getLocation() {
        
        let authStatus = locationManager.authorizationStatus
        if authStatus == .notDetermined {
            print("Auth status not determined")
            locationManager.requestWhenInUseAuthorization()
            return
        } else if authStatus == .restricted || authStatus == .denied {
            print("restricted")
            showLocationServicesDeniedAlert()
            return
        }
        
        if updatingLocation {
            stopLocationManager()
        } else {
            getStatus()
            location = nil
            locationError = nil
            startLocationManager()
        }
    }
    
    func startLocationManager() {
        print("getting lcoation")
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
            locationManager.startUpdatingLocation()
            updatingLocation = true
            
            timer = Timer.scheduledTimer(timeInterval: 30, target: self, selector: #selector(didTimeOut), userInfo: nil, repeats: false)
        }
    }
    
    @IBAction func goToUserLocation(_ sender: Any) {
        print("zoom to user tapped")
        zoomUserLocation()
    }
    
    @objc func zoomUserLocation() {
        guard location != nil else {return}
        let region = MKCoordinateRegion(center: location!.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
            mapView.setRegion(mapView.regionThatFits(region), animated: true)
        print("Zooming to user location")
    }

    @objc func didTimeOut() {
        print("***Time Out***")
        if location == nil {
            stopLocationManager()
            locationError = NSError(domain: "MyLocationsErrorDomain", code: 1, userInfo: nil)
            getStatus()
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
}
