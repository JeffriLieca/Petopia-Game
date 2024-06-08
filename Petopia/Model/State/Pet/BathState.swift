//
//  BathState.swift
//  Petopia
//
//  Created by Jeffri Lieca H on 06/06/24.
//


import Foundation
import GameplayKit

class BathState : GameState {
    
    var petComponentSprite : PetAgentNode?
//    var walkingParticle : SKEmitterNode?
    var soap : SoapAgentNode?
    var totalTime : TimeInterval = 0
    var walkingParticle : SKEmitterNode?
    var keluar : Bool = false
    var totalMakan = 0
    var ubah = false
    var lagimandi = false
    var targetVisual : SKShapeNode?
    var lineAgent : SKShapeNode?
    var sudahMandi : Bool = false
    var isDragging : Bool = false
    var locationDrag : CGPoint?
    var jumlahBubble : Int = 0
    
    init(entity:PetEntity, game:GameScene) {
        super.init(entity: entity, game: game)
       
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
        
//        let soap = SoapAgentNode (scene: game, position: CGPoint(x: game.frame.maxX - 100, y: game.frame.minY + 150), size: CGSize(width: 100,height: 100))
        let soap = SoapAgentNode (scene: game, position: CGPoint(x: game.frame.midX, y: game.frame.minY+150), size: CGSize(width: 100,height: 100))
        
        self.soap = soap
        self.totalTime = 0
        self.sudahMandi = false
        self.isDragging = false
        self.jeda = 0
        self.jumlahBubble = 0
        self.keluar = false
        self.ubah = false
        
        self.game.addChild(soap)
//        var kotak = self.soap?.frame.intersects(petComponentSprite!.frame)
        self.petComponentSprite!.useWalkAnimation()
        
        self.petComponentSprite!.setDrawTrails(draw: true)
        
        self.petComponentSprite!.agent!.behavior = GKBehavior()
        self.petComponentSprite!.agent!.mass = 0.01
        self.petComponentSprite!.agent!.delegate = self.petComponentSprite!
        self.petComponentSprite!.agent!.maxSpeed = 200
        self.petComponentSprite!.agent!.maxAcceleration = 50
        self.petComponentSprite!.agent!.speed = 50
        
        self.petComponentSprite!.agent!.behavior!.setWeight(10, for: GKGoal(toSeekAgent: (self.soap?.agent!)!))
        
        gambarRute()

        
//        setDrawTrails(draw: true)
//        self.petComponentSprite?.agent?.behavior?.removeAllGoals()
//        self.petComponentSprite?.agent = GKAgent2D()
        
        self.petComponentSprite?.physicsBody?.isDynamic = false
        self.petComponentSprite?.physicsBody?.isResting = true
        self.petComponentSprite?.physicsBody?.collisionBitMask=0
        self.soap?.physicsBody?.collisionBitMask = 0
        self.soap?.physicsBody?.isDynamic = false
        self.soap?.physicsBody?.isResting = true
    
       
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
        self.lagimandi = false
        self.totalTime = 0
    }
    
    var jeda : TimeInterval = 0
    var lastLoc : CGPoint = CGPoint(x: 0, y: 0)
    
