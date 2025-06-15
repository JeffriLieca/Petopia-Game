//
//  PetSpriteComponent.swift
//  Petopia
//
//  Created by Jeffri Lieca H on 04/06/24.
//

import Foundation
import GameplayKit

class PetSpriteComponent : GKComponent{
    
    var sprite : PetAgentNode
    
    init(sprite: PetAgentNode, size: CGSize) {
        self.sprite = sprite
        self.sprite.size = size
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
