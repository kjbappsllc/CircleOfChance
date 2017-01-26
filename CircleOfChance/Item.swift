//
//  Item.swift
//  CircleOfChance
//
//  Created by Mac on 1/25/17.
//  Copyright © 2017 KJB Apps LLC. All rights reserved.
//

import Foundation
import SpriteKit

enum itemType: Int {
    case skin, theme
}

class item: NSObject, NSCoding{
    static let DocumentsDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    static let UnlockedArchiveURL = DocumentsDirectory.URLByAppendingPathComponent("unlockedItem")
    static let CurrentArchiveURL = DocumentsDirectory.URLByAppendingPathComponent("currentSkin")
    
    private var _itemtype: itemType
    
    var itemtype: itemType {
        get{
            return _itemtype
        }
        set{
            _itemtype = newValue
        }
    }
    
    private var _sprite: SKSpriteNode
    
    var sprite: SKSpriteNode{
        get{
            return _sprite
        }
        set{
            _sprite = newValue
        }
    }
    
    private var _name: String
    
    var name: String{
        get{
            return _name
        }
        set {
            _name = newValue
        }
    }
    private var _price: Int
    
    var price:Int {
        get{
            return _price
        }
        set {
            _price = newValue
        }
    }
    
    override var description: String{
        return "\(name)"
    }
    
    init(item: itemType, sprite: SKSpriteNode, name: String, price: Int) {
        self._itemtype = item
        self._sprite = sprite
        self._name = name
        self._price = price
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let price = aDecoder.decodeObjectForKey("price") as! Int
        let sprite = aDecoder.decodeObjectForKey("sprite") as! SKSpriteNode
        let name = aDecoder.decodeObjectForKey("name") as! String
        let itemtype = aDecoder.decodeIntegerForKey("item")
        self.init(item: itemType.init(rawValue: itemtype)!, sprite: sprite, name: name, price: price)
        
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(_name, forKey: "name")
        aCoder.encodeObject(_price, forKey: "price")
        aCoder.encodeObject(_sprite, forKey: "sprite")
        aCoder.encodeInteger(_itemtype.rawValue, forKey: "item")
    }
}
