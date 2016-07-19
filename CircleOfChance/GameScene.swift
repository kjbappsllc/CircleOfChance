//
//  GameScene.swift
//  Circle of Chance
//
//  Created by Mac on 6/6/16.
//  Copyright (c) 2016 KJB Apps LLC. All rights reserved.
//

import SpriteKit
import GameKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    
    //grouping Barriers Array
    var barrierArray = [barrier]()
    var dotsArray = [String]()
    var colorsArray = [UIColor]()
    var cardsDictionary : [String:Bool] = [:]
    var cardsArray = [String]()
    let card = FateCard()
    
    //gameEssentials
    var ball = Character()
    var star = StarIcon()
    
    //Barriers
    var barrierLeft = barrier()
    var barrierRight = barrier()
    var barrierBottom = barrier()
    var barrierTop = barrier()
    var barrierTopLeft = barrier()
    var barrierTopRight = barrier()
    var barrierBottomLeft = barrier()
    var barrierBottomRight = barrier()
    var hasIncreased = false
    var barrierCount = 0
    
    //Icons
    var settingsIcon = SKSpriteNode()
    var informationIcon = SKSpriteNode()
    var pauseView = UIView()
    var pauseButton = UIButton()
    var homeButton = UIButton()
    var settingsButton = UIButton()
    var pauseText = UILabel()
    var coinImage = SKSpriteNode()
    var achievementIcon = SKSpriteNode()
    var achievementText = SKLabelNode()
    
    //Text
    var highScoreContainer = SKSpriteNode()
    var highScoreText = SKLabelNode()
    static var highscoreInt = Int()
    var highscore = SKLabelNode()
    
    var scoreContainer = SKSpriteNode()
    var scoreText = SKLabelNode()
    static var scoreInt = Int()
    var score = SKLabelNode()
    
    var tapToStart = SKLabelNode()
    
    let levelText = SKLabelNode()
    var levelCounterText = SKLabelNode()
    var levelInt = 1
    var startingText = SKLabelNode()
    var newHighScore = SKLabelNode()
    var coinNotifier = SKLabelNode()
    
    //GameLogic
    var Path = UIBezierPath()
    var movingClockWise = Bool()
    var gameStarted = Bool()
    var isGameOver = false
    var IsPaused = false
    var gameNodeGroup = SKNode()
    var resetted = false
    var barriersReversed = Bool()
    var highScoreAchieved = Bool()
    var checkpoint = Bool()
    static var soundOn = Bool()
    var currency = CurrencyManager()
    
    // sounds
    let dotHitSound = SKAction.playSoundFileNamed("dotHit.wav", waitForCompletion: false)
    let nextLevel = SKAction.playSoundFileNamed("nextLevel.wav", waitForCompletion: false)
    let death = SKAction.playSoundFileNamed("death.wav", waitForCompletion: false)
    let wordsBlip = SKAction.playSoundFileNamed("wordsBlip.wav", waitForCompletion: false)
    let starPickup = SKAction.playSoundFileNamed("starPickup.wav", waitForCompletion: false)
    let highScore = SKAction.playSoundFileNamed("newHighScore.wav", waitForCompletion: false)
    let cardSound = SKAction.playSoundFileNamed("newCard.wav", waitForCompletion: false)
    
    //GameCenter
    var gameCenterAchievements = [String:GKAchievement]()
    
    override func didMoveToView(view: SKView) {
        loadAchievementPercentages()
        
        if (NSUserDefaults.standardUserDefaults().stringForKey("currentSkin") != nil){
            SkinsScene.currentSkin = NSUserDefaults.standardUserDefaults().stringForKey("currentSkin")!
        }
        else{
            SkinsScene.currentSkin = "Character"
        }
        
        if (NSUserDefaults.standardUserDefaults().objectForKey("currentTheme") != nil){
            let data = NSUserDefaults.standardUserDefaults().objectForKey("currentTheme") as! NSData
            ThemesScene.currentTheme = NSKeyedUnarchiver.unarchiveObjectWithData(data) as! [String:AnyObject]
        }
        else{
            ThemesScene.currentTheme = ["name": "defaultTheme", "OuterTexture": "Default", "InnerTexture": "Default", "dotTexture": "Default", "themeColor": UIColor(red: 133/255, green: 0, blue: 241/255, alpha: 1.0)]
        }
        loadView()
        barrierLeft.addRedBarrier()
        // add physics world
        physicsWorld.contactDelegate = self

    }
    
    //loads view
    func loadView() {
        //Sets Up the Scene
        
        if NSUserDefaults.standardUserDefaults().boolForKey("sound") {
            GameScene.soundOn = true
        }
        else{
            GameScene.soundOn = NSUserDefaults.standardUserDefaults().boolForKey("sound")
        }
        
        dotsArray.removeAll()
        checkpoint = false
        highScoreAchieved = false
        barriersReversed = false
        cardsDictionary  = [
            "MotionCard": false,
            "FluctuateCard": false,
            "GhostCard": false,
            "HasteCard": false,
            "UnstableCard": false
        ]
        card.position = CGPoint(x: self.frame.width/2, y: self.frame.height/2)
        card.zPosition = 10
        card.alpha = 0
        self.addChild(card)
        
        for (cards,_) in cardsDictionary {
            cardsArray.append(cards)
        }
        //Adding the colors to the dots
        colorsArray.append(UIColor(red: 1.0, green: 215/255, blue: 0, alpha: 1.0))
        colorsArray.append(UIColor(red: 220/255, green: 255/255, blue: 0.0, alpha: 1.0))
        colorsArray.append(UIColor(red: 1.0, green: 173/255, blue: 38/255, alpha: 1.0))
        colorsArray.append(UIColor(red: 38/255, green: 244/255, blue: 198/255, alpha: 1.0))
        
        scene?.backgroundColor = UIColor(red: 31/255, green: 30/255, blue: 30/255, alpha: 1.0)
        self.addChild(gameNodeGroup)
        addBall()
        
        addText()
        addBarriers()
        addBackground()
        addScoreDots()
        MoveBarriers()
    }
    
    func addBackground() {
        let outerWheelCircle = SKShapeNode(circleOfRadius: 157.5)
        outerWheelCircle.position = CGPointMake(frame.midX, frame.midY)
        outerWheelCircle.strokeColor = ThemesScene.currentTheme["themeColor"] as! SKColor
        outerWheelCircle.lineWidth = 18
        outerWheelCircle.glowWidth = 5
        
        if "defaultTheme" == ThemesScene.currentTheme["name"] as! String {
            outerWheelCircle.fillColor = UIColor(red: 32/255, green: 31/255, blue: 31/255, alpha: 1.0)
        }
        else {
            outerWheelCircle.fillTexture = SKTexture(imageNamed: ThemesScene.currentTheme["outerTexture"] as! String)
            outerWheelCircle.fillColor = SKColor.whiteColor()
        }
        
        outerWheelCircle.zPosition = 1
        gameNodeGroup.addChild(outerWheelCircle)
        
        let innerCirlce = SKShapeNode(circleOfRadius: 90)
        innerCirlce.position = CGPointMake(frame.midX, frame.midY)
        innerCirlce.strokeColor = ThemesScene.currentTheme["themeColor"] as! SKColor
        innerCirlce.lineWidth = 4
        innerCirlce.glowWidth = 2
        
        if "defaultTheme" == ThemesScene.currentTheme["name"] as! String {
            innerCirlce.fillColor = UIColor(red: 57/255, green: 49/255, blue: 49/255, alpha: 1.0)
        }
        else {
            innerCirlce.fillTexture = SKTexture(imageNamed: ThemesScene.currentTheme["innerTexture"] as! String)
            innerCirlce.fillColor = SKColor.whiteColor()
        }
        
        innerCirlce.zPosition = 1
        gameNodeGroup.addChild(innerCirlce)
        
        startingText.fontName = "DayPosterBlack"
        startingText.fontColor = ThemesScene.currentTheme["themeColor"] as? SKColor
        startingText.position = CGPoint(x: self.frame.width/2, y: self.frame.height/2 - 20)
        startingText.fontSize = 24.0
        startingText.text = "Chance"
        startingText.zPosition = 5
        gameNodeGroup.addChild(startingText)
        
        startingText.physicsBody = SKPhysicsBody(rectangleOfSize: CGSize(width: 30, height: 45))
        startingText.physicsBody?.dynamic = false
        startingText.physicsBody?.categoryBitMask = textCategory
        startingText.physicsBody?.contactTestBitMask = ballCategory
        
        coinImage = SKSpriteNode(imageNamed: "coin")
        coinImage.position = CGPoint(x: self.frame.width/2 - 205, y: self.frame.height - 58)
        coinImage.size = CGSize(width: 30, height: 30)
        coinImage.zPosition = 10
        self.addChild(coinImage)
        coinNotifier.fontName = "DayPosterBlack"
        coinNotifier.fontSize = 18.0
        coinNotifier.position = CGPoint(x: self.frame.width/2 - 153, y: self.frame.height-63)
        coinNotifier.text = "\(currency.coins)"
        self.addChild(coinNotifier)
    }
    
    func removeText(label: SKLabelNode) {
        let fadeIn = SKAction.fadeAlphaTo(0.0, duration: 0.2)
        let fadeOut = SKAction.fadeAlphaTo(1.0, duration: 0.2)
        let cycle = SKAction.sequence([fadeOut,fadeIn,fadeOut])
        
        label.runAction(SKAction.sequence([cycle,SKAction.removeFromParent()]))
        label.physicsBody = nil
    }
    
    //addBall
    func addBall() {
        ball.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
        ball.zPosition = 10
        ball.physicsBody?.affectedByGravity = true
        ball.texture = SKTexture(imageNamed: SkinsScene.currentSkin)
        gameNodeGroup.addChild(ball)
        
    }
    
    func addScoreDots() {
        let randomNum = Int(arc4random_uniform(15) + 1)
        let radius: CGFloat = CONSTANTRADIUS
        let numberOfCircle = NUMBEROFCIRCLES
        var added = false
        for i in 1...numberOfCircle {
            if (checkpoint != true) || (checkpoint == true && added == true) {
                let circle = SKShapeNode(circleOfRadius: 6)
                circle.alpha = 0
                circle.physicsBody = SKPhysicsBody(circleOfRadius: 2)
                circle.physicsBody?.categoryBitMask = dotCategory
                circle.physicsBody?.contactTestBitMask = ballCategory
                circle.physicsBody?.affectedByGravity = false
                circle.physicsBody?.collisionBitMask = 0
                circle.strokeColor = SKColor.clearColor()
                circle.glowWidth = 1.0
                
                if "defaultTheme" == ThemesScene.currentTheme["name"] as! String {
                    circle.fillColor = colorsArray[levelInt % colorsArray.count]
                }
                else {
                    circle.fillTexture = SKTexture(imageNamed: ThemesScene.currentTheme["dotTexture"] as! String)
                    circle.fillColor = SKColor.whiteColor()
                }
                
                // You can get every single circle by name:
                circle.name = String(format:"circle%d",i)
                dotsArray.append(circle.name!)
                let angle = 2 * M_PI / Double(numberOfCircle) * Double(i)
                
                let circleX = radius * cos(CGFloat(angle))
                let circleY = radius * sin(CGFloat(angle))
                
                circle.position = CGPoint(x:circleX + frame.midX, y:circleY + frame.midY)
                circle.zPosition = 2
                
                gameNodeGroup.addChild(circle)
                animateDot(circle)
            }
                
            else if checkpoint == true && added == false {
                if i == randomNum {
                    let star = StarIcon()
                    star.name = "Star"
                    dotsArray.append("Star")
                    
                    let angle = 2 * M_PI / Double(numberOfCircle) * Double(i)
                    
                    let circleX = radius * cos(CGFloat(angle))
                    let circleY = radius * sin(CGFloat(angle))
                    
                    star.position = CGPoint(x:circleX + frame.midX, y:circleY + frame.midY)
                    star.zPosition = 2
                    
                    gameNodeGroup.addChild(star)
                    star.animateStar()
                    added = true
                }
                else {
                    let circle = SKShapeNode(circleOfRadius: 6)
                    circle.alpha = 0
                    circle.physicsBody = SKPhysicsBody(circleOfRadius: 2)
                    circle.physicsBody?.categoryBitMask = dotCategory
                    circle.physicsBody?.contactTestBitMask = ballCategory
                    circle.physicsBody?.affectedByGravity = false
                    circle.physicsBody?.collisionBitMask = 0
                    circle.strokeColor = SKColor.clearColor()
                    circle.glowWidth = 1.0
                    
                    if "defaultTheme" == ThemesScene.currentTheme["name"] as! String {
                        circle.fillColor = colorsArray[levelInt % colorsArray.count]
                    }
                    else {
                        circle.fillTexture = SKTexture(imageNamed: ThemesScene.currentTheme["dotTexture"] as! String)
                        circle.fillColor = SKColor.whiteColor()
                    }
                    
                    // You can get every single circle by name:
                    circle.name = String(format:"circle%d",i)
                    dotsArray.append(circle.name!)
                    let angle = 2 * M_PI / Double(numberOfCircle) * Double(i)
                    
                    let circleX = radius * cos(CGFloat(angle))
                    let circleY = radius * sin(CGFloat(angle))
                    
                    circle.position = CGPoint(x:circleX + frame.midX, y:circleY + frame.midY)
                    circle.zPosition = 2
                    
                    gameNodeGroup.addChild(circle)
                    animateDot(circle)
                }
            }
        }
        
    }
    
    func animateDot(circle: SKShapeNode) {
        let fadeIn = SKAction.fadeAlphaTo(1.0, duration: 0.4)
        let scale = SKAction.scaleTo(1.5, duration: 0.1)
        let scaleBack = SKAction.scaleTo(1.0, duration: 0.1)
        
        let cycle = SKAction.sequence([fadeIn,scale,scaleBack])
        circle.runAction(cycle)
        
    }
    
    //Adds barriers to the scene
    func addBarriers() {
        barrierLeft.position = CGPoint(x: self.frame.width/2 - CONSTANTRADIUS, y: self.frame.height/2)
        gameNodeGroup.addChild(barrierLeft)
        barrierArray.append(barrierLeft)
        
        barrierRight.position = CGPoint(x: self.frame.width/2 + CONSTANTRADIUS, y: self.frame.height/2)
        gameNodeGroup.addChild(barrierRight)
        barrierArray.append(barrierRight)
        
        barrierTop.position = CGPoint(x: self.frame.width/2, y: self.frame.height/2 + CONSTANTRADIUS)
        barrierTop.zRotation = 3.14 / 2
        gameNodeGroup.addChild(barrierTop)
        barrierArray.append(barrierTop)
        
        barrierBottom.position = CGPoint(x: self.frame.width/2, y: self.frame.height/2 - CONSTANTRADIUS)
        barrierBottom.zRotation = 3.14 / 2
        gameNodeGroup.addChild(barrierBottom)
        barrierArray.append(barrierBottom)
        
        barrierTopLeft.position = CGPoint(x: self.frame.width / 2 - 83.25, y:self.frame.height / 2 + 83.25)
        barrierTopLeft.zRotation = CGFloat((3*M_PI) / 4)
        gameNodeGroup.addChild(barrierTopLeft)
        barrierArray.append(barrierTopLeft)
        
        barrierTopRight.position = CGPoint(x: self.frame.width / 2 + 83.25, y:self.frame.height / 2 + 83.25)
        barrierTopRight.zRotation = CGFloat(-(3*M_PI) / 4)
        gameNodeGroup.addChild(barrierTopRight)
        barrierArray.append(barrierTopRight)
        
        barrierBottomLeft.position = CGPoint(x: self.frame.width / 2 - 83.25, y:self.frame.height / 2 - 83.25)
        barrierBottomLeft.zRotation = CGFloat((5*M_PI)/4)
        gameNodeGroup.addChild(barrierBottomLeft)
        barrierArray.append(barrierBottomLeft)
        
        barrierBottomRight.position = CGPoint(x: self.frame.width / 2 + 83.25, y:self.frame.height / 2 - 83.25)
        barrierBottomRight.zRotation = CGFloat(-(5*M_PI)/4)
        gameNodeGroup.addChild(barrierBottomRight)
        barrierArray.append(barrierBottomRight)
    }
    
    //add the title bar to the scene
    func addText() {
        settingsIcon  = SKSpriteNode(imageNamed: "SettingsIcon")
        settingsIcon.position = CGPoint(x: self.frame.width/2 + 160, y: self.frame.height/2 + 330)
        settingsIcon.zPosition = 1
        self.addChild(settingsIcon)
        
        highScoreContainer = SKSpriteNode(imageNamed: "textContainer")
        highScoreContainer.position = CGPoint(x: self.frame.width/2 , y: self.frame.height / 2 + 330)
        highScoreContainer.zPosition = 1
        self.addChild(highScoreContainer)
        
        highscore.fontName = "DayPosterBlack"
        highscore.fontSize = 28.0
        
        if NSUserDefaults.standardUserDefaults().integerForKey("highscore") != 0 {
            GameScene.highscoreInt = NSUserDefaults.standardUserDefaults().integerForKey("highscore")
            highscore.text = "\(GameScene.highscoreInt)"
        }
        else{
            highscore.text = "0"
        }
        
        highscore.position = CGPoint(x: 0, y: -10)
        highscore.zPosition = 2
        highScoreContainer.addChild(highscore)
        
        newHighScore.fontName = "DayPosterBlack"
        newHighScore.fontSize = 12.5
        newHighScore.text = "New High Score !"
        newHighScore.position = CGPoint(x: self.frame.width/2, y: self.frame.height/2 + 290)
        newHighScore.alpha = 0
        self.addChild(newHighScore)
        
        score.fontName = "DayPosterBlack"
        score.fontSize = 58.0
        score.fontColor = ThemesScene.currentTheme["themeColor"] as? SKColor
        score.zPosition = 10
        score.text = "0"
        score.position = CGPoint(x: self.frame.width / 2 , y: self.frame.height / 2 + 200)
        score.zPosition = 2
        self.addChild(score)
        
        levelText.fontName = "DayPosterBlack"
        levelText.fontSize = 22.0
        levelText.text = "Level"
        levelText.position = CGPoint(x: self.frame.width / 2, y: self.frame.height/2 - 275)
        gameNodeGroup.addChild(levelText)
        
        levelCounterText.fontName = "DayPosterBlack"
        levelCounterText.fontSize = 22.0
        levelCounterText.text = "1"
        levelCounterText.position = CGPoint(x: self.frame.width / 2, y: self.frame.height/2 - 305)
        gameNodeGroup.addChild(levelCounterText)
        
        tapToStart.fontName = "DayPosterBlack"
        tapToStart.fontSize = 34.0
        tapToStart.text = "Tap To Start"
        tapToStart.fontColor = ThemesScene.currentTheme["themeColor"] as? SKColor
        tapToStart.alpha = 1
        tapToStart.zPosition = 3
        let fadeIn = SKAction.fadeAlphaTo(0.0, duration: 0.9)
        let fadeOut = SKAction.fadeAlphaTo(1.0, duration: 0.6)
        let cycle = SKAction.sequence([fadeIn,fadeOut])
        tapToStart.position = CGPoint(x: self.frame.width / 2, y: self.frame.height/2 - 225)
        gameNodeGroup.addChild(tapToStart)
        tapToStart.runAction(SKAction.repeatActionForever(cycle))
    }
    
    //Moves character Clockwise
    func moveCounterClockWise(){
        let dx = ball.position.x - self.frame.width/2
        let dy = ball.position.y - self.frame.height / 2
        
        let rad = atan2(dy,dx)
        Path = UIBezierPath(arcCenter: CGPoint(x: self.frame.width/2, y: self.frame.height/2), radius: 118.75, startAngle: rad, endAngle: rad+CGFloat(M_PI*4), clockwise: true)
        
        let follow = SKAction.followPath(Path.CGPath, asOffset: false, orientToPath: true, speed: ball.getballSpeedCounterClockWise())
        ball.runAction(SKAction.repeatActionForever(follow))
        
    }
    
    //moves character counterClockwise
    func moveClockWise() {
        let dx = ball.position.x - self.frame.width/2
        let dy = ball.position.y - self.frame.height / 2
        
        let rad = atan2(dy,dx)
        Path = UIBezierPath(arcCenter: CGPoint(x: self.frame.width/2, y: self.frame.height/2), radius: 118.75, startAngle: rad, endAngle: rad+CGFloat(M_PI*4), clockwise: true)
        
        let follow = SKAction.followPath(Path.CGPath, asOffset: false, orientToPath: true, speed: ball.getballSpeedClockWise())
        ball.runAction(SKAction.repeatActionForever(follow).reversedAction())
    }
    
    func gameOver(node: SKNode) {
        
        incrementCurrentPercentageOfAchievement("achievement_50games", amount: 2.0)
        currency.games += 1
        
        if GameScene.highscoreInt == GameScene.scoreInt {
            saveHighscore(GameScene.highscoreInt)
        }
        
        SKTAudio.sharedInstance().pauseBackgroundMusic()
        dotsArray.removeAll()
        gameStarted = false
        isGameOver = true
        for barrier in barrierArray{
            barrier.removeAllActions()
        }
        
        let action1 = SKAction.colorizeWithColor(UIColor.redColor(), colorBlendFactor: 1.0, duration: 0.1)
        let action2 = SKAction.colorizeWithColor(scene!.backgroundColor, colorBlendFactor: 1.0, duration: 0.1)
        self.scene?.runAction(SKAction.sequence([action1,action2]))
        
        let particles = SKEmitterNode(fileNamed: "GameOver")!
        particles.position = node.position
        particles.zPosition = node.zPosition + 1
        particles.particleTexture = SKTexture(imageNamed: SkinsScene.currentSkin)
        addChild(particles)
        node.removeFromParent()
        node.physicsBody = nil
        particles.runAction(SKAction.sequence([SKAction.waitForDuration(1.0), SKAction.removeFromParent()])) {
            if let scene = GameOver(fileNamed:"GameScene") {
                
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
    

    
    // create a random percent, with a precision of one decimal place
    func randomPercent() -> Double {
        return Double(arc4random() % 1000) / 10.0;
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        if firstBody.categoryBitMask == ballCategory && (secondBody.categoryBitMask == dotCategory || secondBody.categoryBitMask == starCategory) {
            
            if resetted == false {
                
                let moveAction = SKAction.moveTo(CGPoint(x: score.position.x, y: score.position.y), duration: 0.4)
                let fade = SKAction.fadeAlphaTo(0.0, duration: 0.1)
                secondBody.node?.runAction(SKAction.sequence([moveAction,fade,SKAction.removeFromParent()]))
                
                if secondBody.node?.name != "Star" {
                    if GameScene.soundOn {
                        secondBody.node?.runAction(dotHitSound)
                    }
                }
            }
            
            for (index,value) in dotsArray.enumerate() {
                if secondBody.node?.name == value && resetted == false {
                    dotsArray.removeAtIndex(index)
                    
                    GameScene.scoreInt += levelInt
                    
                    if GameScene.scoreInt == 300 {
                        incrementCurrentPercentageOfAchievement("achievement_300points", amount: 100.0)
                    }
                    
                    if GameScene.scoreInt == 800 {
                        incrementCurrentPercentageOfAchievement("achievement_800points", amount: 100.0)
                    }
                    
                    if GameScene.scoreInt >= 1500 {
                        incrementCurrentPercentageOfAchievement("achievement_1500points", amount: 100.0)
                    }
                    
                    if GameScene.scoreInt >= 3000 {
                        incrementCurrentPercentageOfAchievement("achievement_3000points", amount: 100.0)
                    }
                    score.text = "\(GameScene.scoreInt)"
                    
                    if GameScene.scoreInt > GameScene.highscoreInt {
                        GameScene.highscoreInt += levelInt
                        highscore.text = "\(GameScene.highscoreInt)"
                        NSUserDefaults.standardUserDefaults().setInteger(GameScene.highscoreInt, forKey: "highscore")

                        if highScoreAchieved == false {
                            if GameScene.soundOn {
                                self.scene?.runAction(highScore)
                            }
                            let action1 = SKAction.colorizeWithColor(UIColor.whiteColor(), colorBlendFactor: 1.0, duration: 0.2)
                            let action2 = SKAction.colorizeWithColor(scene!.backgroundColor, colorBlendFactor: 1.0, duration: 0.2)
                            self.scene?.runAction(SKAction.sequence([action1,action2]))
                            highScoreAchieved = true
                        }
                        
                        let scaleUp = SKAction.scaleTo(1.1, duration: 0.2)
                        let scaleDown = SKAction.scaleTo(1.0, duration: 0.2)
                        
                        newHighScore.alpha = 1
                        newHighScore.runAction(SKAction.repeatActionForever(SKAction.sequence([scaleUp,scaleDown])))
                    }
                    
                    if secondBody.node?.name == "Star" {
                        if GameScene.soundOn {
                            secondBody.node?.runAction(starPickup)
                        }
                        let randomNum = randomPercent()
                        switch randomNum {
                        case 0..<40:
                            var limit = 0
                            for barriers in barrierArray {
                                if limit != 1 {
                                    if barriers.IsActive() {
                                        barriers.removeBarrier()
                                        limit += 1
                                    }
                                }
                            }
                            
                        case 41..<65:
                            var limit = 0
                            for barriers in barrierArray {
                                if limit != 2 {
                                    if barriers.IsActive() {
                                        barriers.removeBarrier()
                                        limit += 1
                                    }
                                }
                            }
                            
                        case 66..<85:
                            var limit = 0
                            for barriers in barrierArray {
                                if limit != 3 {
                                    if barriers.IsActive() {
                                        barriers.removeBarrier()
                                        limit += 1
                                    }
                                }
                            }
                            
                            
                        case 86..<95:
                            var limit = 0
                            for barriers in barrierArray {
                                if limit != 4 {
                                    if barriers.IsActive() {
                                        barriers.removeBarrier()
                                        limit += 1
                                    }
                                }
                            }
                        default:
                            var limit = 0
                            for barriers in barrierArray {
                                if limit != 5 {
                                    if barriers.IsActive() {
                                        barriers.removeBarrier()
                                        limit += 1
                                    }
                                }
                            }
                        }
                    }
                }
            }
            
            if dotsArray.count <= 0{
                if GameScene.soundOn {
                    self.scene?.runAction(nextLevel)
                }
                
                let randomChance = arc4random_uniform(100)
                if randomChance < 70 {
                    if barriersReversed == false{
                        ReversedMoveBarriers()
                        barriersReversed = true
                    }
                    else{
                        MoveBarriers()
                        barriersReversed = false
                    }
                }
                levelInt += 1
                if levelInt % 5 == 0 {
                    checkpoint = true
                }
                else {
                    checkpoint = false
                }
                addScoreDots()
                resetted = true
                
                if ball.getballSpeedClockWise() < 350 && cardsDictionary["MotionCard"] == false{
                    ball.AddBallSpeedClockWise(3)
                    ball.AddBallSpeedCounterClockWise(3)
                }
                levelCounterText.text = "\(levelInt)"
                for barrier in barrierArray {
                    if barrier.IsActive() == false {
                        barrier.addRedBarrier()
                        break
                    }
                }
                
                let randomNumber = randomPercent()
                switch(randomNumber) {
                case 0..<50:
                    if GameScene.soundOn {
                        self.scene?.runAction(cardSound)
                    }
                    cardsArray.shuffleInPlace()
                    for carder in cardsArray {
                        if cardsDictionary[carder] == false {
                            switch carder {
                            case "MotionCard":
                                card.animateAppear(SKTexture(imageNamed: "MotionCard"))
                                IrregularMotion()
                                card.runAction(SKAction.waitForDuration(3.0), completion: {
                                    self.card.animateDisappear()
                                })
                                
                                cardsDictionary[carder] = true
                                
                            case "FluctuateCard":
                                card.animateAppear(SKTexture(imageNamed: "FluctuateCard"))
                                fluctuateBall()
                                card.runAction(SKAction.waitForDuration(3.0), completion: {
                                    self.card.animateDisappear()
                                })
                                cardsDictionary[carder] = true
                                
                            case "HasteCard":
                                card.animateAppear(SKTexture(imageNamed: "HasteCard"))
                                Haste()
                                card.runAction(SKAction.waitForDuration(3.0), completion: {
                                    self.card.animateDisappear()
                                })
                                cardsDictionary[carder] = true
                                
                            case "UnstableCard":
                                card.animateAppear(SKTexture(imageNamed: "UnstableCard"))
                                FluctuateBarriers()
                                card.runAction(SKAction.waitForDuration(3.0),completion: {
                                    self.card.animateDisappear()
                                })
                                cardsDictionary[carder] = true
                                
                            default:
                                card.animateAppear(SKTexture(imageNamed: "GhostCard"))
                                Ghost()
                                card.runAction(SKAction.waitForDuration(3.0), completion: {
                                    self.card.animateDisappear()
                                })
                                cardsDictionary[carder] = true
                            }
                            break
                        }
                    }
                default:
                    return
                }
                
            }
            else {
                resetted = false
            }
            
        }
            
        else if (firstBody.categoryBitMask == ballCategory || firstBody.categoryBitMask == ghostBallCategory) && secondBody.categoryBitMask == textCategory {
            if GameScene.soundOn == true {
                secondBody.node?.runAction(wordsBlip)
            }
            
            firstBody.applyImpulse(CGVector(dx: 0, dy: 0.65))
        }
            
        else if (firstBody.categoryBitMask == ballCategory || firstBody.categoryBitMask == ghostBallCategory) && secondBody.categoryBitMask == redBarrierCategory {
            if GameScene.soundOn == true {
                self.scene?.runAction(death)
            }
            gameOver(ball)
        }
    }
    
    func MoveBarriers(){
        for barrier in barrierArray {
            let dx = barrier.position.x - self.frame.width/2
            let dy = barrier.position.y - self.frame.height / 2
            let rad = atan2(dy,dx)
            let Path3 = UIBezierPath(arcCenter: CGPoint(x: self.frame.width/2, y: self.frame.height/2), radius: CONSTANTRADIUS, startAngle: rad, endAngle: rad+CGFloat(M_PI*4), clockwise: true)
            
            let follow = SKAction.followPath(Path3.CGPath, asOffset: false, orientToPath: true, speed: barrier.GetBarrierSpeed())
            barrier.runAction(SKAction.repeatActionForever(follow), withKey: "Moving")
        }
    }
    
    func ReversedMoveBarriers() {
        for barrier in barrierArray {
            let dx = barrier.position.x - self.frame.width/2
            let dy = barrier.position.y - self.frame.height / 2
            let rad = atan2(dy,dx)
            let Path3 = UIBezierPath(arcCenter: CGPoint(x: self.frame.width/2, y: self.frame.height/2), radius: CONSTANTRADIUS, startAngle: rad, endAngle: rad+CGFloat(M_PI*4), clockwise: true)
            
            let follow = SKAction.followPath(Path3.CGPath, asOffset: false, orientToPath: true, speed: barrier.GetBarrierSpeed())
            barrier.runAction(SKAction.repeatActionForever(follow).reversedAction(), withKey: "Moving")
        }
    }
    
    func IrregularMotion() {
        ball.SetBallSpeedClockWise(275)
        ball.SetBallSpeedCounterClockWise(110)
    }
    
    func fluctuateBall(){
        let scale = SKAction.scaleTo(1.0, duration: 0.3)
        let scaleUp = SKAction.scaleTo(1.5, duration: 0.3)
        let scaling = SKAction.sequence([scaleUp,scale])
        let scalingCycle = SKAction.repeatActionForever(scaling)
        ball.runAction(scalingCycle, withKey: "fluctuate")
    }
    
    func Ghost() {
        let fade = SKAction.fadeAlphaTo(0.5, duration: 0.2)
        let fadeBack = SKAction.fadeAlphaTo(1.0, duration: 0.2)
        let cycle = SKAction.sequence([fade,SKAction.waitForDuration(0.75),fadeBack,SKAction.waitForDuration(1.0)])
        
        ball.runAction(SKAction.repeatActionForever(cycle))
        if ball.alpha != 1 {
            ball.physicsBody?.categoryBitMask = ghostBallCategory
        }
        else {
            ball.physicsBody?.categoryBitMask = ballCategory
        }
    }
    
    
    func Haste() {
        for bar in barrierArray {
            let speed = SKAction.speedTo(1.45, duration: 0.1)
            let slow = SKAction.speedBy(0.3, duration: 0.1)
            let wait = SKAction.waitForDuration(1.3)
            bar.runAction(SKAction.repeatActionForever(SKAction.sequence([slow,wait,speed,wait])))
        }
    }
    
    func FluctuateBarriers(){
        let scaler = SKAction.scaleYTo(1.5, duration: 0.5)
        let scaleback = SKAction.scaleYTo(1.0, duration: 0.5)
        let cycle = SKAction.sequence([scaler,SKAction.waitForDuration(2.0),scaleback,SKAction.waitForDuration(1.0)])
        for barrier in barrierArray{
            barrier.runAction(SKAction.repeatActionForever(cycle), withKey: "barrierfluctuation")
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins */
        
        pause(touches)
        if gameStarted == false && IsPaused == false {
            tapToStart.removeFromParent()
            removeText(startingText)
            ball.physicsBody?.affectedByGravity = false
            ball.runAction(SKAction.moveToY(self.frame.height/2 + CONSTANTRADIUS, duration: 0.3), completion: {
                let trailNode = SKNode()
                trailNode.zPosition = 1
                self.addChild(trailNode)
                let trail = SKEmitterNode(fileNamed: "BallTrail")!
                trail.particleTexture = SKTexture(imageNamed: SkinsScene.currentSkin)
                trail.targetNode = trailNode
                self.ball.addChild(trail)
                self.moveClockWise()
                self.movingClockWise = true
                self.gameStarted = true
            })
            
        }
        else if gameStarted == true && IsPaused == false {
            
            if movingClockWise == true && IsPaused == false {
                moveCounterClockWise()
                movingClockWise = false
            }
            else if movingClockWise == false && IsPaused == false {
                moveClockWise()
                movingClockWise = true
            }
        }

    }
    
    func pause(touches: Set<UITouch>) {
        
        if let touch = touches.first as UITouch! {
            let pos = touch.locationInNode(self)
            let node = self.nodeAtPoint(pos)
            
            if node == settingsIcon && IsPaused == false{
                pauseView = UIView(frame: CGRectMake(0, 0, self.view!.bounds.width, self.view!.bounds.height))
                
                let image = UIImage(named: "PlayButton")
                pauseButton = UIButton(type: UIButtonType.Custom) as UIButton
                pauseButton.frame = CGRectMake(0, 0, 85, 85)
                pauseButton.setImage(image, forState: .Normal)
                pauseButton.addTarget(self, action: #selector(GameScene.btnTouched), forControlEvents: .TouchUpInside)
                pauseView.addSubview(pauseButton)
                
                let homeImage = UIImage(named: "homeButton")
                homeButton = UIButton(type: UIButtonType.Custom) as UIButton
                homeButton.frame = CGRectMake(0, 0, 90, 90)
                homeButton.setImage(homeImage, forState: .Normal)
                homeButton.addTarget(self, action: #selector(GameScene.homeTouched), forControlEvents: .TouchUpInside)
                pauseView.addSubview(homeButton)
                
                pauseText = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 100))
                pauseText.font = UIFont(name: "DayPosterBlack", size: 44)
                pauseText.text = "Paused"
                pauseText.textColor = UIColor.whiteColor()
                pauseView.addSubview(pauseText)
                
                pauseView.backgroundColor = UIColor.blackColor()
                pauseView.alpha = 0.66
                self.view?.addSubview(pauseView)
                self.pauseView.center = CGPointMake(CGRectGetMidX((self.view?.bounds)!), CGRectGetMidY((self.view?.bounds)!))
                self.pauseButton.center = CGPointMake(CGRectGetMidX(pauseView.bounds), CGRectGetMidY(pauseView.bounds) - 50)
                self.homeButton.center = CGPointMake(CGRectGetMidX(pauseView.bounds), CGRectGetMidY(pauseView.bounds) + 50)
                self.pauseText.center = CGPointMake(CGRectGetMidX(pauseView.bounds) + 20, CGRectGetMidY(pauseView.bounds) - 140)
                self.scene!.view?.paused = true
                IsPaused = true
                
                pauseButton.transform = CGAffineTransformMakeScale(0.6, 0.6)
                
                UIView.animateWithDuration(2.0,
                                           delay: 0,
                                           usingSpringWithDamping: CGFloat(0.20),
                                           initialSpringVelocity: CGFloat(6.0),
                                           options: UIViewAnimationOptions.AllowUserInteraction,
                                           animations: {
                                            self.pauseButton.transform = CGAffineTransformIdentity
                    },
                                           completion: { Void in()  })
                
                homeButton.transform = CGAffineTransformMakeScale(0.6, 0.6)
                
                UIView.animateWithDuration(2.0,
                                           delay: 0,
                                           usingSpringWithDamping: CGFloat(0.20),
                                           initialSpringVelocity: CGFloat(6.0),
                                           options: UIViewAnimationOptions.AllowUserInteraction,
                                           animations: {
                                            self.homeButton.transform = CGAffineTransformIdentity
                    },
                                           completion: { Void in()  })
            }
        }
    }
    
    func btnTouched() {
        self.scene!.view?.paused = false
        pauseView.removeFromSuperview()
        IsPaused = false
    }
    
    func homeTouched() {
        pauseView.removeFromSuperview()
        IsPaused = false
        self.scene?.view?.paused = false
        
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
        
        if achievement.percentComplete == 100 {
            currency.coins += 150
            coinNotifier.text = "\(currency.coins)"
        }
        
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
    
    func resetAchievements() {
        GKAchievement.resetAchievementsWithCompletionHandler { (error) in
            if error != nil {
                print("why?")
            }
        }
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        if ball.alpha != 1 {
            ball.physicsBody?.categoryBitMask = ghostBallCategory
        }
        else {
            ball.physicsBody?.categoryBitMask = ballCategory
        }

    }
}
