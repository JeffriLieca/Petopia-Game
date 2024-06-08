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
    
    init(size: Int? = 50, agentSystem: GKComponentSystem<GKComponent>? = nil) {
        self.size = size
        self.agentSystem = agentSystem
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
