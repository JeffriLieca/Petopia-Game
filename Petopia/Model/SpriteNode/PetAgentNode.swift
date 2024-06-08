//
//  PetAgentNode.swift
//  Petopia
//
//  Created by Jeffri Lieca H on 04/06/24.
//

import Foundation
import SpriteKit
import GameplayKit

class PetAgentNode : SKSpriteNode, GKAgentDelegate{
    var agent :GKAgent2D?
    
    private var petWalkingFrames: [SKTexture] = []
    private var petIdleFrames: [SKTexture] = []
//    private var petPokedFrames: [SKTexture] = []
//    private var petDeadFrames: [SKTexture] = []
//    private var petDirtyFrames: [SKTexture] = []
//    private var petSleepingFrames: [SKTexture] = []
    private var petEatingFrames: [SKTexture] = []
    private var diem : Bool = false
    var normalFrame : SKTexture
    var idleFrame : SKTexture
    var pokedFrame : SKTexture
    var pokedSound : SKAudioNode

    var walkingParticle : SKEmitterNode?
    var shadow : SKTexture?
    let petCategory: UInt32 = 0x1 << 0
    let ballCategory: UInt32 = 0x1 << 1
    let wallCategory: UInt32 = 0x1 << 2
    
    var visualAgent : SKSpriteNode?
    var loveParticle : SKEmitterNode?
    
