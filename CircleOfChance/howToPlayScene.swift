//
//  howToPlayScene.swift
//  Circle of Chance
//
//  Created by Mac on 6/14/16.
//  Copyright © 2016 KJB Apps LLC. All rights reserved.
//

import SpriteKit

class howToPlayScene: SKScene {
    var howToPlayImage = SKSpriteNode()
    var goBack = SKSpriteNode()
    var backGround = SKShapeNode()
    var tip = SKSpriteNode()
    var tipActive = true
    var counter = Int()
    var cycle = [SKTexture(imageNamed: "howToPlay1"), SKTexture(imageNamed: "howToPlay2"), SKTexture(imageNamed: "howToPlay3"), SKTexture(imageNamed: "howToPlay4"), SKTexture(imageNamed: "howToPlay5"), SKTexture(imageNamed: "howToPlay6"), SKTexture(imageNamed:"howToPlay7")]
    
    override func didMoveToView(view: SKView) {
        loadview()
        addTip()
    }
    
    func loadview() {
        
        self.backgroundColor = SKColor(red: 31/255, green: 30/255, blue: 30/255, alpha: 1.0)
        
        howToPlayImage = SKSpriteNode(imageNamed: "howToPlay1")
        counter = 0
        howToPlayImage.position = CGPoint(x: self.frame.width/2, y: self.frame.height/2)
        self.addChild(howToPlayImage)
        
        goBack = SKSpriteNode(imageNamed: "backButton")
        goBack.anchorPoint = CGPoint(x: 0.5, y: 1.0)
        goBack.position = CGPoint(x: self.frame.width/2 - 175, y: self.frame.height - 65)
        goBack.size = CGSize(width:50, height: 50)
        goBack.zPosition = 15
        self.addChild(goBack)
        let scaleup = SKAction.scaleTo(1.1, duration: 0.25)
        let scaleDown = SKAction.scaleTo(1.0, duration: 0.25)
        goBack.runAction(SKAction.repeatActionForever(SKAction.sequence([scaleup,scaleDown])))
    }
    
    func addTip() {
        backGround = SKShapeNode(rect: CGRect(x: -self.frame.width/2, y: -self.frame.height/2, width: self.frame.width, height: self.frame.height))
        backGround.fillColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.65)
        backGround.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        backGround.zPosition = 10
        backGround.strokeColor = UIColor.clearColor()
        self.addChild(backGround)
        
        tip = SKSpriteNode(imageNamed: "tipButton")
        backGround.addChild(tip)
        
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let touch = touches.first{
            let touchLocation = touch.locationInNode(self)
            
            if goBack.containsPoint(touchLocation) && tipActive == false {
                goBack.alpha = 0.5
            }
            else {
                goBack.alpha = 1.0
            }
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let touch = touches.first{
            let tiplocation = touch.locationInNode(backGround)
            let touchLocation = touch.locationInNode(self)
            if goBack.containsPoint(touchLocation){
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
                goBack.alpha = 1.0
            }
            
            if tipActive == false && goBack.containsPoint(touchLocation) == false {
                changeImage(touches)
            }
            
            if tip.containsPoint(tiplocation) {
                backGround.removeAllChildren()
                backGround.removeFromParent()
                tipActive = false
            }
        }
        


    }
    
    func changeImage(touches: Set<UITouch>) {
        let upperLimit = cycle.count-1
        let lowerLimit = 0
        
        if let touch = touches.first {
            let touchLocation = touch.locationInNode(self)
            if (touchLocation.x > self.frame.size.width/2) {
                if counter == upperLimit {
                    counter = 0
                }
                else {
                    counter += 1
                }
                
                howToPlayImage.texture = cycle[counter]
            }
            else if (touchLocation.x < self.frame.size.width/2) {
                if counter == lowerLimit {
                    counter = upperLimit
                }
                else {
                    counter -= 1
                }
                
                howToPlayImage.texture = cycle[counter]
            }
        }
    }

    
}
