//
//  TagLocationViewController.swift
//  TrashMapper
//
//  Created by Jacob Case on 5/28/22.
//

import UIKit
import CoreLocation

class LocationDetailsViewController: UITableViewController {
    
    
    
    @IBAction func addPhoto(_ sender: Any) {
        print("add photo tapped")
    }
    @IBAction func cancel(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func submit(_ sender: Any) {
        print("submit tapped")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("At Location details view controller")
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
    }

    
    
}

