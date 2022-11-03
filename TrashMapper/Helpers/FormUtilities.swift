//
//  FormUtilities.swift
//  TrashMapper
//
//  Created by Jacob Case on 8/7/22.
//

import Foundation
import UIKit

class FormUtlities {
    
    static var mainColor = UIColor.init(red: 200/255, green: 220/255, blue: 200/255, alpha: 1)
    
    static func styleEmailPlaceHolderTextField(_ textfield: UITextField) {
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0, y: textfield.frame.height-2, width: textfield.frame.width, height: 2)
        bottomLine.backgroundColor = UIColor.init(red: 200/255, green: 220/255, blue: 200/255, alpha: 1).cgColor
        textfield.borderStyle = .none
        textfield.layer.addSublayer(bottomLine)
        textfield.attributedPlaceholder = NSAttributedString(
            string: "Email",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(red: 200/255, green: 220/255, blue: 200/255, alpha: 1)]
        )
        textfield.textColor = UIColor.init(red: 200/255, green: 220/255, blue: 200/255, alpha: 1)
    }
    
    static func stylePasswordPlaceHolderTextField(_ textfield: UITextField) {
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0, y: textfield.frame.height-2, width: textfield.frame.width, height: 2)
        bottomLine.backgroundColor = UIColor.init(red: 200/255, green: 220/255, blue: 200/255, alpha: 1).cgColor
        textfield.borderStyle = .none
        textfield.layer.addSublayer(bottomLine)
        textfield.attributedPlaceholder = NSAttributedString(
            string: "Password",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(red: 200/255, green: 220/255, blue: 200/255, alpha: 1)]
        )
        textfield.textColor = UIColor.init(red: 200/255, green: 220/255, blue: 200/255, alpha: 1)
    }

    static func styleFilledButton(_ button: UIButton) {
        button.backgroundColor = UIColor.init(red: 200/255, green: 220/255, blue: 200/255, alpha: 1)
        button.layer.cornerRadius = 20
        button.tintColor = UIColor.black
               
    }
    
    static func styleRegularButton(_ button: UIButton) {
        button.tintColor = UIColor.init(red: 200/255, green: 220/255, blue: 200/255, alpha: 1)
    }
    
    static func styleHallowButton(_ button: UIButton) {
        button.layer.borderWidth = 2
        button.layer.borderColor = CGColor.init(red: 200/255, green: 220/255, blue: 200/255, alpha: 1)
        button.layer.cornerRadius = 20
        button.tintColor = UIColor.init(red: 200/255, green: 220/255, blue: 200/255, alpha: 1)
               
    }
    
    static func setTextColor(_ label: UILabel) {
        label.textColor = UIColor.init(red: 200/255, green: 220/255, blue: 200/255, alpha: 1)
    }
    
    static func setupBackgroundColor(_ view: UIView) {
        view.backgroundColor = .systemBlue
    }
    
    static func toggleSecurePasswordAndIcon(_ passwordTextField: DesignableUITextField, _ tapGestureRecognizer: UITapGestureRecognizer) {
        if passwordTextField.isSecureTextEntry {
            passwordTextField.rightImage = UIImage(systemName: "eye")
            passwordTextField.isSecureTextEntry = false
            passwordTextField.rightView?.isUserInteractionEnabled = true
            passwordTextField.rightView?.addGestureRecognizer(tapGestureRecognizer)

        } else {
            passwordTextField.rightImage = UIImage(systemName: "eye.slash")
            passwordTextField.isSecureTextEntry = true
            passwordTextField.rightView?.isUserInteractionEnabled = true
            passwordTextField.rightView?.addGestureRecognizer(tapGestureRecognizer)
        }
        
    }
    
    
}
