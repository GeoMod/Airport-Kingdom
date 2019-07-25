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
    
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var livesLabel: UILabel!
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var tapToStartButtonLabel: UIButton!
    
    var isGamePlaying = false
    
    var currentGame: GameScene!
    var levelCreator: GameLevelCreator!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        playPauseButton.isHidden = true
        playPauseButton.alpha = 0.8
        playPauseButton.tintColor = .white
        
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
    
    
    @IBAction func tapToStartButton(_ sender: UIButton) {
        currentGame.addChild(currentGame.airplane)
        playPauseButton.setBackgroundImage(UIImage(systemName: "pause.circle.fill"), for: .normal)
//        isStartOfLevel = false
        isGamePlaying = true
        playPauseButton.isHidden = false
        tapToStartButtonLabel.isHidden = true
        currentGame.motionManager.startAccelerometerUpdates()
    }
    
    @IBAction func playPauseButtonTapped(_ sender: UIButton) {
        switch isGamePlaying {
        case false:
            // Game is paused.
            playPauseButton.setBackgroundImage(UIImage(systemName: "pause.circle.fill"), for: .normal)
            isGamePlaying.toggle()
            // stop aircraft movement
            // freeze aircraft position
//            currentGame.airplane.position = currentGame.airplane.position
            // stop timer
        case true:
            playPauseButton.setBackgroundImage(UIImage(systemName: "play.circle.fill"), for: .normal)
            isGamePlaying.toggle()
            // start aircraft movement
        }
    }
    

    override var shouldAutorotate: Bool {
        return true
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
