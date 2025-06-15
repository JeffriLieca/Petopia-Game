//
//  BallAgentNode.swift
//  Petopia
//
//  Created by Jeffri Lieca H on 05/06/24.
//

import Foundation
import SpriteKit
import GameplayKit

class SoapAgentNode : SKSpriteNode, GKAgentDelegate{
    var agent :GKAgent2D?
    let petCategory: UInt32 = 0x1 << 0
    let ballCategory: UInt32 = 0x1 << 1
    let wallCategory: UInt32 = 0x1 << 2
    
    var visualAgent : SKSpriteNode?
    
    private var soapFrame: SKTexture = SKTexture(imageNamed: "soap")
 
    init( scene: SKScene, position: CGPoint, size: CGSize) {
        
        
//        let ball = SKSpriteNode(imageNamed: "ball")
//        ball.size = CGSize (width: 100, height: 100)
////        ball.position = CGPoint(x: game.frame.midX, y: game.frame.midY-400)
//        ball.zPosition = 10000000
//        ball.physicsBody = SKPhysicsBody(circleOfRadius: 50)
//        ball.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "ball"), size: ball.size)
//        ball.name = "ball"
//        ball.physicsBody?.restitution = 0.7
//        ball.physicsBody?.categoryBitMask = ballCategory
//        ball.physicsBody?.collisionBitMask = petCategory
//        ball.physicsBody?.contactTestBitMask = petCategory
//        scene.addChild(ball)
        
        // Call the designated initializer of SKSpriteNode with a color and size
               let color = SKColor.clear
               let size = size
        super.init(texture: self.soapFrame, color: color, size: size)
        
//        self.agent = GKAgent2D()
//        self.agent!.position = vector_float2(x: Float(position.x), y: Float(position.y))
//        self.agent!.delegate = self
//        self.agent!.maxSpeed = 300
//        self.agent!.maxAcceleration = 50
//        self.agent!.speed = 100
        
       
       
        
        self.texture = soapFrame
        self.size = size
        self.position = position
        self.zPosition = 10000000
//        self.physicsBody = SKPhysicsBody(circleOfRadius: self.size.width/2)
//        self.physicsBody = SKPhysicsBody(texture: self.texture!, size: self.size)
        self.physicsBody = SKPhysicsBody(circleOfRadius: self.size.width/2-10)
        self.name = "soap"
        self.physicsBody?.restitution = 0.7
//        self.physicsBody?.categoryBitMask = ballCategory
//        self.physicsBody?.collisionBitMask = petCategory | wallCategory
        self.physicsBody?.contactTestBitMask = petCategory
        self.physicsBody?.affectedByGravity = false
        
        self.agent = GKAgent2D()
        self.agent!.position = vector_float2(x: Float(position.x), y: Float(position.y))
        self.agent!.delegate = self
        
        
        
        let agentNode = SKSpriteNode(texture: self.texture)
        agentNode.size = self.size
        
        agentNode.position = CGPoint(x: (self.position.x), y: (self.position.y)) // Posisi awal
        agentNode.run(SKAction.colorize(with: SKColor.black, colorBlendFactor: 100, duration: 1))
        agentNode.zPosition = -1000
        self.visualAgent = agentNode
//        scene.addChild(agentNode)
       
        
//
//        self.agent = agent
//        self.ballFrame = ballFrame
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func agentWillUpdate(_ agent: GKAgent) {
        
        print("agent Will Update Pet")
        if let agent2d = agent as? GKAgent2D {
            agent2d.position = SIMD2(Float(self.position.x), Float(self.position.y))
        }
    }
    
    func agentDidUpdate(_ agent: GKAgent) {
        self.visualAgent?.position = self.position
        self.visualAgent?.size = self.size
        self.visualAgent?.texture = self.texture
    }
    
    
}
