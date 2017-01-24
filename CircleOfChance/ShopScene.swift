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
    var shopItems = items()
    var moveableArea = SKNode()
    var itemSelectionBG = SKSpriteNode()
    var current = SKLabelNode()
    var end = SKLabelNode()
    var counterNode = SKNode()
    
    //items
    var shopSkins = [Skins]()
    var shopThemes = [Themes]()
    var startX: CGFloat = 0.0
    var lastX: CGFloat = 0.0
    var beginLimit = 1
    var furthestLimit = Int()
    var currentItem = 1
    var moved = false
    
    override func didMoveToView(view: SKView) {
        userInteractionEnabled = false
        shopSkins = shopItems.skins
        shopThemes = shopItems.themes
        
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
        itemSelectionBG = self.childNodeWithName("itemSelectionBg") as! SKSpriteNode
        doubleCoins = self.childNodeWithName("doubleCoins") as! SKSpriteNode
        counterNode = self.childNodeWithName("counterNode")!
        current = counterNode.childNodeWithName("current") as! SKLabelNode
        end = counterNode.childNodeWithName("end") as! SKLabelNode
        
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
        itemSelectionBG.addChild(moveableArea)
        current.text = "1"
        end.text = "\(shopSkins.count)"

        addItems(shopSkins, isSkin: true)
    }
    
    func addItems(nodes: [AnyObject], isSkin: Bool) {
        for i in 0..<nodes.count {
            //Setup the slot that the item will go in
            let item = itemContainer()
            item.position.x = self.size.width/2 * CGFloat(i)
            if isSkin == true{
                item.name = shopSkins[i].name
                if let itemskin = nodes[i] as? Skins {
                    item.skinItem = itemskin
                }
            }
            else{
                item.name = shopThemes[i].name
                if let itemTheme = nodes[i] as? Themes{
                    item.themeItem = itemTheme
                }
            }
            moveableArea.addChild(item)
            
            //position the price
            let price = SKLabelNode()
            if isSkin {
                price.text = "\(shopSkins[i].price)"
            }
            else{
                price.text = "\(shopThemes[i].price)"
            }
            price.fontSize = 36.0
            price.fontName = "Lucida Grande-Bold"
            price.fontColor = UIColor.blackColor()
            price.position = CGPoint(x: 0, y: -item.size.height/2 + 70)
            price.zPosition = 10
            price.name = "price"
            item.addChild(price)
            
            let name = SKLabelNode()
            if isSkin {
                var text = shopSkins[i].name
                text = text.capitalizedString
                name.text = text
            }
            else{
                var text = shopThemes[i].name
                text = text.capitalizedString
                name.text = text
            }
            
        }
    }
    
    func animateEnter(completion: ()->()){
        topBar.position.y = size.height
        selectionLayer.position.x = -size.width
        moveableArea.alpha = 0
        itemSelectionBG.alpha = 0
        
        let topBarEnter = SKAction.moveBy(CGVector(dx: 0,dy: -size.height), duration: 0.4)
        topBarEnter.timingMode = .EaseIn
        topBar.runAction(topBarEnter)
        
        let selectionEnter = SKAction.moveBy(CGVector(dx: size.width,dy: 0), duration: 0.3)
        selectionEnter.timingMode = .EaseIn
        selectionLayer.runAction(selectionEnter,completion: completion)
        
        let moveableAreaEnter = SKAction.fadeInWithDuration(0.3)
        moveableAreaEnter.timingMode = .EaseIn
        moveableArea.runAction(moveableAreaEnter)
        
        itemSelectionBG.runAction(SKAction.fadeInWithDuration(0.1), completion:completion)
    }
    
    func animateExit(completion: () ->()) {
        let topBarExit = SKAction.moveBy(CGVector(dx: 0,dy: size.height), duration: 0.4)
        topBarExit.timingMode = .EaseOut
        topBar.runAction(topBarExit)
        
        let selectionExit = SKAction.moveBy(CGVector(dx:size.width,dy:0), duration: 0.2)
        selectionExit.timingMode = .EaseOut
        selectionLayer.runAction(selectionExit)
        
        itemSelectionBG.runAction(SKAction.fadeOutWithDuration(0.1))
        moveableArea.runAction(SKAction.fadeOutWithDuration(0.3))
        
        doubleCoins.runAction(SKAction.fadeOutWithDuration(0.3), completion: completion)
        
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        // store the starting position of the touch
        
        for touch in touches {
            let location = touch.locationInNode(itemSelectionBG)
            startX = location.x
            lastX = location.x
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches {
            if moved == false {
                let location = touch.locationInNode(self)
                let currentX = location.x
                
                // Set Top and Bottom scroll distances, measured in screenlengths
                if skins_selected == true {
                    furthestLimit = shopSkins.count
                }
                else{
                    furthestLimit = shopThemes.count
                }
                
                // Set scrolling speed - lower number is faster speed
                let scrollSpeed:Double = 0.3
                
                // calculate distance moved since last touch registered and add it to current position
                let offset =  -self.frame.width/2
                
                // perform checks to see if new position will be over the limits, otherwise set as new position
                if currentX < lastX && currentItem != furthestLimit {
                    let moveLAction = SKAction.moveBy(CGVector(dx: offset,dy: 0), duration: scrollSpeed)
                    moveLAction.timingMode = .EaseOut
                    moveableArea.runAction(moveLAction)
                    currentItem += 1
                    current.text = "\(currentItem)"
                    moved = true
                }
                else if currentX > lastX && currentItem != beginLimit{
                    let moveRAction = SKAction.moveBy(CGVector(dx: -offset,dy: 0), duration: scrollSpeed)
                    moveRAction.timingMode = .EaseOut
                    moveableArea.runAction(moveRAction)
                    currentItem -= 1
                    current.text = "\(currentItem)"
                    moved = true
                }
                
                // Set new last location for next time
                lastX = currentX
            }
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let touch = touches.first{
            moved = false
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
                    animateExit({ 
                        skView.presentScene(scene)
                    })
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
                    moveableArea.removeAllChildren()
                    moveableArea.position.x = 0
                    addItems(shopSkins, isSkin: true)
                    currentItem = 1
                    current.text = "\(currentItem)"
                    end.text = "\(shopSkins.count)"
                }
            }
            
            if themesSection.containsPoint(selectionTouch) {
                if skins_selected == true {
                    skins_selected = false
                    themesSection.alpha = 1.0
                    skinsSection.alpha = 0.5
                    moveableArea.removeAllChildren()
                    moveableArea.position.x = 0
                    addItems(shopThemes, isSkin: false)
                    currentItem = 1
                    current.text = "\(currentItem)"
                    end.text = "\(shopThemes.count)"
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
