//
//  Skins.swift
//  Circle Of Chance
//
//  Created by Mac on 6/16/16.
//  Copyright © 2016 KJB Apps LLc. All rights reserved.
//
import SpriteKit

class Skins: NSObject, NSCoding {
    //MARK: Properties
    var name: String
    var price: Int
    var locked: Bool
    
    //MARK: Archiving Paths
    static let DocumentsDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.URLByAppendingPathComponent("skins")
    
    // MARK: Types
    
    struct PropertyKey {
        static let nameKey = "name"
        static let priceKey = "price"
        static let lockedKey = "locked"
    }
    
    init(name: String, price: Int, locked: Bool) {
        self.name = name
        self.price = price
        self.locked = locked
    }
    
    //MARK: NSCoding
    
    required convenience init?(coder aDecoder: NSCoder) {
        let name = aDecoder.decodeObjectForKey(PropertyKey.nameKey) as! String
        
        let price = aDecoder.decodeIntegerForKey(PropertyKey.priceKey)
        
        let locked = aDecoder.decodeBoolForKey(PropertyKey.lockedKey)
        
        self.init(name:name, price:price, locked: locked)
        
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(name, forKey: PropertyKey.nameKey)
        aCoder.encodeBool(locked, forKey: PropertyKey.lockedKey)
        aCoder.encodeInteger(price, forKey: PropertyKey.priceKey)
    }
}
