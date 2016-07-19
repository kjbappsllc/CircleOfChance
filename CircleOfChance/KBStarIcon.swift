//
//  KBStarIcon.swift
//  Circle Of Chance
//
//  Created by Mac on 6/16/16.
//  Copyright © 2016 KJB Apps LLc. All rights reserved.
//
import Foundation
import SpriteKit

class StarIcon: SKSpriteNode {
    
    init(){

        let texture = SKTexture(imageNamed: "Star2")
        
        super.init(texture: texture ,color: UIColor.clearColor(), size: CGSize(width: 25, height: 24))
        
        zPosition = 2
        LoadPhysics()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func animateStar() {
        let scaled = SKAction.scaleTo(1.2, duration: 0.2)
        let scaleDown = SKAction.scaleTo(1.0, duration: 0.2)
        self.runAction(SKAction.repeatActionForever(SKAction.sequence([scaled,scaleDown])))
    }
    
    func LoadPhysics() {
        physicsBody = SKPhysicsBody(circleOfRadius: 2.5)
        physicsBody?.categoryBitMask = starCategory
        physicsBody?.contactTestBitMask = ballCategory
        physicsBody?.collisionBitMask = ballCategory
        physicsBody?.affectedByGravity = false
        physicsBody?.dynamic = false
    }
    
}
