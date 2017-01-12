//
//  ThemesScene.swift
//  Circle of Chance
//
//  Created by Mac on 6/8/16.
//  Copyright © 2016 MasterKey. All rights reserved.
//

import SpriteKit
import GameKit

class ThemesScene: SKScene {
    
    var shopTextContainer = SKSpriteNode()
    var backtoMenuButton = SKSpriteNode()
    var themesText = SKLabelNode()
    var coinBox = SKSpriteNode()
    var coins = SKLabelNode()
    
    /// Moveable node in the scrollView
    var startY: CGFloat = 0.0
    var lastY: CGFloat = 0.0
    var moveableArea = SKNode()
    var moving = Bool()
    var currency = CurrencyManager()
    
    var ThemesArray = [Themes]()
    let unlockSound = SKAction.playSoundFileNamed("unlock.mp3", waitForCompletion: false)
    
    var nodesArray = [SKShapeNode]()
    var gameCenterAchievements = [String:GKAchievement]()
    
    static var currentTheme = [String:AnyObject]()
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
        loadAchievementPercentages()
        // Load the initial data
        if let savedthemes = loadThemes() {
            ThemesArray += savedthemes
        }
        else {
            loadInitialThemes()
        }
        
        if (NSUserDefaults.standardUserDefaults().objectForKey("currentTheme") != nil){
            let data = NSUserDefaults.standardUserDefaults().objectForKey("currentTheme") as! NSData
            ThemesScene.currentTheme = NSKeyedUnarchiver.unarchiveObjectWithData(data) as! [String:AnyObject]
        }
        else{
            ThemesScene.currentTheme = ["name": "defaultTheme", "OuterTexture": "Default", "InnerTexture": "Default", "dotTexture": "Default", "themeColor": SKColor(red: 133/255, green: 0, blue: 241/255, alpha: 1.0)]
        }
        scene?.backgroundColor = UIColor(red: 31/255, green: 30/255, blue: 30/255, alpha: 1.0)
        addTitle()
        
        /// add moveable node
        moveableArea.position = CGPointMake(0, 0)
        self.addChild(moveableArea)
        addThemes()
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
        
        themesText.fontName = "DayPosterBlack"
        themesText.fontSize = 50.0
        themesText.text = "Themes"
        themesText.position = CGPoint(x: 0, y: -18)
        themesText.zPosition = 1
        shopTextContainer.addChild(themesText)
        
