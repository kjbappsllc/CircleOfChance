//
//  Items.swift
//  CircleOfChance
//
//  Created by Mac on 1/23/17.
//  Copyright © 2017 KJB Apps LLC. All rights reserved.
//

import Foundation
import SpriteKit

class items {
    fileprivate var _unlocked: [item]
    
    var unlocked: [item] {
        get {
            return _unlocked
        }
        set {
            _unlocked = newValue
        }
    }
    
    fileprivate var _current: item
    
    var current: item {
        get {
            return _current
        }
        set {
            _current = newValue
            NSKeyedArchiver.archiveRootObject(_current, toFile: item.CurrentArchiveURL.path)
        }
    }
    
    init() {
        let defaultItem = item(item: .skin, sprite: SKSpriteNode(imageNamed: "ball"), name: "BLUE", price: 0)
        
        _unlocked = [item]()
        _current = defaultItem
        
        if let saveditems = loadItems() {
            _unlocked += saveditems
        }
        else {
            _unlocked.append(defaultItem)
        }
        
        if let currentitem = loadCurrentSkin() {
            _current = currentitem
        }
        
    }
    
    //Mark: NSCoding
    
    func saveItems() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(_unlocked, toFile: item.UnlockedArchiveURL.path)
        if !isSuccessfulSave {
            print("Failed to save Items...")
        }
    }
    
    func loadItems() -> [item]? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: item.UnlockedArchiveURL.path) as? [item]
    }
    
    func loadCurrentSkin() -> item? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: item.CurrentArchiveURL.path) as? item
    }
    
    //Initial Skins
    func loadInitialSkins() -> [item] {
        var skinsArray = [item]()
        let skin1 = item(item: .skin, sprite: SKSpriteNode(imageNamed: "ball"), name: "BLUE", price: 0)
        skinsArray.append(contentsOf: [skin1])
        return skinsArray
        
    }
    
    func loadInitialThemes() -> [item] {
        let themesArray = [item]()
        
        return themesArray
        
    }
}
