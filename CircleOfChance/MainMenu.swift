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
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        addChild(titleLayer)
        addChild(topButtonLayer)
        addChild(bottomButtonLayer)
        addChild(playButtonLayer)

        loadview()
    }
    
    func loadview() {
        addBackground()
        addTopArea()
        addPlayButton()
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
    
    //This adds the button to me played
    func addPlayButton() {
        playButton = SKSpriteNode(imageNamed: "playButton")
        playButton.zPosition = layerPositions.topLayer.rawValue
        playButton.position = CGPoint(x: 220, y: -300)
        playButtonLayer.addChild(playButton)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
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
                    skView.presentScene(scene)
                }
            }
            else {
                playButtonNode.alpha = 1
            }
        }
    }
    
    func gameCenterViewControllerDidFinish(gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismissViewControllerAnimated(true, completion: nil)
    }
    
}
