//
//  ShopScene.swift
//  Circle of Chance
//
//  Created by Mac on 6/8/16.
//  Copyright © 2016 KJB Apps LLC. All rights reserved.
//
import SpriteKit
import GameKit
import GoogleMobileAds

class SkinsScene: SKScene {
    
    var shopTextContainer = SKSpriteNode()
    var backtoMenuButton = SKSpriteNode()
    var skinsText = SKLabelNode()
    var coinBox = SKSpriteNode()
    var coins = SKLabelNode()
    
    /// Moveable node in the scrollView
    var startY: CGFloat = 0.0
    var lastY: CGFloat = 0.0
    var moveableArea = SKNode()
    var moving = Bool()
    
    var skinsArray = [Skins]()
    let unlockSound = SKAction.playSoundFileNamed("unlock.mp3", waitForCompletion: false)
    
    var nodesArray = [SKShapeNode]()
    var gameCenterAchievements = [String:GKAchievement]()
    var currency = CurrencyManager()
    var bottomLimit = CGFloat()
    
    static var currentSkin = String()
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        loadAchievementPercentages()
        
            // Load the initial data
        if let savedskins = loadSkins() {
            skinsArray += savedskins
        }
        else {
            loadInitialSkins()
        }
        
        if (NSUserDefaults.standardUserDefaults().stringForKey("currentSkin") != nil){
            SkinsScene.currentSkin = NSUserDefaults.standardUserDefaults().stringForKey("currentSkin")!
        }
        else{
            SkinsScene.currentSkin = "Character"
        }
        scene?.backgroundColor = UIColor(red: 31/255, green: 30/255, blue: 30/255, alpha: 1.0)
        addTitle()
        
