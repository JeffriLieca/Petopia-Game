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
//    var cohoredAgent : PetEntity
    
    init(sprite: FlyAgentNode, size: CGSize) {
    
        self.sprite = sprite
        self.sprite.size = size
//        self.cohoredAgent = cohoredAgent
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    override func update(deltaTime seconds: TimeInterval) {
//        print ("Fly Sprite Component")
//    }
    
    func SetHidden (hidden:Bool){
        self.sprite.isHidden = hidden
//        self.sprite.scale(to: CGSize(width: 0, height: 0))
    }
}
