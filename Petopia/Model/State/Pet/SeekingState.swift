//
//  SeekingState.swift
//  Petopia
//
//  Created by Jeffri Lieca H on 04/06/24.
//

import Foundation
import GameplayKit

class SeekingState : GameState {
    
    var seekGoal : GKGoal?
    var trackingAgent: GKAgent2D?
    var seeking : Bool?
    var petComponentSprite : PetAgentNode?
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
        
//        self.seekingParticle = SKEmitterNode(fileNamed: "SmokeParticle")
//        self.seekingParticle?.position=CGPointMake( 0 , 0 - self.petComponentSprite!.size.height/2)
//        self.seekingParticle?.zPosition = -1
//        self.seekingParticle?.targetNode = game
//        self.seekingParticle?.particleBirthRate = 15
//        self.seekingParticle?.particleSize = CGSize(width: self.petComponentSprite!.size.width/2, height: self.petComponentSprite!.size.width/2)
//        self.seekingParticle!.particlePositionRange=CGVectorMake(self.petComponentSprite!.size.width/2,0)
//        self.petComponentSprite!.addChild(self.seekingParticle!)
        
        self.petComponentSprite!.agent = GKAgent2D()
    
        
       setAgent()
        
        
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
        
        self.petComponentSprite!.useWalkAnimation()
        self.petComponentSprite!.agent!.behavior = GKBehavior()
        self.petComponentSprite!.agent!.mass = 0.01
        self.petComponentSprite!.agent!.delegate = self.petComponentSprite!
        self.petComponentSprite!.agent!.maxSpeed = 300
        self.petComponentSprite!.agent!.maxAcceleration = 200
        self.petComponentSprite!.agent!.speed = 50
        
//        self.petComponentSprite!.agent!.behavior?.setWeight(100, for: GKGoal(toAvoid: self.obstacle!, maxPredictionTime: 10))
        
       
//        self.petComponentSprite!.agent!.behavior?.setWeight(10000, for: GKGoal(toAvoid: self.obstacless!, maxPredictionTime: 1))
        
       
        
    }
    
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
        
        self.petComponentSprite!.agent!.update(deltaTime: seconds)
        
        
        if (self.petComponentSprite?.agent?.position.x)! < Float(self.petComponentSprite!.position.x)
        {
            self.petComponentSprite!.xScale = abs(self.petComponentSprite!.xScale) * -1
            
        }
        else{
            self.petComponentSprite!.xScale = abs(self.petComponentSprite!.xScale)
        }

        self.petComponentSprite!.zPosition = -(self.petComponentSprite?.position.y)!
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
    func penguinMoveEnded() {
        self.petComponentSprite!.removeAllActions()
    }
    
    
    
    override func willExit(to nextState: GKState) {
//        setDrawTrails(draw: false)
        penguinMoveEnded()
    }
    
   
}

