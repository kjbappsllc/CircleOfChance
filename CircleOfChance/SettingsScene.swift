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
    var restorePurchases = SKSpriteNode()
    var musicIcon = SKSpriteNode()
    var changeMusic = SKSpriteNode()
    
    //text
    var settingsText = SKLabelNode()
    var restorePurchasesText = SKLabelNode()
    
    //TopBar
    var settingsBar = SKSpriteNode()
    
    //store
    let productID: NSSet = NSSet(objects:"com.KJBApps.CircleOfChance.doublecoins")
    var store: IAPHelper?
    
    override func didMoveToView(view: SKView) {
        addChild(buttonLayer)
        addChild(topBarLayer)
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        topBarLayer.hidden = true
        buttonLayer.hidden = true
        
        loadview()
        
        if AudioManager.sharedInstance().SoundisPlaying {
            volumeIcon.texture = SKTexture(imageNamed: "soundIcon")
            soundContainer.alpha = 1.0
            volumeIcon.alpha = 1.0
        }
        else {
            volumeIcon.texture = SKTexture(imageNamed: "NoSoundIcon")
            volumeIcon.alpha = 0.75
            soundContainer.alpha = 0.75
        }
        
        if AudioManager.sharedInstance().BackgroundisPlaying {
            musicIcon.alpha = 1.0
            musicContainer.alpha = 1.0
        }
            
        else {
            musicIcon.alpha = 0.75
            musicContainer.alpha = 0.75
        }
    }
    
    //Mark: This loads the view
    func loadview() {
        addBackground()
        addButtons()
        store = IAPHelper(productIds: productID as! Set<ProductIdentifier>)

        userInteractionEnabled = false
        
        settingsBar = SKSpriteNode(imageNamed: "SettingsBar")
        settingsBar.position = CGPoint(x: 0, y: self.frame.height/2 - settingsBar.frame.height/2)
        settingsBar.zPosition = layerPositions.topLayer.rawValue
        topBarLayer.addChild(settingsBar)
        
        settingsText.fontName = "Arial Hebrew-Bold"
        settingsText.fontSize = 80.0
        settingsText.fontColor = UIColor.whiteColor()
        settingsText.text = "Settings"
        settingsText.position.y = -15
        settingsText.zPosition = layerPositions.textLayer.rawValue
        settingsBar.addChild(settingsText)
        
        backButton = SKSpriteNode(imageNamed: "backButton")
        backButton.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        backButton.position = CGPoint(x: -settingsBar.width/2 + 100, y: 10)
        backButton.zPosition = layerPositions.textLayer.rawValue
        settingsBar.addChild(backButton)
        
        animateEnter { 
            self.userInteractionEnabled = true
        }
        
    }
    
    //Mark: This adds the colorful background
    func addBackground() {
        //Adds the colorful background
        
        let background = SKSpriteNode(imageNamed: "backGround")
        background.zPosition = layerPositions.background.rawValue
        self.addChild(background)
    }
    
    //Mark: This adds the buttons
    func addButtons() {
        soundContainer = SKSpriteNode(imageNamed: "settingsContainer")
        soundContainer.zPosition = layerPositions.topLayer.rawValue
        soundContainer.position = CGPoint(x: 0, y: -50)
        buttonLayer.addChild(soundContainer)
        
        volumeIcon = SKSpriteNode(imageNamed: "soundIcon")
        volumeIcon.position.y = 7
        volumeIcon.zPosition = layerPositions.textLayer.rawValue
        soundContainer.addChild(volumeIcon)
        
        musicContainer = SKSpriteNode(imageNamed: "settingsContainer")
        musicContainer.zPosition = layerPositions.topLayer.rawValue
        musicContainer.position = CGPoint(x: 0, y: 150)
        buttonLayer.addChild(musicContainer)
        
        musicIcon = SKSpriteNode(imageNamed: "musicIcon")
        musicIcon.position.y = 7
        musicIcon.zPosition = layerPositions.textLayer.rawValue
        musicContainer.addChild(musicIcon)
        
        restorePurchases = SKSpriteNode(imageNamed: "settingsContainer")
        restorePurchases.zPosition = layerPositions.topLayer.rawValue
        restorePurchases.position = CGPoint(x: 0, y: -250)
        buttonLayer.addChild(restorePurchases)
        
        restorePurchasesText.fontName = "Arial Hebrew"
        restorePurchasesText.text = "Restore Purchases"
        restorePurchasesText.fontSize = 44
        restorePurchasesText.fontColor = SKColor(colorLiteralRed: 156/255, green: 23/255, blue: 1, alpha: 1)
        restorePurchasesText.zPosition = layerPositions.textLayer.rawValue
        restorePurchases.addChild(restorePurchasesText)
    }
    
    //Mark: This animates the screen into view
    func animateEnter(completion: () -> ()){
        topBarLayer.position = CGPoint(x: 0, y: size.height)
        buttonLayer.position = CGPoint(x: size.width, y: 0)
        buttonLayer.hidden = false
        topBarLayer.hidden = false
        
        let topMoveIn = SKAction.moveBy(CGVector(dx: 0, dy: -size.height), duration: 0.4)
        topMoveIn.timingMode = .EaseOut
        
        topBarLayer.runAction(topMoveIn)
        
        let buttonMoveIn = SKAction.moveBy(CGVector(dx: -size.width, dy: 0), duration: 0.2)
        buttonMoveIn.timingMode = .EaseOut
        
        buttonLayer.runAction(buttonMoveIn,completion: completion)
    }
    
    
    
    //Mark: This animates the screen off the view
    func animateExit(completion: () -> ()) {
        let TopMoveOut = SKAction.moveBy(CGVector(dx: 0, dy: size.height), duration: 0.4)
        TopMoveOut.timingMode = .EaseIn
        
        topBarLayer.runAction(TopMoveOut)
        
        let moveOut = SKAction.moveBy(CGVector(dx: size.width, dy: 0), duration: 0.2)
        moveOut.timingMode = .EaseIn
        
        buttonLayer.runAction(moveOut, completion: completion)
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let touch = touches.first{
            let touchLocation = touch.locationInNode(self)
            let topbarLocation = touch.locationInNode(settingsBar)
            if backButton.containsPoint(topbarLocation) {
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
                    animateExit({ 
                        skView.presentScene(scene)
                    })
                }
            }
            
            if soundContainer.containsPoint(touchLocation) {
                if AudioManager.sharedInstance().SoundisPlaying == true {
                    AudioManager.sharedInstance().SoundisPlaying = false
                    volumeIcon.texture = SKTexture(imageNamed: "NoSoundIcon")
                    soundContainer.alpha = 0.75
                    volumeIcon.alpha = 0.75
                }
                
                else if AudioManager.sharedInstance().SoundisPlaying == false {
                    AudioManager.sharedInstance().SoundisPlaying = true
                    volumeIcon.texture = SKTexture(imageNamed: "soundIcon")
                    soundContainer.alpha = 1.0
                    volumeIcon.alpha = 1.0
                }
            }
            
            if musicContainer.containsPoint(touchLocation){
                if AudioManager.sharedInstance().BackgroundisPlaying == true{
                    AudioManager.sharedInstance().BackgroundisPlaying = false
                    AudioManager.sharedInstance().pauseBackgroundMusic()
                    musicIcon.alpha = 0.75
                    musicContainer.alpha = 0.75
                }
                else if AudioManager.sharedInstance().BackgroundisPlaying == false {
                    AudioManager.sharedInstance().BackgroundisPlaying = true
                    if AudioManager.sharedInstance().playerExist() {
                        AudioManager.sharedInstance().resumeBackgroundMusic()
                    }
                    else{
                        AudioManager.sharedInstance().playBackgroundMusic("bgMusic.wav")
                    }
                    musicIcon.alpha = 1.0
                    musicContainer.alpha = 1.0
                }
            }
            
            if restorePurchases.containsPoint(touchLocation) {
                store?.restorePurchases()
                
                NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ShopScene.handlePurchaseNotification(_:)),
                                                                 name: IAPHelper.IAPHelperPurchaseNotification,
                                                                 object: nil)
            }
        }
    }
}