    override func update(deltaTime seconds: TimeInterval) {
        
        
        
        self.petComponentSprite!.zPosition = -(self.petComponentSprite?.position.y)!
        
        // ke tempat mandi
        
        let moveDifference = CGPoint(x: (self.soap!.position.x) - self.petComponentSprite!.position.x, y: (self.soap!.position.y)  - self.petComponentSprite!.position.y + 30)
        let distanceToMove = sqrt(moveDifference.x * moveDifference.x + moveDifference.y * moveDifference.y)
        
        //        if distanceToMove <= 150 {
        //            let moveAction = SKAction.move(to: CGPoint(x: (self.food?.position.x)!, y: (self.food?.position.y)!), duration: 1)
        //            self.petComponentSprite?.run(moveAction)
        //
        //        }
        print("distance to move : \(distanceToMove)")
        
        if !ubah {
            if distanceToMove <= 1 {
                self.petComponentSprite?.position = CGPoint(x: (self.soap?.position.x)!, y: (self.soap?.position.y)! + 30)
                self.petComponentSprite?.setDiem(diem: true)
                self.petComponentSprite!.setDrawTrails(draw: false)                //                self.entity.component(ofType: PetIntelligenceComponent.self)?.stateMachine.enter(EatingState.self)
                ubah = true
                
            }
            else if distanceToMove <= 50 {
                let moveAction = SKAction.move(to: CGPoint(x: (self.soap?.position.x)!, y: (self.soap?.position.y)! + 30), duration: 1)
                self.petComponentSprite?.run(moveAction)
                self.petComponentSprite?.setDiem(diem: true)
                totalTime+=seconds
                self.petComponentSprite!.setDrawTrails(draw: false)
            }
        }
        else
        {
            if !lagimandi {
                self.petComponentSprite?.removeAllActions()
                self.petComponentSprite?.texture = self.petComponentSprite!.normalFrame
                lagimandi = true
            }
            else {
                if sudahMandi{
                    totalTime += seconds
                    
                    if (totalTime >= 8){
                        
                        
                        self.entity.component(ofType: PetIntelligenceComponent.self)?.stateMachine.enter(WalkingState2.self)
                    }
                }
                else {
                    if isDragging{
                        if jeda >= 0.1
                        {
                            if lastLoc == self.soap!.position {
                                
                            }
                            else{
                                if !(jumlahBubble >= 200){
                                    visualizeOverlap()
                                    jeda = 0
                                }
                                else{
                                    sudahMandi = true
//                                    removeBubblesWithAnimation()
                                    let removeBubble = SKAction.run {
                                        self.removeBubblesWithAnimation()
                                    }
                                    let fadeOutAction = SKAction.fadeOut(withDuration: 1.5)
                                       let removeAction = SKAction.removeFromParent()
                                    let sequenceAction = SKAction.sequence([fadeOutAction, removeAction,removeBubble])
                                    self.soap!.run(sequenceAction)                            }
                                
                                lastLoc = self.soap!.position
                            }
                           
                            
                        }
                    
                        jeda += seconds
                        
                        
                    }
                    
                }
                
            }
            
            
            
        }
        self.petComponentSprite!.agent!.update(deltaTime: seconds)
        //            print("Agent Walk point \(self.petComponentSprite!.agent!.position)")
        //            print("Sprite Walk point \(self.petComponentSprite!.position)")
        
        
//        calculateOverlapArea()
        
        
        
        
        
    }
    func setSudahMandi (sudah:Bool) {
        self.sudahMandi = sudah
    }
   
    override func willExit(to nextState: GKState) {
//        setDrawTrails(draw: false)
        self.petComponentSprite!.setDrawTrails(draw: false)
        self.petComponentSprite?.physicsBody?.isDynamic = true
        self.soap?.removeAllChildren()
        self.soap?.removeFromParent()
        self.petComponentSprite?.setDiem(diem: false)
        
        self.petComponentSprite?.physicsBody?.isDynamic = true
        self.petComponentSprite?.physicsBody?.isResting = false
        self.petComponentSprite?.physicsBody?.collisionBitMask=self.petComponentSprite!.petCategory
        self.soap?.physicsBody?.collisionBitMask = 0
        self.soap?.physicsBody?.isDynamic = true
        self.soap?.physicsBody?.isResting = false
//        self.food?.agent?.behavior?.removeAllGoals()
//        self.walkingParticle!.removeFromParent()
        
        self.lineAgent?.removeFromParent()
        self.targetVisual?.removeFromParent()
        
        
        self.petComponentSprite?.removeAllChildren()
        self.soap?.visualAgent?.removeFromParent()
        self.game.flies?.removeComponent(ofType: FlySpriteComponent.self)
        self.game.flies?.component(ofType: FlySpriteComponent.self)?.sprite.removeFromParent()
//        self.petComponentSprite?.children.removeAll(where: posit)
    }
    
