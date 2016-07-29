//
//  KBFateCards.swift
//  Circle Of Chance
//
//  Created by Mac on 6/16/16.
//  Copyright © 2016 KJB Apps LLc. All rights reserved.
//

import Foundation
import SpriteKit

class ChanceCard: SKSpriteNode {
    
    init() {
        let texture = SKTexture(imageNamed: "MotionCard")
        super.init(texture: nil, color: UIColor.clearColor(), size: texture.size())
        self.zPosition = 2
        self.hidden = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func animateAppear(texture: SKTexture) {
        self.hidden = false
        let scaleUp = SKAction.scaleTo(1.1, duration: 0.2)
        let scaleFurther = SKAction.scaleTo(1.3, duration: 0.2)
        let scaleDown = SKAction.scaleTo(1.0, duration: 0.2)
        
        self.runAction(scaleUp)
        self.texture = texture
        self.runAction(SKAction.sequence([scaleFurther,scaleDown]))
        self.alpha = 1
    }
    
    func animateDisappear() {
        let scale = SKAction.scaleTo(1.1, duration: 1.0)
        let disappear = SKAction.scaleTo(0.0, duration: 0.1)
        let cycle = SKAction.sequence([scale,disappear])
        self.runAction(cycle)
        
    }
    
}
