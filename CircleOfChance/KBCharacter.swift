//
//  Character.swift
//  Circle Of Chance
//
//  Created by Mac on 6/16/16.
//  Copyright © 2016 KJB Apps LLc. All rights reserved.
//

import Foundation
import SpriteKit

class Character {
    var ballSpeedClockWise = CGFloat()
    var ballSpeedCounterClockWise = CGFloat()
    private var _size: CGSize
    var size: CGSize {
        get{
            return _size
        }
        set{
            _size = newValue
        }
    }
    
    init(){
        ballSpeedClockWise = 195.0
        ballSpeedCounterClockWise = 195.0
        _size = CGSize(width: 55, height: 55)
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
    
    func loadPhysics() -> SKPhysicsBody{
        
        let physicsBody = SKPhysicsBody(circleOfRadius: self.size.height/2 - 15)
        physicsBody.categoryBitMask = ballCategory
        physicsBody.contactTestBitMask = redBarrierCategory | dotCategory
        physicsBody.collisionBitMask = redBarrierCategory
        physicsBody.affectedByGravity = false
        return physicsBody
    }
    
}
