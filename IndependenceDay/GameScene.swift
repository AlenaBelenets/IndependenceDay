//
//  GameScene.swift
//  IndependenceDay
//
//  Created by Alena Belenets on 10.09.2023.
//

import SpriteKit
import GameplayKit

var gameScore = 0
enum GameState {
    case preGame
    case inGame
    case afterGame
}

struct PhysicCategories {
    static let None: UInt32 = 0
    static let Player: UInt32 = 0b1 //1
    static let Bullet: UInt32 = 0b10 //2
    static let Enemy: UInt32 = 0b100 //4
}

class GameScene: SKScene, SKPhysicsContactDelegate {


    var currentGameState = GameState.inGame
    let scoreLAbel = SKLabelNode(fontNamed: "The Bold Font")



    // MARK: - Private properties
    private let player = SKSpriteNode(imageNamed: "airplane")
    private let bulletSound = SKAction.playSoundFileNamed("bulletSound.mp3", waitForCompletion: false)
    private let rightButton = SKSpriteNode(imageNamed: "right")
    private let leftButton = SKSpriteNode(imageNamed: "left")
    private let telescopicSign = SKSpriteNode(imageNamed: "telescopicSign")


    func random() -> CGFloat {
        CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    func random(min: CGFloat, max: CGFloat) -> CGFloat {
        random() * (max - min) + min
    }

    var gameArea: CGRect

    // MARK: - Initialisations
    override init(size: CGSize) {
        let maxAspectRatio: CGFloat = 16.0/9.0
        let playableWidth = size.height / maxAspectRatio
        let margin = (size.width - playableWidth) / 2
        gameArea = CGRect(x: margin, y: 0, width: playableWidth, height: size.height)
        super.init(size: size)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - didMove
    override func didMove(to view: SKView) {
        gameScore = 0

        self.physicsWorld.contactDelegate = self

        let background = SKSpriteNode(imageNamed: "sky")
        background.size = self.size
        background.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        background.zPosition = 0
        self.addChild(background)

        player.setScale(1.3)
        player.position = CGPoint(x: self.size.width/2, y: self.size.height * 0.2)
        player.zPosition = 2
        player.physicsBody = SKPhysicsBody(rectangleOf: player.size)
        player.physicsBody?.affectedByGravity = false
        player.physicsBody?.categoryBitMask = PhysicCategories.Player
        player.physicsBody?.collisionBitMask = PhysicCategories.None
        player.physicsBody?.contactTestBitMask = PhysicCategories.Enemy
        self.addChild(player)

        leftButton.name = "Left"
        rightButton.name = "Right"

        rightButton.setScale(0.7)
        rightButton.position = CGPoint(x: self.size.width/1.5, y: self.size.height * 0.1)
        rightButton.zPosition = 2
        self.addChild(rightButton)

        leftButton.setScale(0.7)
        leftButton.position = CGPoint(x: self.size.width/3, y: self.size.height * 0.1)
        leftButton.zPosition = 2
        self.addChild(leftButton)

        telescopicSign.setScale(0.3)
        telescopicSign.position = CGPoint(x: self.size.width/2, y: self.size.height * 0.1)
        telescopicSign.zPosition = 2
        telescopicSign.name = "telescopicSign"
        self.addChild(telescopicSign)


        scoreLAbel.text = "Score: 0"
        scoreLAbel.fontSize = 70
        scoreLAbel.fontColor = SKColor.black
        scoreLAbel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        scoreLAbel.position = CGPoint(x: self.size.width*0.2, y: self.size.height*0.9)
        scoreLAbel.zPosition = 100
        self.addChild(scoreLAbel)
        startNewLevel()



    }

    func addScore() {
        gameScore += 1
        scoreLAbel.text = "Score: \(gameScore)"
    }

    func runGameOver() {
        currentGameState = GameState.afterGame


        self.removeAllActions()
        self.enumerateChildNodes(withName: "Enemy") { enemy, stop in
            enemy.removeAllActions()
        }
        let changeSceneAction = SKAction.run(changeScene)
        let waitToChange = SKAction.wait(forDuration: 1)
        let changeSceneSequence = SKAction.sequence([waitToChange, changeSceneAction])
        self.run(changeSceneSequence)
        
    }

    func changeScene() {
        let sceneToMoveTo = GameOverScene(size: self.size)
        sceneToMoveTo.scaleMode = self.scaleMode
        let transition = SKTransition.fade(withDuration: 0.5)
        self.view?.presentScene(sceneToMoveTo)

    }

    func fireBullet() {
        let bullet = SKSpriteNode(imageNamed: "bullet")
        bullet.setScale(0.2)
        bullet.position = player.position
        bullet.zPosition = 1
        bullet.physicsBody = SKPhysicsBody(rectangleOf: bullet.size)
        bullet.physicsBody!.affectedByGravity = false
        bullet.physicsBody?.categoryBitMask = PhysicCategories.Bullet
        bullet.physicsBody?.collisionBitMask = PhysicCategories.None
        bullet.physicsBody?.contactTestBitMask = PhysicCategories.Enemy
        self.addChild(bullet)

        let  moveBullet = SKAction.moveTo(y: self.size.height + bullet.size.height, duration: 1)
        let deleteBullet = SKAction.removeFromParent()
        let bulletSequence = SKAction.sequence([bulletSound, moveBullet, deleteBullet])
        bullet.run(bulletSequence)
    }

    // MARK: - functions for enemy
    func addEnemy() {
        let enemy = SKSpriteNode(imageNamed: "enemy")
        enemy.name = "Enemy"

        let randomXStart = random(min: CGRectGetMinX(gameArea), max: CGRectGetMaxX(gameArea))
        let randomXEnd = random(min: CGRectGetMinX(gameArea), max: CGRectGetMaxX(gameArea))

        let startPoint = CGPoint(x: randomXStart, y: self.size.height * 1.2)
        let endPoint = CGPoint(x: randomXEnd, y: -self.size.height * 0.2)

        enemy.setScale(0.4)
        enemy.position = startPoint
        enemy.zPosition = 2
        enemy.physicsBody = SKPhysicsBody(rectangleOf: enemy.size)
        enemy.physicsBody?.affectedByGravity = false
        enemy.physicsBody?.categoryBitMask = PhysicCategories.Enemy
        enemy.physicsBody?.collisionBitMask = PhysicCategories.None
        enemy.physicsBody?.contactTestBitMask = PhysicCategories.Player | PhysicCategories.Bullet
        self.addChild(enemy)

        let moveEnemy = SKAction.move(to: endPoint, duration: 5)
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

    func startNewLevel() {
        let enemy = SKAction.run(addEnemy)
        let waitToEnemy = SKAction.wait(forDuration: 1)
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

    func spawnExplosion(spawnPosition: CGPoint) {
        let explosion = SKSpriteNode(imageNamed: "boom")
        explosion.position = spawnPosition
        explosion.zPosition = 3
        explosion.setScale(0)
        self.addChild(explosion)

        let scaleIn = SKAction.scale(to: 1, duration: 0.1)
        let fadeOut = SKAction.fadeOut(withDuration: 0.1)
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

            if (node.name == "Left") {
                // Implement your logic for left button touch here:
                player.position = CGPoint(x:player.position.x-15, y:player.position.y)
            } else if (node.name == "Right") {
                // Implement your logic for right button touch here:
                player.position = CGPoint(x:player.position.x+15, y:player.position.y)
            }
            if (node.name == "telescopicSign") {
                fireBullet()

            }

            if player.position.x > CGRectGetMaxX(gameArea) - player.size.width/2{
                player.position.x = CGRectGetMaxX(gameArea) - player.size.width/2
            }
            if player.position.x < CGRectGetMinX(gameArea) + player.size.width/2{
                player.position.x = CGRectGetMinX(gameArea) + player.size.width/2
            }
        }



    }
//    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
//        for touch: AnyObject in touches {
//            if currentGameState == GameState.inGame {
//
//            }
//        }
//    }
}
