//
//  ScoreBoard.swift
//  Airport Kingdom
//
//  Created by Daniel O'Leary on 7/31/19.
//  Copyright © 2019 Impulse Coupled Dev. All rights reserved.
//

//import Foundation

protocol AdjustScore {
    func update(score: Int)
}

class Player: AdjustScore {
    var currentLevel = 1
    var lives = 3
    var score = 0
    var name: String?
    
    let vc = GameViewController()
    
    func update(score: Int) {
        // Update score count and score label.
        vc.scoreLabel.text = "Score: \(score)"
    }
}

