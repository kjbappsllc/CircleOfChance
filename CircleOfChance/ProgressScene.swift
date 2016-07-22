//
//  ProgressScene.swift
//  Circle Of Chance
//
//  Created by Mac on 7/12/16.
//  Copyright © 2016 KJBApps. All rights reserved.
//

import Foundation
import SpriteKit
import GameKit

class ProgressScene: SKScene, GKGameCenterControllerDelegate {
    var achievementProgress = CGFloat()
    var achievementTextProgress = CGFloat()
    var gameCenterAchievements = [String:GKAchievement]()
    var count = CGFloat()
    var rounded = CGFloat()
    
    var backButton = SKSpriteNode()
    var progressText = SKLabelNode()
    let percentNotifier = SKLabelNode()
    var achievementText = SKLabelNode()
    
    var bestScore = SKLabelNode()
    var highScore = String()
    var totalCoinsEarned = SKLabelNode()
    var totalGamesPlayed = SKLabelNode()
    var currency = CurrencyManager()
    
    var gamecenterbutton = SKSpriteNode()
    
    override func didMoveToView(view: SKView){
        loadAchievementPercentages()
        scene?.backgroundColor = UIColor(red: 31/255, green: 30/255, blue: 30/255, alpha: 1.0)
        loadView()
    }
    
    func loadView() {
        
        progressText.fontName = "DayPosterBlack"
        progressText.fontSize = 42.0
        progressText.text = "Progress"
        progressText.fontColor = UIColor.whiteColor()
        progressText.position = CGPoint(x: self.frame.width/2 + 35, y: self.frame.height - 95)
        self.addChild(progressText)
        
        percentNotifier.position = CGPoint(x: self.frame.width/2, y: self.frame.height/2 + 20)
        percentNotifier.fontName = "DayPosterBlack"
        percentNotifier.fontColor = SKColor.whiteColor()
        percentNotifier.fontSize = 26.0
        self.addChild(percentNotifier)
        
        backButton = SKSpriteNode(imageNamed: "backButton")
        backButton.anchorPoint = CGPoint(x: 1.0, y: 0.5)
        backButton.position = CGPoint(x: progressText.position.x - progressText.frame.width/2 - 50 , y: progressText.position.y + 20)
        backButton.size = CGSize(width: backButton.size.width - 15, height: backButton.size.height - 15)
        self.addChild(backButton)
        
        achievementText.fontName = "DayPosterBlack"
        achievementText.fontSize = 28.0
        achievementText.text = "Achievements"
        achievementText.fontColor = UIColor(red: 133/255, green: 0, blue: 241/255, alpha: 1.0)
        achievementText.position = CGPoint(x: self.frame.width/2 , y: self.frame.height/2 + 140)
        self.addChild(achievementText)
        
        bestScore.fontSize = 18.0
        bestScore.fontName = "DayPosterBlack"
        
        if NSUserDefaults.standardUserDefaults().integerForKey("highscore") != 0 {
            highScore = String(NSUserDefaults.standardUserDefaults().integerForKey("highscore"))
        }
        else{
            highScore = "0"
        }

        bestScore.text = "Best Score:     \(highScore)"
        bestScore.position = CGPoint(x: self.frame.width/2 - 41, y: self.frame.height/2 - 120)
        self.addChild(bestScore)
        
        totalCoinsEarned.fontName = "DayPosterBlack"
        totalCoinsEarned.fontSize = 18.0
        totalCoinsEarned.text = "Total Coins Earned:     \(currency.totalCoins)"
        totalCoinsEarned.position = CGPoint(x: self.frame.width/2 - 10, y: self.frame.height/2 - 150)
        self.addChild(totalCoinsEarned)
        
        totalGamesPlayed.fontName = "DayPosterBlack"
        totalGamesPlayed.fontSize = 18.0
        totalGamesPlayed.text = "Total Games Played:     \(currency.games)"
        totalGamesPlayed.position = CGPoint(x: self.frame.width/2 - 10, y: self.frame.height/2 - 180)
        self.addChild(totalGamesPlayed)
        
        gamecenterbutton = SKSpriteNode(imageNamed: "gamecenterbutton")
        gamecenterbutton.anchorPoint = CGPoint(x: 0.5, y: 0)
        gamecenterbutton.position = CGPoint(x: self.frame.width/2, y: bannerHeight + 30)
        self.addChild(gamecenterbutton)
        
    }
    
