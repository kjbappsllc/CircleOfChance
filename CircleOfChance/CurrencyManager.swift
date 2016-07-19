//
//  CurrencyManager.swift
//  Circle Of Chance
//
//  Created by Mac on 6/16/16.
//  Copyright © 2016 KJB Apps LLc. All rights reserved.
//

import SpriteKit

class CurrencyManager: NSObject {
    var coins: Int {
        
        set(value) {
            NSUserDefaults.standardUserDefaults().setInteger(value, forKey: "coins")
        }
        get {
            return NSUserDefaults.standardUserDefaults().integerForKey("coins")
        }
    }
    
    var totalCoins: Int {
        set(value) {
            NSUserDefaults.standardUserDefaults().setInteger(value, forKey: "totalcoins")
        }
        
        get {
            return NSUserDefaults.standardUserDefaults().integerForKey("totalcoins")
        }
    }
    
    var games: Int {
        set(value) {
            NSUserDefaults.standardUserDefaults().setInteger(value, forKey: "games")
        }
        
        get {
            return NSUserDefaults.standardUserDefaults().integerForKey("games")
        }
    }
}
