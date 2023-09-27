//
//  SettingsScene.swift
//  IndependenceDay
//
//  Created by Alena Belenets on 21.09.2023.
//

import Foundation
import SpriteKit

// MARK: - Enum NodesName
  enum NodesNames: String {
    case back = "Back"
    case left = "left"
    case right = "right"
    case theBoltFont = "The Bolt Font"
    case player = "Player"
    case name = "Name"
    case airplane1 = "airplane1"
    case airplane2 = "airplane2"
    case airplane3 = "airplane3"
    case duration = "Duration"
    case nameLabel = "NameLabel"
    case gameOver = "Game Over"
    case restart = "Restart"
}

// MARK: - extension Alertable
protocol Alertable { }
extension Alertable where Self: SKScene {

    func showAlert(withTitle title: String, message: String) {

        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)

        let okAction = UIAlertAction(title: "OK", style: .cancel) { action in
            if let textField = alertController.textFields?[0], let text = textField.text {
                UserDefaults.standard.set(text, forKey: NodesNames.name.rawValue)
            }

        }


        alertController.addAction(okAction)

        alertController.addTextField { (textField)  in
            textField.placeholder = NodesNames.player.rawValue
        }

        view?.window?.rootViewController?.present(alertController, animated: true)
    }

    func showAlertWithSettings(withTitle title: String, message: String, text: UITextField) {

        let alertController = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)


        let settingsAction = UIAlertAction(title: "Enter Your Name", style: .default) { _ in

            guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }

        alertController.addAction(settingsAction)

        view?.window?.rootViewController?.present(alertController, animated: true)
    }
}

// MARK: - class SettingsScene
class SettingsScene: SKScene, Alertable {

    var gameModel = GameModel.getGameModel()
    let backLabel = SKLabelNode(fontNamed: NodesNames.theBoltFont.rawValue)
    lazy var doneNode = SKSpriteNode(imageNamed: gameModel.done)
    let nameLabel = SKLabelNode(fontNamed: NodesNames.theBoltFont.rawValue)
    lazy var durationLabel = SKLabelNode(fontNamed: NodesNames.theBoltFont.rawValue)
    lazy var changeDuration = gameModel.duration

