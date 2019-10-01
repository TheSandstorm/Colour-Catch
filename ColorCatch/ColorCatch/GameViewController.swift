//
//  GameViewController.swift
//  ColorCatch
//
//  Created by John Strange on 30/09/19.
//  Copyright © 2019 John Strange. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

//Game Controller class
//Loads the SKview and then loads the main menu
class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        UserDefaults.standard.set(0, forKey: "Current Score") // Sets the current score to 0 at the start of the app
        //Creates and loads the menu scene
        if let skView = view as! SKView? {
            let skScene = MainMenu(size: skView.bounds.size)
            skScene.scaleMode = .aspectFill
            skView.presentScene(skScene)
            skView.ignoresSiblingOrder = true
            skView.showsFPS = true
            skView.showsNodeCount = true
        }
    }
}
