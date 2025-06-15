//
//  Pet.swift
//  Petopia
//
//  Created by Jeffri Lieca H on 02/06/24.
//

import Foundation
import GameplayKit

enum PetType {
    case tiger, panda, elephant
}

class PetEntity : GKEntity {
//    static let shared : PetEntity() // Singleton instance
    
    var size :CGSize?
    var agentSystem : GKComponentSystem<GKComponent>?
    var intelligenceSystem : GKComponentSystem<GKComponent>?
    // Tambahan
    var name: String
    var type: PetType
    var birthDate: Date
    var age: TimeInterval {
        return Date().timeIntervalSince(birthDate)
    }
    var dead = false
    
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
    
    var hungerTime : TimeInterval?
    var thirstTime : TimeInterval?
    var happinessTime : TimeInterval?
    var energyTime : TimeInterval?
    var hygieneTime : TimeInterval?
//    var stateMachineComponent: PetStateMachineComponent
    
    init(size: CGSize? = CGSize(width: 200, height: 200), name: String, type: PetType, agentSystem: GKComponentSystem<GKComponent>, intelligenceSystem: GKComponentSystem<GKComponent>) {
        self.size = size
        self.agentSystem = agentSystem
        self.intelligenceSystem = intelligenceSystem
        self.name = name
        self.type = type
        self.birthDate = Date()
        self.hungerLevel = 60 //100 for full, 0 for hungry
        self.thirstLevel = 55 //100 for not thirsty, 0 for thirsty
        self.happinessLevel = 80
        self.energyLevel = 100
        self.hygieneLevel = false //true for clean, false for dirty
        
        super.init()
        
        self.hungerTime = 0
        self.thirstTime = 0
        self.happinessTime = 0
        self.energyTime = 0
        self.hygieneTime = 0
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
//    init(size: Int, agentSystem: GKComponentSystem<GKComponent>) {
//        self.size = size
//        self.agentSystem = agentSystem
//    }
    
    var totalTime : TimeInterval = 0
    
    override func update(deltaTime seconds: TimeInterval) {
        if !dead {
            totalTime += seconds
            agentSystem?.update(deltaTime: seconds)
            //        self.happinessLevel -= 1
            //        print ("dari pet entity")
            //        self.intelligenceSystem?.update(deltaTime: seconds)
            self.component(ofType: PetIntelligenceComponent.self)?.update(deltaTime: seconds)
            
            self.hungerTime!+=seconds
            updateHunger()
            self.thirstTime!+=seconds
            updateThirst()
            self.happinessTime!+=seconds
            updateHappiness()
            self.energyTime!+=seconds
            updateEnergy()
            self.hygieneTime!+=seconds
            updateHygiene()
        }
        else{
//            self.component(ofType: PetSpriteComponent.self)?.sprite.texture = self.component(ofType: PetSpriteComponent.self)?.sprite.deadFrame
            self.component(ofType: PetIntelligenceComponent.self)?.stateMachine.enter(DeadState.self)
        }
        
    }
    
    func tambahHunger(tambah:Int) {
        self.hungerLevel += tambah
    }
    
    func updateHunger () {
        if self.hungerTime! >= 60{
            self.hungerTime = 0
            self.hungerLevel -= 1
            self.hungerLevel = cekLimitHunger()
        }
    }
    
    func cekHunger () {
        if self.hungerLevel <= 50 {
            // notif
        }
    }
    
    func cekLimitHunger () -> Int {
        if self.hungerLevel >= 100
        {
            return 100
        }
        else if self.hungerLevel <= 0
        {
            self.dead = true
            return 0
        }
        else {
            return self.hungerLevel
        }
    }
    
    func tambahThirst(tambah:Int) {
        self.thirstLevel += tambah
    }
    
    func updateThirst () {
        if self.thirstTime! >= 60{
            self.thirstTime = 0
            self.thirstLevel -= 1
            self.thirstLevel = cekLimitThirst()
        }
    }
    
    func cekThirst () {
        if self.thirstLevel <= 50 {
            // notif
        }
    }
    
    func cekLimitThirst () -> Int {
        if self.thirstLevel >= 100
        {
            return 100
        }
        else if self.thirstLevel <= 0
        {
            self.dead = true
            return 0
        }
        else {
            return self.thirstLevel
        }
    }
    
    func tambahHappiness(tambah:Int) {
        self.happinessLevel += tambah
    }
    
    func updateHappiness () {
        if self.happinessTime! >= 60{
            self.happinessTime = 0
            self.happinessLevel -= 1
            self.happinessLevel = cekLimitHappiness()
        }
    }
    
    func cekHappiness () {
        if self.happinessLevel <= 50 {
            // notif
        }
    }
    
    func cekLimitHappiness () -> Int {
        if self.happinessLevel >= 100
        {
            return 100
        }
        else if self.happinessLevel <= 0
        {
            return 0
        }
        else {
            return self.happinessLevel
        }
    }
    
    func tambahEnergy(tambah:Int) {
        self.energyLevel += tambah
    }
    
    func updateEnergy () {
        if self.energyTime! >= 30{
            self.energyTime = 0
            self.energyLevel -= 1
            self.energyLevel = cekLimitEnergy()
        }
    }
    
    func cekEnergy () {
        if self.energyLevel <= 50 {
            // notif
        }
    }
    
    func cekLimitEnergy () -> Int {
        if self.energyLevel >= 100
        {
            return 100
        }
        else if self.energyLevel <= 0
        {
            return 0
        }
        else {
            return self.energyLevel
        }
    }
    
    func cekHygiene() {
        if self.hygieneLevel == false {
            
        }
    }
    
    func updateHygiene() {
        if self.hygieneTime! >= 60{
            self.hygieneLevel = false
        }
    }
    
}
