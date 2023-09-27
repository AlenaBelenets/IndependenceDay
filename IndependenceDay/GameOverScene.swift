//
//  GameOverScene.swift
//  IndependenceDay
//
//  Created by Alena Belenets on 19.09.2023.
//

import SpriteKit

class GameOverScene: SKScene {

    private var gameModel = GameModel.getGameModel()


    let defaults = UserDefaults()
    lazy var gamerName = defaults.string(forKey: gameModel.firstNameKey)
    lazy var hightScoreNumber = defaults.integer(forKey: gameModel.keyHightScore)
    lazy var score = defaults.integer(forKey: NodesName.score.rawValue)

    lazy var firstHightScore = defaults.integer(forKey: gameModel.keyForFirstRecord)
    lazy var secondHightScore = defaults.integer(forKey: gameModel.keyForSecondRecord)
    lazy var thirdHightScore = defaults.integer(forKey: gameModel.keyForThirdRecord)


    let restartLabel = SKLabelNode(fontNamed: NodesNames.theBoltFont.rawValue)

    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: gameModel.nameOfSky)
        background.size = self.size
        background.position = CGPoint(x: self.size.width/DoubleNumbers.two.rawValue, y: self.size.height/DoubleNumbers.two.rawValue)
        background.zPosition = 0
        self.addChild(background)

        let gameOverLAbel = SKLabelNode(fontNamed: NodesNames.theBoltFont.rawValue)
        gameOverLAbel.text = NodesNames.gameOver.rawValue
        gameOverLAbel.fontSize = DoubleNumbers.oneHundredAndFifty.rawValue
        gameOverLAbel.fontColor = SKColor.black
        gameOverLAbel.position = CGPoint(x: self.size.width*DoubleNumbers.zeroPointFive.rawValue, y: self.size.height*DoubleNumbers.zeroPointSeven.rawValue)
        gameOverLAbel.zPosition = DoubleNumbers.one.rawValue
        self.addChild(gameOverLAbel)

        let scoresLabel = SKLabelNode(fontNamed: NodesNames.theBoltFont.rawValue)
        scoresLabel.text = "Score: \(score)"
        scoresLabel.fontSize = DoubleNumbers.ninety.rawValue
        scoresLabel.fontColor = SKColor.black
        scoresLabel.position = CGPoint(x: self.size.width/DoubleNumbers.two.rawValue, y: self.size.height*DoubleNumbers.zeroPointFour.rawValue)
        scoresLabel.zPosition = DoubleNumbers.one.rawValue
        self.addChild(scoresLabel)

        defaults.set(firstHightScore, forKey: gameModel.keyForFirstRecord)
        defaults.set(secondHightScore, forKey: gameModel.keyForSecondRecord)
        defaults.set(thirdHightScore, forKey: gameModel.keyForThirdRecord)


        if score > hightScoreNumber {
            hightScoreNumber = score
            defaults.set(hightScoreNumber, forKey: gameModel.keyHightScore)
            defaults.set(hightScoreNumber, forKey: gameModel.keyForFirstRecord)
            defaults.set(gamerName, forKey: gameModel.firstNameKey)

        } else if secondHightScore >= hightScoreNumber {
            defaults.set(gameModel.score, forKey: gameModel.keyForSecondRecord)
            defaults.set(gamerName, forKey: gameModel.secondNameKey)
        } else  if thirdHightScore >= hightScoreNumber {
            defaults.set(gameModel.score, forKey: gameModel.keyForThirdRecord)
            defaults.set(gamerName, forKey: gameModel.thirdNameKey)
        }

        let highScoreLabel = SKLabelNode(fontNamed: NodesNames.theBoltFont.rawValue)
        highScoreLabel.text = "High Score: \(hightScoreNumber)"
        highScoreLabel.fontSize = DoubleNumbers.ninety.rawValue
        highScoreLabel.fontColor = SKColor.black
        highScoreLabel.position = CGPoint(x: self.size.width/DoubleNumbers.two.rawValue, y: self.size.height*DoubleNumbers.zeroPointFive.rawValue)
        highScoreLabel.zPosition = DoubleNumbers.one.rawValue
        self.addChild(highScoreLabel)

        restartLabel.text = NodesNames.restart.rawValue
        restartLabel.fontSize = DoubleNumbers.seventy.rawValue
        restartLabel.fontColor = SKColor.black
        restartLabel.position = CGPoint(x: self.size.width/DoubleNumbers.two.rawValue, y: self.size.height*DoubleNumbers.zeroPointThree.rawValue)
        restartLabel.zPosition = DoubleNumbers.one.rawValue
        self.addChild(restartLabel)

    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches {

            let pointOfTouch = touch.location(in: self)

            if restartLabel.contains(pointOfTouch) {
                let sceneMoveTo = GameScene(size: self.size)
                sceneMoveTo.scaleMode = self.scaleMode
                let myTransition = SKTransition.fade(withDuration: DoubleNumbers.zeroPointFive.rawValue)
                self.view?.presentScene(sceneMoveTo, transition: myTransition)
            }
        }
    }
}
