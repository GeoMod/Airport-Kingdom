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
        
        physicsBody = SKPhysicsBody(texture: texture!, size: size)
        physicsBody?.categoryBitMask = CollisionTypes.runwaysurface.rawValue
        physicsBody?.contactTestBitMask = CollisionTypes.airplane.rawValue
        physicsBody?.collisionBitMask = 0
        physicsBody?.isDynamic = false
        
        switch level {
        case 1:
            position = CGPoint(x: 300, y: 360)
        case 2:
            position = CGPoint(x: 736, y: 385)
        default:
            position = CGPoint(x: 300, y: 360)
        }
        blendMode = .alpha
        zPosition = 0
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

