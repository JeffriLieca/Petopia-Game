//
//  PetNode.swift
//  Petopia
//
//  Created by Michelle Swastika on 03/06/24.
//

import SpriteKit

class PetNode: SKSpriteNode {
    var pet: Pet
    
    init(pet: Pet) {
        self.pet = pet
        let texture = SKTexture(imageNamed: "tiger_sprite") // Replace with actual image asset
        super.init(texture: texture, color: .clear, size: texture.size())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update() {
        removeAllChildren()
        
        // Optionally, display the pet's age
        let ageLabel = SKLabelNode(text: "Age: \(pet.formattedAge)")
        ageLabel.position = CGPoint(x: 0, y: -self.size.height / 2 - 20)
        ageLabel.fontSize = 12
        ageLabel.fontColor = .black
        addChild(ageLabel)
    }
}
