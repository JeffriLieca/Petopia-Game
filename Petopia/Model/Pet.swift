//
//  Pet.swift
//  Petopia
//
//  Created by Michelle Swastika on 30/05/24.
//

import Foundation
import GameplayKit

enum PetType {
    case tiger, panda, elephant
}

class Pet: GKEntity {
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
    var stateMachineComponent: PetStateMachineComponent
    
    init(name: String, type: PetType) {
        self.name = name
        self.type = type
        self.birthDate = Date()
        self.hungerLevel = 100 //100 for full, 0 for hungry
        self.thirstLevel = 100 //100 for not thirsty, 0 for thirsty
        self.happinessLevel = 100
        self.energyLevel = 100
        self.hygieneLevel = true //true for clean, false for dirty
        
        // Initiate the states
        let normalState = NormalState()
        let idleState = IdleState()
        let pokedState = PokedState()
        let playingState = PlayingState()
        let walkingState = WalkingState4()
        let deadState = DeadState()
        let hungryState = HungryState()
        let eatingState = EatingState2()
        let dirtyState = DirtyState()
        let sleepingState = SleepingState()
        let bathingState = BathingState()
        
        self.stateMachineComponent = PetStateMachineComponent(states: [
            normalState,
            idleState,
            pokedState,
            playingState,
            walkingState,
            deadState,
            hungryState,
            eatingState,
            dirtyState,
            sleepingState,
            bathingState
        ])
        
        super.init()
        
        (normalState as! PetState).pet = self
        (idleState as! PetState).pet = self
        (pokedState as! PetState).pet = self
        (playingState as! PetState).pet = self
        (walkingState as! PetState).pet = self
        (deadState as! PetState).pet = self
        (hungryState as! PetState).pet = self
        (eatingState as! PetState).pet = self
        (dirtyState as! PetState).pet = self
        (sleepingState as! PetState).pet = self
        (bathingState as! PetState).pet = self
        
        addComponent(stateMachineComponent)
        stateMachineComponent.stateMachine.enter(NormalState.self)
        
        // Start the update loop for decreasing levels
        startLevelDecreaseLoop()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateAge() {
        // Age is automatically calculated from the birth date
    }
    
    func startLevelDecreaseLoop() {
        let decreaseInterval: TimeInterval = 300.0 // Decrease levels every 10 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + decreaseInterval) { [weak self] in
            guard let self = self else { return }
            self.decreaseLevels()
            self.startLevelDecreaseLoop() // Recursively start the loop again
        }
    }
    
    func decreaseLevels() {
        decreaseHungerLevel()
        decreaseThirstLevel()
        decreaseHappinessLevel()
        decreaseEnergyLevel()
        decreaseHygieneLevel()
    }
    
    func decreaseHungerLevel() {
        hungerLevel -= 1
        if hungerLevel <= 40 {
            stateMachineComponent.stateMachine.enter(HungryState.self)
        }
        if hungerLevel < 0 {
            hungerLevel = 0
        }
    }
        
    func decreaseThirstLevel() {
        thirstLevel -= 1
        if thirstLevel < 0 {
            thirstLevel = 0
        }
    }
        
    func decreaseHappinessLevel() {
        happinessLevel -= 1
        if happinessLevel < 0 {
            happinessLevel = 0
        }
    }
        
    func decreaseEnergyLevel() {
        energyLevel -= 1
        if energyLevel <= 20 {
            sleep()
        }
        if energyLevel < 0 {
            energyLevel = 0
        }
    }
        
    func decreaseHygieneLevel() {
        // Example logic: hygiene level decreases randomly
        let random = Int.random(in: 1...10)
        if random <= 2 { // 20% chance to become dirty
            hygieneLevel = false
        }
    }
    
    func feed(food: Food) {
        stateMachineComponent.stateMachine.enter(EatingState.self)
        hungerLevel += food.fill
        
        if hungerLevel >= 100 {
            hungerLevel = 100
        }
    }
    
    func giveDrink(drink: Drink) {
        thirstLevel += drink.fill
        if thirstLevel >= 100 {
            thirstLevel = 100
        }
    }
    
    func play(toy:Toy) {
        stateMachineComponent.stateMachine.enter(PlayingState.self)
        happinessLevel += toy.fill
        if happinessLevel >= 100 {
            happinessLevel = 100
        }
    }
    
