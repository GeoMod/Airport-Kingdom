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
//    var levelCreator: GameLevelCreator!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        playPauseButton.isHidden = true
        playPauseButton.alpha = 0.7
        playPauseButton.tintColor = .white
        
        tapToStartButtonLabel.setTitle("Tap To Start", for: .normal)
        
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
    
    override func viewWillAppear(_ animated: Bool) {
        // Consider code here for use in level transitions.
    }
    
    
    @IBAction func tapToStartButton(_ sender: UIButton) {
        beginGamePlay()
    }
    
    @IBAction func playPauseButtonTapped(_ sender: UIButton) {
        switch isGamePlaying {
        case false:
            // Game is paused but we want to start/resume the game.
            beginGamePlay()
        case true:
            // Game is running but we want to pause.
            playPauseButton.setBackgroundImage(UIImage(systemName: "play.circle.fill"), for: .normal)
            tapToStartButtonLabel.setTitle("Paused", for: .normal)
            tapToStartButtonLabel.isHidden = false
            view.alpha = 0.5
            currentGame.airplane.removeFromParent()
            currentGame.airplane.position = currentGame.playerLastKnownPosition
            currentGame.motionManager.stopAccelerometerUpdates()
            // stop timer
            isGamePlaying.toggle()
        }
    }
    
    func beginGamePlay() {
        playPauseButton.setBackgroundImage(UIImage(systemName: "pause.circle.fill"), for: .normal)
        playPauseButton.isHidden = false
        
        tapToStartButtonLabel.isHidden = true
        tapToStartButtonLabel.setTitle("Paused", for: .normal)
        view.alpha = 1.0
        currentGame.loadAirplane(at: currentGame.playerLastKnownPosition, addToScene: true)
        currentGame.motionManager.startAccelerometerUpdates()
        isGamePlaying.toggle()
    }
    

    override var shouldAutorotate: Bool {
        return true
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
