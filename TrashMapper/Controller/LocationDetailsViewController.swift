//
//  TagLocationViewController.swift
//  TrashMapper
//
//  Created by Jacob Case on 5/28/22.
//

import UIKit
import CoreLocation

class LocationDetailsViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CLLocationManagerDelegate {
    
    
    
    
    

    var image: UIImage?
    
    
    @IBAction func cancel(_ sender: Any) {
        navigationController?.popViewController(animated: true)
        
    }

    @IBAction func addPhoto(_ sender: Any) {
        print("add photo tapped")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
