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
    private var _unlocked: [unlockedItem]
    
    var unlocked: [unlockedItem] {
        get {
            return _unlocked
        }
        set {
            _unlocked = newValue
        }
    }
    
    private var _current: currentSkin
    
    var current: currentSkin {
        get {
            return _current
        }
        set {
            _current = newValue
            NSKeyedArchiver.archiveRootObject(_current, toFile: currentSkin.ArchiveURL!.path!)
        }
    }
    
    init() {
        let defaultItem = item(item: .skin, sprite: SKSpriteNode(imageNamed: "ball"), name: "BLUE", price: 0)
        
        _unlocked = [unlockedItem]()
        _current = currentSkin(items: defaultItem)
        
        if let saveditems = loadItems() {
            _unlocked += saveditems
        }
        else {
            _unlocked.append(unlockedItem(items: defaultItem))
        }
        
        if let currentitem = loadCurrentSkin() {
            _current = currentitem
        }
        
    }
    
    //Mark: NSCoding
    
    func saveItems() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(_unlocked, toFile: unlockedItem.ArchiveURL!.path!)
        if !isSuccessfulSave {
            print("Failed to save Items...")
        }
    }
    
    func loadItems() -> [unlockedItem]? {
        return NSKeyedUnarchiver.unarchiveObjectWithFile(unlockedItem.ArchiveURL!.path!) as? [unlockedItem]
    }
    
    func loadCurrentSkin() -> currentSkin? {
        return NSKeyedUnarchiver.unarchiveObjectWithFile(currentSkin.ArchiveURL!.path!) as? currentSkin
    }
    
    //Initial Skins
    func loadInitialSkins() -> [item] {
        var skinsArray = [item]()
        let skin1 = item(item: .skin, sprite: SKSpriteNode(imageNamed: "ball"), name: "BLUE", price: 0)
        let skin2 = item(item: .skin, sprite: SKSpriteNode(imageNamed: "basketballSkin"), name: "BASKETBALL", price: 200)
        skinsArray.appendContentsOf([skin1,skin2])
        return skinsArray
        
    }
    
    func loadInitialThemes() -> [item] {
        let themesArray = [item]()
        
        return themesArray
        
    }
}
