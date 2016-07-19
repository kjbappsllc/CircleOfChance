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
        ballSpeedClockWise = 155.0
        ballSpeedCounterClockWise = 155.0
        let texture = SKTexture(imageNamed: "Character")
        super.init(texture: texture,color: UIColor.clearColor(), size: CGSize(width: 32, height: 32))
        
        self.physicsBody = SKPhysicsBody(circleOfRadius: 4.25)
        self.physicsBody?.categoryBitMask = ballCategory
        self.physicsBody?.contactTestBitMask = redBarrierCategory | dotCategory | textCategory
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.usesPreciseCollisionDetection = true
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
    
}
