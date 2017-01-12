//
//  SettingsScene.swift
//  Circle of Chance
//
//  Created by Mac on 6/6/16.
//  Copyright (c) 2016 KJB Apps LLC. All rights reserved.
//

import SpriteKit

class SettingsScene: SKScene {
    //nodes
    var topBarLayer = SKNode()
    var buttonLayer = SKNode()
    
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
    
    //TopBar
    var settingsBar = SKSpriteNode()
    
    override func didMoveToView(view: SKView) {
        addChild(buttonLayer)
        addChild(topBarLayer)
        anchorPoint = CGPoint(x: 0.5, y: 0.5)

        loadview()
        self.backgroundColor = SKColor(red: 31/255, green: 30/255, blue: 30/255, alpha: 1.0)
    
        if AudioManager.sharedInstance().SoundisPlaying {
            soundText.text = "Sound Off"
            volumeIcon.texture = SKTexture(imageNamed: "soundIcon")
            soundContainer.alpha = 1.0
            volumeIcon.alpha = 1.0
        }
        else {
            soundText.text = "Sound On"
            volumeIcon.texture = SKTexture(imageNamed: "NoSoundIcon")
            volumeIcon.alpha = 0.5
            soundContainer.alpha = 0.5
        }
        
        if AudioManager.sharedInstance().BackgroundisPlaying {
            musicText.text = "Music Off"
            musicIcon.alpha = 1.0
            musicContainer.alpha = 1.0
        }
            
        else {
            musicText.text = "Music On"
            musicIcon.alpha = 0.5
            musicContainer.alpha = 0.5
        }
    }
    
    func loadview() {
        
        settingsBar = SKSpriteNode(imageNamed: "SettingsBar")
        settingsBar.position = CGPoint(x: 0, y: self.frame.height/2 - settingsBar.frame.height/2)
        settingsBar.zPosition = layerPositions.topLayer.rawValue
        topBarLayer.addChild(settingsBar)
        
        settingsText.fontName = "DayPosterBlack"
        settingsText.fontSize = 54.0
        settingsText.fontColor = UIColor.whiteColor()
        settingsText.text = "Settings"
        settingsText.position = CGPoint(x: self.frame.width/2 + 50, y: self.frame.height - 120)
        self.addChild(settingsText)
        
        backButton = SKSpriteNode(imageNamed: "backButton")
        backButton.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        backButton.position = CGPoint(x: -settingsBar.width/2 + 100, y: 10)
        backButton.zPosition = layerPositions.textLayer.rawValue
        settingsBar.addChild(backButton)
        
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
            if backButton.containsPoint(touchLocation) {
                AudioManager.sharedInstance().playSoundEffect("buttonTouched.wav")
                
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
            
            if soundContainer.containsPoint(touchLocation) {
                if AudioManager.sharedInstance().SoundisPlaying == true {
                    AudioManager.sharedInstance().SoundisPlaying = false
                    soundText.text = "Sound On"
                    volumeIcon.texture = SKTexture(imageNamed: "NoSoundIcon")
                    soundContainer.alpha = 0.5
                    volumeIcon.alpha = 0.5
                }
                
                else if AudioManager.sharedInstance().SoundisPlaying == false {
                    AudioManager.sharedInstance().SoundisPlaying = true
                    soundText.text = "Sound Off"
                    volumeIcon.texture = SKTexture(imageNamed: "soundIcon")
                    soundContainer.alpha = 1.0
                    volumeIcon.alpha = 1.0
                }
            }
            
            if musicContainer.containsPoint(touchLocation){
                if AudioManager.sharedInstance().BackgroundisPlaying == true{
                    AudioManager.sharedInstance().BackgroundisPlaying = false
                    AudioManager.sharedInstance().pauseBackgroundMusic()
                    musicText.text = "Music On"
                    musicIcon.alpha = 0.5
                    musicContainer.alpha = 0.5
                }
                else if AudioManager.sharedInstance().BackgroundisPlaying == false {
                    AudioManager.sharedInstance().BackgroundisPlaying = true
                    AudioManager.sharedInstance().resumeBackgroundMusic()
                    musicText.text = "Music Off"
                    musicIcon.alpha = 1.0
                    musicContainer.alpha = 1.0
                }
            }
        }
    }
}
