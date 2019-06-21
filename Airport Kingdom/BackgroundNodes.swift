//
//  BackgroundNode.swift
//  Airport Kingdom
//
//  Created by Daniel O'Leary on 6/13/19.
//  Copyright © 2019 Impulse Coupled Dev. All rights reserved.
//

import UIKit
import SpriteKit

class BackgroundNodes: SKSpriteNode {
    
    func setUpBackground() {
        position = CGPoint(x: 512, y: 384)
        blendMode = .replace
        zPosition = -1
    }
    
    func setUpRunway() {
        name = "runway"
        anchorPoint = CGPoint(x: 0, y: 0)
        position = CGPoint(x: 236, y: 180)
//        physicsBody = SKPhysicsBody(
        physicsBody?.categoryBitMask = CollisionTypes.runwayEdge.rawValue
        physicsBody?.contactTestBitMask = CollisionTypes.airplane.rawValue
        physicsBody?.collisionBitMask = 0
        blendMode = .replace
        zPosition = 0
    }
    
    func setUpControlTower() {
        name = "tower"
        position = CGPoint(x: 512, y: 384)
        zPosition = 1
        physicsBody = SKPhysicsBody(circleOfRadius: size.width / 2)
        physicsBody?.categoryBitMask = CollisionTypes.tower.rawValue
        physicsBody?.contactTestBitMask = CollisionTypes.airplane.rawValue
        physicsBody?.collisionBitMask = 0
        blendMode = .alpha
    }

}

