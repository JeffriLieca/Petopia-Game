//
//  PetStateMachineComponent.swift
//  Petopia
//
//  Created by Michelle Swastika on 03/06/24.
//

import GameplayKit

class PetStateMachineComponent: GKComponent {
    let stateMachine: GKStateMachine
    
    init(states: [GKState]) {
        self.stateMachine = GKStateMachine(states: states)
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        stateMachine.update(deltaTime: seconds)
        
        // Update the pet's age
        if let pet = (stateMachine.currentState as? PetState)?.pet {
            pet.updateAge()
        }
    }
}
