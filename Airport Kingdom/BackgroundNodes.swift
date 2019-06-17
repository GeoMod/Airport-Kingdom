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
    
    func setUpAirportEnvironment() {
        anchorPoint = CGPoint(x: 0, y: 0)
        position = CGPoint(x: 236, y: 180)
        blendMode = .replace
        zPosition = 0
    }

}

