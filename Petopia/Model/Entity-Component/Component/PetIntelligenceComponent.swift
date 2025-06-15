//
//  PetIntelligenceComponent.swift
//  Petopia
//
//  Created by Jeffri Lieca H on 04/06/24.
//

import Foundation
import GameplayKit

class PetIntelligenceComponent : GKComponent{
    var stateMachine: GKStateMachine

    var game : GameScene
    var pet : PetEntity
    
//
    init( game: GameScene, pet: PetEntity) {
        self.game = game
        self.pet = pet
        
        let walk = WalkingState2(entity:self.pet , game: self.game)
        let seek = SeekingState(entity:self.pet , game: self.game)
        let ball = PlayingBallState(entity:self.pet , game: self.game)
        let eat = EatingState(entity:self.pet , game: self.game)
        let bath = BathState(entity:self.pet , game: self.game)
        let wand = PlayingWandState(entity:self.pet , game: self.game)
        let dead = DeadState(entity: self.pet, game: self.game)
//        let idle = IdleState(entity:self.pet , game: self.game)
        
        self.stateMachine = GKStateMachine(states: [walk,seek,ball,eat,bath,wand,dead])
        super.init()
        print("init State")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        self.stateMachine.update(deltaTime: seconds)
        print("PetIntelligenceComponent")
    }
    
}

