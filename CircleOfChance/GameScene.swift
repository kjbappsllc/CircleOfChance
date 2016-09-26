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
    
    //Layers
    private var gameLayer = SKNode()
    private var hudLayer = SKNode()
    private var pauseLayer = SKNode()
    private var cropLayer = SKCropNode()
    private var maskLayer = SKNode()
    
    //groupings
    private var dotsArray = [String]()
    private var effectsArray = [Effect]()
    private var barrierArray = [barrier]()
    
    //Gameplay
    private var gamePlayArea = SKSpriteNode()
    private var ball = Character()
    private var star = StarIcon()
    private var pauseScreen = SKSpriteNode()
    private var multiplier = SKSpriteNode()
    private var multiplyText = SKLabelNode()
    private var mulitplyCounter = 1
    
    //barriers
    var barrier1 = barrier()
    var barrier2 = barrier()
    var barrier3 = barrier()
    var barrier4 = barrier()
    var barrier5 = barrier()
    var barrier6 = barrier()
    
    //effects
    private let motionEffect = Effect(active: false, effecttype: EffectType.motion)
    private let fluctuateEffect = Effect(active: false, effecttype: EffectType.fluctuate)
    private let ghostEffect = Effect(active: false, effecttype: EffectType.ghost)
    private let hasteEffect = Effect(active: false, effecttype: EffectType.haste)
    private let unstableEffect = Effect(active: false, effecttype: EffectType.unstable)
    private let shakeEffect = Effect(active: false, effecttype: EffectType.shake)
    private var effectSprite = SKSpriteNode()
    
    //HUD
    var topBar = SKSpriteNode()
    var pause = SKSpriteNode()
    let levelText = SKLabelNode()
    var levelInt = 1
    var scoreText = SKLabelNode()
    var score = SKLabelNode()
    
    //PauseLayer
    var homeButton = SKSpriteNode()
    var pausePlayButton = SKSpriteNode()
    
    //HighScore
    static var highscoreInt = Int()
    var highscore = SKLabelNode()
    static var scoreInt = Int()
    var newHighScore = SKLabelNode()
    
    //GameLogic
    var Path = UIBezierPath()
    var movingClockWise = Bool()
    var gameStarted = Bool()
    var isGameOver = false
    var IsPaused = false
    var barriersReversed = Bool()
    var highScoreAchieved = Bool()
    var checkpoint = Bool()
    static var soundOn = Bool()
    var currency = CurrencyManager()
    var starHit = SKSpriteNode()
    
    
    
    //GameCenter
    var gameCenterAchievements = [String:GKAchievement]()
    
    override func didMoveToView(view: SKView) {
        
        
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        addChild(gameLayer)
        addChild(hudLayer)
        
        //Adds the cropLayer to the Scene and masks the middle area
        gameLayer.addChild(cropLayer)
        maskLayer.position = CGPoint(x: 0, y: -50)
        let maskinglayer = SKSpriteNode(imageNamed: "cropLayer")
        maskLayer.addChild(maskinglayer)
        cropLayer.maskNode = maskLayer
        cropLayer.zPosition = layerPositions.maskLayer.rawValue
        effectSprite.zPosition = layerPositions.maskLayer.rawValue
        effectSprite = SKSpriteNode(imageNamed: "fluctuate")
        cropLayer.addChild(effectSprite)
        
        effectSprite.position = CGPoint(x: 120, y: -50)
        
        //Pre set properties
        gameLayer.hidden = true
        hudLayer.hidden = true
        ball.hidden = true
        effectSprite.hidden = true
        barriersReversed = false
        checkpoint = false
        highScoreAchieved = false
        dotsArray.removeAll()
        
        //Initializes the barrierArray to add all the barriers
        barrierArray = [barrier1,barrier2,barrier5,barrier3,barrier6,barrier4]
        
        //Intializes the effects array to add all of the effects
        effectsArray = [motionEffect,fluctuateEffect, hasteEffect, ghostEffect, unstableEffect,shakeEffect]
        
        //Loads the Achievements from gameCenter
        loadAchievementPercentages()
        
        //This Detects from NSUserDefauls whether or not if you have a skin before the data is viewed.
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
        
        // add physics world
        physicsWorld.contactDelegate = self

    }
    
    //loads view
    func loadView() {
        //Sets Up the Scene
        
        userInteractionEnabled = false
        
        //Adds all the necessary stuff
        addBackground()
        addGamePlayArea()
        addHud()
        
        animateBeginGame {
            
            //Adds the barriers and the ball after the game begins
            self.addBarriers()
            self.MoveBarriers()
            self.addBall({
                self.userInteractionEnabled = true
            })
        }
        
    }
    
    //MARK: This function adds the background to the game
    func addBackground() {
        //Adds the colorful background
        
        let background = SKSpriteNode(imageNamed: "backGround")
        background.zPosition = layerPositions.background.rawValue
        self.addChild(background)
    }
    
    //MARK:This function adds the gameplay area including the dots and the barriers
    func addGamePlayArea() {
        //Adds the outside area where the game will be played
        
        gamePlayArea = SKSpriteNode(imageNamed: "PlayingArea")
        gamePlayArea.zPosition = layerPositions.gamePlayArea.rawValue
        gamePlayArea.position = CGPoint(x: 0, y: OFFSET)
        gameLayer.addChild(gamePlayArea)
        
        //Adds the Dots for the beginning of the game
        addScoreUnits()
        
        //Adds the muliplier to the game
        multiplier = SKSpriteNode(imageNamed: "Multiplier")
        multiplier.position = CGPoint(x: -260, y: -460)
        multiplier.zPosition = layerPositions.gamePlayArea.rawValue
        
        multiplyText.text = "1"
        multiplyText.fontName = "Grand Hotel"
        multiplyText.fontSize = 45.0
        multiplyText.position = CGPoint(x: 30, y: -30)
        multiplyText.zPosition = 100
        
        self.addChild(multiplier)
        multiplier.addChild(multiplyText)
        
    }
    
    //Mark: This function ads the hud
    func addHud() {
        
        //Adds the top bar area
        topBar = SKSpriteNode(imageNamed: "topBar")
        topBar.zPosition = layerPositions.topLayer.rawValue
        topBar.position = CGPoint(x: 0, y: (self.frame.height/2) - topBar.frame.height/2)
        hudLayer.addChild(topBar)
        
        //Adds the pause button
        pause = SKSpriteNode(imageNamed: "PauseButton")
        pause.zPosition = layerPositions.topLayer.rawValue
        pause.position = CGPoint(x: 245, y: 15)
        topBar.addChild(pause)
        
        //Adds the text that goes inside the top bar circle
        levelText.text = "\(levelInt)"
        levelText.fontName = "Grand Hotel"
        levelText.position = CGPoint(x: 0, y: -5)
        levelText.zPosition = layerPositions.textLayer.rawValue
        levelText.fontSize = 96.0
        topBar.addChild(levelText)
        
        
        //Adds the text "Score"
        scoreText.text = "Score:"
        scoreText.fontName = "Bodoni 72 Smallcaps"
        scoreText.position = CGPoint(x: -260, y: 0)
        scoreText.fontSize = 46.0
        scoreText.zPosition = layerPositions.textLayer.rawValue
        topBar.addChild(scoreText)
        
        //Adds the players score that is initialized to zero
        score.text = "0"
        score.fontName = "Bodoni 72 Smallcaps"
        score.position = CGPoint(x: -260, y: -45)
        score.fontSize = 46.0
        score.zPosition = layerPositions.textLayer.rawValue
        topBar.addChild(score)
        
    }
    
    //Mark: This animates the beginning of the game
    func animateBeginGame(completion_: () -> ()) {
        
        //Animates the gameLayer
        gameLayer.hidden = false
        gameLayer.position = CGPoint(x: size.width, y: 0)
        let gameLayerMove = SKAction.moveBy(CGVector(dx: -size.width, dy: 0), duration: 0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.7)
        gameLayerMove.timingMode = .EaseOut
        gameLayer.runAction(gameLayerMove)
        
        //Animates the hudlayer
        hudLayer.hidden = false
        hudLayer.position = CGPoint(x: 0, y: size.height)
        let hudAction = SKAction.moveBy(CGVector(dx: 0, dy: -size.height), duration: 0.5, delay: 0.2, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.9)
        hudAction.timingMode = .EaseOut
        
        //Animates the multiplier on screen
        multiplier.position = CGPoint(x: multiplier.position.x - 400, y: multiplier.position.y)
        let multiplierAction = SKAction.moveBy(CGVector(dx: 400, dy: 0), duration: 0.3, delay: 0.2, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.9)
        
        multiplier.runAction(multiplierAction)
        hudLayer.runAction(hudAction, completion: completion_)
    }
    
    //Mark: This function animates the end of the game when the character hits the barrier or when the home button is pressed during the pause screen.
    func animateEndGame(completion: () -> ()) {

        let gameLayerMove = SKAction.moveBy(CGVector(dx: size.width, dy:0), duration: 0.3)
        
        gameLayerMove.timingMode = .EaseIn
        
        let hudAction = SKAction.moveBy(CGVector(dx: 0, dy: size.height), duration: 0.5)
        
        hudAction.timingMode = .EaseIn
        
        let multiplierAction = SKAction.moveBy(CGVector(dx: -400, dy: 0), duration: 0.3)
        
        gameLayer.runAction(gameLayerMove)
        multiplier.runAction(multiplierAction)
        hudLayer.runAction(hudAction, completion: completion)
    }
    
    //MARK: THIS function adds the barriers to the gameplay area
    func addBarriers() {
        barrier1.position = CGPoint(x: 0, y: 210)
        barrier1.zPosition = layerPositions.barriers.rawValue
        barrier1.zRotation = CGFloat(M_PI / 2)
        gamePlayArea.addChild(barrier1)
        barrier1.addRedBarrier()
        
        barrier2.position = CGPoint(x: 0, y: -122.5)
        barrier2.zPosition = layerPositions.barriers.rawValue
        barrier2.zRotation = CGFloat(3*M_PI / 2)
        gamePlayArea.addChild(barrier2)
        
        barrier5.position = CGPoint(x: -140, y: 135)
        barrier5.zPosition = layerPositions.barriers.rawValue
        barrier5.zRotation = CGFloat(5*M_PI / 6)
        gamePlayArea.addChild(barrier5)
        
        barrier3.position = CGPoint(x: 145.5, y: -40)
        barrier3.zPosition = layerPositions.barriers.rawValue
        barrier3.zRotation = CGFloat(11 * M_PI / 6)
        gamePlayArea.addChild(barrier3)
        
        barrier6.position = CGPoint(x: 140, y: 135)
        barrier6.zPosition = layerPositions.barriers.rawValue
        barrier6.zRotation = CGFloat(M_PI / 6)
        gamePlayArea.addChild(barrier6)
        
        barrier4.position = CGPoint(x: -145.5, y: -40)
        barrier4.zPosition = layerPositions.barriers.rawValue
        barrier4.zRotation = CGFloat(7 * M_PI / 6)
        gamePlayArea.addChild(barrier4)
    }
    
    //MARK: This function moves the barriers at the start of the game
    func MoveBarriers(){
        for barrier in barrierArray {
            let dx = barrier.position.x
            let dy = barrier.position.y - 45
            
            let rad = atan2(dy, dx)
            let Path3 = UIBezierPath(arcCenter: CGPoint(x: 0, y: 45), radius: 165, startAngle: rad, endAngle: rad+CGFloat(M_PI*4), clockwise: true)
            
            let follow = SKAction.followPath(Path3.CGPath, asOffset: false, orientToPath: true, speed: barrier.GetBarrierSpeed())
            barrier.runAction(SKAction.repeatActionForever(follow), withKey: "Moving")
        }
    }
    
    //Mark: This function moves the barriers in the opposite direction
    func ReversedMoveBarriers() {
        for barrier in barrierArray {
            let dx = barrier.position.x
            let dy = barrier.position.y - 45
            let rad = atan2(dy,dx)
            let Path3 = UIBezierPath(arcCenter: CGPoint(x: 0, y: 45), radius: 165, startAngle: rad, endAngle: rad+CGFloat(M_PI*4), clockwise: true)
            
            let follow = SKAction.followPath(Path3.CGPath, asOffset: false, orientToPath: true, speed: barrier.GetBarrierSpeed())
            barrier.runAction(SKAction.repeatActionForever(follow).reversedAction(), withKey: "Moving")
        }
    }
    
    //MARK: This function adds the dots to the gamePlay area
    func addScoreUnits() {
        
        //The constants
        let randomNum = Int(arc4random_uniform(15) + 1)
        let radius: CGFloat = CONSTANTRADIUS
        let numberOfCircle = NUMBEROFCIRCLES
        var added = false
        for i in 1...numberOfCircle {
            if (checkpoint != true) || (checkpoint == true && added == true) {
                //Physics body
                let circle = SKSpriteNode(imageNamed: "scoreDotYellow")
                circle.alpha = 0
                circle.physicsBody = nil
                
                if "defaultTheme" == ThemesScene.currentTheme["name"] as! String {
                    if levelInt % 2 == 0 {
                        circle.texture = SKTexture(imageNamed: "scoreDotYellow")
                    }
                    else {
                        circle.texture = SKTexture(imageNamed: "scoreDotWhite")
                    }
                }
                else {
                    circle.texture = SKTexture(imageNamed: ThemesScene.currentTheme["dotTexture"] as! String)
                }
                
                // You can get every single circle by name:
                circle.name = String(format:"circle%d",i)
                dotsArray.append(circle.name!)
                let angle = 2 * M_PI / Double(numberOfCircle) * Double(i)
                
                let initialPosition = CGPoint(x:0, y:50)
                
                let circleX = radius * cos(CGFloat(angle))
                let circleY = radius * sin(CGFloat(angle))
                let finalPosition = CGPoint(x:circleX - gamePlayArea.position.x / 2, y:circleY - gamePlayArea.position.y / 2 - 10)
                
                circle.position = initialPosition
                circle.zPosition = layerPositions.dots.rawValue
                
                gamePlayArea.addChild(circle)
                animateDot(circle, location: finalPosition) {
                    circle.physicsBody = SKPhysicsBody(circleOfRadius: 2.5)
                    circle.physicsBody?.categoryBitMask = dotCategory
                    circle.physicsBody?.contactTestBitMask = ballCategory
                    circle.physicsBody?.affectedByGravity = false
                    circle.physicsBody?.dynamic = false
                    
                }
            }
                
            else if checkpoint == true && added == false {
                if i == randomNum {
                    let star = StarIcon()
                    star.physicsBody = nil
                    star.name = "Star"
                    dotsArray.append("Star")
                    
                    let angle = 2 * M_PI / Double(numberOfCircle) * Double(i)
 
                    let initialPosition = CGPoint(x:0, y:50)
                    
                    let circleX = radius * cos(CGFloat(angle))
                    let circleY = radius * sin(CGFloat(angle))
                    
                    let finalPosition = CGPoint(x:circleX - gamePlayArea.position.x / 2, y:circleY - gamePlayArea.position.y / 2 - 10)
                    
                    star.position = initialPosition
                    
                    star.zPosition = layerPositions.dots.rawValue
                    
                    gamePlayArea.addChild(star)
                    animateDot(star, location: finalPosition){
                        star.LoadPhysics()
                    }
                    star.animateStar()
                    added = true
                }
                else {
                    let circle = SKSpriteNode(imageNamed: "scoreDotYellow")
                    circle.alpha = 0
                    circle.physicsBody = nil
                    
                    if "defaultTheme" == ThemesScene.currentTheme["name"] as! String {
                        if levelInt % 2 == 0 {
                            circle.texture = SKTexture(imageNamed: "scoreDotYellow")
                        }
                        else {
                            circle.texture = SKTexture(imageNamed: "scoreDotWhite")
                        }
                    }
                    else {
                        circle.texture = SKTexture(imageNamed: ThemesScene.currentTheme["dotTexture"] as! String)
                    }
                    
                    // You can get every single circle by name:
                    circle.name = String(format:"circle%d",i)
                    dotsArray.append(circle.name!)
                    let angle = 2 * M_PI / Double(numberOfCircle) * Double(i)
                    
                    let initialPosition = CGPoint(x:0, y:50)
                    
                    let circleX = radius * cos(CGFloat(angle))
                    let circleY = radius * sin(CGFloat(angle))
                    let finalPosition = CGPoint(x:circleX - gamePlayArea.position.x / 2, y:circleY - gamePlayArea.position.y / 2 - 10)
                    
                    circle.position = initialPosition
                    circle.zPosition = layerPositions.dots.rawValue
                    
                    gamePlayArea.addChild(circle)
                    animateDot(circle, location: finalPosition) {
                        circle.physicsBody = SKPhysicsBody(circleOfRadius: 2.5)
                        circle.physicsBody?.categoryBitMask = dotCategory
                        circle.physicsBody?.contactTestBitMask = ballCategory
                        circle.physicsBody?.affectedByGravity = false
                        circle.physicsBody?.dynamic = false
                        
                    }
                }
            }
        }
    }
    
    //MARK: This is to animate the dots into view
    func animateDot(circle: SKSpriteNode, location: CGPoint, completion: () -> ()) {
        let moveAction = SKAction.moveTo(location, duration: 0.7)
        let fadeIn = SKAction.fadeInWithDuration(0.5)
        moveAction.timingMode = .EaseOut
        circle.runAction(SKAction.group([moveAction,fadeIn]), completion: completion)
    }
    
    //Mark: This Function adds the ball onto the area
    func addBall(completion: () -> ()) {
        ball.position = CGPoint(x: -40, y: 45)
        ball.zPosition = layerPositions.character.rawValue
        ball.hidden = false
        gamePlayArea.addChild(ball)
        
        let moveAction = SKAction.moveBy(CGVector(dx: 80, dy: 0), duration: 0.7)
        let wait = SKAction.waitForDuration(0.1)
        
        moveAction.timingMode = .EaseOut
        
        ball.runAction(SKAction.repeatActionForever(SKAction.sequence([moveAction, wait, moveAction.reversedAction(), wait])), withKey: "moveAction")
        
        ball.runAction(SKAction.waitForDuration(0.0), completion: completion)
        
    }
    
    //Mark: Moves the ball counter clockwise
    func moveCounterClockWise(){
        let dx = ball.position.x
        let dy = ball.position.y - 45
        
        let rad = atan2(dy,dx)
        Path = UIBezierPath(arcCenter: CGPoint(x: 0, y: 45), radius: 165, startAngle: rad, endAngle: rad+CGFloat(M_PI*4), clockwise: true)
        
        let follow = SKAction.followPath(Path.CGPath, asOffset: false, orientToPath: false, speed: ball.getballSpeedCounterClockWise())
        ball.runAction(SKAction.repeatActionForever(follow))
        
    }
    
    //Mark: moves the ball Clockwise
    func moveClockWise() {
        let dx = ball.position.x
        let dy = ball.position.y - 45
        
        let rad = atan2(dy,dx)
        Path = UIBezierPath(arcCenter: CGPoint(x: 0, y: 45), radius: 165, startAngle: rad, endAngle: rad+CGFloat(M_PI*4), clockwise: true)
        
        let follow = SKAction.followPath(Path.CGPath, asOffset: false, orientToPath: false, speed: ball.getballSpeedClockWise())
        ball.runAction(SKAction.repeatActionForever(follow).reversedAction())
    }
    
    

    //Mark: Executed When there is contact with the dots or the star
    // create a random percent, with a precision of one decimal place
    func randomPercent() -> Double {
        return Double(arc4random() % 1000) / 10.0;
    }
    
    //Mark: Checks to see whether or not there is a need to update the achievements
    func updatePointAchievements() {
        
        if GameScene.scoreInt == 300 {
            self.incrementCurrentPercentageOfAchievement("achievement_300points", amount: 100.0)
        }
        
        if GameScene.scoreInt == 800 {
            self.incrementCurrentPercentageOfAchievement("achievement_800points", amount: 100.0)
        }
        
        if GameScene.scoreInt >= 1500 {
            self.incrementCurrentPercentageOfAchievement("achievement_1500points", amount: 100.0)
        }
        
        if GameScene.scoreInt >= 3000 {
            self.incrementCurrentPercentageOfAchievement("achievement_3000points", amount: 100.0)
        }
    }
    
    //Mark: This function checks to see whether or not the player should go to the next level
    func handleNewLevel() {
        //If the there are no dots in play do this
        if dotsArray.count <= 0{
            
            let randomChance = arc4random_uniform(100)
            
            //Checks and sees whether or not between each level the barriers will reverse
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
            
            //When their are no dots the level increase and check whether or not their should be a checkpoint
            levelInt += 1
            levelText.text = "\(levelInt)"
            
            let scale = SKAction.scaleTo(1.4, duration: 0.3, delay: 0.0, usingSpringWithDamping: 0.2, initialSpringVelocity: 0.0)
            let scaleBack = SKAction.scaleTo(1.0, duration: 0.3, delay: 0.1, usingSpringWithDamping: 0.2, initialSpringVelocity: 0.9)
            levelText.runAction(SKAction.sequence([scale, scaleBack]))
            
            if levelInt % 5 == 0 {
                checkpoint = true
            }
            else {
                checkpoint = false
            }
            
            //Adds the score units back into play for the next level
            addScoreUnits()
            
            
            //Checks to see whether or not to add more speed to the ball based on whether the effect "Motion" is up
            if ball.getballSpeedClockWise() < 350 && motionEffect.isActive == false{
                ball.AddBallSpeedClockWise(3)
                ball.AddBallSpeedCounterClockWise(3)
            }
            
            //Adds the new level in the beginning of the level
            for barrier in barrierArray {
                if barrier.IsActive() == false {
                    barrier.addRedBarrier()
                    break
                }
            }
            
            let randomNumber = randomPercent()
            switch(randomNumber) {
            case 0..<55:
                
                effectsArray.shuffleInPlace()
                for effect in effectsArray {
                    if effect.isActive == false {
                        switch effect.effectType {
                            
                        case .motion:
                            effectSprite.hidden = false
                            let move = SKAction.moveBy(CGVector(dx: -120, dy: 0), duration: 0.2)
                            move.timingMode = .EaseOut
                            
                            let resizing = SKAction.scaleTo(1.2, duration: 0.5)
                            let scaleback = SKAction.scaleTo(1.0, duration: 0.5)
                            let wait = SKAction.waitForDuration(1.0)
                            
                            let resizeAction = SKAction.sequence([resizing,scaleback,wait])
                            
                            effectSprite.texture = SKTexture(imageNamed: "motion")
                            
                            IrregularMotion()
                            effect.isActive = true
                            
                            effectSprite.runAction(SKAction.sequence([move,resizeAction,move.reversedAction()])){
                                self.effectSprite.hidden = true
                            }
                            
                        case .fluctuate:
                            
                            effectSprite.hidden = false
                            let move = SKAction.moveBy(CGVector(dx: -120, dy: 0), duration: 0.2)
                            move.timingMode = .EaseOut
                            
                            let resizing = SKAction.scaleTo(1.2, duration: 0.5)
                            let scaleback = SKAction.scaleTo(1.0, duration: 0.5)
                            let wait = SKAction.waitForDuration(1.0)
                            
                            let resizeAction = SKAction.sequence([resizing,scaleback,wait])
                            effectSprite.texture = SKTexture(imageNamed: "fluctuate")
                            fluctuateBall()
                            effect.isActive = true
                            
                            effectSprite.runAction(SKAction.sequence([move,resizeAction,move.reversedAction()])){
                                self.effectSprite.hidden = true
                            }
                            
                        case .haste:
                            effectSprite.hidden = false
                            let move = SKAction.moveBy(CGVector(dx: -120, dy: 0), duration: 0.2)
                            move.timingMode = .EaseOut
                            
                            let resizing = SKAction.scaleTo(1.2, duration: 0.5)
                            let scaleback = SKAction.scaleTo(1.0, duration: 0.5)
                            let wait = SKAction.waitForDuration(1.0)
                            
                            let resizeAction = SKAction.sequence([resizing,scaleback,wait])
                            
                            effectSprite.texture = SKTexture(imageNamed: "haste")
                            Haste()
                            effect.isActive = true
                            
                            effectSprite.runAction(SKAction.sequence([move,resizeAction,move.reversedAction()])){
                                self.effectSprite.hidden = true
                            }
                            
 
                        case .unstable:
                            effectSprite.hidden = false
                            let move = SKAction.moveBy(CGVector(dx: -120, dy: 0), duration: 0.2)
                            move.timingMode = .EaseOut
                            
                            let resizing = SKAction.scaleTo(1.2, duration: 0.5)
                            let scaleback = SKAction.scaleTo(1.0, duration: 0.5)
                            let wait = SKAction.waitForDuration(1.0)

                            
                            let resizeAction = SKAction.sequence([resizing,scaleback,wait])
                            
                            effectSprite.texture = SKTexture(imageNamed: "unstable")
                            FluctuateBarriers()
                            effect.isActive = true
                            

                            effectSprite.runAction(SKAction.sequence([move,resizeAction,move.reversedAction()])){
                                self.effectSprite.hidden = true
                            }
                            
 
                        case .ghost:
                            effectSprite.hidden = false
                            let move = SKAction.moveBy(CGVector(dx: -120, dy: 0), duration: 0.2)
                            move.timingMode = .EaseOut
                            let resizing = SKAction.scaleTo(1.2, duration: 0.5)
                            let scaleback = SKAction.scaleTo(1.0, duration: 0.5)
                            let wait = SKAction.waitForDuration(1.0)
                            
                            let resizeAction = SKAction.sequence([resizing,scaleback,wait])
                            effectSprite.texture = SKTexture(imageNamed: "ghost")
                            Ghost()
                            effect.isActive = true
                            
                            effectSprite.runAction(SKAction.sequence([move,resizeAction,move.reversedAction()])){
                                self.effectSprite.hidden = true
                            }
                            
                        case .shake:
                            
                            effectSprite.hidden = false
                            let move = SKAction.moveBy(CGVector(dx: -120, dy: 0), duration: 0.2)
                            move.timingMode = .EaseOut
                            let resizing = SKAction.scaleTo(1.2, duration: 0.5)
                            let scaleback = SKAction.scaleTo(1.0, duration: 0.5)
                            let wait = SKAction.waitForDuration(1.0)
                            
                            let resizeAction = SKAction.sequence([resizing,scaleback,wait])
                            effectSprite.texture = SKTexture(imageNamed: "shake")
                            Shake()
                            effect.isActive = true
                            
                            effectSprite.runAction(SKAction.sequence([move,resizeAction,move.reversedAction()])){
                                self.effectSprite.hidden = true
                            }
 
                        }
                        break
                    }
                }
                
            default:
                return
            }
        }
    }


    //Mark: Adds the particles when the barrier breaks
    func addBarrierBreakParticles(bar: barrier) {
        let particles = SKEmitterNode(fileNamed: "BarrierBreak")!
        particles.position = bar.position
        particles.zPosition = bar.zPosition + 1
        self.addChild(particles)
        bar.removeBarrier()
        
        particles.runAction(SKAction.sequence([SKAction.waitForDuration(1.0), SKAction.removeFromParent()]))
    }
    
    //Mark: This function handles the logic for when the star is hit
    func handleStarPickup(node:SKNode) {
        if node.name == "Star" {
            
            let moveR = SKAction.moveBy(CGVector(dx: 10, dy:0), duration: 0.15)
            let moveL = SKAction.moveBy(CGVector(dx: -20, dy:0), duration: 0.3)
            
            mulitplyCounter += 1
            multiplyText.text = "\(mulitplyCounter)"
            
            multiplyText.runAction(SKAction.sequence([moveR,moveL,moveL.reversedAction(),moveR.reversedAction()]))
            
            let randomNum = self.randomPercent()
            switch randomNum {
                
            case 0..<75:
                var limit = 0
                for barriers in self.barrierArray.reverse() {
                    if limit != 2 {
                        if barriers.IsActive() {
                            
                            addBarrierBreakParticles(barriers)
                            
                            limit += 1
                        }
                    }
                }
                
            default:
                var limit = 0
                for barriers in self.barrierArray.reverse() {
                    if limit != 3 {
                        if barriers.IsActive() {
                            
                            addBarrierBreakParticles(barriers)
                            
                            limit += 1
                        }
                    }
                }
            }
        }

    }
    
    //Mark: This is an auxiliary function that does action when the ball hits the dots or the star
    func handleScoreUnitContact(node: SKNode) {
        node.physicsBody = nil
        node.runAction(SKAction.removeFromParent())
        
        for (index,value) in self.dotsArray.enumerate() {
            if node.name == value {
                
                self.dotsArray.removeAtIndex(index)
                GameScene.scoreInt += 1 * mulitplyCounter
                self.score.text = "\(GameScene.scoreInt)"
                self.updatePointAchievements()
                
                if GameScene.scoreInt > GameScene.highscoreInt {
                    NSUserDefaults.standardUserDefaults().setInteger(GameScene.highscoreInt, forKey: "highscore")
                    
                    let scaleUp = SKAction.scaleTo(1.1, duration: 0.2)
                    let scaleDown = SKAction.scaleTo(1.0, duration: 0.2)
                    
                    self.newHighScore.alpha = 1
                    self.newHighScore.runAction(SKAction.repeatActionForever(SKAction.sequence([scaleUp,scaleDown])))
                }
                
                self.handleStarPickup(node)
                self.handleNewLevel()
            }
        }
        
        
    }
    
    // Mark: Lets me know when there is contact
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
            
            handleScoreUnitContact(secondBody.node!)
            
        }
            
        else if (firstBody.categoryBitMask == ballCategory || firstBody.categoryBitMask == ghostBallCategory) && secondBody.categoryBitMask == redBarrierCategory {
            
            gameOver(firstBody.node!)
        }
    }
    
    
    //Mark: This function is called when the player hits the barrier and the game is over
    func gameOver(node: SKNode) {
        
        currency.games += 1
        
        if currency.games == 50 {
        
            incrementCurrentPercentageOfAchievement("achievement_50games", amount: 100.0)
            currency.coins += 75
        }
        
        if currency.games == 100 {
            incrementCurrentPercentageOfAchievement("achievement_100games", amount: 100.0)
            currency.coins += 75
        }
        
        if currency.games == 200 {
            incrementCurrentPercentageOfAchievement("achievement_200games", amount: 100.0)
            currency.coins += 75
        }
        
        if currency.games == 500 {
            incrementCurrentPercentageOfAchievement("achievement_500games", amount: 100.0)
            currency.coins += 75
        }
        
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
        
        ball.removeAllActions()
        
        let action1 = SKAction.colorizeWithColor(UIColor.redColor(), colorBlendFactor: 1.0, duration: 0.1)
        let action2 = SKAction.colorizeWithColor(scene!.backgroundColor, colorBlendFactor: 1.0, duration: 0.1)
        self.scene?.runAction(SKAction.sequence([action1,action2]))
        
        let particles = SKEmitterNode(fileNamed: "GameOver")!
        particles.particlePosition = ball.position
        particles.zPosition = layerPositions.barriers.rawValue + 1
        gamePlayArea.addChild(particles)
        
        ball.removeFromParent()

        particles.runAction(SKAction.sequence([SKAction.waitForDuration(1.0), SKAction.removeFromParent()])) {
            self.animateEndGame({
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
            })
        }
    }
    
    //An effect that changes the motion of the ball
    func IrregularMotion() {
        ball.SetBallSpeedClockWise(310)
        ball.SetBallSpeedCounterClockWise(130)
    }
    
    //An effect that changes the size of the ball
    func fluctuateBall(){
        let scale = SKAction.scaleTo(1.0, duration: 0.3)
        let scaleUp = SKAction.scaleTo(1.35, duration: 0.3)
        let scaling = SKAction.sequence([scaleUp,scale])
        let scalingCycle = SKAction.repeatActionForever(scaling)
        ball.runAction(scalingCycle, withKey: "fluctuate")
    }
    
    //An effect that changes the visibility of the ball
    func Ghost() {
        let fade = SKAction.fadeAlphaTo(0.5, duration: 0.0)
        let fadeBack = SKAction.fadeAlphaTo(1.0, duration: 0.0)
        let cycle = SKAction.sequence([fade,SKAction.waitForDuration(0.5),fadeBack,SKAction.waitForDuration(2.0)])
        
        ball.runAction(SKAction.repeatActionForever(cycle))
    }
    
    //An effect that changes the speed of the barriers
    func Haste() {
        for bar in barrierArray {
            let speed = SKAction.speedTo(1.45, duration: 0.1)
            let slow = SKAction.speedBy(0.3, duration: 0.1)
            let wait = SKAction.waitForDuration(1.3)
            bar.runAction(SKAction.repeatActionForever(SKAction.sequence([slow,wait,speed,wait])))
        }
    }
    
    //An effect that changes the size of the barriers
    func FluctuateBarriers(){
        let scaler = SKAction.scaleYTo(1.5, duration: 0.5)
        let scaleback = SKAction.scaleYTo(1.0, duration: 0.5)
        let cycle = SKAction.sequence([scaler,SKAction.waitForDuration(2.0),scaleback,SKAction.waitForDuration(1.0)])
        for barrier in barrierArray{
            barrier.runAction(SKAction.repeatActionForever(cycle), withKey: "barrierfluctuation")
        }
    }
    
    //An effect that shakes the area
    func Shake() {
        let moveR = SKAction.moveBy(CGVector(dx: -25, dy: 0), duration: 0.2)
        let moveU = SKAction.moveBy(CGVector(dx: 0, dy: 25), duration: 0.2)
        let wait = SKAction.waitForDuration(0.1)
        
        moveR.timingMode = .EaseOut
        moveU.timingMode = .EaseOut
        
        let moveHorizonalActionL = SKAction.sequence([moveR,wait,moveR.reversedAction(),wait])
        let moveVerticalActionU = SKAction.sequence([moveU,wait,moveU.reversedAction(),wait])
        
        let moveHorizonalActionR = SKAction.sequence([moveR.reversedAction(),wait,moveR,wait])
        let moveVerticalActionD = SKAction.sequence([moveU.reversedAction(),wait,moveU,wait])
        
        let shakeAction = SKAction.sequence([moveHorizonalActionL, moveVerticalActionU, moveHorizonalActionR,moveVerticalActionD])
        
        gameLayer.runAction(SKAction.repeatActionForever(shakeAction))
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins */
        var node = SKNode()
        if let touch = touches.first {
            let pos = touch.locationInNode(topBar)
            node = topBar.nodeAtPoint(pos)
        }
        if gameStarted == false && IsPaused == false && node != pause{
            self.scene?.userInteractionEnabled = false
            
            if ball.position.x > gamePlayArea.position.x {
                ball.removeAllActions()
                let move = SKAction.moveBy(CGVector(dx: CONSTANTRADIUS - ball.position.x, dy: 0), duration: 0.4)
                move.timingMode = .EaseIn
                ball.runAction(move, completion: {
                    SKAction.waitForDuration(0.3)
                    self.moveCounterClockWise()
                    self.gameStarted = true
                    self.scene?.userInteractionEnabled = true
                })
            }
            else {
                ball.removeAllActions()
                let move = SKAction.moveBy(CGVector(dx: -CONSTANTRADIUS - ball.position.x, dy: 0), duration: 0.4)
                move.timingMode = .EaseIn
                ball.runAction(move, completion: {
                    SKAction.waitForDuration(0.3)
                    self.moveClockWise()
                    self.gameStarted = true
                    self.scene?.userInteractionEnabled = true
                })
            }
            
        }
        else if gameStarted == true && IsPaused == false && node != pause {
            
            if movingClockWise == true && IsPaused == false {
                moveCounterClockWise()
                movingClockWise = false
            }
            else if movingClockWise == false && IsPaused == false {
                moveClockWise()
                movingClockWise = true
            }
        }
        pause(touches)

    }
    
    //Mark: This function is called when the pause button is pressed
    func pause(touches: Set<UITouch>) {
        
        if let touch = touches.first as UITouch! {
            let pos = touch.locationInNode(topBar)
            let node = topBar.nodeAtPoint(pos)
            
            let loc = touch.locationInNode(pauseLayer)
            
            if node == pause && IsPaused == false {
                self.addChild(pauseLayer)
                pauseScreen = SKSpriteNode(imageNamed: "pauseLayer")
                pauseScreen.zPosition = 100
                pauseLayer.addChild(pauseScreen)
                
                homeButton = SKSpriteNode(imageNamed: "homebutton")
                homeButton.position = CGPoint(x: -240, y: 440)
                homeButton.zPosition = 150
                
                pausePlayButton = SKSpriteNode(imageNamed: "playButton")
                pausePlayButton.position = CGPoint(x: 0, y: -60)
                pausePlayButton.zPosition = 150
                
                pauseLayer.addChild(pausePlayButton)
                pauseLayer.addChild(homeButton)
                self.scene?.paused = true
                IsPaused = true
            }
            
            if IsPaused == true && pausePlayButton.containsPoint(loc) {
                for children in pauseLayer.children {
                    children.removeFromParent()
                }
                pauseLayer.removeFromParent()
                self.scene?.paused = false
                IsPaused = false
                
            }
            
            if IsPaused == true && homeButton.containsPoint(loc) {
                scene?.userInteractionEnabled = false
                for children in pauseLayer.children {
                    children.removeFromParent()
                }
                pauseLayer.removeFromParent()
                self.scene!.paused = false
                self.animateEndGame({
                    if let scene = MainMenu(fileNamed:"GameScene") {
                        
                        // Configure the view.
                        let skView = self.view as SKView!
                        /* Sprite Kit applies additional optimizations to improve rendering performance */
                        skView.ignoresSiblingOrder = true
                        /* Set the scale mode to scale to fit the window */
                        scene.scaleMode = .AspectFill
                        skView.presentScene(scene)
                    }
                })
            }
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
            ball.physicsBody?.collisionBitMask = redBarrierCategory
        }
        else {
            ball.physicsBody?.categoryBitMask = ballCategory
            ball.physicsBody?.collisionBitMask = dotCategory | redBarrierCategory
        }

    }
}