    var alert = UIAlertController(title: "Some Title", message: "Enter a text", preferredStyle: .alert)

    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: gameModel.nameOfSky)
        background.position = CGPoint(x: self.size.width/DoubleNumbers.two.rawValue, y: self.size.height/DoubleNumbers.two.rawValue)
        background.zPosition = 0
        background.size = self.size
        self.addChild(background)

        let settingsLAbel = SKLabelNode(fontNamed: NodesNames.theBoltFont.rawValue)
        settingsLAbel.text = "Settings:"
        settingsLAbel.fontSize = DoubleNumbers.oneHundred.rawValue
        settingsLAbel.fontColor = SKColor.black
        settingsLAbel.position = CGPoint(x: self.size.width*DoubleNumbers.zeroPointFive.rawValue, y: self.size.height*DoubleNumbers.zeroPointNine.rawValue)
        settingsLAbel.zPosition = DoubleNumbers.one.rawValue
        self.addChild(settingsLAbel)

        let airplaneLabel = SKLabelNode(fontNamed: NodesNames.theBoltFont.rawValue)
        airplaneLabel.text = "Choose your airplane:"
        airplaneLabel.fontSize = DoubleNumbers.seventy.rawValue
        airplaneLabel.fontColor = SKColor.black
        airplaneLabel.position = CGPoint(x: self.size.width*DoubleNumbers.zeroPointFive.rawValue, y: self.size.height*DoubleNumbers.zeroPointEightFive.rawValue)
        airplaneLabel.zPosition = DoubleNumbers.one.rawValue
        self.addChild(airplaneLabel)

        backLabel.text = NodesNames.back.rawValue
        backLabel.fontSize = DoubleNumbers.seventy.rawValue
        backLabel.fontColor = SKColor.black
        backLabel.position = CGPoint(x: self.size.width/DoubleNumbers.two.rawValue, y: self.size.height*DoubleNumbers.zeroPointOne.rawValue)
        backLabel.zPosition = DoubleNumbers.one.rawValue
        self.addChild(backLabel)

        let changeDurationLabel = SKLabelNode(fontNamed: NodesNames.theBoltFont.rawValue)
        changeDurationLabel.text = "Change duration:"
        changeDurationLabel.fontSize = DoubleNumbers.seventy.rawValue
        changeDurationLabel.fontColor = SKColor.black
        changeDurationLabel.position = CGPoint(x: self.size.width/DoubleNumbers.two.rawValue, y: self.size.height*DoubleNumbers.zeroPointFour.rawValue)
        changeDurationLabel.zPosition = DoubleNumbers.one.rawValue
        self.addChild(changeDurationLabel)

        var duration = UserDefaults.standard.string(forKey: NodesNames.duration.rawValue
        ) ?? String(gameModel.duration)

        durationLabel.text = "\(duration)"
        durationLabel.fontSize = DoubleNumbers.seventy.rawValue
        durationLabel.fontColor = SKColor.black
        durationLabel.position = CGPoint(x: self.size.width/DoubleNumbers.two.rawValue, y: self.size.height*DoubleNumbers.zeroPointThree.rawValue)
        durationLabel.zPosition = DoubleNumbers.one.rawValue
        self.addChild(durationLabel)

        let airplaneNodeOne = SKSpriteNode(imageNamed: NodesNames.airplane1.rawValue)
        airplaneNodeOne.setScale(DoubleNumbers.onePointEight.rawValue)
        airplaneNodeOne.position = CGPoint(x: self.size.width*DoubleNumbers.zeroPointFive.rawValue, y: self.size.height*DoubleNumbers.zeroPointSeven.rawValue)
        airplaneNodeOne.zPosition = DoubleNumbers.two.rawValue
        airplaneNodeOne.name = NodesNames.airplane1.rawValue
        self.addChild(airplaneNodeOne)

        let airplaneNodeTwo = SKSpriteNode(imageNamed: NodesNames.airplane2.rawValue)
        airplaneNodeTwo.setScale(DoubleNumbers.onePointThree.rawValue)
        airplaneNodeTwo.position = CGPoint(x: self.size.width/DoubleNumbers.three.rawValue, y: self.size.height*DoubleNumbers.zeroPointSeven.rawValue)
        airplaneNodeTwo.zPosition = DoubleNumbers.two.rawValue
        airplaneNodeTwo.name = NodesNames.airplane2.rawValue
        self.addChild(airplaneNodeTwo)

        let airplaneNodeThree = SKSpriteNode(imageNamed: NodesNames.airplane3.rawValue)
        airplaneNodeThree.setScale(DoubleNumbers.two.rawValue)
        airplaneNodeThree.position = CGPoint(x: self.size.width/DoubleNumbers.onePointFive.rawValue, y: self.size.height*DoubleNumbers.zeroPointSeven.rawValue)
        airplaneNodeThree.zPosition = DoubleNumbers.two.rawValue
        airplaneNodeThree.name = NodesNames.airplane3.rawValue
        self.addChild(airplaneNodeThree)

        let playerName = UserDefaults.standard.string(forKey: NodesNames.name.rawValue) ?? NodesNames.player.rawValue
        nameLabel.text = "Tap to change name- \(playerName)"
        nameLabel.fontSize = DoubleNumbers.seventy.rawValue
        nameLabel.fontColor = SKColor.black
        nameLabel.position = CGPoint(x: self.size.width/DoubleNumbers.two.rawValue, y: self.size.height*DoubleNumbers.zeroPointFive.rawValue)
        nameLabel.zPosition = DoubleNumbers.one.rawValue
        nameLabel.name = NodesNames.nameLabel.rawValue
        self.addChild(nameLabel)

        doneNode.setScale(DoubleNumbers.one.rawValue)
        doneNode.zPosition = DoubleNumbers.three.rawValue
        self.addChild(doneNode)

        let leftImage = SKSpriteNode(imageNamed: gameModel.leftButton)
        leftImage.setScale(DoubleNumbers.zeroPointFour.rawValue)
        leftImage.position = CGPoint(x: self.size.width/DoubleNumbers.three.rawValue, y: self.size.height*DoubleNumbers.zeroPointThree.rawValue)
        leftImage.zPosition = DoubleNumbers.two.rawValue
        leftImage.name = NodesName.left.rawValue
        self.addChild(leftImage)

        let rightImage = SKSpriteNode(imageNamed: gameModel.rightButton)
        rightImage.setScale(DoubleNumbers.zeroPointFour.rawValue)
        rightImage.position = CGPoint(x: self.size.width/DoubleNumbers.onePointFive.rawValue, y: self.size.height*DoubleNumbers.zeroPointThree.rawValue)
        rightImage.zPosition = DoubleNumbers.two.rawValue
        rightImage.name = NodesName.right.rawValue
        self.addChild(rightImage)

    }


    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

        for touch: AnyObject in touches {

            let location = touch.location(in: self)
            let node = self.atPoint(location)

            if (node.name == Airplanes.airplane1.rawValue) {
                UserDefaults.standard.set(Airplanes.airplane1.rawValue, forKey: gameModel.keyForAirplane)
                doneNode.position = node.position

            } else if (node.name == Airplanes.airplane2.rawValue) {
                UserDefaults.standard.set(Airplanes.airplane2.rawValue, forKey: gameModel.keyForAirplane)
                doneNode.position = node.position
            } else if (node.name == Airplanes.airplane3.rawValue) {
                //                    gameModel.airplane = Airplanes.airplane3.rawValue
                UserDefaults.standard.set(Airplanes.airplane3.rawValue, forKey: gameModel.keyForAirplane)
                doneNode.position = node.position

            } else if (node.name == NodesNames.nameLabel.rawValue) {
                showAlert(withTitle: "Hey!", message: "Enter your name")

            } else if (node.name == NodesName.left.rawValue) {

                changeDuration -= DoubleNumbers.zeroPointOne.rawValue
                durationLabel.text = String(changeDuration)
                UserDefaults.standard.set(changeDuration, forKey: NodesNames.duration.rawValue)

            }  else if (node.name == NodesName.right.rawValue) {

                changeDuration += DoubleNumbers.zeroPointOne.rawValue
                durationLabel.text = String(changeDuration)
                UserDefaults.standard.set(changeDuration, forKey: NodesNames.duration.rawValue)

            }
            else if backLabel.contains(location)      {
                let sceneMoveTo = MainMenuScene(size: self.size)
                sceneMoveTo.scaleMode = self.scaleMode
                let myTransition = SKTransition.fade(withDuration: DoubleNumbers.zeroPointFive.rawValue)
                self.view?.presentScene(sceneMoveTo, transition: myTransition)

            }

        }
    }
}
