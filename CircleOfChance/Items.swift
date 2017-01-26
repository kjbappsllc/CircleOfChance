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
    
    init() {
        _unlocked = [unlockedItem]()
        
        if let saveditems = loadItems() {
            _unlocked += saveditems
        }
        else {
            let defaultItem = item(item: .skin, sprite: SKSpriteNode(imageNamed: "ball"), name: "BLUE", price: 0)
            _unlocked.append(unlockedItem(items: defaultItem))
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
