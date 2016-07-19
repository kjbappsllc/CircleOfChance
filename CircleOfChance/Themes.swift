//
//  Themes.swift
//  Circle Of Chance
//
//  Created by Mac on 6/16/16.
//  Copyright © 2016 KJB Apps LLc. All rights reserved.
//

import SpriteKit

class Themes: NSObject, NSCoding {
    //MARK: Properties
    var name: String
    var themeColor: SKColor
    var innerTexture: String
    var outerTexture: String
    var dotTexture: String
    var price: Int
    var locked: Bool
    
    //MARK: Archiving Paths
    static let DocumentsDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.URLByAppendingPathComponent("themes")
    
    // MARK: Types
    
    struct PropertyKey {
        static let nameKey = "name"
        static let themeColorKey = "themeColor"
        static let innerTextureKey = "innerTexture"
        static let outerTextureKey = "outerTexture"
        static let dotTextureKey = "dotTexture"
        static let priceKey = "price"
        static let lockedKey = "locked"
    }
    
    init(name: String, themeColor: SKColor, innerTexture: String, outerTexture: String, dotTexture: String, price: Int, locked: Bool) {
        self.name = name
        self.themeColor = themeColor
        self.innerTexture = innerTexture
        self.outerTexture = outerTexture
        self.dotTexture = dotTexture
        self.price = price
        self.locked = locked
    }
    
    //MARK: NSCoding
    
    required convenience init?(coder aDecoder: NSCoder) {
        let name = aDecoder.decodeObjectForKey(PropertyKey.nameKey) as! String
        
        let innerTexture = aDecoder.decodeObjectForKey(PropertyKey.innerTextureKey) as! String
        
        let outerTexture = aDecoder.decodeObjectForKey(PropertyKey.outerTextureKey) as! String
        
        let dotTexture = aDecoder.decodeObjectForKey(PropertyKey.dotTextureKey) as! String
        
        let price = aDecoder.decodeIntegerForKey(PropertyKey.priceKey)
        
        let themeColor = aDecoder.decodeObjectForKey(PropertyKey.themeColorKey) as! SKColor
        
        let locked = aDecoder.decodeBoolForKey(PropertyKey.lockedKey)
        
        self.init(name: name, themeColor: themeColor, innerTexture: innerTexture, outerTexture: outerTexture, dotTexture: dotTexture, price:price, locked: locked)
        
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(name, forKey: PropertyKey.nameKey)
        aCoder.encodeObject(themeColor, forKey: PropertyKey.themeColorKey)
        aCoder.encodeObject(outerTexture, forKey: PropertyKey.outerTextureKey)
        aCoder.encodeObject(innerTexture, forKey: PropertyKey.innerTextureKey)
        aCoder.encodeObject(dotTexture, forKey: PropertyKey.dotTextureKey)
        aCoder.encodeBool(locked, forKey: PropertyKey.lockedKey)
        aCoder.encodeInteger(price, forKey: PropertyKey.priceKey)
    }

}