        coinBox = SKSpriteNode(imageNamed: "coinBox")
        coinBox.position = CGPoint(x: 0, y: -45)
        coinBox.zPosition = 15
        shopTextContainer.addChild(coinBox)
        coins.fontName = "DayPosterBlack"
        coins.fontColor = UIColor.whiteColor()
        coins.position = CGPoint(x: 0, y: -6)
        coins.zPosition = 1
        coins.text = "\(currency.coins)"
        coins.fontSize = 16.0
        coinBox.addChild(coins)
    }
    func loadInitialThemes() {
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
        
        ThemesArray += [theme0,theme1,theme2,theme3,theme4,theme5,theme6,theme7,theme8,theme9,theme10,theme11]

    }
    
    func addThemes() {
        for i in 0...ThemesArray.count-1 {
            let shape = SKShapeNode(rectOfSize: CGSize(width: 283, height: 335), cornerRadius: 40.05)
            shape.position = CGPoint(x: self.frame.width/2, y: self.frame.height - 380*CGFloat(i) - 380)
            shape.strokeColor = UIColor(red: 133/255, green: 0, blue: 241/255, alpha: 1.0)
            shape.fillColor = UIColor(red: 1/255, green: 1/255, blue: 1/255, alpha: 0.78)
            shape.name = String(format: "theme%d", i)
            nodesArray.append(shape)
            moveableArea.addChild(shape)
            
            let price = SKLabelNode()
            price.text = "\(ThemesArray[i].price)"
            price.fontSize = 15.0
            price.fontName = "DayPosterBlack"
            price.fontColor = UIColor.whiteColor()
            price.position = CGPoint(x: -shape.frame.size.width/2 + 100, y: shape.frame.size.height/2 - 45)
            price.name = "price"
            shape.addChild(price)
            
            let theme = SKSpriteNode(imageNamed: ThemesArray[i].name)
            theme.name = "theme"
            theme.zPosition = 2
            shape.addChild(theme)
            
            if ThemesArray[i].locked == true {
                let locked = SKSpriteNode(imageNamed: "lock")
                locked.name = "lock"
                locked.position = CGPoint(x: -shape.frame.size.width/2 + 50, y: shape.frame.size.height/2 - 40)
                shape.addChild(locked)
                theme.alpha = 0.45
            }
            else if ThemesArray[i].locked == false {
                shape.fillColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.1)
                theme.alpha = 1.0
                let locked = SKSpriteNode(imageNamed: "unlock")
                locked.name = "lock"
                locked.position = CGPoint(x: -shape.frame.size.width/2 + 50, y: shape.frame.size.height/2 - 40)
                shape.addChild(locked)
                price.removeFromParent()
            }
            
            if ThemesArray[i].name == ThemesScene.currentTheme["name"] as! String {
                shape.strokeColor = UIColor(red: 65/255, green: 117/255, blue: 5/255, alpha: 1.0)
                shape.lineWidth = 3.0
            }
        }

    }
    
    //Mark: NSCoding
    
    func saveThemes() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(ThemesArray, toFile: Themes.ArchiveURL!.path!)
        if !isSuccessfulSave {
            print("Failed to save Themes...")
        }
    }
    
    func loadThemes() -> [Themes]? {
        return NSKeyedUnarchiver.unarchiveObjectWithFile(Themes.ArchiveURL!.path!) as? [Themes]
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
                for i in 0...ThemesArray.count-1 {
                    if touchedNode.name == String(format: "theme%d", i) || touchedNode.inParentHierarchy(nodesArray[i]){
                        let price = ThemesArray[i].price
                        if price < currency.coins && ThemesArray[i].locked == true {
                            currency.coins -= price
                            coins.text = "\(currency.coins)"
                            ThemesArray[i].locked = false
                            
                            incrementCurrentPercentageOfAchievement("achievement_theme", amount: 100.0)
                            incrementCurrentPercentageOfAchievement("achievement_3theme", amount: (1/3) * 100)
                            
                            nodesArray[i].fillColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.1)
                            for child in nodesArray[i].children {
                                if child.name == "lock" {
                                    child.removeFromParent()
                                    let locked = SKSpriteNode(imageNamed: "unlock")
                                    locked.name = "lock"
                                    locked.position = CGPoint(x: -nodesArray[i].frame.size.width/2 + 50, y: nodesArray[i].frame.size.height/2 - 40)
                                    nodesArray[i].addChild(locked)
                                }
                                else if child.name == "theme" {
                                    child.alpha = 1.0
                                }
                                else if child.name == "price" {
                                    child.removeFromParent()
                                }
                            }
                            saveThemes()
                            
                            if GameScene.soundOn == true{
                                self.scene?.runAction(unlockSound)
                            }
                        }
                        else if ThemesArray[i].locked == false {
                            ThemesScene.currentTheme["name"] = ThemesArray[i].name 
                            ThemesScene.currentTheme["outerTexture"] = ThemesArray[i].outerTexture 
                            ThemesScene.currentTheme["innerTexture"] = ThemesArray[i].innerTexture 
                            ThemesScene.currentTheme["dotTexture"] = ThemesArray[i].dotTexture
                            ThemesScene.currentTheme["themeColor"] = ThemesArray[i].themeColor 
                            let data = NSKeyedArchiver.archivedDataWithRootObject(ThemesScene.currentTheme)
                            NSUserDefaults.standardUserDefaults().setObject(data, forKey: "currentTheme")
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
            let bottomLimit:CGFloat = CGFloat(ThemesArray.count) / ((self.frame.height + shopTextContainer.frame.size.height) / 425)
            
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
