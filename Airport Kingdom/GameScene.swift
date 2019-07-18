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
    var motionManager = CMMotionManager()
    
    let background = GameLevelCreator(imageNamed: "BackgroundLvl1")
    let runway = GameLevelCreator(imageNamed: "runway")
    let airplane = SKSpriteNode(imageNamed: "airplane")
    let deadTree = SKSpriteNode(imageNamed: "deadTree")
    let treeCluster = SKSpriteNode(imageNamed: "treeCluster")
    
    var airplaneAcceleration = CGVector(dx: 0, dy: 0)
    let maxPlayerSpeed: CGFloat = 200
    let maxPlayerAcceleration: CGFloat = 400
    var accelerometerXYZ = CMAcceleration(x: 0, y: 0, z: 0)
    
    var playerVelocity = CGVector(dx: 0, dy: 0)
    var lastUpdateTime: CFTimeInterval = 0
    var direction = SIMD2<Float>(x: 0, y: 0)
    var directionAngle: CGFloat = 0.0 {
        didSet {
            if directionAngle != oldValue {
                // action that rotates the node to an angle expressed in radian.
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
    
    // MARK: - didMove(to:)
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
//        setUpRunwayEdges()
        setUpGameScene()
        motionManager.startAccelerometerUpdates()
    }
    
    func setUpGameScene() {
        background.setUpBackground()
        addChild(background)
        
        runway.setUpRunway()
        addChild(runway)
        
        setUpTreeCluster()
        setUpDeadTree()
        setUpLiveTree()
    }
    
    
    func setUpTreeCluster() {
        // These are "fly over". No physics bodies.
        let position = CGPoint(x: runway.position.x + 300, y: runway.position.y + 50)
        
        treeCluster.name = "treeCluster"
        treeCluster.position = position
        treeCluster.zPosition = 0
        addChild(treeCluster)
    }
    
    func setUpDeadTree() {
        let position = CGPoint(x: runway.position.x - 200, y: runway.position.y - 100)
        
        deadTree.name = "deadTree"
        deadTree.position = position
        deadTree.zPosition = 0
        deadTree.physicsBody = SKPhysicsBody(circleOfRadius: deadTree.size.width / 2, center: deadTree.position)
        deadTree.physicsBody?.categoryBitMask = CollisionTypes.deadTree.rawValue
        deadTree.physicsBody?.contactTestBitMask = CollisionTypes.airplane.rawValue
        deadTree.physicsBody?.collisionBitMask = CollisionTypes.airplane.rawValue
        deadTree.physicsBody?.isDynamic = false
        addChild(deadTree)
    }
    
    func setUpLiveTree() {
        let node = SKSpriteNode(imageNamed: "liveTree")
        let position = CGPoint(x: treeCluster.position.x - 200, y: treeCluster.position.y + 170)
        
        node.name = "liveTree"
        node.scale(to: CGSize(width: 90, height: 90))
        node.position = position
        node.zPosition = 0
        node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width / 2, center: node.position)
        node.physicsBody?.categoryBitMask = CollisionTypes.liveTree.rawValue
        node.physicsBody?.contactTestBitMask = CollisionTypes.airplane.rawValue
        node.physicsBody?.collisionBitMask = CollisionTypes.airplane.rawValue
        node.physicsBody?.isDynamic = false
        addChild(node)
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
        airplane.position = CGPoint(x: treeCluster.position.x, y: treeCluster.position.y - 100)
        airplane.zPosition = 1
        
        airplane.physicsBody = SKPhysicsBody(circleOfRadius: airplane.size.width / 2)
        airplane.physicsBody?.categoryBitMask = CollisionTypes.airplane.rawValue
        airplane.physicsBody?.contactTestBitMask = CollisionTypes.runwaysurface.rawValue
        airplane.physicsBody?.collisionBitMask = CollisionTypes.deadTree.rawValue | CollisionTypes.liveTree.rawValue
        airplane.physicsBody?.isDynamic = true
        airplane.physicsBody?.linearDamping = 0.5
        addChild(airplane)
    }
    
    override func update(_ currentTime: TimeInterval) {
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
//            levelCreator.level += 1
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                let nextLevel = GameScene(size: self.size)
                nextLevel.viewController = self.viewController
                self.viewController.currentGame = nextLevel
                
                let transition = SKTransition.doorway(withDuration: 1.5)
                self.view?.presentScene(nextLevel, transition: transition)
            }
            return
        } else if node.name == "deadTree" || node.name == "liveTree" {
            if let fireExplosion = SKEmitterNode(fileNamed: "TowerFireExplosion") {
                fireExplosion.position = airplane.position
                addChild(fireExplosion)
                score = 0
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    if let treeFire = SKEmitterNode(fileNamed: "TreeFire") {
                        treeFire.position = node.position
                        self.addChild(treeFire)
                        // consider removing Tree node after the fire is out.
                    }
                }
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
        }
    }
    
    // MARK: - Player acceleration
    func updatePlayerAccelerationFromMotionManager() {
        guard let acceleration = motionManager.accelerometerData?.acceleration else { return }
        let filterFactor = 0.9

        accelerometerXYZ.x = acceleration.x * filterFactor + accelerometerXYZ.x * (1 - filterFactor)
        accelerometerXYZ.y = acceleration.y * filterFactor + accelerometerXYZ.y * (1 - filterFactor)

        airplaneAcceleration.dx = CGFloat(accelerometerXYZ.y) * -maxPlayerAcceleration
        airplaneAcceleration.dy = CGFloat(accelerometerXYZ.x) * maxPlayerAcceleration
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
    
}
