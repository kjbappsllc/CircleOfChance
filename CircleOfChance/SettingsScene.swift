//
//  SettingsScene.swift
//  Circle of Chance
//
//  Created by Mac on 6/6/16.
//  Copyright (c) 2016 KJB Apps LLC. All rights reserved.
//

import SpriteKit

class SettingsScene: SKScene {
    //images
    var backButton = SKSpriteNode()
    var soundContainer = SKSpriteNode()
    var musicContainer = SKSpriteNode()
    var volumeIcon = SKSpriteNode()
    var resetHighScore = SKSpriteNode()
    var musicIcon = SKSpriteNode()
    var changeMusic = SKSpriteNode()
    //text
    var settingsText = SKLabelNode()
    var soundText = SKLabelNode()
    var musicText = SKLabelNode()
    var resetScoreText = SKLabelNode()
    var changeMusicText1 = SKLabelNode()
    var changeMusicText2 = SKLabelNode()
    
    override func didMoveToView(view: SKView) {
        loadview()
        self.backgroundColor = SKColor(red: 31/255, green: 30/255, blue: 30/255, alpha: 1.0)
    
        if GameScene.soundOn == true {
            soundText.text = "Sound Off"
            volumeIcon.texture = SKTexture(imageNamed: "soundIcon")
            soundContainer.alpha = 1.0
            volumeIcon.alpha = 1.0
        }
        else if GameScene.soundOn == false {
            soundText.text = "Sound On"
            volumeIcon.texture = SKTexture(imageNamed: "NoSoundIcon")
            volumeIcon.alpha = 0.5
            soundContainer.alpha = 0.5
        }
        
        if !NSUserDefaults.standardUserDefaults().boolForKey("music") {
            musicText.text = "Music Off"
            musicIcon.alpha = 1.0
            musicContainer.alpha = 1.0
        }
            
        else if NSUserDefaults.standardUserDefaults().boolForKey("music") == false {
            musicText.text = "Music On"
            musicIcon.alpha = 0.5
            musicContainer.alpha = 0.5
        }
        
        else if NSUserDefaults.standardUserDefaults().boolForKey("music") == true {
            musicText.text = "Music Off"
            musicIcon.alpha = 1.0
            musicContainer.alpha = 1.0
        }
    }
    
