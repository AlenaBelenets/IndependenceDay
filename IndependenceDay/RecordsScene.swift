//
//  RecordsScene.swift
//  IndependenceDay
//
//  Created by Alena Belenets on 21.09.2023.
//

import Foundation
import SpriteKit

class RecordScene: SKScene {

    private var gameModel = GameModel.getGameModel()

    lazy var firstHightScore = UserDefaults.standard.string(forKey: gameModel.keyForFirstRecord)
    lazy var secondHightScore = UserDefaults.standard.string(forKey: gameModel.keyForSecondRecord)
    lazy var thirdHightScore = UserDefaults.standard.string(forKey: gameModel.keyForThirdRecord)

    lazy var firstName = UserDefaults.standard.string(forKey: gameModel.firstNameKey)

    lazy var secondName = UserDefaults.standard.string(forKey: gameModel.secondNameKey)
    lazy var thirdName = UserDefaults.standard.string(forKey: gameModel.thirdNameKey)

    let backLabel = SKLabelNode(fontNamed: NodesNames.theBoltFont.rawValue)
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: gameModel.nameOfSky)
        background.position = CGPoint(x: self.size.width/DoubleNumbers.two.rawValue, y: self.size.height/DoubleNumbers.two.rawValue)
        background.zPosition = 0
        background.size = self.size
        self.addChild(background)

        let recordsLAbel = SKLabelNode(fontNamed: NodesNames.theBoltFont.rawValue)
        recordsLAbel.text = "Records: "
        recordsLAbel.fontSize = DoubleNumbers.oneHundredAndFifty.rawValue
        recordsLAbel.fontColor = SKColor.black
        recordsLAbel.position = CGPoint(x: self.size.width*DoubleNumbers.zeroPointFive.rawValue, y: self.size.height*DoubleNumbers.zeroPointEightFive.rawValue)
        recordsLAbel.zPosition = DoubleNumbers.one.rawValue
        self.addChild(recordsLAbel)

        let firstHightScoreLabel = SKLabelNode(fontNamed: NodesNames.theBoltFont.rawValue)
        if firstName != nil {
            firstHightScoreLabel.text = "\(firstName!) - \(firstHightScore!)"
        }
        firstHightScoreLabel.fontSize = DoubleNumbers.fifty.rawValue
        firstHightScoreLabel.fontColor = SKColor.black
        firstHightScoreLabel.position = CGPoint(x: self.size.width*DoubleNumbers.zeroPointFive.rawValue, y: self.size.height*DoubleNumbers.zeroPointSeven.rawValue)
        firstHightScoreLabel.zPosition = DoubleNumbers.one.rawValue
        self.addChild(firstHightScoreLabel)

        let secondHightScoreLabel = SKLabelNode(fontNamed: NodesNames.theBoltFont.rawValue)
        if secondName != nil {
            secondHightScoreLabel.text = "\(secondName!) - \(secondHightScore!)"
        }
        secondHightScoreLabel.fontSize = DoubleNumbers.fifty.rawValue
        secondHightScoreLabel.fontColor = SKColor.black
        secondHightScoreLabel.position = CGPoint(x: self.size.width*DoubleNumbers.zeroPointFive.rawValue, y: self.size.height*DoubleNumbers.zeroPointFive.rawValue)
        secondHightScoreLabel.zPosition = DoubleNumbers.one.rawValue
        self.addChild(secondHightScoreLabel)

        let thirdHightScoreLabel = SKLabelNode(fontNamed: NodesNames.theBoltFont.rawValue)
        if thirdName != nil {
            thirdHightScoreLabel.text = "\(thirdName!) - \(thirdHightScore!)"
        }
        thirdHightScoreLabel.fontSize = DoubleNumbers.fifty.rawValue
        thirdHightScoreLabel.fontColor = SKColor.black
        thirdHightScoreLabel.position = CGPoint(x: self.size.width*DoubleNumbers.zeroPointFive.rawValue, y: self.size.height*DoubleNumbers.zeroPointThree.rawValue)
        thirdHightScoreLabel.zPosition = DoubleNumbers.one.rawValue
        self.addChild(thirdHightScoreLabel)


        backLabel.text = NodesNames.back.rawValue
        backLabel.fontSize = DoubleNumbers.seventy.rawValue
        backLabel.fontColor = SKColor.black
        backLabel.position = CGPoint(x: self.size.width/DoubleNumbers.two.rawValue, y: self.size.height*DoubleNumbers.zeroPointOne.rawValue)
        backLabel.zPosition = DoubleNumbers.one.rawValue
        self.addChild(backLabel)
    }

override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    for touch: AnyObject in touches {

        let pointOfTouch = touch.location(in: self)

            if backLabel.contains(pointOfTouch) {
            let sceneMoveTo = MainMenuScene(size: self.size)
            sceneMoveTo.scaleMode = self.scaleMode
            let myTransition = SKTransition.fade(withDuration: DoubleNumbers.zeroPointFive.rawValue)
            self.view?.presentScene(sceneMoveTo, transition: myTransition)
        }
    }
}
}
