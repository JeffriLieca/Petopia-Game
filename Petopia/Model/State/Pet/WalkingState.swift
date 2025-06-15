//
//  WalkingState.swift
//  Petopia
//
//  Created by Jeffri Lieca H on 04/06/24.
//

import Foundation
import GameplayKit

class WalkingState2 : GameState {
    
    var petComponentSprite : PetAgentNode?
    var walkingParticle : SKEmitterNode?
    var TotalTime : TimeInterval = 0
    var obstacle : [GKObstacle]?
    var avoidGoal : GKGoal?
    
    init(entity:PetEntity, game:GameScene) {
        super.init(entity: entity, game: game)
        
        //pindah Sprite
        self.petComponentSprite = self.entity.component(ofType: PetSpriteComponent.self)?.sprite
        self.petComponentSprite?.useWalkAnimation()
       
        self.petComponentSprite!.zPosition = -(self.petComponentSprite?.position.y)!
        
       
    }
    
    func setAgent (){
//        self.petComponentSprite!.agent = GKAgent2D()
        self.petComponentSprite!.agent!.mass = 0.01
        self.petComponentSprite!.agent!.position = vector_float2(x: Float(self.petComponentSprite!.position.x), y: Float(self.petComponentSprite!.position.y))
        self.petComponentSprite!.agent!.delegate = self.petComponentSprite!
        self.petComponentSprite!.agent!.maxSpeed = 500
        self.petComponentSprite!.agent!.maxAcceleration = 200
        self.petComponentSprite!.agent?.behavior?.setWeight(1, for: GKGoal(toWander: 10))
    }
    
    
    override func didEnter(from previousState: GKState?) {
//        setAgent()
        
        self.petComponentSprite!.useWalkAnimation()
        self.petComponentSprite!.setDrawTrails(draw: true)
//
//        self.petComponentSprite!.agent = GKAgent2D()
        self.petComponentSprite!.agent!.behavior = GKBehavior()
        self.petComponentSprite!.agent!.mass = 0.01
        self.petComponentSprite!.agent!.delegate = self.petComponentSprite!
        self.petComponentSprite?.agent?.position = vector_float2(x: Float(self.petComponentSprite!.position.x), y: Float(self.petComponentSprite!.position.y))
        self.petComponentSprite!.agent!.maxSpeed = 100
        self.petComponentSprite!.agent!.maxAcceleration = 50
        self.petComponentSprite!.agent?.radius = Float((self.petComponentSprite?.size.width)!/2)
        self.petComponentSprite!.agent?.behavior?.setWeight(1, for: GKGoal(toWander: 10))
//        
        
//        let circleShape = SKShapeNode(circleOfRadius: 200)
//        circleShape.fillColor = SKColor.red
//        circleShape.lineWidth = 2
//        circleShape.zPosition = 1000
//        circleShape.position = CGPoint(x: self.game.frame.midX, y: self.game.frame.midY )
//        
//        self.game.addChild(circleShape)
//        let obstacle = GKCircleObstacle(radius: 200)
//        obstacle.position = vector_float2(x: Float(circleShape.position.x), y: Float(circleShape.position.y))
//        self.obstacle=[obstacle]
//        
//        let avoidGoal = GKGoal(toAvoid: self.obstacle!, maxPredictionTime: 1)
//        self.avoidGoal = avoidGoal
//        self.petComponentSprite!.agent!.behavior!.setWeight(100, for: avoidGoal)

    }
    
    
    override func update(deltaTime seconds: TimeInterval) {
//       
        
        self.TotalTime+=seconds
        
        if TotalTime > 3 {
//            TotalTime = 0
//            self.petComponentSprite!.agent!.behavior = GKBehavior()
//            self.petComponentSprite!.agent?.behavior?.setWeight(1, for: GKGoal(toWander: 10))
        }
       
        if (self.petComponentSprite?.agent?.position.x)! < Float(self.petComponentSprite!.position.x)
        {
            self.petComponentSprite!.xScale = abs(self.petComponentSprite!.xScale) * -1
            
        }
        else{
            self.petComponentSprite!.xScale = abs(self.petComponentSprite!.xScale)
        }

        self.petComponentSprite!.agent!.update(deltaTime: seconds)
//        print("Agent Walk point \(self.petComponentSprite!.agent!.position)")
//        print("Sprite Walk point \(self.petComponentSprite!.position)")
        
        self.petComponentSprite!.zPosition = -(self.petComponentSprite?.position.y)!
    }
   
    override func willExit(to nextState: GKState) {
        self.petComponentSprite!.setDrawTrails(draw: false)
    }
    
    
}

