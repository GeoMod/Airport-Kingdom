//
//  GameViewController.swift
//  Airport Kingdom
//
//  Created by Daniel O'Leary on 5/12/19.
//  Copyright © 2019 Impulse Coupled Dev. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    
    var currentGame: GameScene!
    
    @IBOutlet weak var leftRightSlider: UISlider!
    var value: Float = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // load the default values for the sliders
        moveLeftAndRight(leftRightSlider)
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "GameScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                
                // Present the scene
                view.presentScene(scene)
                currentGame = scene as? GameScene
                currentGame.viewController = self
            }
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }
    
    
    @IBAction func moveLeftAndRight(_ sender: UISlider) {
        if currentGame != nil {
            currentGame.posX = CGFloat(sender.value)
//            currentGame.moveAirplane(posX: CGFloat(sender.value), posY: CGFloat(sender.value))
        }
    }
    
    @IBAction func moveUpDown(_ sender: UISlider) {
        if currentGame != nil {
            currentGame.posY = CGFloat(sender.value)
        }
    }
    
    

    override var shouldAutorotate: Bool {
        return true
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
