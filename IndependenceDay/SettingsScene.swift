//
//  SettingsScene.swift
//  IndependenceDay
//
//  Created by Alena Belenets on 21.09.2023.
//

import Foundation
import SpriteKit


protocol Alertable { }
extension Alertable where Self: SKScene {

    func showAlert(withTitle title: String, message: String) {

        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)

        let okAction = UIAlertAction(title: "OK", style: .cancel) { action in
            if let textField = alertController.textFields?[0], let text = textField.text {
                UserDefaults.standard.set(text, forKey: "Name")
            }

        }


            alertController.addAction(okAction)

            alertController.addTextField { (textField)  in
                textField.placeholder = "Player"
            }

            view?.window?.rootViewController?.present(alertController, animated: true)
        }

    func showAlertWithSettings(withTitle title: String, message: String, text: UITextField) {

        let alertController = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)

//        let okAction = UIAlertAction(title: "OK", style: .default)
//        alertController.addAction(okAction)

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



class SettingsScene: SKScene, Alertable {

    let backLabel = SKLabelNode(fontNamed: "The Bolt Font")
    var gameModel = GameModel.getGameModel()
    lazy var doneNode = SKSpriteNode(imageNamed: gameModel.done)
    let nameLabel = SKLabelNode(fontNamed: "The Bolt Font")
    lazy var durationLabel = SKLabelNode(fontNamed: "The Bolt Font")

    lazy var changeDuration = gameModel.duration


    var alert = UIAlertController(title: "Some Title", message: "Enter a text", preferredStyle: .alert)

//    private lazy var textField: UITextField = {
//           let textField = UITextField()
//           textField.frame.size = CGSize(width: 100, height: 30)
//           textField.backgroundColor = .cyan
//           return textField
//       }()


    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "sky")
        background.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        background.zPosition = 0
        background.size = self.size
        self.addChild(background)



        let settingsLAbel = SKLabelNode(fontNamed: "The Bold Font")
        settingsLAbel.text = "Settings:"
        settingsLAbel.fontSize = 100
        settingsLAbel.fontColor = SKColor.black
        settingsLAbel.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.85)
        settingsLAbel.zPosition = 1
        self.addChild(settingsLAbel)

        let aiplaineLAbel = SKLabelNode(fontNamed: "The Bold Font")
        aiplaineLAbel.text = "Choose your airplane:"
        aiplaineLAbel.fontSize = 70
        aiplaineLAbel.fontColor = SKColor.black
        aiplaineLAbel.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.79)
        aiplaineLAbel.zPosition = 1
        self.addChild(aiplaineLAbel)

        backLabel.text = "Back"
        backLabel.fontSize = 70
        backLabel.fontColor = SKColor.black
        backLabel.position = CGPoint(x: self.size.width/2, y: self.size.height*0.1)
        backLabel.zPosition = 1
        self.addChild(backLabel)

        let changeDurationLabel = SKLabelNode(fontNamed: "The Bolt Font")
        changeDurationLabel.text = "Change duration:"
        changeDurationLabel.fontSize = 70
        changeDurationLabel.fontColor = SKColor.black
        changeDurationLabel.position = CGPoint(x: self.size.width/2, y: self.size.height*0.4)
        changeDurationLabel.zPosition = 1
        self.addChild(changeDurationLabel)

        var duration = UserDefaults.standard.string(forKey: "Duration") ?? String(gameModel.duration)

        durationLabel.text = "\(duration)"
        durationLabel.fontSize = 70
        durationLabel.fontColor = SKColor.black
        durationLabel.position = CGPoint(x: self.size.width/2, y: self.size.height*0.33)
        durationLabel.zPosition = 1
        self.addChild(durationLabel)

        let airplaine1 = SKSpriteNode(imageNamed: "airplane1")
        airplaine1.setScale(1.8)
        airplaine1.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.7)
        airplaine1.zPosition = 2
        airplaine1.name = "airplane1"
        self.addChild(airplaine1)

        let airplaine2 = SKSpriteNode(imageNamed: "airplane2")
        airplaine2.setScale(1.3)
        airplaine2.position = CGPoint(x: self.size.width/3.2, y: self.size.height*0.7)
        airplaine2.zPosition = 2
        airplaine2.name = "airplane2"
        self.addChild(airplaine2)

        let airplaine3 = SKSpriteNode(imageNamed: "airplane3")
        airplaine3.setScale(1.8)
        airplaine3.position = CGPoint(x: self.size.width/1.5, y: self.size.height*0.7)
        airplaine3.zPosition = 2
        airplaine3.name = "airplane3"
        self.addChild(airplaine3)



        alert.addTextField(configurationHandler: { (textField) -> Void in
            textField.text = "Some default text."
        })
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [self] (action) -> Void in
            let textField = alert.textFields![0] as UITextField
            print("Text field: \(String(describing: textField.text))")
        }))

        let playerName = UserDefaults.standard.string(forKey: "Name") ?? "Player"
        nameLabel.text = "Tap to change name- \(playerName)"
        nameLabel.fontSize = 65
        nameLabel.fontColor = SKColor.black
        nameLabel.position = CGPoint(x: self.size.width/2, y: self.size.height*0.55)
        nameLabel.zPosition = 1
        nameLabel.name = "NameLabel"
        self.addChild(nameLabel)

        doneNode.setScale(1)
        doneNode.zPosition = 3
        self.addChild(doneNode)

        let leftImage = SKSpriteNode(imageNamed: gameModel.leftButton)
        leftImage.setScale(0.4)
        leftImage.position = CGPoint(x: self.size.width/3.2, y: self.size.height*0.3)
        leftImage.zPosition = 2
        leftImage.name = "left"
        self.addChild(leftImage)

        let rightImage = SKSpriteNode(imageNamed: gameModel.rightButton)
        rightImage.setScale(0.4)
        rightImage.position = CGPoint(x: self.size.width/1.5, y: self.size.height*0.3)
        rightImage.zPosition = 2
        rightImage.name = "right"
        self.addChild(rightImage)


    }


