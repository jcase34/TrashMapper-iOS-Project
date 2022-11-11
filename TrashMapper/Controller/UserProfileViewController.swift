//
//  UserProfileViewController.swift
//  TrashMapper
//
//  Created by Jacob Case on 5/27/22.
//

import UIKit
import FirebaseAuth


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
    
    @IBAction func logOutButtonTap(_ sender: UIButton) {
        print("logout tap")
        let firebaseAuth = Auth.auth()
        do {
            print("user logged out")
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
        transitionToWelcomeVC()
        
    }
    
    
    @IBAction func deleteAccountButtonTap(_ sender: UIButton) {
        let user = Auth.auth().currentUser
            user?.delete { error in
              if let error = error {
                  print("error deleting account \(error.localizedDescription)")
              } else {
                  print("Account successfully deleted")
                  /*
                   Add loading button for sign out
                   */
                  self.transitionToWelcomeVC()
              }
            }
        
    }
    
    func transitionToWelcomeVC() {
        let welcomeVC = storyboard?.instantiateViewController(withIdentifier: K.StoryBoard.welcomeVC) as? UINavigationController
        view.window?.rootViewController = welcomeVC
        view.window?.makeKeyAndVisible()
    }
    
    
    func setupElements() {
        FormUtlities.setTextColor(userProfileTitle)
        FormUtlities.styleFilledButton(logOutButton)
        FormUtlities.styleHallowButton(deleteAccountButton)
        FormUtlities.setupBackgroundColor(self.view)
        
    }
    
}
