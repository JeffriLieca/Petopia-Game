//
//  WalkingState.swift
//  Petopia
//
//  Created by Jeffri Lieca H on 04/06/24.
//

import Foundation
import GameplayKit

class DrinkingState : GameState {
    
    var petComponentSprite : PetAgentNode?
//    var walkingParticle : SKEmitterNode?
    var foodName : FoodName?
    var food : FoodAgentNode?
    var totalTime : TimeInterval = 0
    var walkingParticle : SKEmitterNode?
    var keluar : Bool = false
    var totalMakan = 0
    var ubah = false
    var lagimakan = false
    var targetVisual : SKShapeNode?
    var lineAgent : SKShapeNode?
    
    init(entity:PetEntity, game:GameScene, foodName:FoodName = FoodName.chicken) {
        super.init(entity: entity, game: game)
        self.foodName = foodName
        //pindah Sprite
        self.petComponentSprite = self.entity.component(ofType: PetSpriteComponent.self)?.sprite
        self.petComponentSprite?.useWalkAnimation()
       
        self.petComponentSprite!.zPosition = -(self.petComponentSprite?.position.y)!
//        
//        self.walkingParticle = SKEmitterNode(fileNamed: "SmokeParticle")
//        self.walkingParticle?.position=CGPointMake( 0 , 0 - self.petComponentSprite!.size.height/2)
//        self.walkingParticle?.zPosition = -1
////        self.target(forAction: Selector, withSender: <#T##Any?#>)
//        self.walkingParticle?.targetNode = game
//        self.walkingParticle?.particleBirthRate = 15
//        self.walkingParticle?.particleSize = CGSize(width: self.petComponentSprite!.size.width/2, height: self.petComponentSprite!.size.width/2)
//        self.walkingParticle!.particlePositionRange=CGVectorMake(self.petComponentSprite!.size.width/2,0)
//        self.petComponentSprite!.addChild(self.walkingParticle!)
        
       
    }
    
//    func setAgent (){
//        self.petComponentSprite!.agent = GKAgent2D()
//        self.petComponentSprite!.agent!.mass = 0.01
//        self.petComponentSprite!.agent!.position = vector_float2(x: Float(CGRectGetMidX(self.game.frame)), y: Float(CGRectGetMidY(self.game.frame)))
//        self.petComponentSprite!.agent!.delegate = self.petComponentSprite!
//        self.petComponentSprite!.agent!.maxSpeed = 500
//        self.petComponentSprite!.agent!.maxAcceleration = 200
//        self.petComponentSprite!.agent?.behavior?.setWeight(1, for: GKGoal(toWander: 100))
//    }
    
    
    override func didEnter(from previousState: GKState?) {
        let food = FoodAgentNode(scene: game, position: CGPoint(x: game.frame.midX, y: game.frame.minY+150), nama: self.foodName! , size: CGSize(width: 100,height: 100))
        self.food = food
        self.totalTime = 0
        
        self.game.addChild(food)
        
        self.petComponentSprite!.useWalkAnimation()
        self.petComponentSprite!.setDrawTrails(draw: true)
        
        self.petComponentSprite!.agent!.behavior = GKBehavior()
        self.petComponentSprite!.agent!.mass = 0.01
        self.petComponentSprite!.agent!.delegate = self.petComponentSprite!
        self.petComponentSprite!.agent!.maxSpeed = 200
        self.petComponentSprite!.agent!.maxAcceleration = 50
        self.petComponentSprite!.agent!.speed = 50
        self.petComponentSprite!.agent!.behavior!.setWeight(100, for: GKGoal(toSeekAgent: (self.food?.agent!)!))
        
//        gambarRute()

        
//        setDrawTrails(draw: true)
//        self.petComponentSprite?.agent?.behavior?.removeAllGoals()
//        self.petComponentSprite?.agent = GKAgent2D()
        
//        self.petComponentSprite?.physicsBody?.isDynamic = false
//        self.petComponentSprite?.physicsBody?.isResting = true
//        self.petComponentSprite?.physicsBody?.collisionBitMask=0
        self.food?.physicsBody?.collisionBitMask = 0
        self.food?.physicsBody?.categoryBitMask = 0
        self.food?.physicsBody?.isDynamic = false
        self.food?.physicsBody?.isResting = true
        self.petComponentSprite?.setDiem(diem: false)

    
       
//        self.petComponentSprite?.position = self.food!.position
//        self.petComponentSprite?.agent?.position = vector_float2(x: Float(self.petComponentSprite!.position.x), y: Float(self.petComponentSprite!.position.y))
//        let eatAction = SKAction.run {
//            self.petComponentSprite?.animateEat()
//            self.totalMakan += 1
//            print("Eating. Total eaten: \(self.totalMakan)")
//        }
//        let changeFoodFrameAction = SKAction.run {
//            self.food?.goToNextFrame()
//        }
//        
//        let changeStateAction = SKAction.run {
//            print("State changed.")
//            self.entity.component(ofType: PetIntelligenceComponent.self)?.stateMachine.enter(EatingState.self)}
//
//        let sequence = SKAction.sequence([
//            eatAction,
//            SKAction.wait(forDuration: 1), // Tambahkan delay jika perlu
//            changeFoodFrameAction,
//            changeStateAction
//        ])
//
//
//
//        
//        if self.petComponentSprite?.position == CGPoint(x: (self.food?.position.x)!, y: (self.food?.position.y)! + 30) {
////            self.petComponentSprite?.animateEat()
////            totalMakan += 1
//            self.petComponentSprite?.run(sequence)
//            
//        }
        
        self.keluar = false
        self.totalMakan = 0
        self.ubah = false
        self.lagimakan = false
    }
    
    
    override func update(deltaTime seconds: TimeInterval) {
        
        
        
        self.petComponentSprite!.zPosition = -(self.petComponentSprite?.position.y)!
        
        // ke tempat makan
        
        let moveDifference = CGPoint(x: (self.food?.position.x)! - self.petComponentSprite!.position.x, y: (self.food?.position.y)!  - self.petComponentSprite!.position.y + 30)
        let distanceToMove = sqrt(moveDifference.x * moveDifference.x + moveDifference.y * moveDifference.y)
        
        //        if distanceToMove <= 150 {
        //            let moveAction = SKAction.move(to: CGPoint(x: (self.food?.position.x)!, y: (self.food?.position.y)!), duration: 1)
        //            self.petComponentSprite?.run(moveAction)
        //
        //        }
//        print("distance to move : \(distanceToMove)")
        
        if !ubah {
            if distanceToMove <= 1 {
                self.petComponentSprite?.position = CGPoint(x: (self.food?.position.x)!, y: (self.food?.position.y)! + 30)
                self.petComponentSprite?.setDiem(diem: true)
                self.petComponentSprite!.setDrawTrails(draw: false)                //                self.entity.component(ofType: PetIntelligenceComponent.self)?.stateMachine.enter(EatingState.self)
//                self.game.flies?.component(ofType: FlyIntelligenceComponent.self)?.stateMachine.state(forClass: FlyingState.self)?.flyComponentSprite?.setHidden()
                self.game.flies?.component(ofType: FlyIntelligenceComponent.self)?.stateMachine.enter(FlyingState.self)
//                self.flyComponentSprite?.setHidden()
                
                ubah = true
                
            }
            else if distanceToMove <= 50 {
                let moveAction = SKAction.move(to: CGPoint(x: (self.food?.position.x)!, y: (self.food?.position.y)! + 30), duration: 0.02 * distanceToMove)
                self.petComponentSprite?.run(moveAction)
                self.petComponentSprite?.setDiem(diem: true)
                totalTime+=seconds
                self.petComponentSprite!.setDrawTrails(draw: false)
            }
        }
        else
        {
            if !lagimakan {
                let eatAction = SKAction.run {
                    self.petComponentSprite?.animateEat()
                    self.totalMakan += 1
                    print("Eating. Total eaten: \(self.totalMakan)")
                }
                let changeFoodFrameAction = SKAction.run {
                    self.food?.goToNextFrame()
                }
                
                let changeStateAction = SKAction.run {
                    print("State changed.")
                    self.entity.component(ofType: PetIntelligenceComponent.self)?.stateMachine.enter(WalkingState2.self)
                    self.keluar = true
                }
                
                let sequence = SKAction.repeat(SKAction.sequence([
                    eatAction,
                    SKAction.wait(forDuration: 1), // Tambahkan delay jika perlu
                    changeFoodFrameAction
                ]),count: 3)
                self.food?.run(SKAction.sequence([sequence,SKAction.removeFromParent()]))
//                self.food?.run(SKAction.removeFromParent())
                self.petComponentSprite?.run(SKAction.sequence([sequence,changeStateAction]))
//                self.game.run(changeStateAction)
                //                self.petComponentSprite?.run(sequence)
                //                self.petComponentSprite?.run(sequence)
                lagimakan = true
                totalTime = 0
//                self.keluar = true
            }
            else {
                totalTime += seconds
                if (totalTime>=4 ){
                    self.keluar = true
                }
            }
            if self.keluar {
                self.entity.component(ofType: PetIntelligenceComponent.self)?.stateMachine.enter(WalkingState2.self)
            }
        }
        
        
        
        //        if totalTime >= 0.5 {
        //            self.petComponentSprite?.animateEat()
        //
        //        }
        
        //            var sampek = false
        //            print ("Eating State")
        //
        //            if (self.petComponentSprite?.agent?.position.x)! < Float(self.petComponentSprite!.position.x)
        //            {
        //                self.petComponentSprite!.xScale = abs(self.petComponentSprite!.xScale) * -1
        //
        //            }
        //            else{
        //                self.petComponentSprite!.xScale = abs(self.petComponentSprite!.xScale)
        //            }
        //
                    self.petComponentSprite!.agent!.update(deltaTime: seconds)
        //            print("Agent Walk point \(self.petComponentSprite!.agent!.position)")
        //            print("Sprite Walk point \(self.petComponentSprite!.position)")
        
        
        
        
        
        
    }
   
