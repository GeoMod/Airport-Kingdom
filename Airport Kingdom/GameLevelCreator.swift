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
    var level = 1
    
    func setUpBackground() {
        position = CGPoint(x: 512, y: 384)
        blendMode = .replace
        zPosition = -1
    }
    
    func setUpRunway() {
        name = "runway"
        anchorPoint = CGPoint(x: 0, y: 0)
        
        physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: size.width, height: size.height))
        physicsBody?.categoryBitMask = CollisionTypes.runwaysurface.rawValue
        physicsBody?.contactTestBitMask = CollisionTypes.airplane.rawValue
        physicsBody?.isDynamic = false
        
        switch level {
        case 1:
            position = CGPoint(x: 236, y: 180)
        case 2:
            position = CGPoint(x: 736, y: 180)
        default:
            position = CGPoint(x: 236, y: 180)
        }
        blendMode = .replace
        zPosition = 0
    }
    
    func setUpControlTower() {
        name = "tower"
        position = CGPoint(x: 512, y: 384)
        zPosition = 1
        physicsBody = SKPhysicsBody(texture: self.texture!, size: size)
//        physicsBody = SKPhysicsBody(circleOfRadius: size.width / 2)
        physicsBody?.categoryBitMask = CollisionTypes.tower.rawValue
        physicsBody?.contactTestBitMask = CollisionTypes.airplane.rawValue
        physicsBody?.collisionBitMask = 0
        blendMode = .alpha
    }
    
    
    // Idea for possibly combining methods for setup...
//    func setUpLevel(background: SKSpriteNode, runway: SKSpriteNode) {
//        background.position = CGPoint(x: 512, y: 384)
//        background.blendMode = .replace
//        background.zPosition = -1
//
//        runway.position = CGPoint(x: 236, y: 180)
//        runway.anchorPoint = CGPoint(x: 0, y: 0)
//        runway.blendMode = .replace
//        runway.zPosition = 0
//        runway.name = "runway"
//
//    }
}

