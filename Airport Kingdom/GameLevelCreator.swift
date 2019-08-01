//
//  BackgroundNode.swift
//  Airport Kingdom
//
//  Created by Daniel O'Leary on 6/13/19.
//  Copyright © 2019 Impulse Coupled Dev. All rights reserved.
//

import UIKit
import SpriteKit

class GameLevelCreator: SKSpriteNode {
    
    weak var gameScene: GameScene!
    weak var viewController: GameViewController!
    
    func setUpBackground() {
        position = CGPoint(x: 512, y: 384)
        blendMode = .replace
        zPosition = -1
    }
    
//    func setUpControlTower() {
//        name = "tower"
//        position = CGPoint(x: 512, y: 384)
//        zPosition = 1
//        physicsBody = SKPhysicsBody(rectangleOf: size)
//        physicsBody?.categoryBitMask = CollisionTypes.tower.rawValue
//        physicsBody?.contactTestBitMask = CollisionTypes.airplane.rawValue
//        physicsBody?.isDynamic = false
//        blendMode = .alpha
//    }
    
}

