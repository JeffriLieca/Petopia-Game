//
//  Toy.swift
//  Petopia
//
//  Created by Michelle Swastika on 03/06/24.
//

import GameplayKit

class Toy: GKEntity {
    let name: String
    let fill: Int
    
    init(name: String, fill: Int) {
        self.name = name
        self.fill = fill
        super.init()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
