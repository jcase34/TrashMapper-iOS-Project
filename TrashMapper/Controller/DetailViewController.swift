//
//  DetailViewController.swift
//  TrashMapper
//
//  Created by Jacob Case on 11/18/22.
//

import UIKit

class DetailViewController: UIViewController {
    
    var imageURL: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        print("Image URL Received at detail: \(imageURL)")
    }
    
    @IBAction func close() {
        dismiss(animated: true, completion: nil)
    }
    
}
