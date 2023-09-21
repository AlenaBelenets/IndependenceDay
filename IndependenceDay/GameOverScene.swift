//
//  GameOverScene.swift
//  IndependenceDay
//
//  Created by Alena Belenets on 19.09.2023.
//

import SpriteKit

class GameOverScene: SKScene {

    let restartLabel = SKLabelNode(fontNamed: "The Bolt Font")

    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "sky")
        background.size = self.size
        background.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        background.zPosition = 0
        self.addChild(background)

        let gameOverLAbel = SKLabelNode(fontNamed: "The Bold Font")
        gameOverLAbel.text = "Game Over"
        gameOverLAbel.fontSize = 150
        gameOverLAbel.fontColor = SKColor.black
        gameOverLAbel.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.7)
        gameOverLAbel.zPosition = 1
        self.addChild(gameOverLAbel)

        let scoresLabel = SKLabelNode(fontNamed: "The Bolt Font")
        scoresLabel.text = "Score: \(gameScore)"
        scoresLabel.fontSize = 90
        scoresLabel.fontColor = SKColor.black
        scoresLabel.position = CGPoint(x: self.size.width/2, y: self.size.height*0.55)
        scoresLabel.zPosition = 1
        self.addChild(scoresLabel)

        let defaults = UserDefaults()
        var hightScoreNumber = defaults.integer(forKey: "highScoreSaved")

        if gameScore > hightScoreNumber {
            hightScoreNumber = gameScore
            defaults.set(hightScoreNumber, forKey: "highScoreSaved")
        }

        let highScoreLabel = SKLabelNode(fontNamed: "The Bolt Font")
        highScoreLabel.text = "High Score: \(hightScoreNumber)"
        highScoreLabel.fontSize = 90
        highScoreLabel.fontColor = SKColor.black
        highScoreLabel.position = CGPoint(x: self.size.width/2, y: self.size.height*0.45)
        highScoreLabel.zPosition = 1
        self.addChild(highScoreLabel)

        restartLabel.text = "Restart"
        restartLabel.fontSize = 70
        restartLabel.fontColor = SKColor.black
        restartLabel.position = CGPoint(x: self.size.width/2, y: self.size.height*0.3)
        restartLabel.zPosition = 1
        self.addChild(restartLabel)

    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches {

            let pointOfTouch = touch.location(in: self)

            if restartLabel.contains(pointOfTouch) {
                let sceneMoveTo = GameScene(size: self.size)
                sceneMoveTo.scaleMode = self.scaleMode
                let myTransition = SKTransition.fade(withDuration: 0.5)
                self.view?.presentScene(sceneMoveTo, transition: myTransition)
            }
        }
    }
}
