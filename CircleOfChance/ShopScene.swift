//
//  ShopScene.swift
//  Circle of Chance
//
//  Created by Mac on 6/8/16.
//  Copyright © 2016 KJB Apps LLC. All rights reserved.
//

import SpriteKit

class ShopScene: SKScene, ChartboostDelegate {
    var shopTextContainer = SKShapeNode()
    var backtoMenuButton = SKSpriteNode()
    var shopText = SKLabelNode()
    var coinBox = SKSpriteNode()
    var coins = SKLabelNode()
    var skinsSection = SKSpriteNode()
    var skinsSectionText = SKLabelNode()
    var trailSection = SKSpriteNode()
    var trailSectionText = SKLabelNode()
    var themesSection = SKSpriteNode()
    var themesSectionText = SKLabelNode()
    var getMoreCoinsButton = SKSpriteNode()
    var getMoreCoinsText = SKLabelNode()
    let button = SKAction.playSoundFileNamed("buttonTouched.wav", waitForCompletion: false)
    var currency = CurrencyManager()
    var doubleCoins = SKSpriteNode()
    var getMoreCoins = SKSpriteNode()
    
    var shopMenu = SKSpriteNode()
    var backGround = SKShapeNode()
    var exitButton = SKSpriteNode()
    var restorePurchasesButton = SKSpriteNode()
    
    var getMoreCoinsOptions = SKSpriteNode()
    var shading = SKSpriteNode()
    
    var shopActive = false
    
    var pricesArray = [Prices]()
    
    struct Prices {
        var amount = Int()
        var price = CGFloat()
    }
    
    var price0 = Prices()
    var price1 = Prices()
    var price2 = Prices()
    var price3 = Prices()
    var price4 = Prices()
    
    override func didMoveToView(view: SKView) {
        Chartboost.setDelegate(self)
        addPrices()
        addTitle()
        addSections()
        self.scene?.backgroundColor = UIColor(red: 31/255, green: 30/255, blue: 30/255, alpha: 1.0)
        
        if Chartboost.hasRewardedVideo(CBLocationIAPStore) == false {
            Chartboost.cacheRewardedVideo(CBLocationIAPStore)
            
        }

    }
    
    func addTitle() {
        shopTextContainer = SKShapeNode(rectOfSize: CGSize(width: self.frame.size.width, height: 130))
        shopTextContainer.position = CGPoint(x: self.frame.width/2, y: self.frame.height - 65)
        shopTextContainer.fillColor = UIColor(red: 133/255, green: 0, blue: 241/255, alpha: 1.0)
        shopTextContainer.strokeColor = UIColor.clearColor()
        self.addChild(shopTextContainer)
        
        backtoMenuButton = SKSpriteNode(imageNamed: "backButton")
        backtoMenuButton.anchorPoint = CGPoint(x: 1.0, y: 0.5)
        backtoMenuButton.position = CGPoint(x: -120, y: 0)
        backtoMenuButton.zPosition = 1
        shopTextContainer.addChild(backtoMenuButton)
        
        shopText.fontName = "DayPosterBlack"
        shopText.fontSize = 50.0
        shopText.text = "Shop"
        shopText.position = CGPoint(x: 0, y: -23)
        shopTextContainer.addChild(shopText)
        
        coinBox = SKSpriteNode(imageNamed: "coinBox")
        coinBox.position = CGPoint(x: 0, y: -50)
        shopTextContainer.addChild(coinBox)
        coins.fontName = "DayPosterBlack"
        coins.fontColor = UIColor.whiteColor()
        coins.position = CGPoint(x: 0, y: -6)
        coins.zPosition = 1
        coins.text = "\(currency.coins)"
        coins.fontSize = 16.0
        coinBox.addChild(coins)
    }
    
    func addSections() {
        
        doubleCoins = SKSpriteNode(imageNamed: "doubleCoinsButton")
        doubleCoins.position = CGPoint(x: self.frame.width/2, y: self.frame.height/2 - 215)
        self.addChild(doubleCoins)
        
        skinsSection = SKSpriteNode(imageNamed: "shopTextContainer")
        skinsSection.position = CGPoint(x: self.frame.width/2, y: self.frame.height/2 + 120)
        skinsSection.size = CGSize(width: doubleCoins.size.width, height: skinsSection.size.height)
        self.addChild(skinsSection)
        skinsSectionText.fontName = "DayPosterBlack"
        skinsSectionText.text = "Skins"
        skinsSectionText.position = CGPoint(x: 0, y: -9)
        skinsSectionText.zPosition = 1
        skinsSectionText.fontSize = 40.0
        skinsSectionText.fontColor = UIColor.whiteColor()
        skinsSection.addChild(skinsSectionText)
        
        themesSection = SKSpriteNode(imageNamed: "shopTextContainer")
        themesSection.position = CGPoint(x: self.frame.width/2, y: self.frame.height/2 - 15)
        themesSection.size = CGSize(width: doubleCoins.size.width, height: themesSection.size.height)
        self.addChild(themesSection)
        themesSectionText.fontName = "DayPosterBlack"
        themesSectionText.text = "Themes"
        themesSectionText.position = CGPoint(x: 0, y: -9)
        themesSectionText.zPosition = 1
        themesSectionText.fontSize = 40.0
        themesSectionText.fontColor = UIColor.whiteColor()
        themesSection.addChild(themesSectionText)
        
        getMoreCoins = SKSpriteNode(imageNamed: "getMoreCoinsButton")
        getMoreCoins.position = CGPoint(x: self.frame.width/2, y: self.frame.height/2 - 135)
        getMoreCoins.size = CGSize(width: doubleCoins.size.width, height: getMoreCoins.size.height)
        self.addChild(getMoreCoins)
        

        
    }
    