        /// add moveable node
        moveableArea.position = CGPointMake(0, 0)
        self.addChild(moveableArea)
        addSkins()
    }
    
    //MARK: Scene setup
    func addTitle() {
        shopTextContainer = SKSpriteNode(imageNamed: "ShoppingTopContainer")
        shopTextContainer.size = CGSize(width: self.size.width, height: shopTextContainer.size.height + 50)
        shopTextContainer.position = CGPoint(x: self.frame.width/2, y: self.frame.height - 65)
        shopTextContainer.zPosition = 10
        self.addChild(shopTextContainer)
        
        backtoMenuButton = SKSpriteNode(imageNamed: "backButton")
        backtoMenuButton.anchorPoint = CGPoint(x: 1.0, y: 0.5)
        backtoMenuButton.size = CGSize(width: backtoMenuButton.size.width - 5, height: backtoMenuButton.size.height - 5)
        backtoMenuButton.position = CGPoint(x: -120, y: -5)
        backtoMenuButton.zPosition = 15
        shopTextContainer.addChild(backtoMenuButton)
        
        skinsText.fontName = "DayPosterBlack"
        skinsText.fontSize = 50.0
        skinsText.text = "Skins"
        skinsText.position = CGPoint(x: 0, y: -18)
        skinsText.zPosition = 15
        shopTextContainer.addChild(skinsText)
        
        coinBox = SKSpriteNode(imageNamed: "coinBox")
        coinBox.position = CGPoint(x: 0, y: -45)
        coinBox.zPosition = 1
        shopTextContainer.addChild(coinBox)
        coins.fontName = "DayPosterBlack"
        coins.fontColor = UIColor.whiteColor()
        coins.position = CGPoint(x: 0, y: -6)
        coins.zPosition = 15
        coins.text = "\(currency.coins)"
        coins.fontSize = 16.0
        coinBox.addChild(coins)
    }
    
    func loadInitialSkins() {
        let skin0 = Skins(name: "Character", price: 0, locked: false)
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
        
        skinsArray += [skin0,skin1,skin2,skin3,skin4,skin5,skin6,skin7,skin8,skin9,skin10,skin11,skin12,skin13,skin14,skin15,
                    skin16,skin17,skin18,skin19,skin20,skin21,skin22,skin23,skin24,skin25,skin26,skin27,skin28,skin29,skin30, skin31,skin32,skin33,skin34,skin35,skin36,skin37,skin38,skin39,skin40,skin41,skin42,skin43,skin44,skin45,skin46,skin47
                    ]
    }
    
    func addSkins() {
        
        for i in 0...skinsArray.count-1 {
            let shape = SKShapeNode(rectOfSize: CGSize(width: 283, height: 73), cornerRadius: 40.05)
            shape.position = CGPoint(x: self.frame.width/2, y: self.frame.height - 105*CGFloat(i) - 215)
            shape.strokeColor = UIColor(red: 133/255, green: 0, blue: 241/255, alpha: 1.0)
            shape.fillColor = UIColor(red: 1/255, green: 1/255, blue: 1/255, alpha: 0.78)
            shape.name = String(format: "skin%d", i)
            nodesArray.append(shape)
            moveableArea.addChild(shape)
            
            let price = SKLabelNode()
            price.text = "\(skinsArray[i].price)"
            price.fontSize = 15.0
            price.fontName = "DayPosterBlack"
            price.fontColor = UIColor.whiteColor()
            price.position = CGPoint(x: 0, y: -30)
            price.name = "price"
            shape.addChild(price)
            
            let skin = SKSpriteNode(imageNamed: skinsArray[i].name)
            skin.name = "skin"
            skin.zPosition = 1
            skin.position = CGPoint(x: 0, y: 4)
            shape.addChild(skin)
            
            if skinsArray[i].locked == true {
                let locked = SKSpriteNode(imageNamed: "lock")
                locked.name = "lock"
                locked.position = CGPoint(x: -shape.frame.size.width/2 + 50, y: 0)
                shape.addChild(locked)
                skin.alpha = 0.45
            }
            else if skinsArray[i].locked == false {
                shape.fillColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.1)
                skin.alpha = 1.0
                let locked = SKSpriteNode(imageNamed: "unlock")
                locked.name = "lock"
                locked.position = CGPoint(x: -shape.frame.size.width/2 + 50, y: 0)
                shape.addChild(locked)
                price.removeFromParent()
            }
            
            if skinsArray[i].name == SkinsScene.currentSkin {
                shape.strokeColor = UIColor(red: 65/255, green: 117/255, blue: 5/255, alpha: 1.0)
                shape.lineWidth = 3.0
            }
        }
        
    }
    
    //Mark: NSCoding
    
    func saveSkins() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(skinsArray, toFile: Skins.ArchiveURL!.path!)
        if !isSuccessfulSave {
            print("Failed to save Skins...")
        }
    }
    
    func loadSkins() -> [Skins]? {
        return NSKeyedUnarchiver.unarchiveObjectWithFile(Skins.ArchiveURL!.path!) as? [Skins]
    }
    
    /// Touches began,
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        // store the starting position of the touch
        
        for touch in touches {
            let location = touch.locationInNode(self)
            let goBack = touch.locationInNode(shopTextContainer)
            startY = location.y
            lastY = location.y
            if backtoMenuButton.containsPoint(goBack){
                backtoMenuButton.alpha = 0.7
            }
            else {
                backtoMenuButton.alpha = 1.0
            }
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches {
            let location = touch.locationInNode(self)
            let goBack = touch.locationInNode(shopTextContainer)
            let touchedNode = self.nodeAtPoint(location)
            if backtoMenuButton.containsPoint(goBack) && backtoMenuButton.alpha != 1{
                if let scene = ShopScene(fileNamed:"GameScene") {
                    
                    // Configure the view.
                    let skView = self.view as SKView!
                    skView.showsFPS = true
                    skView.showsNodeCount = true
                    /* Sprite Kit applies additional optimizations to improve rendering performance */
                    skView.ignoresSiblingOrder = true
                    /* Set the scale mode to scale to fit the window */
                    scene.scaleMode = .AspectFill
                    let transition = SKTransition.fadeWithDuration(0.8)
                    skView.presentScene(scene, transition: transition)
                }
            }
            
            else {
                backtoMenuButton.alpha = 1.0
            }
            if startY == lastY {
                for i in 0...skinsArray.count-1 {
                    if touchedNode.name == String(format: "skin%d", i) || touchedNode.inParentHierarchy(nodesArray[i]){
                        let price = skinsArray[i].price
                        if price < currency.coins && skinsArray[i].locked == true {
                            currency.coins -= price
                            coins.text = "\(currency.coins)"
                            skinsArray[i].locked = false
                            
                            incrementCurrentPercentageOfAchievement("achievement_skin", amount: 100.0)
                            incrementCurrentPercentageOfAchievement("achievement_5skin", amount: (1/5)*100)
                            
                            nodesArray[i].fillColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.1)
                            for child in nodesArray[i].children {
                                if child.name == "lock" {
                                    child.removeFromParent()
                                    let locked = SKSpriteNode(imageNamed: "unlock")
                                    locked.name = "lock"
                                    locked.position = CGPoint(x: -nodesArray[i].frame.size.width/2 + 50, y: 0)
                                    nodesArray[i].addChild(locked)
                                }
                                else if child.name == "skin" {
                                    child.alpha = 1.0
                                }
                                else if child.name == "price" {
                                    child.removeFromParent()
                                }
                            }
                            saveSkins()

                            if GameScene.soundOn == true{
                                self.scene?.runAction(unlockSound)
                            }
                        }
                        else if skinsArray[i].locked == false {
                            SkinsScene.currentSkin = skinsArray[i].name
                            NSUserDefaults.standardUserDefaults().setObject(SkinsScene.currentSkin, forKey: "currentSkin")
                            if let scene = MainMenu(fileNamed:"GameScene") {
                                
                                // Configure the view.
                                let skView = self.view as SKView!
                                skView.showsFPS = true
                                skView.showsNodeCount = true
                                /* Sprite Kit applies additional optimizations to improve rendering performance */
                                skView.ignoresSiblingOrder = true
                                /* Set the scale mode to scale to fit the window */
                                scene.scaleMode = .AspectFill
                                let transition = SKTransition.fadeWithDuration(0.8)
                                skView.presentScene(scene, transition: transition)
                            }
                        }
                    }
                }
            }
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches {
            let location = touch.locationInNode(self)
            let currentY = location.y
            
            // Set Top and Bottom scroll distances, measured in screenlengths
            let topLimit:CGFloat = 0.0
            
            bottomLimit = CGFloat(skinsArray.count) / ((self.size.height + shopTextContainer.frame.height) / 119)
    
            // Set scrolling speed - Higher number is faster speed
            let scrollSpeed:CGFloat = 1.3
            
            // calculate distance moved since last touch registered and add it to current position
            let newY = moveableArea.position.y + ((currentY - lastY)*scrollSpeed)
            
            // perform checks to see if new position will be over the limits, otherwise set as new position
            if newY < self.size.height*(-topLimit) {
                moveableArea.position = CGPointMake(moveableArea.position.x, self.size.height*(-topLimit))
            }
            else if newY > self.size.height*bottomLimit {
                moveableArea.position = CGPointMake(moveableArea.position.x, self.size.height*bottomLimit)
            }
            else {
                moveableArea.position = CGPointMake(moveableArea.position.x, newY)
            }
            
            // Set new last location for next time
            lastY = currentY
        }
    }
    
    
    //MARK: GAMECENTER
    func saveHighscore(gameScore: Int) {
        
        if GKLocalPlayer.localPlayer().authenticated {
            
            let scoreReporter = GKScore(leaderboardIdentifier: "Highest_Scores")
            scoreReporter.value = Int64(gameScore)
            let scoreArray: [GKScore] = [scoreReporter]
            
            GKScore.reportScores(scoreArray, withCompletionHandler: {error -> Void in
                if error != nil {
                    print("An error has occured: \(error)")
                }
            })
        }
    }
    
    func loadAchievementPercentages() {
        
        GKAchievement.loadAchievementsWithCompletionHandler { (allAchievements, error) -> Void in
            
            if error != nil {
                print("GC could not load ach, error:\(error)")
            }
            else
            {
                //nil if no progress on any achiement
                if(allAchievements != nil) {
                    for theAchiement in allAchievements! {
                        
                        if let singleAchievement:GKAchievement = theAchiement {
                            
                            self.gameCenterAchievements[singleAchievement.identifier!] = singleAchievement
                        }
                    }
                }
                
                for(id,achievement) in self.gameCenterAchievements {
                    print("\(id) - \(achievement.percentComplete)")
                }
                
            }
        }
    }
    func incrementCurrentPercentageOfAchievement (identifier:String, amount:Double) {
        
        if GKLocalPlayer.localPlayer().authenticated {
            
            var currentPercentFound:Bool = false
            
            if ( gameCenterAchievements.count != 0) {
                
                for (id,achievement) in gameCenterAchievements {
                    print(id)
                    if (id == identifier) {
                        //progress on the achievement found
                        currentPercentFound = true
                        
                        var currentPercent:Double = achievement.percentComplete
                        
                        currentPercent = currentPercent + amount
                        
                        reportAchievement(identifier,percentComplete:currentPercent)
                        
                        break
                    }
                }
            }
            
            if (currentPercentFound == false) {
                //no progress on the achievement
                print("no progress")
                reportAchievement(identifier,percentComplete:amount)
                
            }
        }
    }
    
    func reportAchievement (identifier:String, percentComplete:Double) {
        
        let achievement = GKAchievement(identifier: identifier)
        
        achievement.percentComplete = percentComplete
        achievement.showsCompletionBanner = true
        
        let achievementArray: [GKAchievement] = [achievement]
        
        GKAchievement.reportAchievements(achievementArray, withCompletionHandler: {
            
            error -> Void in
            
            if ( error != nil) {
                print(error)
            }
                
            else {
                
                print ("reported achievement with % complete of \(percentComplete)")
                
                self.loadAchievementPercentages()
            }
            
        })
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
