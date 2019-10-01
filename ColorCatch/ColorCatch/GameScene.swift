//
//  GameScene.swift
//  ColorCatch
//
//  Created by John Strange on 30/09/19.
//  Copyright © 2019 John Strange. All rights reserved.
//

import SpriteKit

//Game Scene
//Where the gameplay takes place and is shown

class GameScene: SKScene {
    //Creates all nesseary variables
    var ball = SKShapeNode(circleOfRadius: 15)
    var rightSide:SKShapeNode? // an object that takes up the right side of the screen space
    var leftSide:SKShapeNode? // an object that takes up the left side of the screen space
    let backToMain = SKShapeNode(rectOf: CGSize(width: 50, height: 50))
    let background = SKSpriteNode(imageNamed: "background")
    let colourWheel = SKSpriteNode(imageNamed: "ColourWheel")
    let scoreLabel = SKLabelNode()
    var ballDuration = 3.0
    var multiplyer = 1.0
    var score = 0
    let wheelSpeed = 0.2

    enum Color : CaseIterable
    {
        case RED
        case YELLOW
        case GREEN
        case BLUE
    }
    var currentColor = Color.RED // Starts always as red
    var ballColor = Color.allCases.randomElement()! // Starts with a random color
    
    override func didMove(to view: SKView)
    {
        //Setting the objects values
        UserDefaults.standard.set(score, forKey: "Current Score")
        leftSide = SKShapeNode(rectOf: CGSize(width: self.frame.midX, height: self.frame.maxY))
        rightSide = SKShapeNode(rectOf: CGSize(width: self.frame.midX, height: self.frame.maxY))
        SetSides()
        SetScoreLabel()
        SetColorWheel()
        SetBackToMain()
        self.backgroundColor = UIColor.gray
        SetBall()
        SetBackground()
        //Starts the game
        SetAction()
        }
    