    func addShopButtons() {
        backGround = SKShapeNode(rect: CGRect(x: -self.frame.width/2, y: -self.frame.height/2, width: self.frame.width, height: self.frame.height))
        backGround.fillColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.65)
        backGround.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        backGround.strokeColor = UIColor.clearColor()
        backGround.zPosition = 10
        self.addChild(backGround)
        
        shopMenu = SKSpriteNode(imageNamed: "shopMenu")
        shopMenu.setScale(0)
        backGround.addChild(shopMenu)
        
        shopMenu.runAction(SKAction.scaleTo(1.0, duration: 0.2))
        
        exitButton = SKSpriteNode(imageNamed: "exitButton")
        exitButton.position = CGPoint(x: shopMenu.position.x - 112 , y: shopMenu.position.y + 176)
        exitButton.zPosition = 5
        shopMenu.addChild(exitButton)
        
        for i in 0...pricesArray.count-1 {
            let price = SKSpriteNode(imageNamed: "priceContainer")
            price.name = String(format: "price%d", i)
            price.zPosition = 15
            price.position = CGPoint(x: 0, y: -55 * CGFloat(i) + 130)
            shopMenu.addChild(price)
            
            let amountLabel = SKLabelNode()
            amountLabel.fontName = "DayPosterBlack"
            amountLabel.fontSize = 20.0
            amountLabel.text = "\(pricesArray[i].amount)"
            amountLabel.position = CGPoint(x: price.position.x - 30, y: -10)
            amountLabel.zPosition = 20
            price.addChild(amountLabel)
            
            let priceLabel = SKLabelNode()
            priceLabel.position = CGPoint(x: price.position.x + 75, y: -10)
            priceLabel.fontName = "DayPosterBlack"
            priceLabel.fontSize = 20.0
            priceLabel.text = "$\(pricesArray[i].price)"
            priceLabel.zPosition = 20
            price.addChild(priceLabel)
            
            if i == pricesArray.count-1 {
                let bestValue = SKLabelNode()
                bestValue.fontName = "DayPosterBlack"
                bestValue.fontSize = 17.0
                bestValue.text = "best value"
                bestValue.zPosition = 20
                bestValue.position = CGPoint(x: price.position.x, y: price.position.y - 40)
                shopMenu.addChild(bestValue)
            }
        }
        
        restorePurchasesButton = SKSpriteNode(imageNamed: "restorePurchases")
        restorePurchasesButton.position = CGPoint(x: shopMenu.position.x, y: shopMenu.position.y - 165)
        restorePurchasesButton.zPosition = 20
        shopMenu.addChild(restorePurchasesButton)
        
