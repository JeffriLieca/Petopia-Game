//
//  SeekingState.swift
//  Petopia
//
//  Created by Jeffri Lieca H on 04/06/24.
//

import Foundation
import GameplayKit

class PlayingBallState : GameState {
    
    var seekGoal : GKGoal?
    var trackingAgent: GKAgent2D?
    var seeking : Bool?
    var petComponentSprite : PetAgentNode?
    var ball : BallAgentNode?
    
    let petCategory: UInt32 = 0x1 << 0
    let ballCategory: UInt32 = 0x1 << 1
    var playTime : TimeInterval = 0
    var tabrak : Bool = false
    
    lazy var stopGoal: GKGoal = {
        return GKGoal(toReachTargetSpeed: 0)
    }()
    var seekingParticle: SKEmitterNode?
 
    init(entity:PetEntity, game:GameScene) {
        super.init(entity: entity, game: game)
        
        //pindah Sprite
        self.petComponentSprite = self.entity.component(ofType: PetSpriteComponent.self)?.sprite
        self.petComponentSprite?.useWalkAnimation()
       
        self.petComponentSprite!.zPosition = -(self.petComponentSprite?.position.y)!
//        
//        self.seekingParticle = SKEmitterNode(fileNamed: "SmokeParticle")
//        self.seekingParticle?.position=CGPointMake( 0 , 0 - self.petComponentSprite!.size.height/2)
//        self.seekingParticle?.zPosition = -1
//        self.seekingParticle?.targetNode = game
//        self.seekingParticle?.particleBirthRate = 15
//        self.seekingParticle?.particleSize = CGSize(width: self.petComponentSprite!.size.width/2, height: self.petComponentSprite!.size.width/2)
//        self.seekingParticle!.particlePositionRange=CGVectorMake(self.petComponentSprite!.size.width/2,0)
//        self.petComponentSprite!.addChild(self.seekingParticle!)
//        
    
    
//        let ball = BallAgentNode(scene: game, position: CGPoint(x: game.frame.midX, y: game.frame.midY-200) , size: CGSize(width: 100,height: 100))
//        self.ball = ball
////        game.addChild(ball)
//        posisiawal = ball.position
        
//       setAgent()
        
       
        
        
        
        
    }
    
    func setAgent(){
        self.petComponentSprite!.agent = GKAgent2D()
        self.petComponentSprite!.agent!.behavior = GKBehavior()
        self.petComponentSprite!.agent!.mass = 0.01
        self.petComponentSprite!.agent!.position = vector_float2(x: Float(CGRectGetMidX(self.game.frame)), y: Float(CGRectGetMidY(self.game.frame)))
        self.petComponentSprite!.agent!.delegate = self.petComponentSprite!
        self.petComponentSprite!.agent!.maxSpeed = 500
        self.petComponentSprite!.agent!.maxAcceleration = 400
        self.petComponentSprite!.agent!.speed = 200
        self.trackingAgent = GKAgent2D()
        self.trackingAgent!.position = vector_float2(x: Float(CGRectGetMidX(self.game.frame)), y: Float(CGRectGetMidY(self.game.frame)))
        self.seekGoal = GKGoal(toSeekAgent: self.ball!.agent!)
        self.petComponentSprite!.agent!.behavior!.setWeight(1, for: self.seekGoal!)
//        self.seekGoal = GKGoal(toSeekAgent: self.trackingAgent!)
//        setSeeking(seeking: false)
    }
    
