//
//  Character.swift
//  Circle Of Chance
//
//  Created by Mac on 6/16/16.
//  Copyright © 2016 KJB Apps LLc. All rights reserved.
//

import Foundation
import SpriteKit

class Character: SKSpriteNode {
    var ballSpeedClockWise = CGFloat()
    var ballSpeedCounterClockWise = CGFloat()
    init(){
        ballSpeedClockWise = 195.0
        ballSpeedCounterClockWise = 195.0
        let texture = SKTexture(imageNamed: "ball")
        super.init(texture: texture,color: UIColor.clearColor(), size: CGSize(width: 50, height: 55))
        
        loadPhysics()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func getballSpeedClockWise() -> CGFloat {
        return ballSpeedClockWise
    }
    
    func getballSpeedCounterClockWise() -> CGFloat {
        return ballSpeedCounterClockWise
    }
    
    func AddBallSpeedClockWise(add: CGFloat) -> CGFloat {
        ballSpeedClockWise += add
        return ballSpeedClockWise
    }
    
    func AddBallSpeedCounterClockWise(add:CGFloat) -> CGFloat {
        ballSpeedCounterClockWise += add
        return ballSpeedCounterClockWise
    }
    
    func SetBallSpeedCounterClockWise(new:CGFloat) -> CGFloat {
        ballSpeedCounterClockWise = new
        return ballSpeedCounterClockWise
    }
    
    func SetBallSpeedClockWise(new:CGFloat) -> CGFloat {
        ballSpeedClockWise = new
        return ballSpeedClockWise
    }
    
    func loadPhysics() {
        
        self.physicsBody = SKPhysicsBody(circleOfRadius: self.size.height/2 - 15)
        self.physicsBody?.categoryBitMask = ballCategory
        self.physicsBody?.contactTestBitMask = redBarrierCategory | dotCategory
        self.physicsBody?.collisionBitMask = redBarrierCategory
        self.physicsBody?.affectedByGravity = false
    }
    
}
