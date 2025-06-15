//
//  FlyAgentNode.swift
//  Petopia
//
//  Created by Jeffri Lieca H on 04/06/24.
//

import Foundation
import SpriteKit
import GameplayKit

class FlyAgentNode : SKSpriteNode, GKAgentDelegate{
    var agent : GKAgent2D?
    private var flyanimation:[SKTexture]
    var visualAgent : SKSpriteNode?
    
    
    init(scene: SKScene, position: CGPoint, size: CGSize) {
        
        let flyAnimatedAtlas = SKTextureAtlas(named: "Fly_images")
        var flyFrames: [SKTexture] = []
        var numImages = 2
        for i in 1...numImages {
            let flyTextureName = "fly_\(i)"
            flyFrames.append(flyAnimatedAtlas.textureNamed(flyTextureName))
        }
        self.flyanimation = flyFrames
        // Call the designated initializer of SKSpriteNode with a color and size
        let color = SKColor.clear // Use
        let size = size
        super.init(texture: self.flyanimation[0], color: color, size: size)
        
        self.position=position
        self.xScale = -1*abs(self.xScale)
//        self.physicsBody = SKPhysicsBody(circleOfRadius: size.width/2)
//        self.physicsBody?.isDynamic = false
//        self.physicsBody?.isResting = true
        scene.addChild(self)
        
        self.agent = GKAgent2D()
        self.agent!.position = vector_float2(x: Float(position.x), y: Float(position.y))
        self.agent!.delegate = self
        self.agent?.radius = Float(self.size.height/2)
        self.agent!.maxSpeed = 100
        self.agent!.maxAcceleration = 50
        self.agent!.mass = 0.2
        
        let agentNode = SKSpriteNode(texture: self.texture)
        agentNode.size = self.size
        
        agentNode.position = CGPoint(x: (self.position.x), y: (self.position.y)) // Posisi awal
        agentNode.run(SKAction.colorize(with: SKColor.black, colorBlendFactor: 100, duration: 1))
        agentNode.zPosition = -1000
        self.visualAgent = agentNode
        self.visualAgent?.xScale = 1.1*(self.xScale)
//        scene.addChild(agentNode)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func useFlyAnimation(){
        self.run(SKAction.repeatForever(
          SKAction.animate(with: self.flyanimation,
                           timePerFrame: 0.1,
                           resize: false,
                           restore: true)),
          withKey:"flying")
    }
    
    func agentDidUpdate(_ agent: GKAgent) {
//        print("Fly agent point : \(self.agent?.position)")
//        print("Cohered agent point : \(self.coheredAgent.position)")
        var sizeBaru = CGSize(width: -(20 - self.position.y/400 * 15 + 20), height: -(20 - self.position.y/400 * 15 + 20))
        
        if let agent2d = agent as? GKAgent2D {
            self.position = CGPoint(x: CGFloat(agent2d.position.x), y: CGFloat(agent2d.position.y))
            self.scale(to: sizeBaru)
            self.zRotation = CGFloat(agent2d.rotation)
            self.zPosition = -(self.position.y)
        }
    }
    
    func agentWillUpdate(_ agent: GKAgent) {
        print("agent Will Update Fly")
        if let agent2d = agent as? GKAgent2D {
            agent2d.position = SIMD2(Float(self.position.x), Float(self.position.y))
        }
        
        self.visualAgent?.position = CGPoint(x: self.position.x , y: self.position.y )
        self.visualAgent?.size = CGSize(width: self.size.width + 10, height : self.size.height + 10)
        self.visualAgent?.texture = self.texture
    }
    
//    func setHidden () {
//        self.isHidden = !self.isHidden
//        self.agent?.position = SIMD2(Float(self.position.x), Float(self.position.y))
//    }
    
}


