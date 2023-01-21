//
//  DetailViewController.swift
//  TrashMapper
//
//  Created by Jacob Case on 11/18/22.
//

import UIKit
import SDWebImage
import FirebaseStorage
import FirebaseAuth
import FirebaseFirestore

class DetailViewController: UIViewController {
    
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var detailView: UIView!
    @IBOutlet weak var createdAtLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var closeButton: UIButton!
    var postDetails: [String:String] = [:]

    override func viewDidLoad() {
        super.viewDidLoad()
        setupElements()
        
        detailView.layer.cornerRadius = 15
        FirebaseDataManager.shared.downloadImage(postDetails["postImageURL"]!) {image in
            self.postImage.image = image
        }
        titleLabel.text = postDetails["postTitle"]
        subtitleLabel.text = postDetails["postSubtitle"]
    }
    
    @IBAction func close() {
        dismiss(animated: true, completion: nil)
    }
    
    func setupElements() {
        FormUtlities.setTextColor(titleLabel)
        FormUtlities.setTextColor(createdAtLabel)
        FormUtlities.setTextColor(subtitleLabel)
        FormUtlities.setTextColor(descriptionLabel)
        //FormUtlities.styleHallowButton(closeButton)
        FormUtlities.setupBackgroundColor(detailView)
        
    }
    
}
