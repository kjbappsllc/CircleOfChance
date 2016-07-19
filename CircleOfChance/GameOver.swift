//
//  GameOver.swift
//  Wheel of Misfortune
//
//  Created by Mac on 5/31/16.
//  Copyright © 2016 KeyEnt. All rights reserved.
//

import SpriteKit

class GameOver: SKScene, ChartboostDelegate {
    
    var title = SKLabelNode()
    var homeButton = SKSpriteNode()
    var coins = SKSpriteNode()
    
    var scoreRect = SKSpriteNode()
    var scoreTitle = SKLabelNode()
    var score = SKLabelNode()
    
    var highscoreRect = SKSpriteNode()
    var highscoreTitle = SKLabelNode()
    var highscore = SKLabelNode()
    var coinLabel = SKLabelNode()
    var coinsMadeNotifier = SKLabelNode()
    var replay = SKSpriteNode()
    var currency = CurrencyManager()
    
    var movieButton = SKSpriteNode()
    
    override func didMoveToView(view: SKView) {
        
        Chartboost.setDelegate(self)
        
        loadView()
        
        if Chartboost.hasRewardedVideo(CBLocationGameOver) {
            let scale = SKAction.scaleTo(1.1, duration: 0.5)
            let scaleback = SKAction.scaleTo(1.0, duration: 0.5)
            let pulsing = SKAction.sequence([scale,scaleback])
            self.addChild(movieButton)
            movieButton.runAction(SKAction.repeatActionForever(pulsing))
        }

    }
    
