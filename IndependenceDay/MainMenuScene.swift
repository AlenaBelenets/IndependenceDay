//
//  MainMenuScene.swift
//  IndependenceDay
//
//  Created by Alena Belenets on 21.09.2023.
//

import Foundation
import SpriteKit

class MainMenuScene: SKScene {
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "sky")
        background.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        background.zPosition = 0
        background.size = self.size
        self.addChild(background)

        let gameBy = SKLabelNode(fontNamed: "The Bolt Font")
        gameBy.text = "Independence Day Game"
        gameBy.fontSize = 50
        gameBy.fontColor = SKColor.white
        gameBy.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.8)
        gameBy.zPosition = 1
        self.addChild(gameBy)

        let gameName1 = SKLabelNode(fontNamed: "The Bolt Font")
        gameName1.text = "Settings"
        gameName1.fontSize = 130
        gameName1.fontColor = SKColor.black
        gameName1.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.7)
        gameName1.zPosition = 1
        gameName1.name = "settingsButton"
        self.addChild(gameName1)

        let gameName2 = SKLabelNode(fontNamed: "The Bolt Font")
        gameName2.text = "Records"
        gameName2.fontSize = 130
        gameName2.fontColor = SKColor.black
        gameName2.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.55)
        gameName2.zPosition = 1
        gameName2.name = "recordsButton"
        self.addChild(gameName2)

        let startGame = SKLabelNode(fontNamed: "The Bolt Font")
        startGame.text = "Start Game"
        startGame.fontSize = 130
        startGame.fontColor = SKColor.black
        startGame.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.4)
        startGame.zPosition = 1
        startGame.name = "startButton"
        self.addChild(startGame)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

        for touch: AnyObject in touches {

            let pointOfTouch = touch.location(in: self)
            let nodeTapped = nodes(at: pointOfTouch)

            if nodeTapped.first?.name == "startButton" {
                let sceneToMove = GameScene(size: self.size)
                sceneToMove.scaleMode = self.scaleMode
                let myTransition = SKTransition.fade(withDuration: 0.5)
                self.view?.presentScene(sceneToMove, transition: myTransition)
            }
            if nodeTapped.first?.name == "recordsButton" {
                let sceneToMove = RecordScene(size: self.size)
                sceneToMove.scaleMode = self.scaleMode
                let myTransition = SKTransition.fade(withDuration: 0.5)
                self.view?.presentScene(sceneToMove, transition: myTransition)
            }
        if nodeTapped.first?.name == "settingsButton" {
            let sceneToMove = SettingsScene(size: self.size)
            sceneToMove.scaleMode = self.scaleMode
            let myTransition = SKTransition.fade(withDuration: 0.5)
            self.view?.presentScene(sceneToMove, transition: myTransition)
        }



        }
    }
}
