//
//  GameViewController.swift
//  IndependenceDay
//
//  Created by Alena Belenets on 10.09.2023.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let scene = MainMenuScene(size: CGSize(width: 1536, height: 2048))

        let skView = self.view as! SKView
        skView.showsFPS = true
        skView.showsNodeCount = true

        skView.ignoresSiblingOrder = true

        scene.scaleMode = .aspectFill
        skView.presentScene(scene)

    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
