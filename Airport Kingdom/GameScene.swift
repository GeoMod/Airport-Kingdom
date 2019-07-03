//
//  GameScene.swift
//  Airport Kingdom
//
//  Created by Daniel O'Leary on 5/12/19.
//  Copyright © 2019 Impulse Coupled Dev. All rights reserved.
//

import SpriteKit
import GameplayKit
import CoreMotion


class GameScene: SKScene, SKPhysicsContactDelegate {
    
    weak var viewController: GameViewController!
    var levelCreator = GameLevelCreator()
    
    var motionManager: CMMotionManager!
    
    let background = GameLevelCreator(imageNamed: "BackgroundLvl1")
    let runway = GameLevelCreator(imageNamed: "runway")
//    let tower = GameLevelCreator(imageNamed: "tower")
    let yokeBase = SKSpriteNode(imageNamed: "yokeBase")
    let yoke = SKSpriteNode(imageNamed: "yoke")
    let airplane = SKSpriteNode(imageNamed: "airplane")
    
    var airplaneAcceleration = CGVector(dx: 0, dy: 0)
    let maxPlayerSpeed: CGFloat = 200
    let maxPlayerAcceleration: CGFloat = 400
    var accelerometerX: UIAccelerationValue = 0
    var accelerometerY: UIAccelerationValue = 0
    var playerVelocity = CGVector(dx: 0, dy: 0)
    var lastUpdateTime: CFTimeInterval = 0
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
    var score = 0 {
        didSet {
            viewController.scoreLabel.text = "Score: \(score)"
        }
    }
    
    var lives = 3 {
        didSet {
            viewController.livesLabel.text = "Lives: \(lives)"
        }
    }
    
    var didTouchYoke = false
    var touchDegrees = CGFloat(0)
    
    // hacking together some airplane initial positions.
    var posX: CGFloat = 256.0
    var posY: CGFloat = 256.0
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        
//        setUpRunwayEdges()
        setUpGameScene()
        addAirplane()
        
        motionManager = CMMotionManager()
        motionManager.startAccelerometerUpdates()
    }
    
    func setUpGameScene() {
        background.setUpBackground()
        addChild(background)
        
        runway.setUpRunway()
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
        
    }
    
