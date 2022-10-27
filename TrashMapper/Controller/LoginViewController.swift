//
//  LoginViewController.swift
//  TrashMapper
//
//  Created by Jacob Case on 8/7/22.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class LoginViewController: UIViewController {
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpElements()
    }
    
    @IBAction func loginTap(_ sender: Any) {
        
        //validate the fields
        let error = validateFields()
        
        if error != nil {
            showError(error!)
        } else {
            
            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let pw = (passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines))!
        
            Auth.auth().signIn(withEmail: email, password: pw) { [self] (result, err) in
                if err != nil {
                    showError(err!.localizedDescription)
                } else {
                    self.transitionToHome()
                }
            }
        }
    }
        
    func showError(_ message:String) {
        errorLabel.text = message
        errorLabel.alpha = 1
    }
        
    //checks fields for valid data. If correct, returns nil
    func validateFields() -> String? {
        
        //chekc that all fields are filled in
        if emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return "Please fill in all fields."
        }
        return nil
    }
    
    func transitionToHome() {
        let mainViewController = storyboard?.instantiateViewController(withIdentifier: K.StoryBoard.mainViewController) as? UITabBarController
        
        view.window?.rootViewController = mainViewController
        view.window?.makeKeyAndVisible()
    }
    
    
    func setUpElements() {
        //hide error label
        errorLabel.alpha = 0
        FormUtlities.styleRegularButton(loginButton)
        FormUtlities.styleEmailPlaceHolderTextField(emailTextField)
        FormUtlities.stylePasswordPlaceHolderTextField(passwordTextField)
        FormUtlities.setupBackgroundColor(self.view)

    }
}