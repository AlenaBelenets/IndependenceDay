//
//  GameScene.swift
//  IndependenceDay
//
//  Created by Alena Belenets on 10.09.2023.
//

import SpriteKit
import GameplayKit

var gameScore = 0

private enum GameState {
    case preGame
    case inGame
    case afterGame
}

 enum NodesName: String {
    case background = "Background"
    case left = "Left"
    case right = "Right"
    case telescopicSign = "telescopicSign"
    case enemy = "Enemy"
     case score = "score"
}

enum DoubleNumbers: Double {
    case zeroPointOne = 0.1
    case zeroPointTwo = 0.2
    case zeroPointThree = 0.3
    case zeroPointFour = 0.4
    case zeroPointFive = 0.5
    case zeroPointSeven = 0.7
    case zeroPointEightFive = 0.85
    case zeroPointNine = 0.9
    case one = 1.0
    case onePointTwo = 1.2
    case onePointThree = 1.3
    case onePointFive = 1.5
    case onePointEight = 1.8
    case two = 2.0
    case three = 3.0
    case nine = 9.0
    case ten = 10.0
    case fifteen = 15.0
    case sixteen = 16.0
    case fifty = 50.0
    case seventy = 70.0
    case ninety = 90.0
    case oneHundred = 100.0
    case oneHundredAndFifty = 150.0 
    case sixHundred = 600.0
}


struct PhysicCategories {
    static let None: UInt32 = 0
    static let Player: UInt32 = 0b1 //1
    static let Bullet: UInt32 = 0b10 //2
    static let Enemy: UInt32 = 0b100 //4
}

class GameScene: SKScene, SKPhysicsContactDelegate {

    // MARK: - Private properties
    private var gameArea: CGRect
    private var currentGameState = GameState.inGame
    private var gameModel = GameModel.getGameModel()
    private var imageName: SKSpriteNode!
    private var player: SKSpriteNode!
    private var scoreLAbel: SKLabelNode!

    private var lastUpdateTime: TimeInterval = 0
    private var deltaFrameTime: TimeInterval = 0
    private var amountToMovePerSecond: CGFloat = DoubleNumbers.sixHundred.rawValue

    lazy var bulletSound = SKAction.playSoundFileNamed(
        gameModel.nameOsBulletSong,
        waitForCompletion: false
    )
    private lazy var rightButton = SKSpriteNode(imageNamed: gameModel.rightButton)
    private lazy var leftButton = SKSpriteNode(imageNamed: gameModel.leftButton)
    private lazy var telescopicSign = SKSpriteNode(imageNamed: gameModel.telescopicSign)

    // MARK: - sceneDidLoad
    override func sceneDidLoad() {
        imageName = SKSpriteNode(imageNamed: gameModel.nameOfSky)
        player = SKSpriteNode(imageNamed: UserDefaults.standard.string(forKey: gameModel.keyForAirplane)!)
        scoreLAbel = SKLabelNode(fontNamed: gameModel.fontNamed)
    }


