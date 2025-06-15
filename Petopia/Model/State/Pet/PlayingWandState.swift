//
//  SeekingState.swift
//  Petopia
//
//  Created by Jeffri Lieca H on 04/06/24.
//

import Foundation
import GameplayKit

class PlayingWandState : GameState {
    
    var seekGoal : GKGoal?
    var trackingAgent: GKAgent2D?
    var seeking : Bool?
    var petComponentSprite : PetAgentNode?
    lazy var stopGoal: GKGoal = {
        return GKGoal(toReachTargetSpeed: 0)
    }()
    var seekingParticle: SKEmitterNode?
    var mulaiMain : Bool = false
    var wand : WandAgentNode?
    var obstacle : [GKObstacle]?
    var avoidGoal : GKGoal?
    var selesai : Bool = false
    
 
    init(entity:PetEntity, game:GameScene) {
        super.init(entity: entity, game: game)
        
        //pindah Sprite
        self.petComponentSprite = self.entity.component(ofType: PetSpriteComponent.self)?.sprite
        self.petComponentSprite?.useWalkAnimation()
       
        self.petComponentSprite!.zPosition = -(self.petComponentSprite?.position.y)!
        
//        self.seekingParticle = SKEmitterNode(fileNamed: "SmokeParticle")
//        self.seekingParticle?.position=CGPointMake( 0 , 0 - self.petComponentSprite!.size.height/2)
//        self.seekingParticle?.zPosition = -1
//        self.seekingParticle?.targetNode = game
//        self.seekingParticle?.particleBirthRate = 15
//        self.seekingParticle?.particleSize = CGSize(width: self.petComponentSprite!.size.width/2, height: self.petComponentSprite!.size.width/2)
//        self.seekingParticle!.particlePositionRange=CGVectorMake(self.petComponentSprite!.size.width/2,0)
//        self.petComponentSprite!.addChild(self.seekingParticle!)
        
//        self.petComponentSprite!.agent = GKAgent2D()
    
        
       setAgent()
//        let rect = CGRect(x:-100, y: 200, width: 1000, height: 500)
//        let rectShape = SKShapeNode(rect: rect)
//        rectShape.fillColor = SKColor.blue
//        self.game.addChild(rectShape)
        
//        let circleShape = SKShapeNode(circleOfRadius: 200)
//        circleShape.fillColor = SKColor.red
//        circleShape.lineWidth = 2
//        circleShape.zPosition = 1000
//        circleShape.position = CGPoint(x: self.game.frame.midX, y: self.game.frame.midY )
//        
//        self.game.addChild(circleShape)
//        let obstacle = GKCircleObstacle(radius: 200)
//        obstacle.position = vector_float2(x: Float(circleShape.position.x), y: Float(circleShape.position.y))
//        
//        let points = [
//            SIMD2<Float>(Float(rect.minX), Float(rect.minY)),
//            SIMD2<Float>(Float(rect.maxX), Float(rect.minY)),
//            SIMD2<Float>(Float(rect.maxX), Float(rect.maxY)),
//            SIMD2<Float>(Float(rect.minX), Float(rect.maxY))
//        ]
//        let obstaclenya = GKPolygonObstacle(points: points)
//        let graph = GKObstacleGraph(obstacles: [obstaclenya], bufferRadius: 1400)
//        
//        
//      
//        self.obstacle=[obstacle]
        
    }
    
    func setAgent(){
        self.petComponentSprite!.agent!.behavior = GKBehavior()
        self.petComponentSprite!.agent!.mass = 0.01
        self.petComponentSprite!.agent!.position = vector_float2(x: Float(CGRectGetMidX(self.game.frame)), y: Float(CGRectGetMidY(self.game.frame)))
        self.petComponentSprite!.agent!.delegate = self.petComponentSprite!
        self.petComponentSprite!.agent!.maxSpeed = 500
        self.petComponentSprite!.agent!.maxAcceleration = 400
        self.petComponentSprite!.agent!.speed = 200
        self.trackingAgent = GKAgent2D()
        self.trackingAgent!.position = vector_float2(x: Float(CGRectGetMidX(self.game.frame)), y: Float(CGRectGetMidY(self.game.frame)))
        self.seekGoal = GKGoal(toSeekAgent: self.trackingAgent!)
        setSeeking(seeking: false)
    }
    
    override func didEnter(from previousState: GKState?) {
        
        let wand = WandAgentNode (scene: game, position: CGPoint(x: game.frame.midX + 100, y: game.frame.minY+150), size: CGSize(width: 100,height: 100))
        
        self.wand = wand
        self.game.addChild(wand)
        self.totalTime = 0
        
        self.petComponentSprite!.useWalkAnimation()
        
        
        self.petComponentSprite!.agent!.behavior = GKBehavior()
//        self.petComponentSprite!.agent!.position = vector_float2(x: Float(CGRectGetMidX(self.game.frame)), y: Float(CGRectGetMidY(self.game.frame)))
        self.petComponentSprite!.agent!.mass = 0.01
        self.petComponentSprite!.agent!.delegate = self.petComponentSprite!
        self.petComponentSprite?.agent!.radius = Float(self.petComponentSprite!.size.height/2)
        self.petComponentSprite!.agent!.maxSpeed = 200
        self.petComponentSprite!.agent!.maxAcceleration = 100
//        self.petComponentSprite!.agent!.speed = 50
        self.seekGoal = GKGoal(toSeekAgent: self.wand!.agent!)
        self.mulaiMain = false
//        self.setSeeking(seeking: true)
//        self.petComponentSprite!.agent!.behavior?.setWeight(100, for: GKGoal(toAvoid: self.obstacle!, maxPredictionTime: 10))
        
       
//        self.petComponentSprite!.agent!.behavior?.setWeight(10000, for: GKGoal(toAvoid: self.obstacless!, maxPredictionTime: 1))
        
//        self.petComponentSprite?.physicsBody?.isDynamic = false
////        self.food?.removeFromParent()
        self.petComponentSprite?.setDiem(diem: false)
//        
//        self.petComponentSprite?.physicsBody?.isDynamic = false
//        self.petComponentSprite?.physicsBody?.isResting = true
//        self.petComponentSprite?.physicsBody?.collisionBitMask=self.petComponentSprite!.petCategory
        self.wand?.physicsBody?.collisionBitMask = 0
        self.wand?.physicsBody?.categoryBitMask = 0
        self.wand?.physicsBody?.isDynamic = false
        self.wand?.physicsBody?.isResting = true
        
//        let avoidGoal = GKGoal(toAvoid: self.obstacle!, maxPredictionTime: 1)
//        self.avoidGoal = avoidGoal
//        
//        self.petComponentSprite!.agent!.behavior!.setWeight(100, for: avoidGoal)
        self.selesai = false
    }
    
