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
        setupLottie()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        welcomeTitle.center.x -= view.bounds.width
        
    }
    
    func setupBackground() {
        self.view.backgroundColor = .systemBlue
        
    }
    
    func setupLottie() {
        self.view.backgroundColor = .systemBlue
        let mapAnimationView = AnimationView()
        /// Some time later
        let mapAnimation = Animation.named("map-points")
        mapAnimationView.animation = mapAnimation
        mapAnimationView.frame = CGRect(x: 0, y: 0, width: 400, height: 400)
        mapAnimationView.center = self.view.center
        mapAnimationView.contentMode = .scaleAspectFill
        
        self.view.addSubview(mapAnimationView)
        
        mapAnimationView.play()
    }
    
    func setupElements() {
        setupBackground()
        UIView.animate(withDuration: 1) {
          self.welcomeTitle.center.x += self.view.bounds.width
        }
        
        FormUtlities.setTextColor(welcomeTitle)
        FormUtlities.styleFilledButton(signUpButton)
        FormUtlities.styleHallowButton(loginButton)
    }
    
    
}