    // MARK: - Initialisations
    override init(size: CGSize) {
        let maxAspectRatio: CGFloat = DoubleNumbers.sixteen.rawValue/DoubleNumbers.nine.rawValue
        let playableWidth = size.height / maxAspectRatio
        let margin = (size.width - playableWidth) / DoubleNumbers.two.rawValue
        gameArea = CGRect(x: margin, y: 0, width: playableWidth, height: size.height)
        super.init(size: size)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - didMove
    override func didMove(to view: SKView) {
        self.physicsWorld.contactDelegate = self

        for i in 0...1 {

            let background = SKSpriteNode(imageNamed: gameModel.nameOfSky)
            background.size = self.size

            background.anchorPoint = CGPoint(x: DoubleNumbers.zeroPointFive.rawValue, y: 0)

            background.position = CGPoint(x: self.size.width/DoubleNumbers.two.rawValue, y: self.size.height*CGFloat(i))
            background.zPosition = 0
            background.name = NodesName.background.rawValue
            self.addChild(background)

        }

        player.setScale(DoubleNumbers.onePointThree.rawValue)
        player.position = CGPoint(x: self.size.width/DoubleNumbers.two.rawValue, y: self.size.height * DoubleNumbers.zeroPointTwo.rawValue)
        player.zPosition = DoubleNumbers.two.rawValue
        player.physicsBody = SKPhysicsBody(rectangleOf: player.size)
        player.physicsBody?.affectedByGravity = false
        player.physicsBody?.categoryBitMask = PhysicCategories.Player
        player.physicsBody?.collisionBitMask = PhysicCategories.None
        player.physicsBody?.contactTestBitMask = PhysicCategories.Enemy
        self.addChild(player)

        leftButton.name = NodesName.left.rawValue
        rightButton.name = NodesName.right.rawValue

        rightButton.setScale(DoubleNumbers.zeroPointSeven.rawValue)
        rightButton.position = CGPoint(x: self.size.width/DoubleNumbers.onePointFive.rawValue, y: self.size.height * DoubleNumbers.zeroPointOne.rawValue)
        rightButton.zPosition = DoubleNumbers.two.rawValue
        self.addChild(rightButton)

        leftButton.setScale(DoubleNumbers.zeroPointSeven.rawValue)
        leftButton.position = CGPoint(x: self.size.width/DoubleNumbers.three.rawValue, y: self.size.height * DoubleNumbers.zeroPointOne.rawValue)
        leftButton.zPosition = DoubleNumbers.two.rawValue
        self.addChild(leftButton)

        telescopicSign.setScale(DoubleNumbers.zeroPointThree.rawValue)
        telescopicSign.position = CGPoint(x: self.size.width/DoubleNumbers.two.rawValue, y: self.size.height * DoubleNumbers.zeroPointOne.rawValue)
        telescopicSign.zPosition = DoubleNumbers.two.rawValue
        telescopicSign.name = NodesName.telescopicSign.rawValue
        self.addChild(telescopicSign)

        scoreLAbel.text = "Score: \(gameModel.score)"
        scoreLAbel.fontSize = DoubleNumbers.seventy.rawValue
        scoreLAbel.fontColor = SKColor.black
        scoreLAbel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        scoreLAbel.position = CGPoint(x: self.size.width*DoubleNumbers.zeroPointTwo.rawValue, y: self.size.height*DoubleNumbers.zeroPointNine.rawValue)
        scoreLAbel.zPosition = DoubleNumbers.oneHundred.rawValue
        self.addChild(scoreLAbel)
        startNewLevel()
    }

    // MARK: - Private Properties
  private func random() -> CGFloat {
        CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }

    private func random(min: CGFloat, max: CGFloat) -> CGFloat {
        random() * (max - min) + min
    }
    private func addScore() {
        gameModel.score += Int(DoubleNumbers.one.rawValue)
        scoreLAbel.text = "Score: \(gameModel.score)"
        UserDefaults.standard.set(gameModel.score, forKey: NodesName.score.rawValue)
    }

    private func runGameOver() {
        currentGameState = GameState.afterGame
        self.removeAllActions()
        self.enumerateChildNodes(withName: NodesName.enemy.rawValue) { enemy, stop in
            enemy.removeAllActions()
        }
        let changeSceneAction = SKAction.run(changeScene)
        let waitToChange = SKAction.wait(forDuration: DoubleNumbers.zeroPointFive.rawValue  )
        let changeSceneSequence = SKAction.sequence([waitToChange, changeSceneAction])
        self.run(changeSceneSequence)
        
    }

    private func changeScene() {
        let sceneToMoveTo = GameOverScene(size: self.size)
        sceneToMoveTo.scaleMode = self.scaleMode
        let transition = SKTransition.fade(withDuration: DoubleNumbers.zeroPointFive.rawValue)
        self.view?.presentScene(sceneToMoveTo)

    }

    private func fireBullet() {
        let bullet = SKSpriteNode(imageNamed: gameModel.bullet)
        bullet.setScale(DoubleNumbers.zeroPointTwo.rawValue)
        bullet.position = player.position
        bullet.zPosition = DoubleNumbers.one.rawValue
        bullet.physicsBody = SKPhysicsBody(rectangleOf: bullet.size)
        bullet.physicsBody!.affectedByGravity = false
        bullet.physicsBody?.categoryBitMask = PhysicCategories.Bullet
        bullet.physicsBody?.collisionBitMask = PhysicCategories.None
        bullet.physicsBody?.contactTestBitMask = PhysicCategories.Enemy
        self.addChild(bullet)

        let  moveBullet = SKAction.moveTo(y: self.size.height + bullet.size.height, duration: DoubleNumbers.one.rawValue)
        let deleteBullet = SKAction.removeFromParent()
        let bulletSequence = SKAction.sequence([bulletSound, moveBullet, deleteBullet])
        bullet.run(bulletSequence)
    }

    // MARK: - functions for enemy
    private func addEnemy() {
        let enemy = SKSpriteNode(imageNamed: gameModel.enemy)
        enemy.name = NodesName.enemy.rawValue

        let randomXStart = random(min: CGRectGetMinX(gameArea), max: CGRectGetMaxX(gameArea))
        let randomXEnd = random(min: CGRectGetMinX(gameArea), max: CGRectGetMaxX(gameArea))

        let startPoint = CGPoint(x: randomXStart, y: self.size.height * DoubleNumbers.onePointTwo.rawValue)
        let endPoint = CGPoint(x: randomXEnd, y: -self.size.height * DoubleNumbers.zeroPointTwo.rawValue)

        enemy.setScale(DoubleNumbers.zeroPointFour.rawValue)
        enemy.position = startPoint
        enemy.zPosition = DoubleNumbers.two.rawValue
        enemy.physicsBody = SKPhysicsBody(rectangleOf: enemy.size)
        enemy.physicsBody?.affectedByGravity = false
        enemy.physicsBody?.categoryBitMask = PhysicCategories.Enemy
        enemy.physicsBody?.collisionBitMask = PhysicCategories.None
        enemy.physicsBody?.contactTestBitMask = PhysicCategories.Player | PhysicCategories.Bullet
        self.addChild(enemy)

        let moveEnemy = SKAction.move(to: endPoint, duration: UserDefaults.standard.double(forKey: gameModel.durationKey))
        let deleteEnemy = SKAction.removeFromParent()
        let enemySequence = SKAction.sequence([moveEnemy, deleteEnemy])

        if currentGameState == GameState.inGame {
            enemy.run(enemySequence)
        }

        let dx = endPoint.x - startPoint.x
        let dy = endPoint.y - startPoint.y
        let amountToRotate = atan2(dy, dx)
        enemy.zRotation = amountToRotate

    }

    override func update(_ currentTime: TimeInterval) {

        if lastUpdateTime == 0 {
            lastUpdateTime = currentTime
        }
        else {
            deltaFrameTime = currentTime - lastUpdateTime
            lastUpdateTime = currentTime
        }

        let amountToMoveBackground = amountToMovePerSecond * CGFloat(deltaFrameTime)
        self.enumerateChildNodes(withName: NodesName.background.rawValue) { background, stop in


            if self.currentGameState == GameState.inGame {
                background.position.y -= amountToMoveBackground
            }

            if background.position.y < -self.size.height {
                background.position.y += self.size.height*DoubleNumbers.two.rawValue
            }
        }

    }

    func startNewLevel() {
        let enemy = SKAction.run(addEnemy)
        let waitToEnemy = SKAction.wait(forDuration: DoubleNumbers.one.rawValue)
        let enemySequence = SKAction.sequence([enemy, waitToEnemy])
        let enemyEverySecond = SKAction.repeatForever(enemySequence)
        self.run(enemyEverySecond)
    }

    func didBegin(_ contact: SKPhysicsContact) {
        var body1 = SKPhysicsBody()
        var body2 = SKPhysicsBody()

        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            body1 = contact.bodyA
            body2 = contact.bodyB
        } else {
            body1 = contact.bodyB
            body2 = contact.bodyA
        }
        if body1.categoryBitMask == PhysicCategories.Player && body2.categoryBitMask == PhysicCategories.Enemy {
            //            if player has hit enemy

            if body1.node != nil {
                spawnExplosion(spawnPosition: body1.node!.position)
            }
            if body2.node != nil {
                spawnExplosion(spawnPosition: body2.node!.position)
            }
            body1.node?.removeFromParent()
            body2.node?.removeFromParent()

            runGameOver()
        }

        if body1.categoryBitMask == PhysicCategories.Bullet && body2.categoryBitMask == PhysicCategories.Enemy && body2.node!.position.y < self.size.height {
            // if bullet has hit enemy
            addScore()

            if body2.node != nil {
                spawnExplosion(spawnPosition: body2.node!.position)
            }

            body1.node?.removeFromParent()
            body2.node?.removeFromParent()
        }

    }