    func gambarRute() {
        // Misalkan kamu memiliki agent dan target sebagai GKAgent
        let targetPosition = CGPoint(x: CGFloat((self.soap?.agent!.position.x)!), y: CGFloat((self.soap?.agent!.position.y)!))

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
   
    
    func setDragging (location : CGPoint)
    {
        if !sudahMandi{
            self.soap?.position = location
        }
    }
    
    func calculateOverlapArea() -> CGRect? {
        if self.soap!.intersects(self.petComponentSprite!) {
            let intersection = self.soap!.frame.intersection(self.petComponentSprite!.frame)
            return intersection
        }
        return nil
    }
    
//    var walkingParticle : SKEmitterNode?
    
    
    func visualizeOverlap() {
        print("visualize")
        if let overlapArea = calculateOverlapArea() {
            // Hapus node overlap lama jika sudah ada
            self.petComponentSprite!.childNode(withName: "overlapArea")?.removeFromParent()
            
            
            // Buat dan tambahkan node baru untuk area overlap
            let overlapNode = SKShapeNode(rect: overlapArea)
            overlapNode.fillColor = SKColor.red.withAlphaComponent(0.2)
            overlapNode.strokeColor = SKColor.clear
            overlapNode.zPosition = 10000000  // Pastikan node ini di atas yang lain
            overlapNode.name = "overlapArea"
            
            
            for i in 1...Int.random(in: 1...5){
                let bubbleOverLap = createRandomSizeBubble()
                bubbleOverLap.alpha = CGFloat.random(in: 0...0.3)
                bubbleOverLap.zPosition = 10000000
                bubbleOverLap.name = "bubble"
                var sizeRandom = GKRandomDistribution(lowestValue: 10, highestValue: 30)
                let angka = sizeRandom.nextInt()
                
                var jarakRandom = GKRandomDistribution(lowestValue: -30, highestValue: 30)
                bubbleOverLap.size = CGSize(width: angka, height: angka)
                bubbleOverLap.position = CGPoint(x:  CGFloat(jarakRandom.nextInt()), y: CGFloat(jarakRandom.nextInt()) )
                self.petComponentSprite!.addChild(bubbleOverLap)
                jumlahBubble += 1
            }
            
            // Konfigurasi partikel untuk menempel pada node overlap
            let walkingParticle = SKEmitterNode(fileNamed: "SmokeParticle")
            walkingParticle?.zPosition = 10000000000
            walkingParticle?.particleBirthRate = 15
            walkingParticle?.particleSize = CGSize(width: overlapArea.width, height: overlapArea.height)
          

            // Tambahkan partikel sebagai child dari overlapNode
            overlapNode.addChild(walkingParticle!)
            
            // Tambahkan overlapNode ke game scene atau petComponentSprite
//            self.game.addChild(bubbleOverLap)
        } else {
            // Hapus node overlap jika tidak ada penindihan
            self.petComponentSprite!.childNode(withName: "overlapArea")?.removeFromParent()
        }
    }
    
    func createRandomSizeBubble() -> SKSpriteNode {
        // Memuat texture dari gambar "bubble"
        let texture = SKTexture(imageNamed: "bubble")
        
        // Membuat sprite node dengan texture tersebut
        let bubbleNode = SKSpriteNode(texture: texture)
        
        // Mengatur ukuran acak antara 0.5x hingga 1.5x dari ukuran asli
        let randomScaleFactor = CGFloat.random(in: 0.5...1.5)
        bubbleNode.size = CGSize(width: texture.size().width * randomScaleFactor,
                                 height: texture.size().height * randomScaleFactor)
        
        return bubbleNode
    }

    func removeBubblesWithAnimation() {
        // Ambil semua node bubble dari pet
        guard let pet = self.petComponentSprite else { return }
        let bubbles = pet.children.filter { $0.name == "bubble" }

        // Urutkan bubble berdasarkan posisi Y dari yang tertinggi ke terendah
        let sortedBubbles = bubbles.sorted { $0.position.y > $1.position.y }

        // Menghapus bubble satu per satu dari atas ke bawah
        for (index, bubble) in sortedBubbles.enumerated() {
            let delay = TimeInterval(index) * 0.01  // Menambahkan delay untuk setiap bubble
            let scaleDown = SKAction.scale(to: 0.1, duration: 0.3)
            let changeColor = SKAction.colorize(with: .white, colorBlendFactor: 1.0, duration: 0.2)
            let fadeOut = SKAction.fadeOut(withDuration: 0.5)
            let remove = SKAction.removeFromParent()
            let sequence = SKAction.sequence([SKAction.wait(forDuration: delay), scaleDown, changeColor, fadeOut, remove])

            bubble.run(sequence)
        }
    }


}

