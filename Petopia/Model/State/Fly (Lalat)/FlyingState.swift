//
//  FlyingState.swift
//  Petopia
//
//  Created by Jeffri Lieca H on 04/06/24.
//

import Foundation
import GameplayKit

class FlyingState : GameState {
    var coheredPet : PetAgentNode
    var flyComponentSprite : FlyAgentNode?
    var updateTime : TimeInterval = 0

    init(entity:FlyEntity, game : GameScene, coheredPet:PetAgentNode) {
       
        self.coheredPet=coheredPet
        super.init(entity: entity, game: game)
        
        self.flyComponentSprite = self.entity.component(ofType: FlySpriteComponent.self)!.sprite
        self.flyComponentSprite!.useFlyAnimation()
        
        setAgent()
        
        self.flyComponentSprite!.zPosition = -(self.flyComponentSprite?.position.y)!
     
    }
    
    func setAgent() {
        self.flyComponentSprite!.agent = GKAgent2D()
        self.flyComponentSprite!.agent!.delegate = self.flyComponentSprite
        self.flyComponentSprite!.agent!.maxSpeed = 100
        self.flyComponentSprite!.agent!.maxAcceleration = 50
        self.flyComponentSprite!.agent!.mass = 0.2
        self.flyComponentSprite!.agent!.behavior = GKBehavior()
//        self.flyComponentSprite!.agent?.behavior = GKBehavior(goal: GKGoal(toWander: 10), weight: 1)
//        self.flyComponentSprite!.agent?.behavior?.setWeight(10, for: GKGoal(toWander: 10))
        self.flyComponentSprite!.agent?.behavior?.setWeight(20, for: GKGoal(toCohereWith: [(self.coheredPet.agent!)], maxDistance: 10000, maxAngle: Float(Double.pi)))
    }
    
    
    override func update(deltaTime seconds: TimeInterval) {
        
        print("Fly agent point : \(self.flyComponentSprite?.agent?.position)")
        print("Cohered agent point : \(self.coheredPet.position)")
        
        self.flyComponentSprite!.agent?.update(deltaTime: seconds)
        
        self.flyComponentSprite!.zPosition = -(self.flyComponentSprite?.position.y)!
       
      
        
        self.updateTime += seconds
        if (updateTime >= 30){
            self.updateTime = 0
//            print("reset")
           setAgent()
        }
    }
    
    override func didEnter(from previousState: GKState?) {
        setAgent()
    }
}