    init(scene: SKScene, position: CGPoint, size: CGSize) {
        let petAnimatedAtlas = SKTextureAtlas(named: "Mangeak")
        
        let normalState = petAnimatedAtlas.textureNamed("normal")
        self.normalFrame = petAnimatedAtlas.textureNamed("normal")
        self.pokedFrame = petAnimatedAtlas.textureNamed("poke_2")
        self.idleFrame = petAnimatedAtlas.textureNamed("Idle 1")
        self.pokedSound = SKAudioNode(fileNamed: "poked")
     

        
        var walkFrames: [SKTexture] = []
        //      let numImages = petAnimatedAtlas.textureNames.count
        var numImages = 3
        for i in 1...numImages {
            let petTextureName = "jalan_rev_\(i)"
            walkFrames.append(petAnimatedAtlas.textureNamed(petTextureName))
        }
        self.petWalkingFrames = walkFrames
        
        // Idle Frame
        var idleFrames: [SKTexture] = []
        numImages = 2
        for i in 1...numImages {
            let petTextureName = "poke_\(i)"
            idleFrames.append(petAnimatedAtlas.textureNamed(petTextureName))
        }
        self.petIdleFrames = idleFrames
        
        // Eat Frame
        var eatingFrames: [SKTexture] = []
        numImages = 1
        eatingFrames.append(normalState)
        for i in 1...numImages {
            let petTextureName = "eat_\(i)"
            eatingFrames.append(petAnimatedAtlas.textureNamed(petTextureName))
        }
        eatingFrames.append(normalState)
        self.petEatingFrames = eatingFrames
        
       
        // Call the designated initializer of SKSpriteNode with a color and size
               let color = SKColor.clear
               let size = size
        super.init(texture: self.normalFrame, color: color, size: size)
        self.position = position
        self.zPosition = 10
        scene.addChild(self)
        
        
        let shadowTexture = SKTexture(imageNamed: "shadow")
        let shadow = SKSpriteNode(texture: shadowTexture)
        shadow.position = CGPoint(x: 0, y: -self.size.height/2 + 20)
        shadow.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        shadow.zPosition = -1000
        let targetHeightShadow: CGFloat = self.size.height
        let aspectRatioShadow = shadowTexture.size().width / shadowTexture.size().height
        let calculatedWidthShadow = targetHeightShadow * aspectRatioShadow
        shadow.size = CGSize(width: calculatedWidthShadow, height: targetHeightShadow)
        
        self.addChild(shadow)
        
        
        self.walkingParticle = SKEmitterNode(fileNamed: "SmokeParticle")
        self.walkingParticle?.position=CGPointMake( 0 , 0 - self.size.height/2.5)
        self.walkingParticle?.zPosition = -1
        self.walkingParticle?.targetNode = self
        self.walkingParticle?.particleBirthRate = 15
        self.walkingParticle?.particleSize = CGSize(width: self.size.width/2, height: self.size.width/2)
        self.walkingParticle!.particlePositionRange=CGVectorMake(self.size.width/2,0)
        
        self.addChild(self.walkingParticle!)
        setDrawTrails(draw: false)
        
        
        self.loveParticle = SKEmitterNode(fileNamed: "LoveFire")
        self.loveParticle?.targetNode = self
        self.loveParticle?.zPosition = self.zPosition + 1
        self.loveParticle?.particleBirthRate = 0
        self.loveParticle?.particleSize = CGSize(width: self.size.width/2, height: self.size.width/2)
        self.addChild(self.loveParticle!)
        
        self.agent = GKAgent2D()
        self.agent!.position = vector_float2(x: Float(position.x), y: Float(position.y))
        self.agent!.delegate = self
        self.agent!.maxSpeed = 300
        self.agent!.maxAcceleration = 50
        self.agent!.speed = 100
        self.physicsBody = SKPhysicsBody(circleOfRadius: size.width/3)
//        self.physicsBody = SKPhysicsBody(texture: petWalkingFrames[0], size: self.size)
//        self.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: size.width, height: self.size.height), center: CGPoint(x: 0, y: 0))
        self.physicsBody?.restitution = 1
        self.physicsBody!.categoryBitMask = 0
        self.physicsBody?.mass = 100
        self.physicsBody?.collisionBitMask = wallCategory | ballCategory
        
//        var kaki = SKShapeNode(rectOf: CGSize(width: self.size.width/1.5, height: self.size.height/4))
//        kaki.fillColor = SKColor.blue
//        kaki.position = CGPoint(x: 0, y: 0)
//        kaki.zPosition = -1
//        let kakiPath = CGPath(rect: kaki.frame, transform: nil)
////        kaki.physicsBody = SKPhysicsBody(edgeLoopFrom: kakiPath)
//
//        kaki.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.size.width/2, height: self.size.height/4))
////        let kotak = CGRect(x: 0, y: self.size.height/4, width: self.size.width/1.5, height: self.size.height/3)
////        self.physicsBody = SKPhysicsBody(edgeLoopFrom: kaki.frame)
//        kaki.physicsBody?.mass = 100
//        kaki.physicsBody?.restitution = 0
//        kaki.physicsBody?.categoryBitMask = petCategory
//        self.addChild(kaki)
        
        
        let agentNode = SKSpriteNode(texture: self.texture)
        agentNode.size = self.size
        
        agentNode.position = CGPoint(x: (self.position.x), y: (self.position.y)) // Posisi awal
        agentNode.run(SKAction.colorize(with: SKColor.black, colorBlendFactor: 100, duration: 1))
        agentNode.zPosition = -1000
        self.visualAgent = agentNode
        self.visualAgent?.xScale = 1.1*(self.xScale)
        scene.addChild(agentNode)


    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func agentDidUpdate(_ agent: GKAgent) {
        
        var sizeBaru = CGSize(width: 150 - self.position.y/400 * 100 + 100, height: 150 - self.position.y/400 * 100 + 100)
        if !diem{
            if (self.agent?.position.x)! < Float(self.position.x)
            {
                self.scale(to: sizeBaru)
                self.xScale = abs(self.xScale)
                //            self.physicsBody = SKPhysicsBody(texture: self.texture!, size: self.size)
//                self.scale(to: CGSize(width: 200, height: 200))
                
            }
            else{
                self.scale(to: sizeBaru)
                self.xScale = abs(self.xScale)  * -1
                //            self.physicsBody = SKPhysicsBody(texture: self.texture!, size: self.size)
//                self.scale(to: CGSize(width: -100, height: 100))
            }
            
            print("agent Did Update Pet")
            if let agent2d = agent as? GKAgent2D {
                //                self.position = CGPoint(x: CGFloat(agent2d.position.x), y: CGFloat(agent2d.position.y))
                
                
                
               
                
//                if agent2d.position.x <= 50{
//                    self.position = CGPoint(x: CGFloat(self.position.x+1), y: CGFloat(self.position.y))
//                }
//                else if agent2d.position.y <= 50 {
//                    self.position = CGPoint(x: CGFloat(self.position.x), y: CGFloat(self.position.y + 1))
//                }
//                else if agent2d.position.y >= 400 {
//                    self.position = CGPoint(x: CGFloat(self.position.x), y: CGFloat(self.position.y - 1))
//                }
//                else if                     agent2d.position.x >= 500 {
//
//                    self.position = CGPoint(x: CGFloat(self.position.x - 1 ), y: CGFloat(self.position.y))
//                    
//                }
//
//                else{
                    self.position = CGPoint(x: CGFloat(agent2d.position.x), y: CGFloat(agent2d.position.y))
//                }
            }
            self.zPosition = -(self.position.y)
        }
    }

    func agentWillUpdate(_ agent: GKAgent) {
        if !diem{
            print("agent Will Update Pet")
            if let agent2d = agent as? GKAgent2D {
                //                agent2d.position = SIMD2(Float(self.position.x), Float(self.position.y))
                
//                if agent2d.position.x <= 50{
//                    agent2d.position = SIMD2(Float(agent2d.position.x + 1), Float(agent2d.position.y))
//                }
//                else if agent2d.position.y <= 50 {
//                    agent2d.position = SIMD2(Float(agent2d.position.x), Float(agent2d.position.y + 1))
//                }
//                else if agent2d.position.y >= 400 {
//                    agent2d.position = SIMD2(Float(agent2d.position.x), Float(agent2d.position.y - 1))
//                }
//                else if
//                    agent2d.position.x >= 500 {
//                    agent2d.position = SIMD2(Float(agent2d.position.x - 1), Float(agent2d.position.y))
//                    
//                    
//                }
//                else{
                    agent2d.position = SIMD2(Float(self.position.x), Float(self.position.y))
//                }
                
                
                
            }
            
            self.visualAgent?.position = CGPoint(x: self.position.x , y: self.position.y )
            self.visualAgent?.size = CGSize(width: self.size.width + 10, height : self.size.height + 10)
            self.visualAgent?.texture = self.texture
        }
    }
    
    func useWalkAnimation() {
      self.run(SKAction.repeatForever(
        SKAction.animate(with: self.petWalkingFrames,
                         timePerFrame: 0.2,
                         resize: false,
                         restore: true)),
        withKey:"walking")
        setDrawTrails(draw: true)
    }
    
    func useIdleAnimation (){
        self.removeAllActions()
        self.run(SKAction.repeatForever(
          SKAction.animate(with: self.petIdleFrames,
                           timePerFrame: 0.1,
                           resize: false,
                           restore: true)),
          withKey:"idle")
    }
    
    func animateEat() {
        self.removeAllActions()
        self.run(SKAction.run {
            self.setLoveFire(num: 1)
        })
        self.run(SKAction.animate(with: self.petEatingFrames, timePerFrame: 0.5,
                                  resize: false,
                                  restore: true),
                 withKey: "eat")
        self.run(SKAction.run {
            self.setLoveFire(num: 0)
        })
//        createSingleParticleEffectLove()
    }
    
    func animatePoked () {
//        self.removeAllActions()
        var diemin = SKAction.run {
            self.setLoveFire(num: 1)
            self.diem = true
        }
        var gerakin = SKAction.run {
            self.setLoveFire(num: 0)
            self.diem = false
        }
        // Memainkan suara ketika melakukan aksi tertentu
        let playSoundAction = SKAction.playSoundFileNamed("poked.mp3", waitForCompletion: false)
//        self.run(playSoundAction)

        
        self.run(SKAction.sequence( [diemin, SKAction.animate(with: [self.pokedFrame,self.normalFrame], timePerFrame: 1,
                                  resize: false,
                                  restore: true), gerakin]),
                 withKey: "poke")
        self.run(playSoundAction)
       
    }
    
    func setDiem(diem:Bool) {
        self.diem = diem
    }
    
    func petMoveEnded() {
      self.removeAllActions()
    }
    
    func setDrawTrails(draw:Bool) {
        if draw {
            self.walkingParticle!.particleBirthRate = 10
        }
        else{
            self.walkingParticle!.particleBirthRate = 0
    
        }
    }
    
    func setLoveFire(num: CGFloat) {
        self.loveParticle?.particleBirthRate = num
    }
    func createSingleParticleEffectLove() {
        guard let particleEmitter = SKEmitterNode(fileNamed: "LoveFire") else { return }
        particleEmitter.position = CGPoint(x: frame.midX, y: frame.midY)
        particleEmitter.numParticlesToEmit = 1  // Mengatur agar hanya satu partikel yang diemit
        particleEmitter.particleBirthRate = 1  // Mengatur birth rate untuk memastikan partikel muncul segera
        
        addChild(particleEmitter)
        
        // Menghapus emitter dari scene setelah partikel diemit
        particleEmitter.run(SKAction.sequence([
            SKAction.wait(forDuration: 1),  // Tunggu cukup lama agar partikel diemit
            SKAction.removeFromParent()     // Hapus emitter dari scene
        ]))
    }


}

