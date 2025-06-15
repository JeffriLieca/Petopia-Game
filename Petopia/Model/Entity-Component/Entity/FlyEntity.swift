//
//  FlyEntity.swift
//  Petopia
//
//  Created by Jeffri Lieca H on 04/06/24.
//

import Foundation
import GameplayKit

class FlyEntity : GKEntity {
    var size :Int?
    var agentSystem : GKComponentSystem<GKComponent>?
    var intelligenceSystem : GKComponentSystem<GKComponent>?
    
    init(size: Int? = 50, agentSystem: GKComponentSystem<GKComponent>, intelligenceSystem: GKComponentSystem<GKComponent>) {
        self.size = size
        self.agentSystem = agentSystem
        self.intelligenceSystem = intelligenceSystem
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func update(deltaTime seconds: TimeInterval) {
//        self.agentSystem?.update(deltaTime: seconds)
        self.component(ofType: FlyIntelligenceComponent.self)?.update(deltaTime: seconds)
//        self.intelligenceSystem?.update(deltaTime: seconds)
    }
}
