//
//  GameOver.swift
//  Circle of Chance
//
//  Created by Mac on 6/6/16.
//  Copyright (c) 2016 KJB Apps LLC. All rights reserved.
//

import SpriteKit
import GameKit

class GameOver: SKScene, ChartboostDelegate {
    //layers
    let gameOverLayer = SKNode()
    
    //buttons
    var homeButton = SKSpriteNode()
    var replay = SKSpriteNode()
    var movieButton = SKSpriteNode()
    
    //Design
    var gameOverSign = SKSpriteNode()
    var coinsBox = SKSpriteNode()
    var coinsMade = Int()
    var currency = CurrencyManager()
    var coinLabel = SKLabelNode()
    
    var score = SKLabelNode()
    
    var highscoreRect = SKSpriteNode()
    var highscoreTitle = SKLabelNode()
    var highscore = SKLabelNode()
    
    var coinsMadeNotifier = SKLabelNode()
    
    //GameCenter
    var gameCenterAchievements = [String:GKAchievement]()
    
    override func didMoveToView(view: SKView) {
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        addChild(gameOverLayer)
        Chartboost.setDelegate(self)
        
        loadView()
        
        if Chartboost.hasRewardedVideo(CBLocationGameOver) == true {
            
            let scale = SKAction.scaleTo(1.1, duration: 0.5)
            let scaleback = SKAction.scaleTo(1.0, duration: 0.5)
            let pulsing = SKAction.sequence([scale,scaleback])
            movieButton.runAction(SKAction.repeatActionForever(pulsing))
        }

    }
    
    
    
    func loadView() {
        addBackground()
        addGameOver()
        
        if NSUserDefaults.standardUserDefaults().boolForKey("com.KJBApps.CircleOfChance.doublecoins") == false {
            //coinsMade = GameScene.scoreInt / 8
            
            coinsMadeNotifier.fontName = "DayPosterBlack"
            coinsMadeNotifier.fontSize = 26.0
            coinsMadeNotifier.position = CGPoint(x: coinLabel.position.x - 10, y: coinLabel.position.y - 40)
            coinsMadeNotifier.fontColor = SKColor(red: 133/255, green: 0, blue: 241/255, alpha: 1.0)
            self.addChild(coinsMadeNotifier)
        }
        
        else if NSUserDefaults.standardUserDefaults().boolForKey("com.KJBApps.CircleOfChance.doublecoins") == true {
            //coinsMade = (GameScene.scoreInt / 16) * 2
            
            coinsMadeNotifier.fontName = "DayPosterBlack"
            coinsMadeNotifier.fontSize = 26.0
            coinsMadeNotifier.position = CGPoint(x: coinLabel.position.x - 10, y: coinLabel.position.y - 40)
            coinsMadeNotifier.fontColor = SKColor(red: 223/255, green: 147/255, blue: 0, alpha: 1.0)
            self.addChild(coinsMadeNotifier)
            
            let doubleC = SKLabelNode()
            doubleC.fontName = "DayPosterBlack"
            doubleC.fontSize = 14.0
            doubleC.position = CGPoint(x: coinsMadeNotifier.position.x + 10, y: coinsMadeNotifier.position.y - 25)
            doubleC.fontColor = SKColor(red: 223/255, green: 147/255, blue: 0, alpha: 1.0)
            doubleC.text = "x2"
            self.addChild(doubleC)
        }
        
        if coinsMade < 0 {
            coinsMade = 0
        }
        
        currency.coins += coinsMade
        currency.totalCoins += coinsMade
        
        if currency.totalCoins >= 1000 {
            incrementCurrentPercentageOfAchievement("achievement_1000coins", amount: 100.0)
        }
        
        if currency.totalCoins >= 3000 {
            incrementCurrentPercentageOfAchievement("achievement_3000coins", amount: 100.0)
        }
        
        if currency.totalCoins >= 7000 {
            incrementCurrentPercentageOfAchievement("achievement_7000coins", amount: 100.0)
        }
        
        if currency.totalCoins >= 12000 {
            incrementCurrentPercentageOfAchievement("achievement_12000coins", amount: 100.0)
        }
        
        coinLabel.text = "\(currency.coins)"
        coinsMadeNotifier.text = "+ \(coinsMade)"
    }
    
    //MARK: This function adds the background to the game
    func addBackground() {
        //Adds the colorful background
        
        let background = SKSpriteNode(imageNamed: "backGround")
        background.zPosition = layerPositions.background.rawValue
        self.addChild(background)
    }
    
