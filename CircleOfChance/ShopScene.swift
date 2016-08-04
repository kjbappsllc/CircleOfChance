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
    var shopMenuText = SKLabelNode()
    var backGround = SKShapeNode()
    var exitButton = SKSpriteNode()
    var restorePurchasesButton = SKSpriteNode()
    var restorePurchasesLabel = SKLabelNode()
    
    var getMoreCoinsOptions = SKSpriteNode()
    var shading = SKSpriteNode()
    var freecoins = SKSpriteNode()
    
    var shopActive = false
    let productID: NSSet = NSSet(objects: "com.KJBApps.CircleOfChance.500", "com.KJBApps.CircleOfChance.doublecoins", "com.KJBApps.CircleOfChance.1250", "com.KJBApps.CircleOfChance.3500", "com.KJBApps.CircleOfChance.7500", "com.KJBApps.CircleOfChance.23000")
    
    var store: IAPHelper?
    var count = 0
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
        
        if NSUserDefaults.standardUserDefaults().boolForKey("com.KJBApps.CircleOfChance.doublecoins") == true {
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
        self.addChild(getMoreCoins)
        
        restorePurchasesButton = SKSpriteNode(imageNamed: "restorePurchases")
        restorePurchasesButton.anchorPoint = CGPoint(x: 0.5,y: 1.0)
        restorePurchasesButton.position = CGPoint(x: self.frame.width/2, y: doubleCoins.position.y - 115)
        restorePurchasesButton.zPosition = 1
        self.addChild(restorePurchasesButton)
        
    }
    
    func addShopButtons() {
        backGround = SKShapeNode(rect: CGRect(x: -self.frame.width/2, y: -self.frame.height/2, width: self.frame.width, height: self.frame.height))
        backGround.fillColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1.0)
        backGround.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        backGround.strokeColor = UIColor.clearColor()
        backGround.zPosition = 10
        self.addChild(backGround)
        
        shopMenu = SKSpriteNode(imageNamed: "GetCoinsTitle")
        shopMenu.size = CGSize(width: backGround.frame.width, height: shopMenu.frame.height + 10)
        shopMenu.anchorPoint = CGPoint(x: 0.5, y: 1.0)
        shopMenu.position = CGPoint(x: 0, y: backGround.frame.height/2)
        shopMenu.zPosition = 15
        backGround.addChild(shopMenu)
        
        shopMenuText.fontName = "DayPosterBlack"
        shopMenuText.fontSize = 32.0
        shopMenuText.text = "Get More Coins"
        shopMenuText.zPosition = 20
        shopMenuText.position = CGPoint(x: 0, y: -shopMenu.size.height/2 - 10)
        shopMenu.addChild(shopMenuText)
        
        
        exitButton = SKSpriteNode(imageNamed: "exitButton")
        exitButton.position = CGPoint(x: shopMenu.size.width/6 + 20 , y: -shopMenu.size.height/2 + 5)
        exitButton.size = CGSize(width: exitButton.size.width + 10, height: exitButton.size.height + 10)
        exitButton.zPosition = 25
        shopMenu.addChild(exitButton)
        
        if IAPHelper.canMakePayments() {
            for product in list{
                
                let prodID = product.productIdentifier
                
                if prodID != "com.KJBApps.CircleOfChance.doublecoins" {
                    switch product.price.floatValue {
        
                        case 0.99:
                            
                            let entry = SKSpriteNode(imageNamed: "500coins")
                            let buyButton = SKSpriteNode(imageNamed: "BuyButton")
                            entry.anchorPoint = CGPoint(x: 0.5, y: 1.0)
                            entry.position = CGPoint(x: 0, y: shopMenu.position.y - shopMenu.size.height/2 - 40)
                            backGround.addChild(entry)
                        
                            buyButton.position = CGPoint(x: 106, y: -entry.size.height/2 - 18)
                            buyButton.name = prodID
                            buyButton.zPosition = 20
                            
                            entry.addChild(buyButton)
                        
                        case 4.99:
                            
                            let entry = SKSpriteNode(imageNamed: "3500coins")
                            let buyButton = SKSpriteNode(imageNamed: "BuyButton")
                            entry.anchorPoint = CGPoint(x: 0.5, y: 1.0)
                            entry.position = CGPoint(x: 0, y: shopMenu.position.y - shopMenu.size.height/2 - entry.size.height - 40)
                            backGround.addChild(entry)
                        
                            buyButton.position = CGPoint(x: 106, y: -entry.size.height/2 - 18)
                            buyButton.name = prodID
                            buyButton.zPosition = 20
                            
                            entry.addChild(buyButton)
                        
                        
                        case 9.99:
                            
                            let entry = SKSpriteNode(imageNamed: "7500coins")
                            let buyButton = SKSpriteNode(imageNamed: "BuyButton")
                            
                            entry.anchorPoint = CGPoint(x: 0.5, y: 1.0)
                            entry.position = CGPoint(x: 0, y: shopMenu.position.y - shopMenu.size.height/2 - entry.size.height*2 - 40)
                            backGround.addChild(entry)
                        
                            buyButton.position = CGPoint(x: 106, y: -entry.size.height/2 - 18)
                            buyButton.name = prodID
                            buyButton.zPosition = 20
                            
                            entry.addChild(buyButton)
                        
                        default:
                            
                            let entry = SKSpriteNode(imageNamed: "23000coins")
                            let buyButton = SKSpriteNode(imageNamed: "BuyButton")
                            entry.anchorPoint = CGPoint(x: 0.5, y: 1.0)
                            entry.position = CGPoint(x: 0, y: shopMenu.position.y - shopMenu.size.height/2 - entry.size.height*3 - 40)
                            backGround.addChild(entry)
                        
                            buyButton.position = CGPoint(x: 106, y: -entry.size.height/2 - 18)
                            buyButton.name = prodID
                            buyButton.zPosition = 20
                            
                            entry.addChild(buyButton)
                        
                    }
                }
            }
            freecoins = SKSpriteNode(imageNamed: "freecoins")
            let goButton = SKSpriteNode(imageNamed: "BuyButton")
            
            goButton.name = "freecoins"
            freecoins.anchorPoint = CGPoint(x: 0.5, y: 1.0)
            freecoins.zPosition = 10
            freecoins.position = CGPoint(x: 0, y: shopMenu.position.y - shopMenu.size.height/2 - freecoins.size.height*4 - 40)
            backGround.addChild(freecoins)
            
            goButton.position = CGPoint(x: 108.5 , y: -freecoins.size.height/2 - 18)
            goButton.zPosition = 20
            
            freecoins.addChild(goButton)
            
            if Chartboost.hasRewardedVideo(CBLocationIAPStore) == false {
               freecoins.alpha = 0.66
            }

        }
        else {

            let unavailable = SKLabelNode()
            unavailable.fontName = "DayPosterBlack"
            unavailable.text = "Unavailable"
            unavailable.fontSize = 20.0
            unavailable.zPosition = 10
            backGround.addChild(unavailable)
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
                if doubleCoins.containsPoint(touchLocation) {
                    doubleCoins.alpha = 0.5
                }
                else {
                    if doubleCoinsBool != true {
                        doubleCoins.alpha = 1.0
                    }
                }
                
                if restorePurchasesButton.containsPoint(touchLocation) {
                    restorePurchasesButton.alpha = 0.5
                }
                else {
                    restorePurchasesButton.alpha = 1.0
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
                    themesSection.alpha = 1.0
                }
                
                else {
                    themesSection.alpha = 1.0
                }
                
                if getMoreCoins.containsPoint(touchLocation) && getMoreCoins.alpha != 1 || coinBox.containsPoint(backtoMenuTouch){
                    if GameScene.soundOn == true {
                        self.scene?.runAction(buttonTouched)
                    }
                    addShopButtons()
                    shopActive = true
                    getMoreCoins.alpha = 1.0
                }
                else {
                    getMoreCoins.alpha = 1.0
                }
                
                if doubleCoins.containsPoint(touchLocation) && doubleCoins.alpha != 1 {
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
            
            else if node.name == "freecoins" {
                if GameScene.soundOn == true {
                    self.scene?.runAction(buttonTouched)
                }
                
                if Chartboost.hasRewardedVideo(CBLocationIAPStore) {
                    Chartboost.showRewardedVideo(CBLocationIAPStore)
                    SKTAudio.sharedInstance().pauseBackgroundMusic()
                }
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
        guard let productID = notification.object as? String else { return }
        
        if productID == "com.KJBApps.CircleOfChance.doublecoins" {
            doubleCoins.alpha = 0.5
            doubleCoinsBool = true
        }
        else {
            coins.text = "\(currency.coins)"
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
