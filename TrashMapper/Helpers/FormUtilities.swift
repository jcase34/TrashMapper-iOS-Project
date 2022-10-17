//
//  FormUtilities.swift
//  TrashMapper
//
//  Created by Jacob Case on 8/7/22.
//

import Foundation
import UIKit

class FormUtlities {
    
    static func styleTextField(_ textfield: UITextField) {
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0, y: textfield.frame.height-2, width: textfield.frame.width, height: 2)
        bottomLine.backgroundColor = UIColor.init(red: 200/255, green: 220/255, blue: 200/255, alpha: 1).cgColor
        textfield.borderStyle = .none
        textfield.layer.addSublayer(bottomLine)
        textfield.textColor = .black
        
    }
    
    static func styleFilledButton(_ button: UIButton) {
        button.backgroundColor = UIColor.init(red: 200/255, green: 220/255, blue: 200/255, alpha: 1)
        button.layer.cornerRadius = 20
        button.tintColor = UIColor.black
               
    }
    
    static func styleHallowButton(_ button: UIButton) {
        button.layer.borderWidth = 2
        button.layer.borderColor = CGColor.init(red: 255/255, green: 220/255, blue: 210/255, alpha: 1)
        button.layer.cornerRadius = 20
        button.tintColor = UIColor.init(red: 200/255, green: 220/255, blue: 200/255, alpha: 1)
               
    }
    
    static func setTextColor(_ label: UILabel) {
        label.tintColor = UIColor.init(red: 200/255, green: 220/255, blue: 200/255, alpha: 1)
    }
    
}
