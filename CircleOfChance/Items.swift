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
    private var _unlocked: [item]
    
    var unlocked: [item] {
        get {
            return _unlocked
        }
        set {
            _unlocked = newValue
        }
    }
    
    var currentSkin: item{
        get {
            return NSUserDefaults.standardUserDefaults().objectForKey("currentSkin") as! item
        }
        set {
            NSUserDefaults.standardUserDefaults().setObject(newValue, forKey: "currentSkin")
        }
    }
    
    init() {
        _unlocked = [item]()

        if let saveditems = loadItems() {
            _unlocked += saveditems
        }
        else {
            _unlocked.append(item(item: .skin, sprite: SKSpriteNode(imageNamed: "ball"), name: "BLUE", price: 0))
        }
    }
    
    //Mark: NSCoding
    
    func saveItems() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(_unlocked, toFile: unlockedItems.ArchiveURL!.path!)
        if !isSuccessfulSave {
            print("Failed to save Items...")
        }
    }
    
    func loadItems() -> [item]? {
        return NSKeyedUnarchiver.unarchiveObjectWithFile(unlockedItems.ArchiveURL!.path!) as? [item]
    }
    
    //Initial Skins
    func loadInitialSkins() -> [item] {
        var skinsArray = [item]()
        let skin1 = item(item: .skin, sprite: SKSpriteNode(imageNamed: "ball"), name: "BLUE", price: 0)
        let skin2 = item(item: .skin, sprite: SKSpriteNode(imageNamed: "basketballSkin"), name: "BASKETBALL", price: 200)
        skinsArray.appendContentsOf([skin1,skin2])
        return skinsArray
        
    }
    
    func loadInitialThemes() -> [Themes] {
        let theme0 = Themes(name: "defaultTheme", themeColor: SKColor(red: 133/255, green: 0, blue: 241/255, alpha: 1.0), innerTexture: "Default", outerTexture: "Default", dotTexture: "Default", price: 0, locked: false)
        let theme1 = Themes(name: "spaceTheme", themeColor: SKColor(red: 133/255, green: 0, blue: 241/255, alpha: 1.0), innerTexture: "spaceInnerTexture", outerTexture: "spaceOuterTexture", dotTexture: "spaceDotTexture", price: 3500, locked: true)
        let theme2 = Themes(name: "sunsetTheme", themeColor: SKColor(red: 242/255, green: 151/255, blue: 0, alpha: 1.0), innerTexture: "sunsetInnerTexture", outerTexture: "sunsetOuterTexture", dotTexture: "sunsetDotTexture", price: 5500, locked: true)
        let theme3 = Themes(name: "forestTheme", themeColor: SKColor(red: 87/255, green: 163/255, blue: 0, alpha: 1.0), innerTexture: "forestInnerTexture", outerTexture: "forestOuterTexture", dotTexture: "forestDotTexture", price: 7500, locked: true)
        let theme4 = Themes(name: "futureTheme", themeColor: SKColor(red: 0, green: 97/255, blue: 221/255, alpha: 1.0), innerTexture: "futureInnerTexture", outerTexture: "futureOuterTexture", dotTexture: "futureDotTexture", price: 9500, locked: true)
        let theme5 = Themes(name: "warTheme", themeColor: SKColor(red: 88/255, green: 42/255, blue: 0, alpha: 1), innerTexture: "warInnerTexture", outerTexture: "warOuterTexture", dotTexture: "warDotTexture", price: 11500, locked: true)
        let theme6 = Themes(name: "wolfTheme", themeColor: SKColor(red: 0, green: 58/255, blue: 88/255, alpha: 1.0), innerTexture: "wolfInnerTexture", outerTexture: "wolfOuterTexture", dotTexture: "wolfDotTexture", price: 13500, locked: true)
        let theme7 = Themes(name: "discoTheme", themeColor: SKColor(red: 118/255, green: 0, blue: 125/255, alpha: 1.0), innerTexture: "discoInnerTexture", outerTexture: "discoOuterTexture", dotTexture: "discoDotTexture", price: 15500, locked: true)
        let theme8 = Themes(name: "pokemonTheme", themeColor: SKColor(red: 160/255, green: 160/255, blue: 160/255, alpha: 1.0), innerTexture: "pokemonInnerTexture", outerTexture: "pokemonOuterTexture", dotTexture: "pokemonDotTexture", price: 17500, locked: true)
        let theme9 = Themes(name: "candyTheme", themeColor: SKColor(red: 255/255, green: 120/255, blue: 120/255, alpha: 1.0), innerTexture: "candyInnerTexture", outerTexture: "candyOuterTexture", dotTexture: "candyDotTexture", price: 19500, locked: true)
        let theme10 = Themes(name: "worldsTheme", themeColor:SKColor(red: 255/255, green: 0, blue: 3/255, alpha: 1.0), innerTexture: "worldsInnerTexture", outerTexture: "worldsOuterTexture", dotTexture: "worldsDotTexture", price: 21500, locked: true)
        let theme11 = Themes(name: "royalTheme", themeColor: SKColor(red: 255/255, green: 168/255, blue: 0, alpha: 1.0), innerTexture: "royalInnerTexture", outerTexture: "royalOuterTexture", dotTexture: "royalDotTexture", price: 23500, locked: true)
        
        let themesArray = [theme0,theme1,theme2,theme3,theme4,theme5,theme6,theme7,theme8,theme9,theme10,theme11]
        
        return themesArray
        
    }
}