        let restorePurchasesLabel = SKLabelNode()
        restorePurchasesLabel.fontName = "DayPosterBlack"
        restorePurchasesLabel.fontSize = 20.0
        restorePurchasesLabel.text = "Restore Purchases"
        restorePurchasesLabel.position = CGPoint(x: 0, y: -10)
        restorePurchasesLabel.zPosition = 20
        restorePurchasesButton.addChild(restorePurchasesLabel)
    }
    
    func addOptions() {
        
        backGround = SKShapeNode(rect: CGRect(x: -self.frame.width/2, y: -self.frame.height/2, width: self.frame.width, height: self.frame.height))
        backGround.fillColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.65)
        backGround.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        backGround.strokeColor = UIColor.clearColor()
        backGround.zPosition = 10
        self.addChild(backGround)
        
        getMoreCoinsOptions = SKSpriteNode(imageNamed: "getMoreCoinsOptions")
        getMoreCoinsOptions.setScale(0)
        backGround.addChild(getMoreCoinsOptions)
        getMoreCoinsOptions.runAction(SKAction.scaleTo(1.0, duration: 0.2))
        
        exitButton = SKSpriteNode(imageNamed: "exitButton")
        exitButton.position = CGPoint(x: getMoreCoinsOptions.position.x + 145 , y: getMoreCoinsOptions.position.y + 65)
        exitButton.zPosition = 10
        getMoreCoinsOptions.addChild(exitButton)
        
        if Chartboost.hasRewardedVideo(CBLocationIAPStore) == false {
            shading = SKSpriteNode(imageNamed: "shadeShape")
            shading.zPosition = 5
            shading.position = CGPoint(x: getMoreCoinsOptions.position.x + 85, y: getMoreCoinsOptions.position.y)
            getMoreCoinsOptions.addChild(shading)
        }
    }
    
    func addPrices() {
        price0.amount = 500
        price0.price = 0.99
        pricesArray.append(price0)
        
        price1.amount = 1200
        price1.price = 1.99
        pricesArray.append(price1)
        
        price2.amount = 3000
        price2.price = 2.99
        pricesArray.append(price2)
        
        price3.amount = 8000
        price3.price = 9.99
        pricesArray.append(price3)
        
        price4.amount = 23000
        price4.price = 19.99
        pricesArray.append(price4)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let touch = touches.first{
            if shopActive == false {
                let touchLocation = touch.locationInNode(self)
                let backtoMenuTouch = touch.locationInNode(shopTextContainer)
                if backtoMenuButton.containsPoint(backtoMenuTouch) {
                    backtoMenuButton.alpha = 0.7
                }
                else {
                    backtoMenuButton.alpha = 1.0
                }
                if skinsSection.containsPoint(touchLocation) {
                    skinsSection.alpha = 0.5
                }
                else {
                    skinsSection.alpha = 1.0
                }
                
                if themesSection.containsPoint(touchLocation) {
                    themesSection.alpha = 0.5
                }
                else {
                    themesSection.alpha = 1.0
                }
                if getMoreCoins.containsPoint(touchLocation) {
                    getMoreCoins.alpha = 0.5
                }
                else {
                    getMoreCoins.alpha = 1.0
                }
            }
            
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let touch = touches.first{
            if shopActive == false {
                let touchLocation = touch.locationInNode(self)
                let backtoMenuTouch = touch.locationInNode(shopTextContainer)
                if backtoMenuButton.containsPoint(backtoMenuTouch) && backtoMenuButton.alpha != 1 {
                    if GameScene.soundOn == true{
                        self.scene?.runAction(buttonTouched)
                    }
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
                else {
                    backtoMenuButton.alpha = 1.0
                }
                
                if skinsSection.containsPoint(touchLocation) && skinsSection.alpha != 1 {
                    if GameScene.soundOn == true {
                        self.scene!.runAction(button)
                    }
                    if let scene = SkinsScene(fileNamed:"GameScene") {
                        
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
                    skinsSection.alpha = 1.0
                }
                
                if themesSection.containsPoint(touchLocation) && themesSection.alpha != 1 {
                    if GameScene.soundOn == true {
                        self.scene?.runAction(button)
                    }
                    if let scene = ThemesScene(fileNamed:"GameScene") {
                        
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
                    themesSection.alpha = 1.0
                }
                
                if getMoreCoins.containsPoint(touchLocation) && getMoreCoins.alpha != 1{
                    if GameScene.soundOn == true {
                        self.scene?.runAction(buttonTouched)
                    }
                    addOptions()
                    shopActive = true
                    getMoreCoins.alpha = 1.0
                }
                else {
                    getMoreCoins.alpha = 1.0
                }
                
                if coinBox.containsPoint(backtoMenuTouch) {
                    if GameScene.soundOn == true {
                        self.scene?.runAction(buttonTouched)
                    }
                    addShopButtons()
                    shopActive = true
                }
            }
            else {
                shopping(touches)
            }
        }
    }
    
    func shopping(touches: Set<UITouch>){
        if let touch = touches.first as UITouch! {
            let pos = touch.locationInNode(self)
            let node = self.nodeAtPoint(pos)
            
            if node == exitButton {
                if GameScene.soundOn == true {
                    self.scene?.runAction(buttonTouched)
                }
                backGround.removeAllChildren()
                backGround.removeFromParent()
                shopActive = false
            }
            
            if node == getMoreCoinsOptions {
                if GameScene.soundOn == true {
                    self.scene?.runAction(buttonTouched)
                }
                if pos.x < self.frame.size.width/2 {
                    backGround.removeAllChildren()
                    backGround.removeFromParent()
                    addShopButtons()
                }
                else if pos.x > self.frame.size.width/2 {
                    if Chartboost.hasRewardedVideo(CBLocationIAPStore) {
                        Chartboost.showRewardedVideo(CBLocationIAPStore)
                        SKTAudio.sharedInstance().pauseBackgroundMusic()
                    }
                }
            }
            
        }
    }
    
    func didCompleteRewardedVideo(location: String!, withReward reward: Int32) {
        if location == CBLocationIAPStore {
            currency.coins += Int(reward)
        }
        backGround.removeAllChildren()
        backGround.removeFromParent()
    }
    
    func didCloseRewardedVideo(location: String!) {
        if location == CBLocationIAPStore {
            coins.text = "\(currency.coins)"
            shopActive = false
        }
        backGround.removeFromParent()
        backGround.removeAllChildren()
        SKTAudio.sharedInstance().playBackgroundMusic(currentMusic)
    }

    
}
