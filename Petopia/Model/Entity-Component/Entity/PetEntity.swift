//
//  Pet.swift
//  Petopia
//
//  Created by Jeffri Lieca H on 02/06/24.
//

import Foundation
import GameplayKit

enum PetTypenya {
    case tiger, panda, elephant
}

class PetEntity : GKEntity {
    var size :CGSize?
    var agentSystem : GKComponentSystem<GKComponent>?
    // Tambahan
    var name: String
    var type: PetType
    var birthDate: Date
    var age: TimeInterval {
        return Date().timeIntervalSince(birthDate)
    }
    
    var formattedAge: String {
            let calendar = Calendar.current
            let ageComponents = calendar.dateComponents([.year, .month], from: birthDate, to: Date())
            if let years = ageComponents.year, years >= 1 {
                return "\(years) year\(years > 1 ? "s" : "")"
            } else if let months = ageComponents.month {
                return "\(months) month\(months > 1 ? "s" : "")"
            } else {
                return "0 months"
            }
        }
    
    var hungerLevel: Int
    var thirstLevel: Int
    var happinessLevel: Int
    var energyLevel: Int
    var hygieneLevel: Bool
//    var stateMachineComponent: PetStateMachineComponent
    
    init(size: CGSize? = CGSize(width: 200, height: 200), name: String, type: PetType, agentSystem: GKComponentSystem<GKComponent>? = nil) {
        self.size = size
        self.agentSystem = agentSystem
        self.name = name
        self.type = type
        self.birthDate = Date()
        self.hungerLevel = 100 //100 for full, 0 for hungry
        self.thirstLevel = 100 //100 for not thirsty, 0 for thirsty
        self.happinessLevel = 100
        self.energyLevel = 100
        self.hygieneLevel = true //true for clean, false for dirty
        
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
//    init(size: Int, agentSystem: GKComponentSystem<GKComponent>) {
//        self.size = size
//        self.agentSystem = agentSystem
//    }
}
