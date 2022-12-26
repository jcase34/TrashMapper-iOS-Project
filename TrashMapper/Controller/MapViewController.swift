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
import FirebaseStorage
import FirebaseFirestore
import FirebaseAuth
import FirebaseCore

class MapViewController: UIViewController  {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var PullButton: UIButton!
    @IBOutlet weak var zoomToUser: UIBarButtonItem!
    
    var locationManagerSet: Bool = false
    var locationManager = CLLocationManager()
    var authStatus : CLAuthorizationStatus = .notDetermined
    var location: CLLocation? {
        didSet{
            print("location updated: \(location)")
            //zoomUserLocation()
        }
    }
    var timer: Timer?
    var locationError: Error?
    var updatingLocation: Bool = false
    
    var mapAnnotation : [MKAnnotation] = [] {
        didSet {
            //print("map annotations updated \(mapAnnotation)")
            mapView.addAnnotations(mapAnnotation)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print("At mapviewcontroller")
        locationManager.delegate = self
        mapView.delegate = self

        FormUtlities.setupBackgroundColor(self.view)
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.init(red: 200/255, green: 220/255, blue: 200/255, alpha: 1)]
        navigationItem.leftBarButtonItem?.tintColor = UIColor.init(red: 200/255, green: 220/255, blue: 200/255, alpha: 1)
        navigationItem.rightBarButtonItem?.tintColor = UIColor.init(red: 200/255, green: 220/255, blue: 200/255, alpha: 1)
        //mapView.register(TaggedLocationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        getLocation()
        zoomUserLocation()
        pullPostsFromFirebase()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("@ view will appear")
    }
        
    @IBAction func zoomToUser(_ sender: Any) {
        if locationManager.location != nil {
            print("do zoom")
            zoomUserLocation()
        } else {
            showNoValidLocation()
            print("no zoomz allowed")
        }
    }
    
    //MARK: - Firebase Operations
    func pullPostsFromFirebase() {
        print("get cloud data")
        FirebaseDataManager.pullPostsFromCloud { newAnnotations in
            for annotation in newAnnotations {
                print(annotation)
                let newTag = TaggedLocationAnnotation(
                    coordinate: CLLocationCoordinate2D(latitude: annotation.latitude, longitude: annotation.longitude),
                    title: annotation.date,
                    subtitle: annotation.description,
                    imageURL: annotation.imageUrl)
                self.mapAnnotation.append(newTag)
            }
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        location = locationManager.location
        print("prepping for segue, identifier = \(String(describing: segue.identifier))")
        if segue.identifier == "addLocation" {
            let destinationVC = segue.destination as! CreatePostViewController
            destinationVC.coordinate = location!.coordinate
            //possible error on not getting current location vs changing to other tab
        } else if segue.identifier == "ShowDetail" {
            segue.destination.modalPresentationStyle = .overFullScreen
            let destinationVC = segue.destination as! DetailViewController
            let annotationInformation = sender as! TaggedLocationAnnotation
            let postDict: [String:String] = [
                "postTitle": annotationInformation.title!,
                "postSubtitle": annotationInformation.subtitle!,
                "postImageURL": annotationInformation.imageURL!
            ]
            destinationVC.postDetails = postDict
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        guard let currentLocation = locationManager.location else {
            print("need valid coords before submitting post")
            showNoValidLocation()
            //getLocation()
            return false
        }
        location = currentLocation
        print("passing valid coords")
        return true
    }
}

//MARK: - MapViewDelegate
extension MapViewController : MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !(annotation is MKUserLocation) else {
            return nil
        }
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "custom")
        
        if annotationView == nil {
            //create the view
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "custom")
            annotationView?.canShowCallout = true
            annotationView?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            
        } else {
            annotationView?.annotation = annotation
        }
        annotationView?.image = UIImage(named: "GarbageBag")
        
        return annotationView
    }

    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        // This illustrates how to detect which annotation type was tapped on for its callout.
        if let annotation = view.annotation as? TaggedLocationAnnotation, annotation.isKind(of: TaggedLocationAnnotation.self) {
            print("tapped detail callout button")
            performSegue(withIdentifier: "ShowDetail", sender: annotation)
            
        }
    }
}

//MARK: - CLLocationManagerDelegate
extension MapViewController : CLLocationManagerDelegate {
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authStatus = manager.authorizationStatus
        switch authStatus {
        case .authorizedWhenInUse:  // Location services are available
            getLocation()
            break
               
        case .restricted, .denied:  // Location services currently unavailable.
            showLocationServicesDeniedAlert()
            break
               
        case .notDetermined:        // Authorization not determined yet.
            manager.requestWhenInUseAuthorization()
            break
               
        default:
            break
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("didFailWithError \(error.localizedDescription)")
        
        if (error as NSError).code == CLError.locationUnknown.rawValue {
            print("Location Unknown")
            return
        }
        
        locationError = error
        stopLocationManager()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let newLocation = locations.last!
        print("didUpdateLocations \(newLocation)")
        
        if newLocation.timestamp.timeIntervalSinceNow < -5 {
            return
        }
        
        if newLocation.horizontalAccuracy < 0 {
            return
        }
        
        if location == nil || location!.horizontalAccuracy > newLocation.horizontalAccuracy {
            //new location to be used, clear error
            locationError = nil
            location = newLocation
            
            //current location and new location accuracy the same, stop updating location
            if newLocation.horizontalAccuracy <= locationManager.desiredAccuracy {
                print("locations similar")
                stopLocationManager()
            }
        }
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
    }
    
    //need to clean up this function, breakout authorization with status, etc.
    func getLocation() {
        if updatingLocation {
            //print(location!)
            stopLocationManager()
        } else {
            location = nil
            locationError = nil
            startLocationManager()
        }
    }
    
    func startLocationManager() {
        print("starting location services")
        checkLocationManagerAuthStatus()
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.startUpdatingLocation()
        updatingLocation = true
        timer = Timer.scheduledTimer(
            timeInterval: 30,
            target: self,
            selector: #selector(didTimeOut),
            userInfo: nil,
            repeats: false)
    }
    
    func checkLocationManagerAuthStatus() {
        let authStatus = locationManager.authorizationStatus
        switch authStatus {
        case .authorizedWhenInUse:  // Location services are available
            print("authorized to record locationr")
            break
            
        case .restricted, .denied:  // Location services currently unavailable.
            showLocationServicesDeniedAlert()
            break
            
        case .notDetermined:        // Authorization not determined yet.
            locationManager.requestWhenInUseAuthorization()
            break
            
        default:
            break
        }
    }
    
    func zoomUserLocation() {
        if let userLocation = locationManager.location?.coordinate {
            let region = MKCoordinateRegion(
                center: userLocation,
                latitudinalMeters: 500,
                longitudinalMeters: 500)
                mapView.setRegion(mapView.regionThatFits(region), animated: true)
            print("Zooming to user location")
        } else {
            print("no valid location")
        }
    }

    @objc func didTimeOut() {
        print("***Time Out***")
        if location == nil {
            stopLocationManager()
            locationError = NSError(domain: "MyLocationsErrorDomain", code: 1, userInfo: nil)
        }
    }
    
    func showLocationServicesDeniedAlert() {
        let ac = UIAlertController(title: "Location Services Disable", message: "Please enable location services for this app in Settings.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        ac.addAction(okAction)
        
        present(ac, animated: true, completion: nil)
    }
    
    func showNoValidLocation() {
        let ac = UIAlertController(title: "No valid location", message: "Please check your phone's location services in Settings.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        ac.addAction(okAction)
        
        present(ac, animated: true, completion: nil)
    }
}