    func sleep() {
        stateMachineComponent.stateMachine.enter(SleepingState.self)
        energyLevel += 20
        if energyLevel >= 100 {
            energyLevel = 100
        }
    }
    
    func bath() {
        stateMachineComponent.stateMachine.enter(BathingState.self)
        hygieneLevel = true
    }
    
    func pooping() {
        let random = Int.random(in: 1...10)
        if random <= 2 { // 20% chance to poop
            // Handle pooping
        }
    }
}

class PetState: GKState {
    weak var pet: Pet?
    
    init(pet: Pet? = nil) {
        self.pet = pet
        super.init()
    }
    
    // Override methods as needed
}

class NormalState: PetState {
    override func didEnter(from previousState: GKState?) {
        // Handle entering the normal state
        // Update the UI, trigger animations, or log events.
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass is IdleState.Type
            || stateClass is NormalState.Type
            || stateClass is PokedState.Type
            || stateClass is PlayingState.Type
            || stateClass is WalkingState4.Type
            || stateClass is DeadState.Type
            || stateClass is HungryState.Type
            || stateClass is EatingState.Type
            || stateClass is DirtyState.Type
            || stateClass is SleepingState.Type
            || stateClass is BathingState.Type
    }
}

class IdleState: PetState {
    override func didEnter(from previousState: GKState?) {
        // Handle entering the hungry state
        // Update the UI, trigger animations, or log events.
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass is NormalState.Type
            || stateClass is IdleState.Type
            || stateClass is PokedState.Type
            || stateClass is PlayingState.Type
            || stateClass is WalkingState4.Type
            || stateClass is DeadState.Type
            || stateClass is HungryState.Type
            || stateClass is EatingState.Type
            || stateClass is DirtyState.Type
            || stateClass is SleepingState.Type
            || stateClass is BathingState.Type
    }
}

class PokedState: PetState {
    override func didEnter(from previousState: GKState?) {
        // Handle entering the hungry state
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass is NormalState.Type
            || stateClass is DeadState.Type
    }
}

class PlayingState: PetState {
    override func didEnter(from previousState: GKState?) {
        // Handle entering the hungry state
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass is NormalState.Type
    }
}

class WalkingState4: PetState {
    override func didEnter(from previousState: GKState?) {
        // Handle entering the hungry state
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass is NormalState.Type
            || stateClass is PokedState.Type
            || stateClass is WalkingState4.Type
            || stateClass is PlayingState.Type
            || stateClass is HungryState.Type
            || stateClass is EatingState.Type
            || stateClass is DirtyState.Type
            || stateClass is SleepingState.Type
            || stateClass is BathingState.Type
    }
}

class DeadState: PetState {
    override func didEnter(from previousState: GKState?) {
        // Handle entering the hungry state
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass is DeadState.Type
    }
}

class HungryState: PetState {
    override func didEnter(from previousState: GKState?) {
        // Handle entering the hungry state
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass is HungryState.Type
            || stateClass is EatingState.Type
            || stateClass is DirtyState.Type
            || stateClass is BathingState.Type
    }
}

class EatingState2: PetState {
    override func didEnter(from previousState: GKState?) {
        // Handle entering the happy state
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass is NormalState.Type
            || stateClass is DeadState.Type
            || stateClass is HungryState.Type
            || stateClass is EatingState.Type
            || stateClass is DirtyState.Type
            || stateClass is SleepingState.Type
    }
}

class DirtyState: PetState {
    override func didEnter(from previousState: GKState?) {
        // Handle entering the happy state
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass is NormalState.Type
            || stateClass is IdleState.Type
            || stateClass is PokedState.Type
            || stateClass is PlayingState.Type
            || stateClass is WalkingState4.Type
            || stateClass is DeadState.Type
            || stateClass is HungryState.Type
            || stateClass is EatingState.Type
            || stateClass is DirtyState.Type
            || stateClass is SleepingState.Type
            || stateClass is BathingState.Type
    }
}

class SleepingState: PetState {
    override func didEnter(from previousState: GKState?) {
        // Handle entering the happy state
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass is NormalState.Type
            || stateClass is PokedState.Type
            || stateClass is SleepingState.Type
    }
}

class BathingState: PetState {
    override func didEnter(from previousState: GKState?) {
        // Handle entering the happy state
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass is NormalState.Type
            || stateClass is HungryState.Type
            || stateClass is SleepingState.Type
            || stateClass is BathingState.Type

    }
}
