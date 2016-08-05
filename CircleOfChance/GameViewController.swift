//
//  GameViewController.swift
//  CircleOfChance
//
//  Created by Mac on 7/13/16.
//  Copyright (c) 2016 KJB Apps LLC. All rights reserved.
//

import UIKit
import SpriteKit
import GoogleMobileAds
import GameKit

class GameViewController: UIViewController, GKGameCenterControllerDelegate{
    
    var googleBannerView : GADBannerView!
    var leaderboardIdentifier: String? = nil
    var gameCenterEnabled: Bool = false
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        if NSUserDefaults.standardUserDefaults().objectForKey("musicOn") == nil {
             SKTAudio.sharedInstance().playBackgroundMusic("bgMusic.wav")
        }
        else if NSUserDefaults.standardUserDefaults().objectForKey("musicOn") as! Bool == false {
            SKTAudio.sharedInstance().pauseBackgroundMusic()
        }
        
        else if NSUserDefaults.standardUserDefaults().objectForKey("musicOn") as! Bool == true {
            SKTAudio.sharedInstance().playBackgroundMusic("bgMusic.wav")
        }
        
        
        if NSUserDefaults.standardUserDefaults().objectForKey("soundOn") == nil {
            GameScene.soundOn = true
        }
        else if NSUserDefaults.standardUserDefaults().objectForKey("soundOn") as! Bool == false {
            GameScene.soundOn = false
        }
        
        else if NSUserDefaults.standardUserDefaults().objectForKey("soundOn") as! Bool == true {
            GameScene.soundOn = true
        }
        
        if let scene = MainMenu(fileNamed:"GameScene") {
            
            // Configure the view.
            let skView = self.view as! SKView
            skView.showsFPS = true
            skView.showsNodeCount = true
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .AspectFill
            let transition = SKTransition.fadeWithDuration(0.8)
            skView.presentScene(scene, transition: transition)
        }

        
        if Chartboost.hasRewardedVideo(CBLocationIAPStore) == false {
            Chartboost.cacheRewardedVideo(CBLocationIAPStore)
            
        }
        loadBanner()

    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        authenticateLocalPlayer()
    }
    
    func loadBanner() {
        googleBannerView = GADBannerView(adSize: kGADAdSizeSmartBannerPortrait)
        googleBannerView.adUnitID = "ca-app-pub-7649281918688809/7940530179"
        googleBannerView.rootViewController = self
        
        let request:GADRequest = GADRequest()
        request.testDevices = [kGADSimulatorID, "ada15951f72c9f6e621f23e6dc7118d6"]
        googleBannerView.loadRequest(request)
        
        googleBannerView.frame = CGRectMake(0, view.bounds.height - googleBannerView.frame.size.height, googleBannerView.frame.size.width, googleBannerView.frame.size.height)
        
        self.view.addSubview(googleBannerView!)
        
        bannerHeight = googleBannerView.frame.size.height
    }
    
    func authenticateLocalPlayer() {
        let localPlayer = GKLocalPlayer.localPlayer()
        localPlayer.authenticateHandler = {(viewController : UIViewController?, error : NSError?) -> Void in
            
            if viewController != nil {
                
                self.presentViewController(viewController!, animated: true, completion: nil)
                
            }
        }
    }
    
    func gameCenterViewControllerDidFinish(gameCenterViewController: GKGameCenterViewController)
    {
        
        gameCenterViewController.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    override func shouldAutorotate() -> Bool {
        return true
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return .Portrait
        }
        else {
            return .Portrait
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