    func loadView() {
        scene?.backgroundColor = UIColor(red: 31/255, green: 30/255, blue: 30/255, alpha: 1.0)
        title.fontName = "DayPosterBlack"
        title.fontSize = 46.0
        title.fontColor = UIColor(red: 133/255, green: 0, blue: 241/255, alpha: 1.0)
        title.position = CGPoint(x: self.frame.width/2 + 40, y: self.frame.height/2 + 270)
        title.text = "Game Over"
        title.zPosition = 2
        self.addChild(title)
        
        homeButton = SKSpriteNode(imageNamed: "homeButton")
        homeButton.position = CGPoint(x: self.frame.width/2 - 160, y: self.frame.height/2 + 290)
        homeButton.zPosition = 2
        self.addChild(homeButton)
        
        scoreRect = SKSpriteNode(imageNamed: "container")
        scoreRect.position = CGPoint(x: self.frame.width/2, y: self.frame.height/2 + 180)
        scoreRect.size = CGSize(width: self.frame.width, height: scoreRect.frame.height)
        self.addChild(scoreRect)
        
        scoreTitle.fontName = "DayPosterBlack"
        scoreTitle.fontSize = 35.0
        scoreTitle.fontColor = UIColor.whiteColor()
        scoreTitle.text = "Score"
        scoreTitle.zPosition = 2
        scoreTitle.position = CGPoint(x: 0, y: -12)
        scoreRect.addChild(scoreTitle)
        
        score.fontName = "DayPosterBlack"
        score.fontSize = 60.0
        score.text = "\(GameScene.scoreInt)"
        score.fontColor = UIColor.whiteColor()
        score.position = CGPoint(x: self.frame.width/2, y: self.frame.height/2 + 80)
        self.addChild(score)
        
        highscoreRect = SKSpriteNode(imageNamed: "container2")
        highscoreRect.position = CGPoint(x: self.frame.width/2, y: self.frame.height/2 + 35)
        highscoreRect.size = CGSize(width: self.frame.width, height: highscoreRect.frame.height)
        self.addChild(highscoreRect)
        
        highscoreTitle.fontName = "DayPosterBlack"
        highscoreTitle.fontSize = 35.0
        highscoreTitle.fontColor = UIColor.whiteColor()
        highscoreTitle.text = "High Score"
        highscoreTitle.zPosition = 2
        highscoreTitle.position = CGPoint(x: 0, y: -12)
        highscoreRect.addChild(highscoreTitle)
        
        highscore.fontName = "DayPosterBlack"
        highscore.fontSize = 100.0
        highscore.text = "\(GameScene.highscoreInt)"
        highscore.fontColor = UIColor(red: 133/255, green: 0, blue: 241/255, alpha: 1.0)
        highscore.position = CGPoint(x: self.frame.width/2, y: self.frame.height/2 - 95)
        self.addChild(highscore)
        
        replay = SKSpriteNode(imageNamed: "replayButton")
        replay.size = CGSize(width: replay.size.width - 15, height: replay.size.height - 15)
        replay.position = CGPoint(x: self.frame.width/2, y: self.frame.height/2 - 210)
        replay.zPosition = 2
        self.addChild(replay)
        
        let scale = SKAction.scaleTo(1.1, duration: 0.5)
        let scaleBack = SKAction.scaleTo(1.0, duration: 0.5)
        let pulse = SKAction.sequence([scale,scaleBack])
        replay.runAction(SKAction.repeatActionForever(pulse))
        
        coins = SKSpriteNode(imageNamed: "coin")
        coins.size = CGSize(width: 55, height: 55)
        coins.position = CGPoint(x: self.frame.width/2 - 145, y: replay.position.y + 40)
        self.addChild(coins)
        
        coinLabel.fontName = "DayPosterBlack"
        coinLabel.fontSize = 34.0
        coinLabel.position = CGPoint(x: coins.position.x + 3, y: coins.position.y - 55)
        self.addChild(coinLabel)
        
        coinsMadeNotifier.fontName = "DayPosterBlack"
        coinsMadeNotifier.fontSize = 26.0
        coinsMadeNotifier.position = CGPoint(x: coinLabel.position.x - 10, y: coinLabel.position.y - 40)
        coinsMadeNotifier.fontColor = SKColor(red: 133/255, green: 0, blue: 241/255, alpha: 1.0)
        self.addChild(coinsMadeNotifier)
        
        var coinsMade = GameScene.scoreInt / 16
        
        if coinsMade < 0 {
            coinsMade = 0
        }
        
        currency.coins += coinsMade
        currency.totalCoins += coinsMade
        coinLabel.text = "\(currency.coins)"
        coinsMadeNotifier.text = "+ \(coinsMade)"
        
        movieButton = SKSpriteNode(imageNamed: "movieButton")
        movieButton.position = CGPoint(x: replay.position.x + 135, y: replay.position.y+10)
        movieButton.size = CGSize(width: movieButton.size.width + 15, height: movieButton.size.height+15)
        movieButton.zPosition = 2
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let touch = touches.first{
            let touchLocation = touch.locationInNode(self)
            if replay.containsPoint(touchLocation) {
               replay.alpha = 0.5

            }
            else if homeButton.containsPoint(touchLocation) {
                homeButton.alpha = 0.5
            }
            
            else if movieButton.containsPoint(touchLocation) {
                movieButton.alpha = 0.5
            }
            
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let touch = touches.first{
            let touchLocation = touch.locationInNode(self)
            if replay.containsPoint(touchLocation) && replay.alpha != 1 {
                if Chartboost.hasRewardedVideo(CBLocationGameOver) == false {
                    Chartboost.cacheRewardedVideo(CBLocationGameOver)
                }
                if let scene = GameScene(fileNamed:"GameScene") {
                    if GameScene.soundOn == true {
                        self.scene?.runAction(buttonTouched)
                    }
                    if NSUserDefaults.standardUserDefaults().boolForKey("music") != false {
                        SKTAudio.sharedInstance().resumeBackgroundMusic()
                    }
                    GameScene.scoreInt = 0
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
                replay.alpha = 1
            }
            
            if homeButton.containsPoint(touchLocation) && homeButton.alpha != 1 {
                if GameScene.soundOn == true {
                    self.scene?.runAction(buttonTouched)
                }
                if NSUserDefaults.standardUserDefaults().boolForKey("music") != false {
                    SKTAudio.sharedInstance().resumeBackgroundMusic()
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
    
    func changeFontAction(label: SKLabelNode, color: UIColor) -> SKAction {
        return SKAction.runBlock({ 
            label.fontColor = color
        })
    }
}
