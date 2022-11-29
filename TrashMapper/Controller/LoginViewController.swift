//
//  LoginViewController.swift
//  TrashMapper
//
//  Created by Jacob Case on 8/7/22.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import Lottie

class LoginViewController: UIViewController {
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: DesignableUITextField!
    @IBOutlet weak var personIcon: UIImageView!
    @IBOutlet weak var keyIcon: UIImageView!
    
    var iconClick = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpElements()
        setupLottie(withAnimation: "login-and-sign-up")
        self.navigationController?.navigationBar.tintColor = FormUtlities.mainColor
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(passwordIconTap(_:)))
        passwordTextField.rightView?.isUserInteractionEnabled = true
        passwordTextField.rightView?.addGestureRecognizer(tapGestureRecognizer)
        
        self.hideKeyboardWhenTappedAround()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)

    }
    
    @objc func passwordIconTap(_ tapGestureRecognizer: UITapGestureRecognizer) {
        FormUtlities.toggleSecurePasswordAndIcon(passwordTextField, tapGestureRecognizer)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    func setupLottie(withAnimation animation: String) {
        let signUpAnimationView = AnimationView()
        let signUpAnimation = Animation.named(animation)
        signUpAnimationView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(signUpAnimationView)
        signUpAnimationView.animation = signUpAnimation
        NSLayoutConstraint.activate([
            signUpAnimationView.widthAnchor.constraint(equalToConstant: 350),
            signUpAnimationView.heightAnchor.constraint(equalToConstant: 350),
            signUpAnimationView.bottomAnchor.constraint(equalTo: emailTextField.topAnchor, constant: -40),
            signUpAnimationView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
        ])
        signUpAnimationView.play()
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
                    
                    /*
                     Add loading button for sign out
                     */
                    self.transitionToMainApp()
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
    
    func transitionToMainApp() {
        let mainAppVC = storyboard?.instantiateViewController(withIdentifier: K.StoryBoard.mainAppVC) as? UITabBarController
        
        view.window?.rootViewController = mainAppVC
        view.window?.makeKeyAndVisible()
    }
    
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//            self.view.endEditing(true)
//            return false
//        }
//
    
    func setUpElements() {
        //hide error label
        errorLabel.alpha = 0
        FormUtlities.styleRegularButton(loginButton)
        FormUtlities.styleEmailPlaceHolderTextField(emailTextField)
        FormUtlities.stylePasswordPlaceHolderTextField(passwordTextField)
        FormUtlities.setupBackgroundColor(self.view)
        personIcon.tintColor = FormUtlities.mainColor
        keyIcon.tintColor = FormUtlities.mainColor

    }
}

extension LoginViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)

    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