    func loadview() {
        
        settingsText.fontName = "DayPosterBlack"
        settingsText.fontSize = 54.0
        settingsText.fontColor = UIColor.whiteColor()
        settingsText.text = "Settings"
        settingsText.position = CGPoint(x: self.frame.width/2 + 50, y: self.frame.height - 120)
        self.addChild(settingsText)
        
        backButton = SKSpriteNode(imageNamed: "backButton")
        backButton.anchorPoint = CGPoint(x: 1.0, y: 0.5)
        backButton.position = CGPoint(x: settingsText.position.x - settingsText.frame.width/2 - 30, y: settingsText.position.y + 20)
        backButton.zPosition = 10
        self.addChild(backButton)
        
        //sound button
        soundContainer = SKSpriteNode(imageNamed: "SettingsContainer")
        soundContainer.position = CGPoint(x: self.frame.width/2, y: self.frame.height/2 + 110)
        self.addChild(soundContainer)
        
        volumeIcon = SKSpriteNode(imageNamed: "soundIcon")
        volumeIcon.zPosition = 1
        volumeIcon.position = CGPoint(x: -soundContainer.frame.width/2 + 50, y: 0)
        soundContainer.addChild(volumeIcon)
        
        soundText.fontName = "DayPosterBlack"
        soundText.fontSize = 34.0
        soundText.zPosition = 1
        soundText.text = "Sound Off"
        soundText.position = CGPoint(x: 12, y: -12)
        soundContainer.addChild(soundText)
        
        //music button
        musicContainer = SKSpriteNode(imageNamed: "SettingsContainer")
        musicContainer.position = CGPoint(x: self.frame.width/2, y: self.frame.height/2 - 10)
        self.addChild(musicContainer)
        
        musicIcon = SKSpriteNode(imageNamed: "musicIcon")
        musicIcon.zPosition = 1
        musicIcon.position = CGPoint(x: -soundContainer.frame.width/2 + 50, y: 0)
        musicContainer.addChild(musicIcon)
        
        musicText.fontName = "DayPosterBlack"
        musicText.fontSize = 34.0
        musicText.text = "Music Off"
        musicText.zPosition = 1
        musicText.position = CGPoint(x: 12, y: -12)
        musicContainer.addChild(musicText)
        
        //reset High score Button
        resetHighScore = SKSpriteNode(imageNamed: "otherOptionsContainer")
        resetHighScore.position = CGPoint(x: self.frame.width/2 + 75, y: self.frame.height/2 - 115)
        self.addChild(resetHighScore)
        resetScoreText.fontName = "DayPosterBlack"
        resetScoreText.fontSize = 20.0
        resetScoreText.text = "Reset"
        resetScoreText.zPosition = 1
        resetScoreText.position = CGPoint(x: 0, y: -10)
        resetHighScore.addChild(resetScoreText)
        
        //Change Music button
        changeMusic = SKSpriteNode(imageNamed: "otherOptionsContainer")
        changeMusic.position = CGPoint(x: self.frame.width/2 - 75, y: self.frame.height/2 - 115)
        self.addChild(changeMusic)
        changeMusicText1.fontName = "DayPosterBlack"
        changeMusicText1.fontSize = 17.0
        changeMusicText1.text = "Change"
        changeMusicText1.zPosition = 1
        changeMusic.addChild(changeMusicText1)

        changeMusicText2.fontName = "DayPosterBlack"
        changeMusicText2.fontSize = 17.0
        changeMusicText2.text = "Music"
        changeMusicText2.zPosition = 1
        changeMusicText2.position = CGPoint(x: 0, y: -20)
        changeMusic.addChild(changeMusicText2)
        
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
            
            if resetHighScore.containsPoint(touchLocation) {
                resetHighScore.alpha = 0.5
            }
            else{
                resetHighScore.alpha = 1.0
            }
            if changeMusic.containsPoint(touchLocation) {
                changeMusic.alpha = 0.5
            }
            else {
                changeMusic.alpha = 1.0
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
            
            if resetHighScore.containsPoint(touchLocation) && resetHighScore.alpha != 1 {
                self.scene?.runAction(buttonTouched)
                // Confirm some destructive action with a popup alert.
                let alert = UIAlertController(title: "Are You Sure You Want To Reset Your High Score?", message: "", preferredStyle: UIAlertControllerStyle.Alert)
                let cancelAction = UIAlertAction(title: "No", style: UIAlertActionStyle.Cancel, handler: { (a) -> Void in
                    // User tapped 'cancel', so do nothing
                })
                let confirmAction = UIAlertAction(title: "Yes", style: UIAlertActionStyle.Destructive, handler: { (a) -> Void in
                    NSUserDefaults.standardUserDefaults().setInteger(0, forKey: "highscore")
                    GameScene.highscoreInt = NSUserDefaults.standardUserDefaults().integerForKey("highscore")
                    let scene = MainMenu(size: self.view!.bounds.size)
                    scene.scaleMode = .ResizeFill
                    self.view!.presentScene(scene, transition: SKTransition.fadeWithDuration(0.3))
                })
                
                alert.addAction(cancelAction)
                alert.addAction(confirmAction)
                
                self.view?.window?.rootViewController?.presentViewController(alert, animated: true, completion: nil)
                resetHighScore.alpha = 1
            }
            else {
                resetHighScore.alpha = 1.0
            }
            
            if soundContainer.containsPoint(touchLocation) {
                if NSUserDefaults.standardUserDefaults().boolForKey("sound") == true {
                    NSUserDefaults.standardUserDefaults().setBool(false, forKey: "sound")
                    GameScene.soundOn = false
                    soundText.text = "Sound On"
                    volumeIcon.texture = SKTexture(imageNamed: "NoSoundIcon")
                    soundContainer.alpha = 0.5
                    volumeIcon.alpha = 0.5
                }
                else if NSUserDefaults.standardUserDefaults().boolForKey("sound") == false{
                    NSUserDefaults.standardUserDefaults().setBool(true, forKey: "sound")
                    GameScene.soundOn = true
                    soundText.text = "Sound Off"
                    volumeIcon.texture = SKTexture(imageNamed: "soundIcon")
                    volumeIcon.alpha = 1.0
                    soundContainer.alpha = 1.0
                }
            }
            
            if musicContainer.containsPoint(touchLocation){
                if NSUserDefaults.standardUserDefaults().boolForKey("music") == true {
                    NSUserDefaults.standardUserDefaults().setBool(false, forKey: "music")
                    SKTAudio.sharedInstance().pauseBackgroundMusic()
                    musicText.text = "Music On"
                    musicIcon.alpha = 0.5
                    musicContainer.alpha = 0.5
                }
                else if NSUserDefaults.standardUserDefaults().boolForKey("music") == false {
                    NSUserDefaults.standardUserDefaults().setBool(true, forKey: "music")
                    SKTAudio.sharedInstance().resumeBackgroundMusic()
                    musicText.text = "Music Off"
                    musicIcon.alpha = 1.0
                    musicContainer.alpha = 1.0
                }
            }
            if changeMusic.containsPoint(touchLocation) && changeMusic.alpha != 1 {
                if currentMusic == "bgMusic" {
                    SKTAudio.sharedInstance().playBackgroundMusic("bgMusic2.mp3")
                    currentMusic = "bgMusic2"
                    if NSUserDefaults.standardUserDefaults().boolForKey("music") == false {
                        SKTAudio.sharedInstance().pauseBackgroundMusic()
                    }
                }
                else {
                    SKTAudio.sharedInstance().playBackgroundMusic("bgMusic.wav")
                    currentMusic = "bgMusic"
                    if NSUserDefaults.standardUserDefaults().boolForKey("music") == false {
                        SKTAudio.sharedInstance().pauseBackgroundMusic()
                    }
                }
                changeMusic.alpha = 1.0
            }
            else {
                changeMusic.alpha = 1.0
            }
        }

    }
}
