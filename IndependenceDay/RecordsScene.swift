//
//  RecordsScene.swift
//  IndependenceDay
//
//  Created by Alena Belenets on 21.09.2023.
//

import Foundation
import SpriteKit

class RecordScene: SKScene {
    let backLabel = SKLabelNode(fontNamed: "The Bolt Font")
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "sky")
        background.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        background.zPosition = 0
        background.size = self.size
        self.addChild(background)

        let recordsLAbel = SKLabelNode(fontNamed: "The Bold Font")
        recordsLAbel.text = "Records:"
        recordsLAbel.fontSize = 150
        recordsLAbel.fontColor = SKColor.black
        recordsLAbel.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.85)
        recordsLAbel.zPosition = 1
        self.addChild(recordsLAbel)

        backLabel.text = "Back"
        backLabel.fontSize = 70
        backLabel.fontColor = SKColor.black
        backLabel.position = CGPoint(x: self.size.width/2, y: self.size.height*0.1)
        backLabel.zPosition = 1
        self.addChild(backLabel)
    }

override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    for touch: AnyObject in touches {

        let pointOfTouch = touch.location(in: self)

            if backLabel.contains(pointOfTouch) {
            let sceneMoveTo = MainMenuScene(size: self.size)
            sceneMoveTo.scaleMode = self.scaleMode
            let myTransition = SKTransition.fade(withDuration: 0.5)
            self.view?.presentScene(sceneMoveTo, transition: myTransition)
        }
    }
}
}
