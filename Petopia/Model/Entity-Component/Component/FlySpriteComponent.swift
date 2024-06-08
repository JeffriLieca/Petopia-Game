//
//  FlySpriteComponent.swift
//  Petopia
//
//  Created by Jeffri Lieca H on 04/06/24.
//

import Foundation
import GameplayKit

class FlySpriteComponent : GKComponent{
    
    var sprite : FlyAgentNode
    
    init(sprite: FlyAgentNode, size: CGSize) {
    
        self.sprite = sprite
        self.sprite.size = size
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
