//
//  DeadState.swift
//  Petopia
//
//  Created by Jeffri Lieca H on 10/06/24.
//

import Foundation
import GameplayKit

class DeadState : GameState {
    var petComponentSprite : PetAgentNode?
    
    init(entity:PetEntity, game:GameScene) {
        super.init(entity: entity, game: game)
        
        //pindah Sprite
        self.petComponentSprite = self.entity.component(ofType: PetSpriteComponent.self)?.sprite
        self.petComponentSprite!.zPosition = -(self.petComponentSprite?.position.y)!
       
        
    }
    
    override func didEnter(from previousState: GKState?) {
        self.petComponentSprite?.setDiem(diem: true)
        self.petComponentSprite!.setDrawTrails(draw: false)
        self.petComponentSprite?.removeAllActions()
        self.petComponentSprite?.texture = self.petComponentSprite!.deadFrame
        self.petComponentSprite?.shadow?.position = CGPoint(x: 0, y: -10)
       
    }
    
    override func willExit(to nextState: GKState) {
        
        self.petComponentSprite?.texture = self.petComponentSprite!.normalFrame
        self.petComponentSprite?.shadow?.position = CGPoint(x: 0, y: -self.petComponentSprite!.size.height/2 + 20)
    }
}
