//
//  WelcomeViewController.swift
//  TrashMapper
//
//  Created by Jacob Case on 8/7/22.
//

import UIKit
import AVKit

class WelcomeViewController: UIViewController {
    
    var videoPlayer: AVPlayer?
    
    var videoPlayerLayer: AVPlayerLayer?
    
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "TrashMapper"
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setUpVideo()
    }
    

    func setUpVideo() {
        
        let bundlePath = Bundle.main.path(forResource: "introvid", ofType: "mp4")
        guard bundlePath != nil else {return}
        print(bundlePath)
        let url = URL(fileURLWithPath: bundlePath!)
        let item = AVPlayerItem(url: url)

        videoPlayer = AVPlayer(playerItem: item)

        
        videoPlayerLayer = AVPlayerLayer(player: videoPlayer)
        
        videoPlayerLayer?.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        
        view.layer.insertSublayer(videoPlayerLayer!, at: 0)
        
        videoPlayer?.playImmediately(atRate: 0.8)
        
    }
    
    
}
