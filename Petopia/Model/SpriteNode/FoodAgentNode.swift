//
//  FoodAgentNode.swift
//  Petopia
//
//  Created by Jeffri Lieca H on 05/06/24.
//

import Foundation
import SpriteKit
import GameplayKit

enum FoodName: String {
    case chicken = "Chicken"
    case meat = "Meat"
    case sausage = "Sausage"
    case bacon = "Bacon"
    case pineapple = "Pineapple"
    case apple = "Apple"
    case banana = "Banana"

    var description: String {
        return self.rawValue
    }
}

class FoodAgentNode : SKSpriteNode , GKAgentDelegate {
    
    var agent : GKAgent2D?
    private var nama : FoodName
    private var foodFrames : [SKTexture] = []
    private var currentFrameIndex = 0
    
    init(scene:SKScene, position: CGPoint, nama: FoodName, size:CGSize = CGSize(width: 100, height: 100)) {
        self.nama = nama
        
        let foodAnimatedAtlas = SKTextureAtlas(named: nama.rawValue)
        
        var foodFrames: [SKTexture] = []
        var numImages = foodAnimatedAtlas.textureNames.count
        for i in 1 ... numImages {
            let foodTextureName = "\(nama.rawValue)_\(i)"
            foodFrames.append(foodAnimatedAtlas.textureNamed(foodTextureName))
        }
        self.foodFrames = foodFrames
        
        
        let color = SKColor.clear
        let size = size
        super.init(texture: self.foodFrames[0], color: color, size: size)
        
        self.physicsBody = SKPhysicsBody(circleOfRadius: 20)
        
        
        self.position = position
        self.zPosition = 11
//        scene.addChild(self)
        
        self.agent = GKAgent2D()
        self.agent!.position = vector_float2(x: Float(position.x), y: Float(position.y))
        self.agent!.delegate = self
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
        
    }
    
    func animate() {
        self.removeAllActions()
        self.run(SKAction.repeatForever(
            SKAction.animate(with: self.foodFrames,
                           timePerFrame: 0.1,
                           resize: false,
                           restore: true)),
          withKey:"food")
    }
    
    func goToNextFrame() {
        currentFrameIndex += 1
        if currentFrameIndex >= foodFrames.count {
            currentFrameIndex = 0
        }
        self.texture = foodFrames[currentFrameIndex]
    }
    func agentWillUpdate(_ agent: GKAgent) {
        
        print("agent Will Update Pet")
        if let agent2d = agent as? GKAgent2D {
            agent2d.position = SIMD2(Float(self.position.x), Float(self.position.y))
        }
    }
    
    
    
}
