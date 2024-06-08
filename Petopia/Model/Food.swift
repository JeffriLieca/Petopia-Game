//
//  Food.swift
//  Petopia
//
//  Created by Michelle Swastika on 30/05/24.
//

import GameplayKit

class Food: GKEntity {
    let name: String
    let type: Int
    let fill: Int
    
    init(name: String, type: Int, fill: Int) {
        self.name = name
        self.type = type
        self.fill = fill
        super.init()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