    //Sets the background for the scene
    func SetBackground()
    {
        background.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        background.size = CGSize(width: self.frame.maxX, height: self.frame.maxY)
        background.zPosition = -2
        self.addChild(background)
    }
    //Setting the score label to show the score
    func SetScoreLabel()
    {
        scoreLabel.text = String(score)
        scoreLabel.fontSize = 64.0
        scoreLabel.fontName = "AvenieNext-Bold"
        scoreLabel.fontColor = UIColor.white
        scoreLabel.position = CGPoint(x: 32, y:self.frame.maxY - 100)
        self.addChild(scoreLabel)
    }
    //Checks if colour of the wheel is the same as the colour of the ball
    func CheckCurrentColour()
    {
        if(currentColor == ballColor)
        {
            let fadeAction = SKAction.fadeOut(withDuration: ballDuration / 4)
            let moveAction = SKAction.move(to: CGPoint(x: colourWheel.position.x, y: colourWheel.position.y), duration: ballDuration / 4);
            ball.run(SKAction.group([fadeAction, moveAction] ))
            {
                self.ResetBall()
            }
        }
        else
        {
            GameOver()
        }
    }
    //Ends the scene and moves it back to the main menu
    func GameOver()
    {
        let newScene = MainMenu(size: (self.view?.bounds.size)!)
        let transition = SKTransition.moveIn(with: .up, duration: 2)
        self.view?.presentScene(newScene, transition:  transition)
        transition.pausesOutgoingScene = true
        transition.pausesIncomingScene = false
    }
    //Starts the ball moving towards the wheel. When it arrives it does a check
    func SetAction()
    {
        ball.run(SKAction.move(to: CGPoint(x: colourWheel.position.x, y: colourWheel.position.y + 65), duration: ballDuration / multiplyer))
        {
            self.CheckCurrentColour()
        }
    }
    //Sets the ball
    func SetBall()
    {
        SetRandomBallColour(ballColor)
        ball.position = CGPoint(x: self.frame.midX, y: self.frame.height/1.2)
        self.addChild(ball)
    }
    // Sets the object sides of the screen
    func SetSides()
    {
        leftSide!.alpha = 0
        leftSide!.position = CGPoint(x: self.frame.midX/2, y: self.frame.midY)
        self.addChild(leftSide!)
        rightSide!.alpha = 0
        rightSide!.position = CGPoint(x: self.frame.midX + self.frame.midX / 2, y: self.frame.midY)
        self.addChild(rightSide!)
    }
    //An main
    func SetBackToMain()
    {
        backToMain.position = CGPoint(x: self.frame.maxX - 25, y: self.frame.maxY - 75)
        backToMain.fillColor = UIColor.white
        backToMain.lineWidth = 0
        backToMain.fillTexture = SKTexture(imageNamed: "MenuIcon")
        self.addChild(backToMain)
    }
    //Sets the Colour wheel position
    func SetColorWheel()
    {
        colourWheel.position = CGPoint(x: self.frame.midX, y: self.frame.midY/4)
        colourWheel.size = CGSize(width: 100, height: 100)
        colourWheel.zPosition = -1
        self.addChild(colourWheel)
    }
    // Resets the position of the ball and increments the score
    func ResetBall()
    {
        score += 1
        scoreLabel.text = String(score)
        UserDefaults.standard.set(score, forKey: "Current Score")
        if(score > UserDefaults.standard.integer(forKey: "High Score") )
        {
            UserDefaults.standard.set(score, forKey: "High Score")
        }
        //If the score is a multiple of 5 then increase the speed of everything.
        if(score.isMultiple(of: 5))
        {
            multiplyer = multiplyer + 0.5
        }
        ballColor = Color.allCases.randomElement()!
        ball.run(SKAction.fadeIn(withDuration: ballDuration / 12))
        SetRandomBallColour(ballColor)
        ball.position = CGPoint(x: self.frame.midX, y: self.frame.height/1.2)
        SetAction()
    }
    //Sets the colour of the ball based on the random value
    func SetRandomBallColour(_ _value: Color)
    {
        switch _value
        {
        case Color.RED:
            ball.fillColor = UIColor.red
        case Color.YELLOW:
            ball.fillColor = UIColor.yellow
        case Color.GREEN:
            ball.fillColor = UIColor.green
        case Color.BLUE:
            ball.fillColor = UIColor.blue
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let location = touches.first?.location(in: self)
        if backToMain.contains(location!){
            let newScene = MainMenu(size: (self.view?.bounds.size)!)
            let transition = SKTransition.moveIn(with: .up, duration: 2)
            self.view?.presentScene(newScene, transition:  transition)
            transition.pausesOutgoingScene = true
            transition.pausesIncomingScene = false
        }
            //In an else if cause right side overlaps the back to main area of space.
        else if leftSide!.contains(location!)
        {
            if colourWheel.hasActions() == false
            {
                //Rotate Left
                colourWheel.run(SKAction.rotate(byAngle: CGFloat((Float.pi * 45) / 180), duration: wheelSpeed / multiplyer))
                {
                    //Switches the colour once it hit 45 degrees of the image
                    switch self.currentColor
                    {
                    case .RED:
                        self.currentColor = Color.YELLOW
                    case .YELLOW:
                        self.currentColor = Color.GREEN
                    case .GREEN:
                        self.currentColor = Color.BLUE
                    case .BLUE:
                        self.currentColor = Color.RED
                    }
                    //finish the rotation
                    self.colourWheel.run(SKAction.rotate(byAngle: CGFloat((Float.pi * 45) / 180), duration: self.wheelSpeed / self.multiplyer))
                }
            }
        }
        else if rightSide!.contains(location!)
        {
            if colourWheel.hasActions() == false
            {
                //Rotate Right
                colourWheel.run(SKAction.rotate(byAngle: CGFloat((Float.pi * -45) / 180), duration: wheelSpeed / multiplyer))
                {
                    //Switches the colour once it hit 45 degrees of the image
                    switch self.currentColor
                    {
                    case .RED:
                        self.currentColor = Color.BLUE
                    case .YELLOW:
                        self.currentColor = Color.RED
                    case .GREEN:
                        self.currentColor = Color.YELLOW
                    case .BLUE:
                        self.currentColor = Color.GREEN
                    }
                    //Finish the rotation
                    self.colourWheel.run(SKAction.rotate(byAngle: CGFloat((Float.pi * -45) / 180), duration: self.wheelSpeed / self.multiplyer))
                }

            }
        }
    }
    
}