    override func didEnter(from previousState: GKState?) {
        let ball = BallAgentNode(scene: game, position: CGPoint(x: game.frame.midX, y: game.frame.midY-200) , size: CGSize(width: 50,height: 50))
        self.ball = ball
        game.addChild(ball)
        posisiawal = ball.position
        lama = 0
        playTime = 0
        tabrak = false
        game.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        
//        setAgent()
        self.petComponentSprite!.useWalkAnimation()
        
        self.petComponentSprite!.agent!.behavior = GKBehavior()
        self.petComponentSprite!.agent!.mass = 0.01
        self.petComponentSprite!.agent!.delegate = self.petComponentSprite!
        self.petComponentSprite!.agent!.maxSpeed = 300
        self.petComponentSprite!.agent!.maxAcceleration = 100
        self.petComponentSprite!.agent!.speed = 50
        self.seekGoal = GKGoal(toSeekAgent: self.ball!.agent!)
        self.petComponentSprite!.agent!.behavior!.setWeight(100, for: self.seekGoal!)
//        self.petComponentSprite!.agent!.behavior?.setWeight(100, for: GKGoal(toAvoid: self.obstacle!, maxPredictionTime: 10))
        
       
//        self.petComponentSprite!.agent!.behavior?.setWeight(10000, for: GKGoal(toAvoid: self.obstacless!, maxPredictionTime: 1))
        
     
        
        
       totalTime = 0
//        self.game.flies?.component(ofType: FlySpriteComponent.self)?.sprite.setHidden()
        
    }
    var posisiawal : CGPoint?
    var lama : TimeInterval = 0
    var totalTime : TimeInterval = 0
    override func update(deltaTime seconds: TimeInterval) {
       
//        if (self.seeking!){
//                        self.setDrawTrails(draw: true)
//            
//        }
//        else{
//            print("berhenti")
//            self.entity.component(ofType: PetIntelligenceComponent.self)?.stateMachine.enter(WalkingState2.self)
//            
//            
//            self.penguinMoveEnded()
//            self.setDrawTrails(draw: false)
//            //            self.trackingAgent!.position = vector_float2(x:Float(self.lastPosition!.x),y:Float(self.lastPosition!.y))
//        }
//
        totalTime += seconds
        if tabrak == false{
            
                self.petComponentSprite!.agent!.behavior!.setWeight(100, for: self.seekGoal!)
                self.petComponentSprite!.agent!.behavior!.setWeight(0, for: self.stopGoal)
            self.petComponentSprite!.agent!.maxSpeed = 500
            self.petComponentSprite!.agent!.maxAcceleration = 200
            self.petComponentSprite!.agent!.speed = 100
            
        }
        else{
            self.petComponentSprite!.agent!.behavior!.setWeight(100, for: self.seekGoal!)
            self.petComponentSprite!.agent!.behavior!.setWeight(1, for: self.stopGoal)
            self.petComponentSprite!.agent!.maxSpeed = 100
            self.petComponentSprite!.agent!.maxAcceleration = 50
            self.petComponentSprite!.agent!.speed = 50
            
            lama += seconds
           
            if lama > 2 {
                tabrak = false
                playTime += 1
            }
        }
        if playTime >= 3 || totalTime >= 15{
            
//            self.game.flies?.component(ofType: FlySpriteComponent.self)?.SetHidden()
            self.game.pet?.tambahHappiness(tambah: 20)
            entity.component(ofType: PetIntelligenceComponent.self)?.stateMachine.enter(WalkingState2.self)
            print(playTime)
        }
//        if (self.ball?.position != posisiawal){
//            self.petComponentSprite!.agent!.behavior!.setWeight(0, for: self.seekGoal!)
//            self.petComponentSprite!.agent!.behavior!.setWeight(100, for: self.stopGoal)
//        }
        
//        print("playingBall State")
        if (self.petComponentSprite?.agent?.position.x)! < Float(self.petComponentSprite!.position.x)
        {
            self.petComponentSprite!.xScale = abs(self.petComponentSprite!.xScale) * -1
            
        }
        else{
            self.petComponentSprite!.xScale = abs(self.petComponentSprite!.xScale)
        }
//        print("ball : \(self.ball!.agent!.position)")
//        print("pet : \(self.petComponentSprite!.agent!.position)")
        self.ball?.zPosition = -1 * self.ball!.position.y
        self.petComponentSprite!.agent!.update(deltaTime: seconds)
        self.ball!.agent!.update(deltaTime: seconds)
        
        
    }
    
    func setNabrak () {
        
        lama = 0
        self.tabrak = true
//        self.petComponentSprite!.agent?.speed = 10
//        self.petComponentSprite!.agent!.behavior!.setWeight(0, for: self.seekGoal!)
//        self.petComponentSprite!.agent!.behavior!.setWeight(1, for: self.stopGoal)
//        self.petComponentSprite!.agent?.behavior?.setWeight(1, for: GKGoal(toWander: 10))
    }
    
    
    func setSeeking (seeking:Bool){
        self.seeking = seeking
        if(self.seeking!) {
                        self.petComponentSprite!.agent!.behavior!.setWeight(1, for: self.seekGoal!)
                        self.petComponentSprite!.agent!.behavior!.setWeight(0, for: self.stopGoal)
        }
        else {
            print("berhenti")
                        self.petComponentSprite!.agent!.behavior!.setWeight(0, for: self.seekGoal!)
                        self.petComponentSprite!.agent!.behavior!.setWeight(100, for: self.stopGoal)
        }
    }
    
    func setTrackingAgent(location : CGPoint) {
        self.trackingAgent?.position = vector_float2(Float(location.x), Float(location.y))
    }
    func petMoveEnded() {
        self.petComponentSprite!.removeAllActions()
    }
    
   
    
    override func willExit(to nextState: GKState) {
        self.ball!.removeFromParent()
        lama = 0
        playTime = 0
        petMoveEnded()
        tabrak=false
        self.ball?.visualAgent?.removeFromParent()
       
    }
    
   
}

