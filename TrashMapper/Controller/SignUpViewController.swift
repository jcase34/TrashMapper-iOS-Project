//
//  SignInViewController.swift
//  TrashMapper
//
//  Created by Jacob Case on 6/30/22.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseFirestore

class SignUpViewController : UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var signUpButton: UIButton!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpElements()
    }
    
    
    //checks fields for valid data. If correct, returns nil
    func validateFields() -> String? {
        
        //chekc that all fields are filled in
        
        if emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return "Please fill in all fields."
        }
        
        return nil
        
    }
    
    @IBAction func signUpTap(_ sender: Any) {
        //validate the fields
        let error = validateFields()
        
        if error != nil {
            showError(error!)
        } else {
            
            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let pw = (passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines))!
            
            
            
            Auth.auth().createUser(withEmail: email, password: pw) { (result, err) in
                if err != nil {
                    self.showError(err!.localizedDescription)
                } else {
                    
                    let db = Firestore.firestore()
                    db.collection("users").addDocument(data: ["email":email, "uid":result!.user.uid]) { (error) in
                        
                        if error != nil {
                            self.showError("Saving data failed.")
                        }
                    }
                    self.transitionToHome()
                    
                }
            }
        }
        
        
        //transition
        
        
    }
    
    func transitionToHome() {
        let mainViewController = storyboard?.instantiateViewController(withIdentifier: K.StoryBoard.mainViewController) as? UITabBarController
        
        view.window?.rootViewController = mainViewController
        view.window?.makeKeyAndVisible()
    }
    
    func showError(_ message:String) {
        errorLabel.text = message
        errorLabel.alpha = 1
    }
    
    
    func setUpElements() {
        //hide error label
        errorLabel.alpha = 0
        
        
    }
    
    
    
    
    
}
