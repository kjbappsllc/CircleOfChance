//
//  MainMenu.swift
//  Circle of Chance
//
//  Created by Mac on 6/6/16.
//  Copyright (c) 2016 KJB Apps LLC. All rights reserved.
//

import SpriteKit
import GameKit

class MainMenu: SKScene, GKGameCenterControllerDelegate {
    
    var title = SKSpriteNode()
    var playButton = SKSpriteNode()
    var playButtonNode = SKNode()
    var playButtonBall = Character()
    
    var shopButton = SKSpriteNode()
    var helpButton = SKSpriteNode()
    var settingsButton = SKSpriteNode()
    var achievementsButton = SKSpriteNode()
    var highscoreButton = SKSpriteNode()
    var rateButton = SKSpriteNode()
    var progressButton = SKSpriteNode()
    var bottomNode = SKNode()
    
    var helpView = UIView()
    var howToPlayButton = UIButton()
    var cardDescriptionsButton = UIButton()
    var helpViewActive = false
    
    var notNewPlayer = false
    var newPlayerTip = SKSpriteNode()
    var backGround = SKShapeNode()
    
    override func didMoveToView(view: SKView) {
        self.addChild(playButtonNode)
        self.addChild(bottomNode)
        loadview()
    }
    
    func loadview() {
        notNewPlayer = NSUserDefaults.standardUserDefaults().boolForKey("notNewPlayer")
        
        scene?.backgroundColor = UIColor(red: 31/255, green: 30/255, blue: 30/255, alpha: 1.0)
        
        title = SKSpriteNode(imageNamed: "title")
        title.anchorPoint = CGPoint(x: 0.5, y: 1.0)
        title.position = CGPoint(x: self.frame.width/2, y: self.frame.height - 40)
        self.addChild(title)
        
        let scale = SKAction.scaleTo(1.04, duration: 0.3)
        let scaleDown = SKAction.scaleTo(1.0, duration: 0.3)
        let cycle = SKAction.sequence([scale,scaleDown])
        let wait = SKAction.waitForDuration(2)
        
        let buttonCycle = SKAction.repeatActionForever(SKAction.sequence([wait,cycle,wait]))
        
        title.runAction(buttonCycle)
        
        addPlayButton()
        addBottomButtons()
        
        if notNewPlayer == false {
            backGround = SKShapeNode(rect: CGRect(x: -self.frame.width/2, y: -self.frame.height/2, width: self.frame.width, height: self.frame.height))
            backGround.fillColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.65)
            backGround.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
            backGround.strokeColor = UIColor.clearColor()
            backGround.zPosition = 10
            helpButton.zPosition = 15
            self.addChild(backGround)
            
            newPlayerTip = SKSpriteNode(imageNamed: "newPlayerTip")
            newPlayerTip.zPosition = 20
            newPlayerTip.anchorPoint = CGPoint(x: 0, y: 0.5)
            newPlayerTip.position = CGPoint(x: helpButton.position.x + 60, y: helpButton.position.y - helpButton.frame.height/2)
            self.addChild(newPlayerTip)
            
            let move = SKAction.moveTo(CGPoint(x: newPlayerTip.position.x + 15, y: newPlayerTip.position.y), duration: 0.75)
            let moveBack = SKAction.moveTo(CGPoint(x: newPlayerTip.position.x, y: newPlayerTip.position.y), duration: 0.75)
            let backnForth = SKAction.repeatActionForever(SKAction.sequence([move,moveBack]))
            newPlayerTip.runAction(backnForth)
            
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "notNewPlayer")
            
        }

    }
    
    func addPlayButton() {
        playButton = SKSpriteNode(imageNamed: "PlayMenuButton")
        playButton.position = CGPoint(x: self.frame.width/2, y: self.frame.height/2)
        playButton.size = CGSize(width: playButton.size.width, height: playButton.size.height)
        playButton.zPosition = 2
        playButtonNode.addChild(playButton)
        
        playButtonBall.position = CGPoint(x: self.frame.width/2, y: self.frame.height/2+100)
        playButtonBall.zPosition = 3
        playButtonNode.addChild(playButtonBall)
        
        let dx = playButtonBall.position.x - self.frame.width/2
        let dy = playButtonBall.position.y - self.frame.height / 2
        
        let rad = atan2(dy,dx)
        let Path = UIBezierPath(arcCenter: CGPoint(x: self.frame.width/2, y: self.frame.height/2), radius: playButton.frame.size.height/2 - 5, startAngle: rad, endAngle: rad+CGFloat(M_PI*4), clockwise: true)
        
        let follow = SKAction.followPath(Path.CGPath, asOffset: false, orientToPath: true, speed: 175)
        playButtonBall.runAction(SKAction.repeatActionForever(follow).reversedAction())
    }
    
    func addBottomButtons() {
        shopButton = SKSpriteNode(imageNamed: "shopButton")
        shopButton.position = CGPoint(x: self.frame.width/2 - shopButton.frame.width/2 - 20, y: (self.frame.height/2) - playButton.frame.height/2 - 50)
        shopButton.anchorPoint = CGPoint(x: 0.5, y: 1.0)
        bottomNode.addChild(shopButton)
        
        helpButton = SKSpriteNode(imageNamed: "HowToIcon")
        helpButton.anchorPoint = CGPoint(x: 0.5, y: 1.0)
        helpButton.position = CGPoint(x: self.frame.width/2 - playButton.frame.width/2 - helpButton.frame.width/2 + 5, y: self.frame.height/2 - playButton.frame.height/2 + 25)
        
        bottomNode.addChild(helpButton)
        
        settingsButton = SKSpriteNode(imageNamed: "SettingIcon")
        settingsButton.anchorPoint = CGPoint(x: 0.5, y: 1.0)
        settingsButton.position = CGPoint(x: shopButton.position.x + shopButton.frame.width + 40, y: (self.frame.height/2) - playButton.frame.height/2 - 50)
        
        bottomNode.addChild(settingsButton)
        
        achievementsButton = SKSpriteNode(imageNamed: "AchievementsButton")
        achievementsButton.anchorPoint = CGPoint(x: 0.5, y: 1.0)
        achievementsButton.position = CGPoint(x: self.frame.width/2 + playButton.frame.width/2 + achievementsButton.frame.width/2 - 5, y: self.frame.height/2 - playButton.frame.height/2 + 25)
        
        bottomNode.addChild(achievementsButton)
        
        let scaleUp = SKAction.scaleTo(1.1, duration: 0.1)
        let scaledown = SKAction.scaleTo(1.0, duration: 0.1)
        let wait = SKAction.waitForDuration(2.0)
        let pulse = SKAction.sequence([scaleUp,scaledown,wait])
        
        shopButton.runAction(SKAction.repeatActionForever(pulse))
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let touch = touches.first{
            let touchLocation = touch.locationInNode(self)
            if playButton.containsPoint(touchLocation) {
                playButtonNode.alpha = 0.5
            }
            else {
                playButtonNode.alpha = 1.0
            }
            
            if settingsButton.containsPoint(touchLocation) {
                settingsButton.alpha = 0.5
            }
            else {
                settingsButton.alpha = 1.0
            }
            
            if shopButton.containsPoint(touchLocation) {
                shopButton.alpha = 0.5
            }
            else {
                shopButton.alpha = 1.0
            }
            if helpButton.containsPoint(touchLocation) {
                helpButton.alpha = 0.5
            }
            else{
                helpButton.alpha = 1.0
            }
            if highscoreButton.containsPoint(touchLocation) {
                highscoreButton.alpha = 0.5
            }
            else {
                highscoreButton.alpha = 1.0
            }
            
            if achievementsButton.containsPoint(touchLocation) {
                achievementsButton.alpha = 0.5
            }
            else {
                achievementsButton.alpha = 1.0
            }
            if progressButton.containsPoint(touchLocation) {
                progressButton.alpha = 0.5
            }
            else {
                progressButton.alpha = 1.0
            }
        }

    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let touch = touches.first {
            let touchLocation = touch.locationInNode(self)
            if playButton.containsPoint(touchLocation) && playButtonNode.alpha != 1{
                if let scene = GameScene(fileNamed:"GameScene") {
                    if GameScene.soundOn == true {
                        self.scene?.runAction(buttonTouched)
                    }
                    GameScene.scoreInt = 0
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
                playButtonNode.alpha = 1
            }
            
            if settingsButton.containsPoint(touchLocation) && settingsButton.alpha != 1 {
                if let scene = SettingsScene(fileNamed:"GameScene") {
                    if GameScene.soundOn == true {
                        self.scene?.runAction(buttonTouched)
                    }
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
                settingsButton.alpha = 1
            }
            
            if shopButton.containsPoint(touchLocation) && shopButton.alpha != 1 {
                if let scene = ShopScene(fileNamed:"GameScene") {
                    if GameScene.soundOn == true {
                        self.scene?.runAction(buttonTouched)
                    }
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
                shopButton.alpha = 1
            }
            
            if achievementsButton.containsPoint(touchLocation) && achievementsButton.alpha != 1 {
                if let scene = ProgressScene(fileNamed:"GameScene") {
                    if GameScene.soundOn == true {
                        self.scene?.runAction(buttonTouched)
                    }
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
                progressButton.alpha = 1.0
            }
            
        }
        howToMenu(touches)
    }
    
    func howToMenu(touches: Set<UITouch>) {
        if let touch = touches.first as UITouch! {
            let pos = touch.locationInNode(self)
            let node = self.nodeAtPoint(pos)
            
            if node == helpButton {
                if let scene = howToPlayScene(fileNamed:"GameScene") {
                    if GameScene.soundOn == true {
                        self.scene?.runAction(buttonTouched)
                    }
                    GameScene.scoreInt = 0
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
                helpButton.alpha = 1.0
            }
        }
    }
    
    func gameCenterViewControllerDidFinish(gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismissViewControllerAnimated(true, completion: nil)
    }
    
}