override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

   



    for touch: AnyObject in touches {

        let location = touch.location(in: self)
        let node = self.atPoint(location)

                if (node.name == Airplanes.airplane1.rawValue) {
//                    gameModel.airplane = Airplanes.airplane1.rawValue
                    UserDefaults.standard.set(Airplanes.airplane1.rawValue, forKey: "AirplaineKey")
                    doneNode.position = node.position
                    
                } else if (node.name == Airplanes.airplane2.rawValue) {
//                    gameModel.airplane = Airplanes.airplane2.rawValue
                    UserDefaults.standard.set(Airplanes.airplane2.rawValue, forKey: "AirplaineKey")
                    doneNode.position = node.position
                } else if (node.name == Airplanes.airplane3.rawValue) {
                    //                    gameModel.airplane = Airplanes.airplane3.rawValue
                    UserDefaults.standard.set(Airplanes.airplane3.rawValue, forKey: "AirplaineKey")
                    doneNode.position = node.position

                } else if (node.name == "NameLabel") {
                   showAlert(withTitle: "Hey!", message: "Enter your name")

                } else if (node.name == "left") {

                    changeDuration -= 0.1
                    durationLabel.text = String(changeDuration)
                    UserDefaults.standard.set(changeDuration, forKey: "Duration")

                }  else if (node.name == "right") {

                    changeDuration += 0.1
                    durationLabel.text = String(changeDuration)
                    UserDefaults.standard.set(changeDuration, forKey: "Duration")

                }
                else if backLabel.contains(location)      {
                    let sceneMoveTo = MainMenuScene(size: self.size)
                    sceneMoveTo.scaleMode = self.scaleMode
                    let myTransition = SKTransition.fade(withDuration: 0.5)
                    self.view?.presentScene(sceneMoveTo, transition: myTransition)

            }
        continue

        }
    }
}