    override func willExit(to nextState: GKState) {
//        setDrawTrails(draw: false)
        self.petComponentSprite!.setDrawTrails(draw: false)
        self.petComponentSprite?.physicsBody?.isDynamic = true
        self.food?.removeFromParent()
        self.petComponentSprite?.setDiem(diem: false)
        
        self.petComponentSprite?.physicsBody?.isDynamic = true
        self.petComponentSprite?.physicsBody?.isResting = false
        self.petComponentSprite?.physicsBody?.collisionBitMask=self.petComponentSprite!.petCategory
        self.food?.physicsBody?.collisionBitMask = 0
        self.food?.physicsBody?.isDynamic = true
        self.food?.physicsBody?.isResting = false
//        self.food?.agent?.behavior?.removeAllGoals()
//        self.walkingParticle!.removeFromParent()
        
        self.lineAgent?.removeFromParent()
        self.targetVisual?.removeFromParent()
        
        self.game.setStatusFill(for: self.game.childNode(withName: "hunger_frame")! as! SKSpriteNode, with: self.game.pet!.hungerLevel)
//        self.entity  = self.entity as! PetEntity
//        self.entity.hungerLevel += 20
        if self.keluar {
            self.game.pet?.tambahHunger(tambah: 20)
        }
    }
    
    func gambarRute() {
        // Misalkan kamu memiliki agent dan target sebagai GKAgent
        let targetPosition = CGPoint(x: CGFloat((self.food?.agent!.position.x)!), y: CGFloat((self.food?.agent!.position.y)!))

        // Membuat visual untuk target
        let targetVisual = SKShapeNode(circleOfRadius: 10)
        targetVisual.fillColor = SKColor.red
        targetVisual.position = targetPosition
        self.targetVisual = targetVisual
            game.addChild(targetVisual)

        // Opsi: Menggambar garis dari agent ke target
        let path = CGMutablePath()
        path.move(to: CGPoint(x: CGFloat((self.petComponentSprite?.agent!.position.x)!), y: CGFloat((self.petComponentSprite?.agent!.position.y)!)))
        path.addLine(to: targetPosition)
    

        let line = SKShapeNode(path: path)
        line.strokeColor = SKColor.blue
        line.lineWidth = 2
        self.lineAgent = line
            game.addChild(line)
    }
}