//    func setUpRunwayEdges() {
//        let leftRunwayEdgeNode = SKSpriteNode(imageNamed: "edge1")
//        let rightRunwayEdgeNode = SKSpriteNode(imageNamed: "edge2")
//        leftRunwayEdgeNode.name = "leftRunwayEdge"
//        rightRunwayEdgeNode.name = "rightRunwayEdge"
//
//        let trailingRunwayEdgePosition = CGPoint(x: runway.position.x + runway.size.width / 2, y: runway.position.y)
//        let leadingRunwayEdgePosition = CGPoint(x: runway.position.x - runway.size.width / 2, y: runway.position.y)
//
//        leftRunwayEdgeNode.physicsBody = SKPhysicsBody(texture: leftRunwayEdgeNode.texture!, size: leftRunwayEdgeNode.size)
//        leftRunwayEdgeNode.physicsBody?.categoryBitMask = CollisionTypes.runwayEdge.rawValue
//        leftRunwayEdgeNode.physicsBody?.contactTestBitMask = CollisionTypes.airplane.rawValue
//        leftRunwayEdgeNode.physicsBody?.isDynamic = false
//        leftRunwayEdgeNode.position = leadingRunwayEdgePosition
//        addChild(leftRunwayEdgeNode)
//
//        rightRunwayEdgeNode.physicsBody = SKPhysicsBody(texture: rightRunwayEdgeNode.texture!, size: rightRunwayEdgeNode.size)
//        rightRunwayEdgeNode.physicsBody?.categoryBitMask = CollisionTypes.runwayEdge.rawValue
//        rightRunwayEdgeNode.physicsBody?.contactTestBitMask = CollisionTypes.airplane.rawValue
//        rightRunwayEdgeNode.physicsBody?.isDynamic = false
//        rightRunwayEdgeNode.position = trailingRunwayEdgePosition
//        addChild(rightRunwayEdgeNode)
//    }
    
    func addAirplane() {
        // Circular physics body offers best performance at the cost of lower precision in collision accuracy.
        // https://developer.apple.com/documentation/spritekit/sknode/getting_started_with_physics_bodies
        airplane.physicsBody = SKPhysicsBody(circleOfRadius: airplane.size.width / 2)
        airplane.physicsBody?.categoryBitMask = CollisionTypes.airplane.rawValue
        airplane.physicsBody?.contactTestBitMask = CollisionTypes.runwaysurface.rawValue
        airplane.physicsBody?.collisionBitMask = 0
        airplane.physicsBody?.isDynamic = true
        airplane.physicsBody?.linearDamping = 0.5
        
        airplane.position = CGPoint(x: size.width / 2, y: size.height / 2)
        airplane.zPosition = 1
        
        addChild(airplane)
    }
    
    override func update(_ currentTime: TimeInterval) {
//        guard motionManager != nil else { return }
        // Called before each frame is rendered
        let deltaTime = max(1.0/30, currentTime - lastUpdateTime)
        lastUpdateTime = currentTime
        
        updatePlayerAccelerationFromMotionManager()
        updatePlayer(deltaTime)
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        guard let nodeA = contact.bodyA.node else { return }
        guard let nodeB = contact.bodyB.node else { return }
        
        if nodeA == airplane {
            playerCollided(with: nodeB)
        } else if nodeB == airplane {
            playerCollided(with: nodeA)
        }
    }
    
    func playerCollided(with node: SKNode) {
        if node.name == "runway" {
            // Consider making the number of points added = the number of seconds remaining on the timer
            score += 100
            levelCreator.level += 1
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                self.scene?.removeAllChildren()
                self.motionManager.stopAccelerometerUpdates()
                let nextLevel = GameScene(size: self.size)
                nextLevel.viewController = self.viewController
                self.viewController.currentGame = nextLevel
                
                let transition = SKTransition.doorway(withDuration: 1.5)
                self.view?.presentScene(nextLevel, transition: transition)
            }
            return
        }
        
        if node.name == "tower" {
            if let fireExplosion = SKEmitterNode(fileNamed: "TowerFireExplosion") {
                fireExplosion.position = airplane.position
                addChild(fireExplosion)
                score = 0
            }
        } else if node.name == "leftRunwayEdge" || node.name == "rightRunwayEdge" {
            if let groundImpact = SKEmitterNode(fileNamed: "GroundImpact") {
                groundImpact.position = airplane.position
                addChild(groundImpact)
                score = 0
            }
        }
        airplane.removeFromParent()
        if lives > 0 {
            lives -= 1
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.addAirplane()
            }
        } else {
            // END GAME/LEVEL
            // Need restart button. Restart from level 1, reset points to zero for current/last level.
        }
    }
    
    // MARK: - Player acceleration and Controller "d-pad"
    func updatePlayerAccelerationFromMotionManager() {
        guard let acceleration = motionManager.accelerometerData?.acceleration else { return }
        let filterFactor = 0.9
        
        accelerometerX = acceleration.x * filterFactor + accelerometerX * (1 - filterFactor)
        accelerometerY = acceleration.y * filterFactor + accelerometerY * (1 - filterFactor)
        
        airplaneAcceleration.dx = CGFloat(accelerometerY) * -maxPlayerAcceleration
        airplaneAcceleration.dy = CGFloat(accelerometerX) * maxPlayerAcceleration
    }

    func virtualDPad() -> CGRect {
        var vDpad = CGRect(x: 0, y: 0, width: yokeBase.frame.width, height: yokeBase.frame.height)

        vDpad.origin.x = yokeBase.position.x - yokeBase.frame.size.width / 2
        vDpad.origin.y = yokeBase.position.y - yokeBase.frame.size.height / 2

        return vDpad
    }
    
    func updatePlayer(_ dt: CFTimeInterval) {
        playerVelocity.dx = playerVelocity.dx + airplaneAcceleration.dx * CGFloat(dt)
        playerVelocity.dy = playerVelocity.dy + airplaneAcceleration.dy * CGFloat(dt)
        
        playerVelocity.dx = max(-maxPlayerSpeed, min(maxPlayerSpeed, playerVelocity.dx))
        playerVelocity.dy = max(-maxPlayerSpeed, min(maxPlayerSpeed, playerVelocity.dy))
        
        var newX = airplane.position.x + playerVelocity.dx * CGFloat(dt)
        var newY = airplane.position.y + playerVelocity.dy * CGFloat(dt)
        
        newX = min(size.width, max(0, newX))
        newY = min(size.height, max(0, newY))
        
        airplane.position = CGPoint(x: newX, y: newY)
        
        let angle = atan2(playerVelocity.dy, playerVelocity.dx)
        airplane.zRotation = angle - 90 * degreesToRadians
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
    
}
