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

class item: CustomStringConvertible{
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
    
    var description: String{
        return "\(name)"
    }
    
    init(item: itemType, sprite: SKSpriteNode, name: String, price: Int) {
        _itemtype = item
        _sprite = sprite
        _name = name
        _price = price
    }
}