    var totalTime : TimeInterval = 0
    
    override func update(deltaTime seconds: TimeInterval) {
//        print("weigth goal: \(String(describing: self.petComponentSprite?.agent?.behavior?.weight(for: self.seekGoal! )))")
//        print("weigth avoid: \(String(describing: self.petComponentSprite?.agent?.behavior?.weight(for: self.avoidGoal! )))")

        totalTime += seconds
//        if (self.seeking!){
////                        self.setDrawTrails(draw: true)
//            
//        }
//        else{
        if totalTime >= 14 {
//            print("berhenti")
            self.wand?.removeFromParent()
            self.setSeeking(seeking: false)
//            self.petComponentSprite?.run(SKAction.moveBy(x: self.game.frame.midX, y: self.game.frame.midY - 100, duration: 1))
//            self.petComponentSprite!.run(SKAction.moveTo(x: self.game.frame.midX, duration: 1))
//            self.petComponentSprite!.run(SKAction.moveTo(y: self.game.frame.midY - 100, duration: 1))
//            self.game.pet?.tambahHappiness(tambah: 30)
            self.selesai = true
        }
        if totalTime >= 14
        {
            self.entity.component(ofType: PetIntelligenceComponent.self)?.stateMachine.enter(WalkingState2.self)
        }
//
//            
//            self.penguinMoveEnded()
//            self.setDrawTrails(draw: false)
//            //            self.trackingAgent!.position = vector_float2(x:Float(self.lastPosition!.x),y:Float(self.lastPosition!.y))
//        }
        
        self.petComponentSprite!.agent!.update(deltaTime: seconds)
        self.wand!.agent!.update(deltaTime: seconds)
       
    }
    
    
    func setSeeking (seeking:Bool){
        self.seeking = seeking
        if(self.seeking!) {
                        self.petComponentSprite!.agent!.behavior!.setWeight(1, for: self.seekGoal!)
                        self.petComponentSprite!.agent!.behavior!.setWeight(0, for: self.stopGoal)
//            self.petComponentSprite!.agent!.behavior!.setWeight(1000000, for: GKGoal(toAvoid: self.obstacle!, maxPredictionTime: 1))
//            self.petComponentSprite!.agent!.behavior!.setWeight(100, for: GKGoal(toAvoid: self.obstacle!, maxPredictionTime: 0.1))
        }
        else {
//            print("berhenti")
                        self.petComponentSprite!.agent!.behavior!.setWeight(0, for: self.seekGoal!)
                        self.petComponentSprite!.agent!.behavior!.setWeight(1, for: self.stopGoal)
//                        self.petComponentSprite!.agent!.behavior!.setWeight(1, for: GKGoal(toAvoid: [self.obstacle!], maxPredictionTime: 1))
        }
    }
    
    func setTrackingAgent(location : CGPoint) {
        self.trackingAgent?.position = vector_float2(Float(location.x), Float(location.y))
    }
    func penguinMoveEnded() {
        self.petComponentSprite!.removeAllActions()
    }
    
    
    
    override func willExit(to nextState: GKState) {
//        setDrawTrails(draw: false)
        penguinMoveEnded()
        self.wand?.removeFromParent()
        
        
//        self.petComponentSprite!.setDrawTrails(draw: false)
        self.petComponentSprite?.physicsBody?.isDynamic = true
//        self.food?.removeFromParent()
        self.petComponentSprite?.setDiem(diem: false)
        
        self.petComponentSprite?.physicsBody?.isDynamic = true
        self.petComponentSprite?.physicsBody?.isResting = false
        self.petComponentSprite?.physicsBody?.collisionBitMask=self.petComponentSprite!.petCategory
        self.wand?.physicsBody?.collisionBitMask = 0
        self.wand?.physicsBody?.isDynamic = true
        self.wand?.physicsBody?.isResting = false
        totalTime = 0
//        self.food?.agent?.behavior?.removeAllGoals()
//        self.walkingParticle!.removeFromParent()
        
//        self.lineAgent?.removeFromParent()
//        self.wand?.visualAgent!.removeFromParent()
//        self.petComponentSprite!.agent?.position = vector_float2(x: Float(self.petComponentSprite!.position.x), y: Float(self.petComponentSprite!.position.y))
        if self.selesai{
            self.game.pet?.tambahHappiness(tambah: 30)
        }
    }
    
    func setDragging (location: CGPoint){
        
        self.wand?.position = CGPointMake(location.x-(self.wand?.size.width)!/3, location.y+(self.wand?.size.height)!/2)
//        self.wand?.agent?.position = vector_float2(x: Float(location.x)
//                                                   , y: Float(location.y))
    }
    
   
}

