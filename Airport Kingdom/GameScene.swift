//
//  GameScene.swift
//  Airport Kingdom
//
//  Created by Daniel O'Leary on 5/12/19.
//  Copyright © 2019 Impulse Coupled Dev. All rights reserved.
//

import SpriteKit
import GameplayKit


class GameScene: SKScene, SKPhysicsContactDelegate {
    
    weak var viewController: GameViewController!
    
    let background = BackgroundNodes(imageNamed: "background")
    let runway = BackgroundNodes(imageNamed: "runway")
    let yokeBase = SKSpriteNode(imageNamed: "yokeBase")
    let yoke = SKSpriteNode(imageNamed: "yoke")
    let airplane = SKSpriteNode(imageNamed: "airplane")
    var direction = SIMD2<Float>(x: 0, y: 0)
    var directionAngle: CGFloat = 0.0 {
        didSet {
            if directionAngle != oldValue {
                // action that rotates the node to an angle in radian.
                let action = SKAction.rotate(toAngle: directionAngle, duration: 0.1, shortestUnitArc: true)
                run(action)
            }
        }
    }
    
    var didTouchYoke = false
    var touchDegrees = CGFloat(0)
    
    
    // hacking together some airplane initial positions.
    var posX: CGFloat = 256.0
    var posY: CGFloat = 256.0
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        setUpGameScene()
    }
    
    
    func setUpGameScene() {
        background.setUpBackground()
        addChild(background)
        
        runway.setUpAirportEnvironment()
        addChild(runway)
        
        // Yoke Base placement
        yokeBase.position.x = yokeBase.frame.size.width / 2 + 20
        yokeBase.position.y = yokeBase.frame.size.height / 2 + 20
        yokeBase.blendMode = .alpha
        yokeBase.zPosition = 0
        addChild(yokeBase)
        
        // Yoke handle placement
        yoke.position = yokeBase.position
        yoke.blendMode = .alpha
        yoke.zPosition = 0
        addChild(yoke)
        
        airplane.zRotation = rad2deg(-90.5)
        airplane.position = CGPoint(x: (runway.position.x + airplane.size.width) - 10, y: (runway.position.y + airplane.size.height) + 10)
        airplane.zPosition = 1
        
        // Circular physics body offers best performance at the cost of lower precision in collision accuracy.
        // https://developer.apple.com/documentation/spritekit/sknode/getting_started_with_physics_bodies
        airplane.physicsBody = SKPhysicsBody(circleOfRadius: max(airplane.size.width / 2, airplane.size.width / 2))
        airplane.physicsBody?.mass = 1.0
        
        
        airplane.physicsBody?.isDynamic = true
        addChild(airplane)
    }

    func virtualDPad() -> CGRect {
        var vDpad = CGRect(x: 0, y: 0, width: yokeBase.frame.width, height: yokeBase.frame.height)

        vDpad.origin.x = yokeBase.position.x - yokeBase.frame.size.width / 2
        vDpad.origin.y = yokeBase.position.y - yokeBase.frame.size.height / 2

        return vDpad
    }
    
    func apply(thrust: CGVector) {
        
        airplane.physicsBody?.applyForce(thrust)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // This introduces a problem where if the user is also touching the throttle quadrant at the same time both controls will be moved.
        for touch in touches {
            let location = touch.location(in: self)
            
            if yokeBase.frame.contains(location) {
                didTouchYoke = true
            } else {
                didTouchYoke = false
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if didTouchYoke {
            for touch in touches {
                let location = touch.location(in: self)
                let vector = CGVector(dx: location.x - yokeBase.position.x, dy: location.y - yokeBase.position.y)
                let angle = atan2(vector.dy, vector.dx)
                touchDegrees = angle * CGFloat(180 / Double.pi)
                
                let lengthFromBase = yokeBase.frame.size.height / 2
                
                let xDistance = sin(angle - 1.57079633) * lengthFromBase
                let yDistance = cos(angle - 1.57079633) * lengthFromBase
                
                if yokeBase.frame.contains(location) {
                    yoke.position = location
                } else {
                    yoke.position = CGPoint(x: yokeBase.position.x - xDistance, y: yokeBase.position.y + yDistance)
                }
                
                if virtualDPad().contains(location) {
                    let middleOfCircleX = virtualDPad().origin.x + 75
                    let middleOfCircleY = virtualDPad().origin.y + 75
                    let lengthOfX = Float(location.x - middleOfCircleX)
                    let lengthOfY = Float(location.y - middleOfCircleY)
                    direction = SIMD2<Float>(x: lengthOfX, y: lengthOfY)
                    direction = normalize(direction)
                    let degree = atan2(direction.x, direction.y)
                    directionAngle = -CGFloat(degree)
                }
                airplane.zRotation = directionAngle
                
                if let thrustSmoke = SKEmitterNode(fileNamed: "SmokeThrust") {
                    thrustSmoke.position = airplane.anchorPoint
                    airplane.addChild(thrustSmoke)
                }
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if didTouchYoke {
            let moveYokeToCenter = SKAction.move(to: yokeBase.position, duration: 0.1)
            moveYokeToCenter.timingMode = .easeOut
            yoke.run(moveYokeToCenter)
            didTouchYoke = false
        }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
    
    
}
