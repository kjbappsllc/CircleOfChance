//
//  ShopScene.swift
//  Circle of Chance
//
//  Created by Mac on 6/8/16.
//  Copyright © 2016 KJB Apps LLC. All rights reserved.
//

import SpriteKit
import StoreKit

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
    let productID: NSSet = NSSet(objects: "com.KJBApps.CircleOfChance.500", "com.KJBApps.CircleOfChance.doublecoins", "com.KJBApps.CircleOfChance.1250", "com.KJBApps.CircleOfChance.3500", "com.KJBApps.CircleOfChance.7500", "com.KJBApps.CircleOfChance.23000")
    
    var store: IAPHelper?
    var count = 0
    var list = [SKProduct]()
    
    override func didMoveToView(view: SKView) {
        
        store = IAPHelper(productIds: productID as! Set<ProductIdentifier>)
        
        if IAPHelper.canMakePayments() {
            store?.requestProducts({ (success, products) in
                if success {
                    self.list = products!
                }
            })
        }
        else {
            print("can't make payments")
        }
        
        
        Chartboost.setDelegate(self)
        addTitle()
        addSections()
        self.scene?.backgroundColor = UIColor(red: 31/255, green: 30/255, blue: 30/255, alpha: 1.0)
        
        if Chartboost.hasRewardedVideo(CBLocationIAPStore) == false {
            Chartboost.cacheRewardedVideo(CBLocationIAPStore)
            
        }
    }
    
    //MARK: Scene setup
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
        
        if IAPHelper.canMakePayments() {
            for product in list{
                let prodID = product.productIdentifier
                switch product.price.floatValue {
    
                    case 0.99:
                        count = 0
                    case 1.99:
                        count = 1
                    case 4.99:
                        count = 2
                    case 9.99:
                        count = 3
                    default:
                        count = 4
                    
                }
                if prodID != "com.KJBApps.CircleOfChance.doublecoins" {
                    let price = SKSpriteNode(imageNamed: "priceContainer")
                    price.name = prodID
                    price.zPosition = 15
                    price.position = CGPoint(x: 0, y: -60 * CGFloat(count) + 140)
                    shopMenu.addChild(price)
                    
                    let amountLabel = SKLabelNode()
                    amountLabel.fontName = "DayPosterBlack"
                    amountLabel.fontSize = 20.0
                    amountLabel.text = "\(product.localizedTitle)"
                    amountLabel.position = CGPoint(x: price.position.x - 30, y: -10)
                    amountLabel.zPosition = 20
                    price.addChild(amountLabel)
                    
                    let priceLabel = SKLabelNode()
                    priceLabel.position = CGPoint(x: price.position.x + 75, y: -10)
                    priceLabel.fontName = "DayPosterBlack"
                    priceLabel.fontSize = 20.0
                    priceLabel.text = "$\(product.price.floatValue)"
                    priceLabel.zPosition = 20
                    price.addChild(priceLabel)
                    
                }
            }
        }
        else {
            let unavailable = SKLabelNode()
            unavailable.fontName = "DayPosterBlack"
            unavailable.text = "Unavailable"
            unavailable.fontSize = 16.0
            shopMenu.addChild(unavailable)
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
                    SKPaymentQueue.defaultQueue().removeTransactionObserver(store!)
                    
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
            
            else if node == getMoreCoinsOptions {
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
            
            else if node == restorePurchasesButton {
                store?.restorePurchases()
            }
            
            else {
                for product in list {
                    if product.productIdentifier == node.name || product.productIdentifier == node.parent?.name{
                        store?.buyProduct(product)
                        
                        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ShopScene.handlePurchaseNotification(_:)),
                                                                         name: IAPHelper.IAPHelperPurchaseNotification,
                                                                         object: nil)
                        break
                    }
                }
            }
            
        }
    }
    
    func handlePurchaseNotification(notification: NSNotification) {
        coins.text = "\(currency.coins)"
        
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
