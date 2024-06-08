//
//  GameState.swift
//  Petopia
//
//  Created by Jeffri Lieca H on 04/06/24.
//

import Foundation
import GameplayKit

class GameState : GKState {
    
    var entity : GKEntity
    var game : GameScene
    
    init(entity: GKEntity, game:GameScene) {
        self.entity = entity
        self.game = game
    }
}
