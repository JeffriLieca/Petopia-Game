//
//  FlyIntellifenceComponent.swift
//  Petopia
//
//  Created by Jeffri Lieca H on 04/06/24.
//

import Foundation
import GameplayKit

class FlyIntelligenceComponent : GKComponent{
    var stateMachine: GKStateMachine

    var game : GameScene
    var fly : FlyEntity
    

    init( game: GameScene, fly: FlyEntity, coheredPet:PetAgentNode) {
        self.game = game
        self.fly = fly
        let flying = FlyingState(entity:self.fly , game: self.game, coheredPet: coheredPet)
//        let jump = JumpingState(entity:self.pet , game: self.game)
        
        self.stateMachine = GKStateMachine(states: [flying])
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func update(deltaTime seconds: TimeInterval) {
//        print("Fly Intel Component updated")
        self.stateMachine.update(deltaTime: seconds)
    }
    
}
