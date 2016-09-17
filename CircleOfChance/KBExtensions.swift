//
//  KBExtension.swift
//  Circle Of Chance
//
//  Created by Mac on 6/16/16.
//  Copyright © 2016 KJB Apps LLc. All rights reserved.
//

import Foundation
import CoreGraphics

enum layerPositions: CGFloat {
    case background = 1, gamePlayArea, dots, character, barriers, topLayer, pauseLayer
}

public extension CollectionType {
    func shuffle() -> [Generator.Element] {
        var list = Array(self)
        list.shuffleInPlace()
        return list
    }
}

public extension MutableCollectionType where Index == Int {
    mutating func shuffleInPlace() {
        if count < 2 { return }
        
        for i in 0..<count - 1 {
            let j = Int(arc4random_uniform(UInt32(count - i))) + i
            guard i != j else { continue }
            swap(&self[i], &self[j])
        }
    }
}

public extension CGFloat {
    /// Rounds the double to decimal places value
    func roundToPlaces(places:Int) -> CGFloat{
        let divisor = pow(10.0, CGFloat(places))
        return round(self * divisor) / divisor
    }
}

