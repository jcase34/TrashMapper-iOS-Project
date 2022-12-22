//
//  WelcomeViewController.swift
//  TrashMapper
//
//  Created by Jacob Case on 8/7/22.
//

import UIKit
import Lottie

class WelcomeViewController: UIViewController {
        
    @IBOutlet weak var signUpButton: UIButton!
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var welcomeTitle: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupElements()
        setupLottie(withAnimation: "map-points")
        welcomeTitle.center.x -= view.bounds.width
        welcomeTitle.shadowColor = .black
        welcomeTitle.shadowOffset = CGSize(width: 3, height: 3)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func setupLottie(withAnimation animation: String) {
        let mapAnimationView = AnimationView()
        let mapAnimation = Animation.named(animation)
        mapAnimationView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(mapAnimationView)
        mapAnimationView.animation = mapAnimation
        NSLayoutConstraint.activate([
            mapAnimationView.widthAnchor.constraint(equalToConstant: 350),
            mapAnimationView.heightAnchor.constraint(equalToConstant: 350),
            mapAnimationView.bottomAnchor.constraint(equalTo: signUpButton.topAnchor, constant: -20),
            mapAnimationView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
        ])
        mapAnimationView.play()
    }
    
    func setupElements() {
        self.view.backgroundColor = .systemBlue
        FormUtlities.setTextColor(welcomeTitle)
        FormUtlities.styleFilledButton(signUpButton)
        FormUtlities.styleHallowButton(loginButton)
        FormUtlities.setupBackgroundColor(self.view)
        UIView.animate(withDuration: 1) {
          self.welcomeTitle.center.x += self.view.bounds.width
        }
        
        
    }
    
    
}