    //MARK: This function adds the gameOver panel
    func addGameOver() {
        let shadowBG = SKSpriteNode(imageNamed: "GameOverLayerBG")
        shadowBG.zPosition = layerPositions.background.rawValue + 1
        self.addChild(shadowBG)
        
        gameOverSign = SKSpriteNode(imageNamed: "GameOverBox")
        gameOverSign.position = CGPoint(x: 0, y: 35)
        gameOverSign.zPosition = layerPositions.topLayer.rawValue
        gameOverLayer.addChild(gameOverSign)
        
        //This is the box that contains the highscore an its text//
        ////////////////////////////////////////////////////////
        let highscoreBox = SKSpriteNode(imageNamed: "HighScoreBox")
        highscoreBox.position = CGPoint(x: 0, y: 220)
        highscoreBox.zPosition = layerPositions.textLayer.rawValue
        gameOverSign.addChild(highscoreBox)
        
        let highestScore = NSUserDefaults.standardUserDefaults().integerForKey("highscore")
        highscore.text = "\(highestScore)"
        highscore.fontSize = 45.0
        highscore.fontName = "Grand Hotel"
        highscore.position = CGPoint(x: 8, y: -38)
        highscore.zPosition = layerPositions.topLayer.rawValue
        highscoreBox.addChild(highscore)
        
        ////////////////////////////////////////////////////////
        
        //This is the box that contains the score and its text//
        ///////////////////////////////////////////////////////
        let scoreBox = SKSpriteNode(imageNamed: "ScoreBox")
        scoreBox.position = CGPoint(x: 0, y: 28)
        scoreBox.zPosition = layerPositions.textLayer.rawValue
        gameOverSign.addChild(scoreBox)
        
        let scoring = self.userData?.objectForKey("score")
        score.text = "\(scoring!)"
        score.fontSize = 45.0
        score.fontName = "Grand Hotel"
        score.position = CGPoint(x: 8, y: -38)
        score.zPosition = layerPositions.topLayer.rawValue
        scoreBox.addChild(score)
        ///////////////////////////////////////////////////////
        
        //This is the containers that let the user know how much coins they earned//
        ///////////////////////////////////////////////////////////////////////////
        let coinsBox = SKSpriteNode(imageNamed: "coinsMade")
        coinsBox.position = CGPoint(x: 0, y: -164)
        coinsBox.zPosition = layerPositions.textLayer.rawValue
        gameOverSign.addChild(coinsBox)
        ///////////////////////////////////////////////////////////////////////////
        
        //This is to bottom buttons//
        ////////////////////////////
        replay = SKSpriteNode(imageNamed: "restartButton")
        replay.position = CGPoint(x: -100, y: -330)
        replay.zPosition = layerPositions.textLayer.rawValue
        gameOverSign.addChild(replay)
        
        movieButton = SKSpriteNode(imageNamed: "movieButton")
        movieButton.position = CGPoint(x: 100, y: -330)
        movieButton.zPosition = layerPositions.textLayer.rawValue
        gameOverSign.addChild(movieButton)
        
        homeButton = SKSpriteNode(imageNamed: "homebutton")
        homeButton.position = CGPoint(x: -190, y: 350)
        homeButton.size = CGSize(width: 100, height: 100)
        homeButton.zPosition = layerPositions.textLayer.rawValue
        gameOverSign.addChild(homeButton)
        ////////////////////////////
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let touch = touches.first{
            let touchLocation = touch.locationInNode(self)
            if replay.containsPoint(touchLocation) {
               replay.alpha = 0.99

            }
            else if homeButton.containsPoint(touchLocation) {
                homeButton.alpha = 0.99
            }
            
            else if movieButton.containsPoint(touchLocation) {
                movieButton.alpha = 0.99
            }
            
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let touch = touches.first{
            let touchLocation = touch.locationInNode(self)
            if replay.containsPoint(touchLocation) && replay.alpha != 1 {
                if let scene = GameScene(fileNamed:"GameScene") {
                    if GameScene.soundOn == true {
                        self.scene?.runAction(buttonTouched)
                    }
                    if NSUserDefaults.standardUserDefaults().objectForKey("musicOn") != nil  {
                        if NSUserDefaults.standardUserDefaults().objectForKey("musicOn") as! Bool != false {
                            SKTAudio.sharedInstance().resumeBackgroundMusic()
                        }
                    }
                    else {
                        SKTAudio.sharedInstance().resumeBackgroundMusic()
                    }
                    // Configure the view.
                    let skView = self.view as SKView!
                    /* Sprite Kit applies additional optimizations to improve rendering performance */
                    skView.ignoresSiblingOrder = true
                    /* Set the scale mode to scale to fit the window */
                    scene.scaleMode = .AspectFill
                    let transition = SKTransition.fadeWithDuration(0.8)
                    skView.presentScene(scene, transition: transition)
                }
                
            }
            else {
                replay.alpha = 1
            }
            
            if homeButton.containsPoint(touchLocation) && homeButton.alpha != 1 {
                if GameScene.soundOn == true {
                    self.scene?.runAction(buttonTouched)
                }
                if NSUserDefaults.standardUserDefaults().objectForKey("musicOn") != nil  {
                    if NSUserDefaults.standardUserDefaults().objectForKey("musicOn") as! Bool != false {
                        SKTAudio.sharedInstance().resumeBackgroundMusic()
                    }
                }
                else {
                    SKTAudio.sharedInstance().resumeBackgroundMusic()
                }
                if let scene = MainMenu(fileNamed:"GameScene") {
                    
                    // Configure the view.
                    let skView = self.view as SKView!
                    /* Sprite Kit applies additional optimizations to improve rendering performance */
                    skView.ignoresSiblingOrder = true
                    /* Set the scale mode to scale to fit the window */
                    scene.scaleMode = .AspectFill
                    let transition = SKTransition.fadeWithDuration(0.8)
                    skView.presentScene(scene, transition: transition)
                }
            }
            else {
                homeButton.alpha = 1
            }
            
            if movieButton.containsPoint(touchLocation) && movieButton.alpha != 1 {
                if Chartboost.hasRewardedVideo(CBLocationGameOver) {
                    Chartboost.showRewardedVideo(CBLocationGameOver)
                }
                movieButton.alpha = 1
            }
            
            else {
                movieButton.alpha = 1
            }
            
        }
    }

    func didCompleteRewardedVideo(location: String!, withReward reward: Int32) {
        if location == CBLocationGameOver {
            currency.coins += Int(reward)
            Chartboost.cacheRewardedVideo(CBLocationGameOver)
        }
    }
    
    func didCloseRewardedVideo(location: String!) {
        if location == CBLocationGameOver {
            let scaleUp = SKAction.scaleTo(1.3, duration: 0.1)
            let scaleback = SKAction.scaleTo(1.0, duration: 0.1)

            
            coinLabel.runAction(SKAction.sequence([scaleUp,changeFontAction(coinLabel, color: UIColor.purpleColor()), scaleback, changeFontAction(coinLabel, color: UIColor.whiteColor())]))
            
            coinLabel.text = "\(currency.coins)"
            
            movieButton.runAction(SKAction.sequence([SKAction.scaleTo(0.0, duration: 0.3),SKAction.removeFromParent()]))
        }
    }
    
    func loadAchievementPercentages() {
        
        GKAchievement.loadAchievementsWithCompletionHandler { (allAchievements, error) -> Void in
            
            if error != nil {
                print("GC could not load ach, error:\(error)")
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
                    print("\(id) - \(achievement.percentComplete)")
                }
                
            }
        }
    }
    func incrementCurrentPercentageOfAchievement (identifier:String, amount:Double) {
        
        if GKLocalPlayer.localPlayer().authenticated {
            
            var currentPercentFound:Bool = false
            
            if ( gameCenterAchievements.count != 0) {
                
                for (id,achievement) in gameCenterAchievements {
                    print(id)
                    if (id == identifier) {
                        //progress on the achievement found
                        currentPercentFound = true
                        
                        var currentPercent:Double = achievement.percentComplete
                        
                        currentPercent = currentPercent + amount
                        
                        reportAchievement(identifier,percentComplete:currentPercent)
                        
                        break
                    }
                }
            }
            
            if (currentPercentFound == false) {
                //no progress on the achievement
                print("no progress")
                reportAchievement(identifier,percentComplete:amount)
                
            }
        }
    }
    
    func reportAchievement (identifier:String, percentComplete:Double) {
        
        let achievement = GKAchievement(identifier: identifier)
        
        achievement.percentComplete = percentComplete
        achievement.showsCompletionBanner = true
        
        let achievementArray: [GKAchievement] = [achievement]
        
        GKAchievement.reportAchievements(achievementArray, withCompletionHandler: {
            
            error -> Void in
            
            if ( error != nil) {
                print(error)
            }
                
            else {
                
                print ("reported achievement with % complete of \(percentComplete)")
                
                self.loadAchievementPercentages()
            }
            
        })
    }
    
    func changeFontAction(label: SKLabelNode, color: UIColor) -> SKAction {
        return SKAction.runBlock({ 
            label.fontColor = color
        })
    }
}
