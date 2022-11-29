//
//  DetailViewController.swift
//  TrashMapper
//
//  Created by Jacob Case on 11/18/22.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let image = imageView.image {
            preferredContentSize = image.size
        }
    }
    
    @IBAction private func doneAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
