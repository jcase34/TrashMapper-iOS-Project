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
import Lottie

class SignUpViewController : UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var signUpButton: UIButton!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLottie(withAnimation: "login-and-sign-up")
        setUpElements()
    }
    @IBOutlet weak var aniView: UIView!
    
    func setupLottie(withAnimation animation: String) {
        let signUpAnimationView = AnimationView()
        let signUpAnimation = Animation.named(animation)
        signUpAnimationView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(signUpAnimationView)
        signUpAnimationView.animation = signUpAnimation
        NSLayoutConstraint.activate([
            signUpAnimationView.widthAnchor.constraint(equalToConstant: 350),
            signUpAnimationView.heightAnchor.constraint(equalToConstant: 350),
            signUpAnimationView.bottomAnchor.constraint(equalTo: emailTextField.topAnchor, constant: -25),
            signUpAnimationView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
        ])
        signUpAnimationView.play()
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
        FormUtlities.styleRegularButton(signUpButton)
        FormUtlities.styleEmailPlaceHolderTextField(emailTextField)
        FormUtlities.stylePasswordPlaceHolderTextField(passwordTextField)
        FormUtlities.setupBackgroundColor(self.view)
        
    }
    
    
    
    
    
}
