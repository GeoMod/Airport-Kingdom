//
//  GameScene.swift
//  Airport Kingdom
//
//  Created by Daniel O'Leary on 5/12/19.
//  Copyright © 2019 Impulse Coupled Dev. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    
    override func didMove(to view: SKView) {
        setUpGameScene()
    
    }
    
    
    func setUpGameScene() {
        let background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)
        
        let runway = SKSpriteNode(imageNamed: "runway")
        runway.anchorPoint = CGPoint(x: 0, y: 0)
        runway.position = CGPoint(x: 236, y: 180)
        runway.blendMode = .replace
        runway.zPosition = 0
        addChild(runway)
        
        let airplane = SKSpriteNode(imageNamed: "airplane")
        airplane.zRotation = rad2deg(-90)
        airplane.position = CGPoint(x: (runway.position.x + airplane.size.width) - 10, y: (runway.position.y + airplane.size.height) + 10)
        airplane.zPosition = 1
        addChild(airplane)
    }
    
    
    func rad2deg(_ number: Double) -> CGFloat {
        return CGFloat(number * 180 / .pi)
    }
    
    func touchDown(atPoint pos : CGPoint) {
        
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        
    }
    
    func touchUp(atPoint pos : CGPoint) {
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
