//
//  MainMenu.swift
//  ColorCatch
//
//  Created by John Strange on 30/09/19.
//  Copyright © 2019 John Strange. All rights reserved.
//

//Main menu Scene

import SpriteKit

class MainMenu: SKScene{
    //Creating all labels and sprites in the scene.
    let start = SKLabelNode()
    let highScore = SKLabelNode()
    let currentScore = SKLabelNode()
    let titleLabel = SKLabelNode()
    let background = SKSpriteNode(imageNamed: "background")
    let logo = SKSpriteNode(imageNamed: "ColourWheel")
    var isStart = false
    
    override func didMove(to view: SKView)
    {
        //Setting the background color for the scene
        self.backgroundColor = UIColor.gray
        //Creates the Text's that will be used within the scene
        start.text = "Let's Start"
        start.fontSize = 64.0
        start.fontName = "AvenieNext-Bold"
        start.fontColor = UIColor.white
        start.position = CGPoint(x: self.frame.midX, y:self.frame.midY)
        addChild(start)
        
        highScore.text = "High Score: " + String(UserDefaults.standard.integer(forKey: "High Score") ) // Will replace with the score int
        highScore.fontSize = 50.0
        highScore.fontName = "AvenieNext-Bold"
        highScore.fontColor = UIColor.white
        highScore.position = CGPoint(x: self.frame.midX, y: self.frame.midY / 2)
        addChild(highScore)
        
        currentScore.text = "Current Score: " + String(UserDefaults.standard.integer(forKey: "Current Score") )// Will replace with the current score
        currentScore.fontSize = 50.0
        currentScore.fontName = "AvenieNext-Bold"
        currentScore.fontColor = UIColor.white
        currentScore.position = CGPoint(x: self.frame.midX, y: self.frame.midY / 3)
        addChild(currentScore)
        
        logo.position = CGPoint(x: self.frame.midX, y: self.frame.midY + self.frame.midY / 1.7)
        logo.size = CGSize(width: 150, height: 150)
        logo.zPosition = -1
        addChild(logo)
        
        titleLabel.numberOfLines = 0
        titleLabel.text = "Color\nCatch"
        titleLabel.fontSize = 32.0
        titleLabel.fontName = "AvemieNext-Bold"
        titleLabel.fontColor = UIColor.white
        titleLabel.position = CGPoint(x: self.frame.midX, y: self.frame.midY + self.frame.midY / 2)
        addChild(titleLabel)
        
        //Sets a background image to the scene
        SetBackground()
    }
    
    func SetBackground()
    {
        background.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        background.size = CGSize(width: self.frame.maxX, height: self.frame.maxY)
        background.zPosition = -2
        self.addChild(background)
    }
    //This function activates when a touch is detected on the screen
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let location = touches.first?.location(in: self)
        //If the start button is pressed then move to the game scene
        if start.contains(location!){
            let newScene = GameScene(size: (self.view?.bounds.size)!)
            let transition = SKTransition.moveIn(with: .down, duration: 2)
            self.view?.presentScene(newScene, transition:  transition)
            transition.pausesOutgoingScene = true
            transition.pausesIncomingScene = false
        }
    }
    //Updates every frame
    override func update(_ currentTime: TimeInterval) {
        //If it's not the start then set up the animation for the logo.
        if(!isStart)
        {
            isStart = true;
            let rotateLeft = SKAction.rotate(byAngle: CGFloat((Float.pi * -360) / 180), duration: 1)
            let wait = SKAction.wait(forDuration: 0.5)
            let rotateRight = SKAction.rotate(byAngle: CGFloat((Float.pi * 360) / 180), duration: 1)
            let logoAction = SKAction.sequence([rotateLeft, wait, rotateRight, wait])
            logo.run(SKAction.repeatForever(logoAction))
        }
    }
}