    func loadAchievementPercentages() {
        
        if GKLocalPlayer.localPlayer().authenticated {
            GKAchievement.loadAchievementsWithCompletionHandler { (allAchievements, error) -> Void in
                
                let progress = CircularProgressNode(radius: 80, color: UIColor(red: 133/255, green: 0, blue: 241/255, alpha: 1.0) , width: 20)
                
                if error != nil {
                    print("GC could not load ach, error:\(error)")
                    let noConnection = SKLabelNode()
                    noConnection.fontName = "DayPosterBlack"
                    noConnection.fontSize = 40.0
                    noConnection.fontColor = SKColor.grayColor()
                    noConnection.text = "Not Connected"
                    noConnection.position = CGPoint(x: self.frame.width/2, y: self.frame.height/2)
                    self.addChild(noConnection)
                    
                }
                else
                {
                    //nil if no progress on any achiement
                    if(allAchievements != nil) {
                        for theAchiement in allAchievements! {
                            
                            if let singleAchievement:GKAchievement = theAchiement {
                                
                                self.gameCenterAchievements[singleAchievement.identifier!] = singleAchievement
                            }
                        }
                    }
                    
                    for(id,achievement) in self.gameCenterAchievements {
                        if achievement.completed {
                            self.count += 1
                        }
                        print("\(id) - \(achievement.percentComplete)")
                    }
                    self.achievementProgress = ((16 - self.count) / 16)
                    self.achievementTextProgress = self.count / 16
                    self.rounded = self.achievementTextProgress.roundToPlaces(2)
                    
                    self.percentNotifier.text = "\((self.rounded * 100))%"
                    
                    progress.zPosition = 5
                    progress.position = CGPoint(x: self.frame.width/2, y: self.frame.height/2 + 35)
                    progress.updateProgress(self.achievementProgress)
                    self.addChild(progress)
                }
            }
        }
        else {
            let noConnection = SKLabelNode()
            noConnection.fontName = "DayPosterBlack"
            noConnection.fontSize = 40.0
            noConnection.fontColor = SKColor.grayColor()
            noConnection.text = "Not Connected"
            noConnection.position = CGPoint(x: self.frame.width/2, y: self.frame.height/2)
            self.addChild(noConnection)
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let touch = touches.first{
            let touchLocation = touch.locationInNode(self)
            if backButton.containsPoint(touchLocation) {
                backButton.alpha = 0.5
            }
            else {
                backButton.alpha = 1.0
            }
            
            if gamecenterbutton.containsPoint(touchLocation) {
                showLeaderOrAchievements(GKGameCenterViewControllerState.Achievements)
            }
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let touch = touches.first{
            let touchLocation = touch.locationInNode(self)
            
            if backButton.containsPoint(touchLocation) && backButton.alpha != 1 {
                if GameScene.soundOn == true {
                    self.scene?.runAction(buttonTouched)
                }
                if let scene = MainMenu(fileNamed:"GameScene") {
                    
                    // Configure the view.
                    let skView = self.view as SKView!
                    skView.showsFPS = true
                    skView.showsNodeCount = true
                    /* Sprite Kit applies additional optimizations to improve rendering performance */
                    skView.ignoresSiblingOrder = true
                    /* Set the scale mode to scale to fit the window */
                    scene.scaleMode = .AspectFill
                    let transition = SKTransition.fadeWithDuration(0.8)
                    skView.presentScene(scene, transition: transition)
                }
            }
            else {
                backButton.alpha = 1.0
            }
        }
    }
    
    func showLeaderOrAchievements(state:GKGameCenterViewControllerState) {
        let viewControllerVar = self.view?.window?.rootViewController
        let gKGCViewController = GKGameCenterViewController()
        gKGCViewController.gameCenterDelegate = self
        
        gKGCViewController.viewState = GKGameCenterViewControllerState.Achievements
        viewControllerVar?.presentViewController(gKGCViewController, animated: true, completion: nil)
    }
    
    func gameCenterViewControllerDidFinish(gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismissViewControllerAnimated(true, completion: nil)
    }
}