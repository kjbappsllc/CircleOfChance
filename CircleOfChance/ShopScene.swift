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
    var shopTextContainer = SKSpriteNode()
    var backtoMenuButton = SKSpriteNode()
    var shopText = SKLabelNode()
    var coinBox = SKSpriteNode()
    var coins = SKLabelNode()
    var skinsSection = SKSpriteNode()
    var skinsSectionText = SKLabelNode()
    var themesSection = SKSpriteNode()
    var themesSectionText = SKLabelNode()
    var getMoreCoinsButton = SKSpriteNode()
    var getMoreCoinsText = SKLabelNode()
    let button = SKAction.playSoundFileNamed("buttonTouched.wav", waitForCompletion: false)
    var currency = CurrencyManager()
    var doubleCoins = SKSpriteNode()
    var getMoreCoins = SKSpriteNode()
    
    var shopMenu = SKSpriteNode()
    var shopMenuText = SKLabelNode()
    var backGround = SKShapeNode()
    var restorePurchasesButton = SKSpriteNode()
    var restorePurchasesLabel = SKLabelNode()
    
    var getMoreCoinsOptions = SKSpriteNode()

    let productID: NSSet = NSSet(objects:"com.KJBApps.CircleOfChance.doublecoins")
    
    var store: IAPHelper?
    var list = [SKProduct]()
    var doubleCoinsBool = Bool()
    
    override func didMoveToView(view: SKView) {
        
        doubleCoinsBool = NSUserDefaults.standardUserDefaults().boolForKey("com.KJBApps.CircleOfChance.doublecoins")
        
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
    
    deinit {
        SKPaymentQueue.defaultQueue().removeTransactionObserver(store!)
    }
    
    //MARK: Scene setup
    func addTitle() {
        
        shopTextContainer = SKSpriteNode(imageNamed: "ShoppingTopContainer")
        shopTextContainer.size = CGSize(width: self.size.width, height: shopTextContainer.size.height + 50)
        shopTextContainer.position = CGPoint(x: self.frame.width/2, y: self.frame.height - 65)
        self.addChild(shopTextContainer)
        
        backtoMenuButton = SKSpriteNode(imageNamed: "backButton")
        backtoMenuButton.anchorPoint = CGPoint(x: 1.0, y: 0.5)
        backtoMenuButton.size = CGSize(width: backtoMenuButton.size.width - 5, height: backtoMenuButton.size.height - 5)
        backtoMenuButton.position = CGPoint(x: -120, y: -5)
        backtoMenuButton.zPosition = 1
        shopTextContainer.addChild(backtoMenuButton)
        
        shopText.fontName = "DayPosterBlack"
        shopText.fontSize = 50.0
        shopText.text = "Shop"
        shopText.position = CGPoint(x: 0, y: -18)
        shopText.zPosition = 1
        shopTextContainer.addChild(shopText)
        
        coinBox = SKSpriteNode(imageNamed: "coinBox")
        coinBox.position = CGPoint(x: 0, y: -45)
        coinBox.zPosition = 1
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
        doubleCoins.position = CGPoint(x: self.frame.width/2 + 90, y: self.frame.height/2 - 85)
        
        if NSUserDefaults.standardUserDefaults().boolForKey("com.KJBApps.CircleOfChance.doublecoins") == true || !IAPHelper.canMakePayments() {
            doubleCoins.alpha = 0.5
        }
        self.addChild(doubleCoins)
        
        skinsSection = SKSpriteNode(imageNamed: "shopTextContainer")
        skinsSection.position = CGPoint(x: self.frame.width/2 - 90, y: self.frame.height/2 + 85)
        skinsSection.size = CGSize(width: doubleCoins.size.width, height: skinsSection.size.height)
        self.addChild(skinsSection)
        skinsSectionText.fontName = "DayPosterBlack"
        skinsSectionText.text = "Skins"
        skinsSectionText.position = CGPoint(x: 0, y: -9)
        skinsSectionText.zPosition = 1
        skinsSectionText.fontSize = 30.0
        skinsSectionText.fontColor = UIColor.whiteColor()
        skinsSection.addChild(skinsSectionText)
        
        themesSection = SKSpriteNode(imageNamed: "shopTextContainer")
        themesSection.position = CGPoint(x: self.frame.width/2 + 90, y: self.frame.height/2 + 85)
        themesSection.size = CGSize(width: doubleCoins.size.width, height: themesSection.size.height)
        self.addChild(themesSection)
        themesSectionText.fontName = "DayPosterBlack"
        themesSectionText.text = "Themes"
        themesSectionText.position = CGPoint(x: 0, y: -9)
        themesSectionText.zPosition = 1
        themesSectionText.fontSize = 30.0
        themesSectionText.fontColor = UIColor.whiteColor()
        themesSection.addChild(themesSectionText)
        
        getMoreCoins = SKSpriteNode(imageNamed: "getMoreCoinsButton")
        getMoreCoins.position = CGPoint(x: self.frame.width/2 - 90, y: self.frame.height/2 - 85)
        getMoreCoins.size = CGSize(width: doubleCoins.size.width, height: getMoreCoins.size.height)
        
        if Chartboost.hasRewardedVideo(CBLocationIAPStore) == false {
            getMoreCoins.alpha = 0.5
        }
        self.addChild(getMoreCoins)
        
        restorePurchasesButton = SKSpriteNode(imageNamed: "restorePurchases")
        restorePurchasesButton.anchorPoint = CGPoint(x: 0.5,y: 1.0)
        restorePurchasesButton.position = CGPoint(x: self.frame.width/2, y: doubleCoins.position.y - 115)
        restorePurchasesButton.zPosition = 1
        self.addChild(restorePurchasesButton)
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let touch = touches.first{
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
            
            if restorePurchasesButton.containsPoint(touchLocation) {
                restorePurchasesButton.alpha = 0.5
            }
            else {
                restorePurchasesButton.alpha = 1.0
            }
        }
        
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let touch = touches.first{
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
                themesSection.alpha = 1.0
            }
            
            else {
                themesSection.alpha = 1.0
            }
            
            if getMoreCoins.containsPoint(touchLocation) && getMoreCoins.alpha != 1 {
                if GameScene.soundOn == true {
                    self.scene?.runAction(buttonTouched)
                }
                if Chartboost.hasRewardedVideo(CBLocationIAPStore) {
                    Chartboost.showRewardedVideo(CBLocationIAPStore)
                    SKTAudio.sharedInstance().pauseBackgroundMusic()
                }
                
                getMoreCoins.alpha = 1.0
            }
            else {
                if Chartboost.hasRewardedVideo(CBLocationIAPStore){
                    getMoreCoins.alpha = 1.0
                }
            }
            
            if doubleCoins.containsPoint(touchLocation) && doubleCoins.alpha == 1 {
                for product in list {
                    if product.productIdentifier == "com.KJBApps.CircleOfChance.doublecoins" {
                        if let isTrue = store?.isProductPurchased("com.KJBApps.CircleOfChance.doublecoins") {
                            if isTrue == false {
                                store?.buyProduct(product)
                            }
                        }
                    }
                }
                if doubleCoinsBool != true {
                    doubleCoins.alpha = 1.0
                }
                
                NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ShopScene.handlePurchaseNotification(_:)),
                                                                 name: IAPHelper.IAPHelperPurchaseNotification,
                                                                 object: nil)
            }
            else {
                if doubleCoinsBool != true {
                    doubleCoins.alpha = 1.0
                }
            }
            
            if restorePurchasesButton.containsPoint(touchLocation) {
                store?.restorePurchases()
                
                NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ShopScene.handlePurchaseNotification(_:)),
                                                                 name: IAPHelper.IAPHelperPurchaseNotification,
                                                                 object: nil)
                restorePurchasesButton.alpha = 1.0
            }
            else {
                restorePurchasesButton.alpha = 1.0
            }
        }
    }
    
    
    func handlePurchaseNotification(notification: NSNotification) {
        guard let productID = notification.object as? String else { return }
        
        if productID == "com.KJBApps.CircleOfChance.doublecoins" {
            doubleCoins.alpha = 0.5
            doubleCoinsBool = true
        }
        
    }
    
    func didCompleteRewardedVideo(location: String!, withReward reward: Int32) {
        if location == CBLocationIAPStore {
            currency.coins += Int(reward)
        }
        backGround.removeAllChildren()
        backGround.removeFromParent()
        Chartboost.cacheRewardedVideo(CBLocationIAPStore)
    }
    
    func didCloseRewardedVideo(location: String!) {
        if location == CBLocationIAPStore {
            coins.text = "\(currency.coins)"
        }
        backGround.removeFromParent()
        backGround.removeAllChildren()
        SKTAudio.sharedInstance().playBackgroundMusic(currentMusic)
    }

    
}
