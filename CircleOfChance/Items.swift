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
    private var _skins: [Skins]
    
    var skins: [Skins] {
        get {
            return _skins
        }
        set {
            _skins = newValue
        }
    }
    
    private var _themes: [Themes]
    
    var themes: [Themes] {
        get {
            return _themes
        }
        set {
            _themes = newValue
        }
    }
    
    var currentSkin: SKTexture {
        get {
            return NSUserDefaults.standardUserDefaults().objectForKey("currentSkin") as! SKTexture
        }
        set {
            NSUserDefaults.standardUserDefaults().setObject(newValue, forKey: "currentSkin")
        }
    }
    
    init() {
        _skins = [Skins]()
        _themes = [Themes]()

        _skins += loadInitialSkins()
        
        if let savedthemes = loadThemes() {
            _themes += savedthemes
        }
        else {
            _themes += loadInitialThemes()
        }
        
        
    }
    
    //Mark: NSCoding
    
    func saveSkins() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(skins, toFile: Skins.ArchiveURL!.path!)
        if !isSuccessfulSave {
            print("Failed to save Skins...")
        }
    }
    
    func loadSkins() -> [Skins]? {
        return NSKeyedUnarchiver.unarchiveObjectWithFile(Skins.ArchiveURL!.path!) as? [Skins]
    }
    
    
    func saveThemes() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(themes, toFile: Themes.ArchiveURL!.path!)
        if !isSuccessfulSave {
            print("Failed to save Themes...")
        }
    }
    
    func loadThemes() -> [Themes]? {
        return NSKeyedUnarchiver.unarchiveObjectWithFile(Themes.ArchiveURL!.path!) as? [Themes]
    }
    
    //Initial Skins
    func loadInitialSkins() -> [Skins] {
        let skin0 = Skins(name: "Character", price: 0, locked: false)
        /*
        let skin1 = Skins(name: "blueCharacter", price: 200, locked: true)
        let skin2 = Skins(name: "blueGreenSkin", price: 400, locked: true)
        let skin3 = Skins(name: "pastureSkin", price: 500, locked: true)
        let skin4 = Skins(name: "squareSkin", price: 700, locked: true)
        let skin5 = Skins(name: "neonSkin", price: 800, locked: true)
        let skin6 = Skins(name: "darkMatterSkin", price: 800, locked: true)
        let skin7 = Skins(name: "scratchedSkin", price: 1000, locked: true)
        let skin8 = Skins(name: "volleyballSkin", price: 1200, locked: true)
        let skin9 = Skins(name: "cricketballSkin", price: 1200, locked: true)
        let skin10 = Skins(name: "tennisballSkin", price: 1200, locked: true)
        let skin11 = Skins(name: "soccerballSkin", price: 1200, locked: true)
        let skin12 = Skins(name: "baseballSkin", price: 1200, locked: true)
        let skin13 = Skins(name: "basketballSkin", price: 1200, locked: true)
        let skin14 = Skins(name: "americanflagSkin", price: 1400, locked: true)
        let skin15 = Skins(name: "brazilflagSkin", price: 1400, locked: true)
        let skin16 = Skins(name: "canadaflagSkin", price: 1400, locked: true)
        let skin17 = Skins(name: "mexicanflagSkin", price: 1400, locked: true)
        let skin18 = Skins(name: "russiaflagSkin", price: 1400, locked: true)
        let skin19 = Skins(name: "southafricaflagSkin", price: 1400, locked: true)
        let skin20 = Skins(name: "spanishflagSkin", price: 1400, locked: true)
        let skin21 = Skins(name: "ukflagSkin", price: 1400, locked: true)
        let skin22 = Skins(name: "eightballSkin", price: 1600, locked: true)
        let skin23 = Skins(name: "tieDyeSkin", price: 1800, locked: true)
        let skin24 = Skins(name: "yogaballSkin", price: 1900, locked: true)
        let skin25 = Skins(name: "flowerballSkin", price: 2100, locked: true)
        let skin26 = Skins(name: "mandmSkin", price: 2300, locked: true)
        let skin27 = Skins(name: "pokeballSkin", price: 2500, locked: true)
        let skin28 = Skins(name: "ultraballSkin", price: 2700, locked: true)
        let skin29 = Skins(name: "masterballSkin", price: 2900, locked: true)
        let skin30 = Skins(name: "golfballSkin", price: 3100, locked: true)
        let skin31 = Skins(name: "smileyfaceSkin", price: 3300, locked: true)
        let skin32 = Skins(name: "straightfaceSkin",price: 3500, locked: true)
        let skin33 = Skins(name: "checkersSkin", price: 3700, locked: true)
        let skin34 = Skins(name: "discoballSkin", price: 3900, locked: true)
        let skin35 = Skins(name: "beachballSkin", price: 4100, locked: true)
        let skin36 = Skins(name: "magicballSkin", price: 4300, locked: true)
        let skin37 = Skins(name: "faceSkin", price: 4500, locked: true)
        let skin38 = Skins(name: "crosshairSkin", price: 4700, locked: true)
        let skin39 = Skins(name: "bowlingballSkin", price: 4900, locked: true)
        let skin40 = Skins(name: "davidstarSkin", price: 5100, locked: true)
        let skin41 = Skins(name: "dragonballSkin", price: 5300, locked: true)
        let skin42 = Skins(name: "earthSkin", price: 5500, locked: true)
        let skin43 = Skins(name: "plutoSkin", price: 5700, locked: true)
        let skin44 = Skins(name: "galaxyBall", price: 5900, locked: true)
        let skin45 = Skins(name: "wolfballSkin", price: 6100, locked: true)
        let skin46 = Skins(name: "goldcoinSkin", price: 6300, locked: true)
        let skin47 = Skins(name: "royalSkin", price: 6500, locked: true)
        */
        
        let skinsArray = [skin0
        ]
        
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
