//
//  UserProfileViewController.swift
//  TrashMapper
//
//  Created by Jacob Case on 5/27/22.
//

import UIKit

class UserProfileViewController: UIViewController {

    @IBOutlet weak var userProfileTitle: UILabel!
    
    @IBOutlet weak var logOutButton: UIButton!
    @IBOutlet weak var deleteAccountButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        print("at userprofile controller")
        setupElements()
        
        
    }
    
    func setupElements() {
        FormUtlities.setTextColor(userProfileTitle)
        FormUtlities.styleFilledButton(logOutButton)
        FormUtlities.styleHallowButton(deleteAccountButton)
        FormUtlities.setupBackgroundColor(self.view)
        
        
    }
    
}