    private func spawnExplosion(spawnPosition: CGPoint) {
        let explosion = SKSpriteNode(imageNamed: gameModel.nameOfAttack)
        explosion.position = spawnPosition
        explosion.zPosition = DoubleNumbers.three.rawValue
        explosion.setScale(0)
        self.addChild(explosion)

        let scaleIn = SKAction.scale(to: DoubleNumbers.one.rawValue, duration: UserDefaults.standard.double(forKey: gameModel.durationKey))
        let fadeOut = SKAction.fadeOut(withDuration: UserDefaults.standard.double(forKey: gameModel.durationKey))
        let delete = SKAction.removeFromParent()
        let explosionSequence = SKAction.sequence([scaleIn, fadeOut, delete])
        explosion.run(explosionSequence)
    }

    // MARK: - touchesBegan
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard currentGameState == GameState.inGame else { return }
        for touch: AnyObject in touches {
            let location = touch.location(in: self)
            let node = self.atPoint(location)

            if (node.name == NodesName.left.rawValue) {
                // Implement your logic for left button touch here:
                player.position = CGPoint(x:player.position.x-DoubleNumbers.fifteen.rawValue, y:player.position.y)
            } else if (node.name == NodesName.right.rawValue) {
                // Implement your logic for right button touch here:
                player.position = CGPoint(x:player.position.x+DoubleNumbers.fifteen.rawValue, y:player.position.y)
            }
            if (node.name == NodesName.telescopicSign.rawValue) {
                fireBullet()

            }

            if player.position.x > CGRectGetMaxX(gameArea) - player.size.width/DoubleNumbers.two.rawValue {
                player.position.x = CGRectGetMaxX(gameArea) - player.size.width/DoubleNumbers.two.rawValue
            }
            if player.position.x < CGRectGetMinX(gameArea) + player.size.width/DoubleNumbers.two.rawValue{
                player.position.x = CGRectGetMinX(gameArea) + player.size.width/DoubleNumbers.two.rawValue
            }
        }
    }
}
