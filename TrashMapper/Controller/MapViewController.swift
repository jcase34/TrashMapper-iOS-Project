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
    var location: CLLocation?
    var timer: Timer?
    var locationError: Error?
    var updatingLocation: Bool = false
    var mapAnnotation: MKAnnotation?
    
    //coreData vars
    var managedObjectContext: NSManagedObjectContext!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        print("At mapviewcontroller")
        //timer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(zoomUserLocation), userInfo: nil, repeats: false)
        
        
        
        //pull dummy data from locationsArray
        
        
        
        
        //pull data from firebase
        //load as pins on map
        //fetched posts should omit userID for privacy
        
              
        
        
        
        
        /*
         Steps for adding annotations:
         1.) Define annotation object
         2.) Define annotation view
         3.) Implement "viewFor annotation" delegate method
         4.) Add annotation object
         
         */
        
        //set the current view controller as the delegate for mapView
        mapView.delegate = self
        
        //register taggedLocationAnnotation as an MKMarkerAnnotation
        mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: NSStringFromClass(TaggedLocationAnnotation.self))
        
        
        //Define the annotation object
        mapAnnotation = TaggedLocationAnnotation()
        
        
        //add sample map annotation
        mapView.addAnnotation(mapAnnotation!)
        
    
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getLocation()
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
        print("prepping for segue, identifier = \(String(describing: segue.identifier))")
        if segue.identifier == "AddLocation" {
            let destinationVC = segue.destination as! CreatePostViewController
            destinationVC.coordinate = location!.coordinate
            //possible error on not getting current location vs changing to other tab
            
            //CoreData context pass
            destinationVC.managedObjectContext = managedObjectContext
      }
    }
}

//MARK: - MapViewDelegate
extension MapViewController : MKMapViewDelegate {
    /*
     Steps for adding annotations:
     1.) Define annotation object
     2.) Define annotation view
     3.) Implement "viewFor annotation" delegate method
     4.) Add annotation object
     
     
     Steps in Swift:
     Assign a delegate
     Register any custom annontation objects
     Create custom objects
     Add the object using addAnnotation -> Calls the viewFor annotation method
     
        viewFor Annotation:
            Take the object annotation data, create a view, and return it to the viewController to be added to the mapView.
     
     */
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        //continue on if the annoatation to be added is not a user location
        guard !annotation.isKind(of: MKUserLocation.self) else {
            return nil
        }
        
        var annotationView: MKAnnotationView?
        
        if let annotation = annotation as? TaggedLocationAnnotation {
            annotationView = setupTaggedLocationAnnotation(for: annotation, on: mapView)
        }
        
        return annotationView
    }
    
    //****************************
    private func setupTaggedLocationAnnotation(for annotation: TaggedLocationAnnotation, on mapView: MKMapView) -> MKAnnotationView {
        
        //identifier is the custom TaggedLocationAnnotation class
        let identifier = NSStringFromClass(TaggedLocationAnnotation.self)
        
        //re-use annotations by dequeuing
        let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier, for: annotation)
        
        //cast the annotationView as a MKMarkerAnnotation
        if let markerAnnotationView = annotationView as? MKMarkerAnnotationView {
            
            //MkMarkerAnnotation allows customization
            markerAnnotationView.animatesWhenAdded = true
            markerAnnotationView.canShowCallout = true
            markerAnnotationView.markerTintColor = UIColor.purple
            
            
            
            // Provide an image view to use as the accessory view's detail view.
            let pinImage = UIImage(named: "trash_in_park.jpg")
            let newPinImage = pinImage?.resized(withBounds: CGSize(width: 100, height: 100))
            
            
            markerAnnotationView.detailCalloutAccessoryView = UIImageView(image: newPinImage)
        }
        
        return annotationView
    }
    
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
        let region = MKCoordinateRegion(center: mapView.userLocation.coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
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
