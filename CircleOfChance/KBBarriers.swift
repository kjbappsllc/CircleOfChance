//
//  Barriers.swift
//  Circle Of Chance
//
//  Created by Mac on 6/16/16.
//  Copyright © 2016 KJB Apps LLc. All rights reserved.
//

import Foundation
import SpriteKit

class barrier: SKSpriteNode {
    var passable = Bool()
    var barrierSpeed = CGFloat()
    var isActive = Bool()
    init(){
        isActive = false
        barrierSpeed = 125.0
        passable = true
        let texture = SKTexture(imageNamed: "RedBarrier")
        super.init(texture: texture,color: UIColor.clearColor(), size: texture.size())
        alpha = 0
        zPosition = layerPositions.barriers.rawValue
    }
    
    required internal init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func canPass() {
        self.passable = true
        self.physicsBody = nil
    }
    
    func notPassable() {
        self.passable = false
        let texture =  SKTexture(imageNamed: "RedBarrier")
        self.texture = texture
        self.loadPhysicsBodySize(self.texture!.size())
    }
    
    func removeBarrier(){
        let fadeOut = SKAction.fadeAlphaTo(0.0, duration: 0.0)
        self.runAction(fadeOut)
        self.canPass()
        self.physicsBody = nil
        isActive = false
    }
    
    func addRedBarrier() {
        isActive = true
        self.texture = SKTexture(imageNamed: "RedBarrierIndicator")
        self.physicsBody = nil
        let fadeIn = SKAction.fadeInWithDuration(0.2)
        let fadeOut = SKAction.fadeAlphaTo(0.0, duration: 0.2)
        
        let pulse = SKAction.sequence([fadeIn,fadeOut])
        let cycle = SKAction.repeatAction(pulse, count: 3)
        
        self.runAction(cycle) { 
            self.notPassable()
            self.alpha = 1
        }
    }
    
    func loadPhysicsBodySize(size: CGSize){
        physicsBody = SKPhysicsBody(rectangleOfSize: size)
        physicsBody?.categoryBitMask = redBarrierCategory
        physicsBody?.contactTestBitMask = ballCategory
        physicsBody?.collisionBitMask = ballCategory
        physicsBody?.affectedByGravity = false
        physicsBody?.dynamic = false
    }
    
    func GetBarrierSpeed() -> CGFloat {
        return barrierSpeed
    }
    
    func SetBarrierSpeed(newValue: CGFloat) -> CGFloat {
        barrierSpeed = newValue
        return barrierSpeed
    }
    
}
