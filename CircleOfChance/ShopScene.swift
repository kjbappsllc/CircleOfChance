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
    
    //Currency and shopping
    var currency = CurrencyManager()
    let productID: NSSet = NSSet(objects:"com.KJBApps.CircleOfChance.doublecoins")
    var store: IAPHelper?
    var list = [SKProduct]()
    var doubleCoinsBool = Bool()
    var doubleCoins = SKSpriteNode()
    
    //TopBar
    var backButton = SKSpriteNode()
    var topBar = SKNode()
    var coins = SKLabelNode()
    
    //Selection
    var selectionLayer = SKNode()
    var skinsSection = SKSpriteNode()
    var themesSection = SKSpriteNode()
    var skins_selected = Bool()
    
    override func didMoveToView(view: SKView) {
        userInteractionEnabled = false
        loadView()
        animateEnter { 
            self.userInteractionEnabled = true
        }
    }
    
    deinit {
        SKPaymentQueue.defaultQueue().removeTransactionObserver(store!)
    }
    
    //Mark: Loads the View
    func loadView() {
        // Top Bar
        topBar = self.childNodeWithName("topBar")!
        backButton = topBar.childNodeWithName("backButton") as! SKSpriteNode
        coins = topBar.childNodeWithName("coins") as! SKLabelNode
        
        //Shop
        doubleCoinsBool = NSUserDefaults.standardUserDefaults().boolForKey("com.KJBApps.CircleOfChance.doublecoins")
        
        //Selection
        selectionLayer = self.childNodeWithName("selection")!
        skinsSection = selectionLayer.childNodeWithName("skinSelection") as! SKSpriteNode
        themesSection = selectionLayer.childNodeWithName("themeSelection") as! SKSpriteNode
        skins_selected = true
        
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
        
        coins.text = "\(currency.coins)"
    }
    
    func animateEnter(completion: ()->()){
        topBar.position.y = size.height
        selectionLayer.position.x = -size.width
        
        let topBarEnter = SKAction.moveBy(CGVector(dx: 0,dy: -size.height), duration: 0.4)
        topBarEnter.timingMode = .EaseIn
        topBar.runAction(topBarEnter)
        
        let selectionEnter = SKAction.moveBy(CGVector(dx: size.width,dy: 0), duration: 0.4)
        selectionEnter.timingMode = .EaseIn
        selectionLayer.runAction(selectionEnter)
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let touch = touches.first{
            let touchLocation = touch.locationInNode(self)
            let backtoMenuTouch = touch.locationInNode(topBar)
            let selectionTouch = touch.locationInNode(selectionLayer)
            if backButton.containsPoint(backtoMenuTouch){
                
                if let scene = MainMenu(fileNamed:"GameScene") {
                    
                    // Configure the view.
                    let skView = self.view as SKView!
                    /* Sprite Kit applies additional optimizations to improve rendering performance */
                    skView.ignoresSiblingOrder = true
                    /* Set the scale mode to scale to fit the window */
                    scene.scaleMode = .AspectFill
                    skView.presentScene(scene)
                }
            }
            
            if doubleCoins.containsPoint(touchLocation){
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
            
            if skinsSection.containsPoint(selectionTouch) {
                if skins_selected == false {
                    skins_selected = true
                    themesSection.alpha = 0.5
                    skinsSection.alpha = 1.0
                }
            }
            
            if themesSection.containsPoint(selectionTouch) {
                if skins_selected == true {
                    skins_selected = false
                    themesSection.alpha = 1.0
                    skinsSection.alpha = 0.5
                }
            }
            
            
            /*
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
    */
        }
    }
    
    
    func handlePurchaseNotification(notification: NSNotification) {
        guard let productID = notification.object as? String else { return }
        
        if productID == "com.KJBApps.CircleOfChance.doublecoins" {
            doubleCoins.alpha = 0.5
            doubleCoinsBool = true
        }
        
    }
    
}
