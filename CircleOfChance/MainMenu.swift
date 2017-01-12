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
    //Layers
    let titleLayer = SKNode()
    let topButtonLayer = SKNode()
    let bottomButtonLayer = SKNode()
    let playButtonLayer = SKNode()
    
    //TopLayer
    var topBar = SKSpriteNode()
    var title = SKSpriteNode()
    
    //Buttons
    var playButton = SKSpriteNode()
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
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        addChild(titleLayer)
        addChild(topButtonLayer)
        addChild(bottomButtonLayer)
        addChild(playButtonLayer)
        
        //Pre set properties
        titleLayer.hidden = true
        topButtonLayer.hidden = true
        bottomButtonLayer.hidden = true

        loadview()
    }
    
    func loadview() {
        userInteractionEnabled = false
        addBackground()
        addTopArea()
        addPlayButton()
        addButtons()
        
        let resize = SKAction.resizeByWidth(7, height: 0, duration: 1.0)
        let ShiftAction = SKAction.sequence([resize, resize.reversedAction()])
        
        animateBeginGame {
            self.userInteractionEnabled = true
            
            for children in self.bottomButtonLayer.children {
                children.runAction(SKAction.repeatActionForever(ShiftAction))
            }
            
            for children in self.topButtonLayer.children {
                children.runAction(SKAction.repeatActionForever(ShiftAction))
            }
            
            self.title.runAction(SKAction.repeatActionForever(ShiftAction))
            self.playButton.runAction(SKAction.repeatActionForever(ShiftAction))
        }
        

    }
    
    //Mark: This function animates the begin of the game
    func animateBeginGame(completion: () -> ()) {
        titleLayer.hidden = false
        titleLayer.position = CGPoint(x: 0, y: size.height)
        let titleAction = SKAction.moveBy(CGVector(dx: 0, dy: -size.height), duration: 0.5, delay: 0.0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.9)
        titleAction.timingMode = .EaseOut
        
        titleLayer.runAction(titleAction)
        
        topButtonLayer.hidden = false
        topButtonLayer.position = CGPoint(x: -size.width, y: 0)
        let topButtonAction = SKAction.moveBy(CGVector(dx: size.width, dy:0), duration: 0.5)
        topButtonAction.timingMode = .EaseOut
        topButtonLayer.runAction(topButtonAction)
        
        bottomButtonLayer.hidden = false
        bottomButtonLayer.position = CGPoint(x: 0, y: -size.height)
        let bottomButtonAction = SKAction.moveBy(CGVector(dx: 0, dy: size.height), duration: 0.5)
        bottomButtonAction.timingMode = .EaseOut
        bottomButtonLayer.runAction(bottomButtonAction)
        
        playButton.setScale(0)
        let playAction = SKAction.scaleTo(1.0, duration: 1.0, delay: 0.5, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.0)
        playButton.runAction(playAction, completion: completion)
    }
    
    //Mark: This function animates the end
    func animateExit(completion: () -> ()) {
        
        let titeExit = SKAction.moveBy(CGVector(dx: 0, dy: size.height), duration: 0.7)
        titeExit.timingMode = .EaseOut
        
        titleLayer.runAction(titeExit)
        
        let topbuttonExit = SKAction.moveBy(CGVector(dx: -size.width, dy: 0), duration: 0.5)
        topButtonLayer.runAction(topbuttonExit)
        topbuttonExit.timingMode = .EaseOut
        
        let bottomExit = SKAction.moveBy(CGVector(dx: 0, dy: -size.height), duration: 0.5)
        bottomButtonLayer.runAction(bottomExit)
        bottomExit.timingMode = .EaseOut
        
        playButton.runAction(SKAction.scaleTo(0.0, duration: 0.5, delay: 0.0, usingSpringWithDamping: 0.0, initialSpringVelocity: 0.0), completion: completion)
    }
    
    //Mark: This adds the colorful background
    func addBackground() {
        //Adds the colorful background
        
        let background = SKSpriteNode(imageNamed: "backGround")
        background.zPosition = layerPositions.background.rawValue
        self.addChild(background)
    }
    
    //Mark: This adds the top area with the title
    func addTopArea() {
        topBar = SKSpriteNode(imageNamed: "TopArea")
        topBar.position = CGPoint(x: 0, y: self.frame.height/2 - topBar.size.height/2)
        topBar.zPosition = layerPositions.topLayer.rawValue
        titleLayer.addChild(topBar)
        
        title = SKSpriteNode(imageNamed: "title")
        title.zPosition = layerPositions.textLayer.rawValue
        topBar.addChild(title)
    }
    
    //Mark: This adds the button to me played
    func addPlayButton() {
        playButton = SKSpriteNode(imageNamed: "playButton")
        playButton.zPosition = layerPositions.topLayer.rawValue
        playButton.size = CGSize(width: 202, height: 202)
        playButton.position = CGPoint(x: 220, y: -300)
        playButtonLayer.addChild(playButton)
    }
    
    //Mark: This adds the rest of the buttons
    func addButtons() {
        helpButton = SKSpriteNode(imageNamed: "HelpButton")
        helpButton.zPosition = layerPositions.topLayer.rawValue
        helpButton.position = CGPoint(x: -210, y: -180)
        topButtonLayer.addChild(helpButton)
        
        shopButton = SKSpriteNode(imageNamed: "ShopButton")
        shopButton.zPosition = layerPositions.topLayer.rawValue
        shopButton.position = CGPoint(x: -10, y: -180)
        topButtonLayer.addChild(shopButton)
        
        settingsButton = SKSpriteNode(imageNamed: "SettingsButton")
        settingsButton.zPosition = layerPositions.topLayer.rawValue
        settingsButton.position = CGPoint(x: -210, y: -380)
        bottomButtonLayer.addChild(settingsButton)
        
        achievementsButton = SKSpriteNode(imageNamed: "AchievementButton")
        achievementsButton.zPosition = layerPositions.topLayer.rawValue
        achievementsButton.position = CGPoint(x: -10, y: -380)
        bottomButtonLayer.addChild(achievementsButton)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let touch = touches.first {
            let touchLocation = touch.locationInNode(playButtonLayer)
            if playButton.containsPoint(touchLocation) {
                animateExit({
                    if let scene = GameScene(fileNamed:"GameScene") {
                        
                        // Configure the view.
                        let skView = self.view as SKView!
                        /* Sprite Kit applies additional optimizations to improve rendering performance */
                        skView.ignoresSiblingOrder = true
                        /* Set the scale mode to scale to fit the window */
                        scene.scaleMode = .AspectFill
                        skView.presentScene(scene)
                    }
                })
            }
            else if settingsButton.containsPoint(touchLocation) {
                animateExit({
                    if let scene = SettingsScene(fileNamed:"GameScene") {
                        
                        // Configure the view.
                        let skView = self.view as SKView!
                        /* Sprite Kit applies additional optimizations to improve rendering performance */
                        skView.ignoresSiblingOrder = true
                        /* Set the scale mode to scale to fit the window */
                        scene.scaleMode = .AspectFill
                        skView.presentScene(scene)
                    }
                })
            }
            
            else if achievementsButton.containsPoint(touchLocation) {
                showLeaderOrAchievements(GKGameCenterViewControllerState.Achievements)
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
