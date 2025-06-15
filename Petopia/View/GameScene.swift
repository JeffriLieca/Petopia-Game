//
//  GameScene.swift
//  Petopia
//
//  Created by Jeffri Lieca H on 04/06/24.
//

import SpriteKit
import GameplayKit

class GameScene : SKScene, SKPhysicsContactDelegate {
    var pet : PetEntity?
    var petSprite : PetAgentNode?
    var coba : SKSpriteNode?
    var flies : FlyEntity?
    var intelligenceSystem : GKComponentSystem<GKComponent>?
    var flyIntelligenceSystem : GKComponentSystem<GKComponent>?
    var agentSystem : GKComponentSystem<GKComponent>?
    var trackingAgent : GKAgent2D?
    var entities = [GKEntity]()
    var graphs = [String : GKGraph]()
    
    private var lastUpdateTime : TimeInterval = 0
    private var dt : TimeInterval = 0
    private var label : SKLabelNode?
    
    var boundaries : [GKObstacle]?
    let petCategory: UInt32 = 0x1 << 0
    let ballCategory: UInt32 = 0x1 << 1
    let wallCategory: UInt32 = 0x1 << 2
    
    var agentVisual : SKSpriteNode?
    var isDragging : Bool = false
    
    var menu : [String] = []
    
    override init(size: CGSize){
        super.init(size: size)
        
        let background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: size.width/2, y: size.height/2)
        background.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        background.zPosition = -100000
        background.size.height = frame.height
        background.size.width = frame.width
        self.addChild(background)
        
//        let window = SKSpriteNode(imageNamed: "jendela")
//        window.position = CGPoint(x: size.width/2, y: size.height/2 + 200)
//        window.anchorPoint = CGPoint(x: 0.5, y: 0.5)
//        window.zPosition = -10000
//        window.size.height = 300
//
//        window.size.width = frame.width
        
        let windowTexture = SKTexture(imageNamed: "jendela")
        let window = SKSpriteNode(texture: windowTexture)
        window.position = CGPoint(x: size.width / 2, y: size.height / 2 + 70)
        window.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        window.zPosition = -10000
        let targetHeight: CGFloat = 700
        let aspectRatio = windowTexture.size().width / windowTexture.size().height
        let calculatedWidth = targetHeight * aspectRatio

        window.size = CGSize(width: calculatedWidth, height: targetHeight)

        self.addChild(window)
        
        let carpetTexture = SKTexture(imageNamed: "karpet")
        let carpet = SKSpriteNode(texture: carpetTexture)
        carpet.position = CGPoint(x: size.width / 2, y: size.height / 2 + 70)
        carpet.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        carpet.zPosition = -10000
        let targetHeightCarpet: CGFloat = 800
        let aspectRatioCarpet = carpetTexture.size().width / carpetTexture.size().height
        let calculatedWidthCarpet = targetHeightCarpet * aspectRatioCarpet
        carpet.size = CGSize(width: calculatedWidthCarpet, height: targetHeightCarpet)
        self.addChild(carpet)
        
        let litterboxTexture = SKTexture(imageNamed: "litterbox")
        let litterbox = SKSpriteNode(texture: litterboxTexture)
       
        litterbox.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        litterbox.zPosition = -10000
        let targetHeightLitterbox: CGFloat = 170
        let aspectRatioLitterbox = litterboxTexture.size().width / litterboxTexture.size().height
        let calculatedWidthLitterbox = targetHeightLitterbox * aspectRatioLitterbox
        litterbox.size = CGSize(width: calculatedWidthLitterbox, height: targetHeightLitterbox)
        litterbox.position = CGPoint(x: self.frame.maxX - 10 - litterbox.size.width/2, y: self.frame.midY - 80)
        self.addChild(litterbox)


        let shopTexture = SKTexture(imageNamed: "shop")
        let shop = SKSpriteNode(texture: shopTexture)
        shop.position = CGPoint(x: self.frame.maxX - 60, y: self.frame.minY + 80)
        shop.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        shop.zPosition = 10000
        let targetHeightShop: CGFloat = 120
        let aspectRatioShop = shopTexture.size().width / shopTexture.size().height
        let calculatedWidthShop = targetHeightShop * aspectRatioShop
        shop.size = CGSize(width: calculatedWidthShop, height: targetHeightShop)
        self.addChild(shop)
    
        let coinBoxTexture = SKTexture(imageNamed: "coin_box")
        let coinBox = SKSpriteNode(texture: coinBoxTexture)
        coinBox.position = CGPoint(x: self.frame.minX + 80, y: self.frame.maxY - 100)
        coinBox.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        coinBox.zPosition = 10000
        let targetHeightCoinBox: CGFloat = 140
        let aspectRatioCoinBox = coinBoxTexture.size().width / coinBoxTexture.size().height
        let calculatedWidthCoinBox = targetHeightCoinBox * aspectRatioCoinBox
        coinBox.size = CGSize(width: calculatedWidthCoinBox, height: targetHeightCoinBox)
        
        let labelCoin = SKLabelNode(text: "100")
        labelCoin.zPosition = coinBox.zPosition + 10
        labelCoin.fontColor = SKColor.black
        labelCoin.fontSize = 25
        labelCoin.verticalAlignmentMode = .center
        labelCoin.horizontalAlignmentMode = .left
        labelCoin.position = CGPoint(x: 0, y: 5)
        labelCoin.fontName = "SFPro-Black"
        coinBox.addChild(labelCoin)
        self.addChild(coinBox)

        createInventNodes()
//        createShopNodes()
        makeOverlay()
        
        
        
//        let inventTexture = SKTexture(imageNamed: "invent")
//        let invent = SKSpriteNode(texture: inventTexture)
//        invent.position = CGPoint(x: self.frame.minX + 60, y: self.frame.minY + 80)
//        invent.anchorPoint = CGPoint(x: 0.5, y: 0.5)
//        invent.zPosition = 10000
//        let targetHeightInvent: CGFloat = 120
//        let aspectRatioInvent = inventTexture.size().width / inventTexture.size().height
//        let calculatedWidthInvent = targetHeightInvent * aspectRatioInvent
//        invent.size = CGSize(width: calculatedWidthInvent, height: targetHeightInvent)
//        self.addChild(invent)

//        let agentNode = SKSpriteNode(texture: self.petSprite?.texture)
//        agentNode.position = CGPoint(x: (self.petSprite?.position.x)!, y: (self.petSprite?.position.y)!) // Posisi awal
//        self.agentVisual = agentNode
//        self.addChild(agentNode)

        
        
        
        createAndShowSquareBoundaryObstacles(scene: self, margin: 0)
        
        
        let pet = PetEntity(name: "Mamang", type: PetType.tiger,agentSystem: GKComponentSystem(componentClass: GKAgent2D.self), intelligenceSystem: GKComponentSystem(componentClass: PetIntelligenceComponent.self))
        
//        let texture = skte
        let petSprite = PetAgentNode(scene: self, position: CGPoint(x: frame.midX, y: frame.midY-200), size: CGSize(width: 100, height: 100))
//        petSprite.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 200, height: 200))
//        petSprite.physicsBody = SKPhysicsBody(texture: petSprite.texture!, size: CGSize(width: 200, height: 200))
        
        petSprite.physicsBody?.allowsRotation = false
        petSprite.physicsBody?.affectedByGravity = false
        
        pet.addComponent(PetSpriteComponent(sprite: petSprite, size:  CGSize(width: 100, height: 100)))
//        self.intelligenceSystem = GKComponentSystem(componentClass: PetIntelligenceComponent.self)
        
        pet.addComponent(PetIntelligenceComponent(game: self, pet: pet))
        self.pet?.agentSystem?.addComponent(petSprite.agent!)
        
        self.pet = pet
        self.petSprite = petSprite
        self.petSprite?.name = "pet"
        
//        self.petSprite!.physicsBody =  SKPhysicsBody(texture: self.petSprite!.texture!, size: self.petSprite!.size)
        
        
    
//        self.agentSystem?.addComponent(petSprite.agent!)
        
        let fly = FlyEntity(agentSystem: GKComponentSystem(componentClass: GKAgent2D.self), intelligenceSystem: GKComponentSystem(componentClass: FlyIntelligenceComponent.self))
        
        let flySprite = FlyAgentNode(scene: self, position: CGPoint(x: (self.petSprite?.position.x)!, y: (self.petSprite?.position.y)!), size: CGSize(width: 20, height: 20))
        fly.addComponent(FlySpriteComponent(sprite: flySprite,size: CGSize(width: 20, height: 20)))
        fly.addComponent(FlyIntelligenceComponent(game: self, fly: fly, coheredPet: self.petSprite!))
        self.flies = fly
//        self.flies?.removeComponent(ofType: FlySpriteComponent.self)
//        self.flies?.component(ofType: FlySpriteComponent.self)?.sprite.isHidden = true
        flySprite.zPosition = -1
        self.flies?.agentSystem?.addComponent(flySprite.agent!)
        
//        self.intelligenceSystem = GKComponentSystem(componentClass: PetIntelligenceComponent.self)
//        self.flyIntelligenceSystem = GKComponentSystem(componentClass: FlyIntelligenceComponent.self)
       
        petSprite.physicsBody?.categoryBitMask = petCategory
        petSprite.physicsBody?.collisionBitMask = ballCategory
        
        let entityComponent = self.pet!.component(ofType: PetIntelligenceComponent.self)
        
        entityComponent!.stateMachine.enter(WalkingState2.self)
        
        self.flies!.component(ofType: FlyIntelligenceComponent.self)?.stateMachine.enter(FlyingState.self)
        
        self.agentSystem = GKComponentSystem(componentClass: GKAgent2D.self)
        agentSystem?.addComponent(flySprite.agent!)
//        agentSystem?.addComponent(petSprite.agent!)
        
//        self.pet?.agentSystem = self.agentSystem
        
        setupStatusBars()
//
        
        self.setStatusFill(for: self.childNode(withName: "hunger_frame")! as! SKSpriteNode, with: self.pet!.hungerLevel)
        self.setStatusFill(for: self.childNode(withName: "thirst_frame")! as! SKSpriteNode, with: self.pet!.thirstLevel)
        self.setStatusFill(for: self.childNode(withName: "happiness_frame")! as! SKSpriteNode, with: self.pet!.happinessLevel)
        self.setStatusFill(for: self.childNode(withName: "energy_frame")! as! SKSpriteNode, with: self.pet!.energyLevel)
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func sceneDidLoad() {
        self.physicsWorld.contactDelegate = self
        
        
        self.lastUpdateTime = 0
//        self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        
       

        
//        // Create player sprite
//        let sprite = SKSpriteNode(color: .cyan, size: CGSize(width: 50, height: 50))
//        sprite.position = CGPoint(x: frame.midX, y: frame.midY + 200)
//        sprite.zRotation = CGFloat.pi / 4
//        sprite.xScale = CGFloat(sqrt(0.5))
//        sprite.yScale = CGFloat(sqrt(0.5))
//        sprite.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 50, height: 50))
//        sprite.physicsBody?.collisionBitMask = 1
//        sprite.name = "buttonMakan"
//        
//        self.addChild(sprite)
//        
//        let sprite2 = SKShapeNode(circleOfRadius: 50)
//        sprite2.fillColor = SKColor.red
//        sprite2.position = CGPoint(x: frame.midX, y: frame.midY+200)
//        sprite2.zRotation = CGFloat.pi / 4
//        sprite2.zPosition = 10000
//        sprite2.physicsBody = SKPhysicsBody(circleOfRadius: sprite2.frame.width/2)
//        sprite2.physicsBody?.collisionBitMask = 1
//        sprite2.name = "button"
//        
//        self.addChild(sprite2)
        
//        let ball = SKSpriteNode(imageNamed: "ball")
//        ball.size = CGSize (width: 100, height: 100)
//        ball.position = CGPoint(x: frame.midX, y: frame.midY-400)
//        ball.zPosition = 10000000
//        ball.physicsBody = SKPhysicsBody(circleOfRadius: 50)
//        ball.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "ball"), size: ball.size)
//        ball.name = "ball"
//        ball.physicsBody?.restitution = 0.7
//        ball.physicsBody?.categoryBitMask = ballCategory
//        ball.physicsBody?.collisionBitMask = petCategory
//        ball.physicsBody?.contactTestBitMask = petCategory
//        self.addChild(ball)
        
        
//        // Inisialisasi pet
//               let pet = SKSpriteNode(color: .blue, size: CGSize(width: 50, height: 50))
//        pet.position = CGPoint(x: self.frame.midX, y: self.frame.midY-300)
//               pet.physicsBody = SKPhysicsBody(rectangleOf: pet.size)
//               pet.physicsBody?.categoryBitMask = petCategory
//               pet.physicsBody?.collisionBitMask = ballCategory
//               addChild(pet)
//
//               // Inisialisasi bola
//               let ball = SKSpriteNode(color: .red, size: CGSize(width: 30, height: 30))
//               ball.position = CGPoint(x: self.frame.midX, y: self.frame.midY-500)
//               ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width / 2)
//               ball.physicsBody?.categoryBitMask = ballCategory
//               ball.physicsBody?.collisionBitMask = petCategory
//               ball.physicsBody?.contactTestBitMask = petCategory
//               addChild(ball)
        
//        self.petSprite!.physicsBody =  SKPhysicsBody(texture: self.petSprite!.texture!, size: self.petSprite!.size)
        
        
        
        //        self.player?.agentSystem.co
        
        
        
        //        let obstacless = [addObstacle(at: CGPoint(x: 1000, y: 1000)),addObstacle(at: CGPoint(x: 2000, y: 2500))]
        //        petSprite.agent!.behavior?.setWeight(10000, for: GKGoal(toAvoid: obstacless, maxPredictionTime: 1))
        //            self.agentSystem?.addComponent(self.pet!.agent!)
        
        //        let circleShape = SKShapeNode(circleOfRadius: 50) // Pastikan nilai 'AAPLDefaultAgentRadius' didefinisikan
        //        circleShape.lineWidth = 2.5
        //        circleShape.fillColor = SKColor.gray
        //        circleShape.strokeColor = SKColor.red
        //        circleShape.zPosition = 1000000
        //        circleShape.position = CGPoint(x: 100, y: 100)
        //        self.scene!.addChild(circleShape)
        
//        let hungerFrameTexture = SKTexture(imageNamed: "hunger_frame")
//        let hungerFrame = SKSpriteNode(texture: hungerFrameTexture)
//        hungerFrame.position = CGPoint(x: frame.midX, y: frame.maxY - 100)  // Atur posisi
//        hungerFrame.zPosition = 1000000000  // Pastikan ini di atas fill
//        hungerFrame.size = CGSize(width: 50, height: 50)
//        self.addChild(hungerFrame)
//        // Asumsikan dimensi dan radius yang diinginkan untuk rounded rectangle
//        let frameSize = CGSize(width: 43, height: 40) // Contoh ukuran, sesuaikan dengan ukuran frame mu
//        let cornerRadius: CGFloat = 10.0  // Contoh radius sudut, sesuaikan dengan kebutuhan
//
//        // Membuat path untuk rounded rectangle
//        var bezierPath = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: frameSize.width, height: frameSize.height - 20), cornerRadius: cornerRadius)
//
//        // Membuat SKShapeNode dari path
//        let statusFill = SKShapeNode(path: bezierPath.cgPath)
//        statusFill.fillColor = SKColor.green  // Warna awal
//        statusFill.lineWidth = 0  // Jika kamu tidak ingin ada garis batas
//        statusFill.position = CGPoint(x:-frameSize.width/2, y:-frameSize.height/2)  // Posisikan agar tengah node ada di (0,0)
//        statusFill.zPosition = -1
//        hungerFrame.addChild(statusFill)
//        bezierPath = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: frameSize.width, height: frameSize.height - 20), cornerRadius: cornerRadius)
//        
//        let backgroundSize = CGSize(width: 200, height: 50)
////        let cornerRadius: CGFloat = 10.0
//
//        // Membuat background node
//        let background = SKShapeNode(path: UIBezierPath(roundedRect: CGRect(origin: CGPoint.zero, size: backgroundSize), cornerRadius: cornerRadius).cgPath)
//        background.fillColor = SKColor.gray  // Warna background
//        background.strokeColor = .clear
//       
//
//        // Membuat mask node
//        let maskNode = SKShapeNode(path: UIBezierPath(roundedRect: CGRect(origin: CGPoint.zero, size: backgroundSize), cornerRadius: cornerRadius).cgPath)
//        maskNode.fillColor = SKColor.white  // Warna harus putih untuk mask
//        maskNode.strokeColor = .clear
//        maskNode.position =  CGPoint(x: frame.midX + 100, y: frame.maxY - 100)
//        
//        // Membuat crop node
//        let cropNode = SKCropNode()
//        cropNode.maskNode = maskNode
//
//        // Membuat isi status fill
//        let fill = SKShapeNode(path: UIBezierPath(roundedRect: CGRect(origin: CGPoint.zero, size: backgroundSize), cornerRadius: cornerRadius).cgPath)
//        fill.fillColor = SKColor.green  // Warna isi
//        fill.strokeColor = .clear
//        cropNode.addChild(fill)
//
//        // Menambahkan crop node ke scene
//        background.addChild(cropNode)
//        addChild(background)

//        self.flies?.component(ofType: FlySpriteComponent.self)?.sprite.setHidden()
        
    }
    
    let shockWaveAction: SKAction = {
        let growAndFadeAction = SKAction.group([SKAction.scale(to: 50, duration: 0.5),
                                                SKAction.fadeOut(withDuration: 0.5)])
        
        let sequence = SKAction.sequence([growAndFadeAction,
                                          SKAction.removeFromParent()])
        
        return sequence
    }()


    func didBegin(_ contact: SKPhysicsContact) {
        var firstBody: SKPhysicsBody
               var secondBody: SKPhysicsBody

               if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
                   firstBody = contact.bodyA
                   secondBody = contact.bodyB
               } else {
                   firstBody = contact.bodyB
                   secondBody = contact.bodyA
               }
               
               if firstBody.categoryBitMask == petCategory && secondBody.categoryBitMask == ballCategory {
                   if let ball = secondBody.node as? SKSpriteNode, let pet = firstBody.node {
                       let collisionVector = CGVector(dx: ball.position.x - pet.position.x, dy: ball.position.y - pet.position.y)
                       let impulseVector = CGVector(dx: collisionVector.dx * 0.1, dy: collisionVector.dy * 0.1)
                       ball.physicsBody?.applyImpulse(impulseVector)
                      
                       
                   }
                   self.pet!.component(ofType: PetIntelligenceComponent.self)?.stateMachine.state(forClass: PlayingBallState.self)!.setNabrak()
               }
           
       
        
        if
                contact.bodyB.categoryBitMask == ballCategory || contact.bodyA.categoryBitMask == ballCategory
        {

            let shockwave = SKShapeNode(circleOfRadius: 1)


            shockwave.position = contact.contactPoint
            self.addChild(shockwave)
            
            shockwave.run(shockWaveAction)
        }
        
    }
    
    var totalTime : TimeInterval = 0
    override func update(_ currentTime: TimeInterval) {
       print ("jam sekarang: \(currentTime/3600)")
        if totalTime >= 10{
//            self.flies?.component(ofType: FlyIntelligenceComponent.self)?.stateMachine.state(forClass: FlyingState.self)?.flyComponentSprite?.isHidden = true
       
        }
        
        if lastUpdateTime>0 {
            dt = currentTime - lastUpdateTime
        }
        else{
            dt = 0
        }
        totalTime += dt
        self.lastUpdateTime = currentTime
        
//        self.intelligenceSystem!.update(deltaTime: dt)
//        self.flyIntelligenceSystem!.update(deltaTime: dt)
        self.flies!.update(deltaTime: dt)
        self.agentSystem!.update(deltaTime: dt)
        self.pet!.update(deltaTime: dt)
       
        self.lastUpdateTime = currentTime
        self.setStatusFill(for: self.childNode(withName: "hunger_frame")! as! SKSpriteNode, with: self.pet!.hungerLevel)
        self.setStatusFill(for: self.childNode(withName: "thirst_frame")! as! SKSpriteNode, with: self.pet!.thirstLevel)
        self.setStatusFill(for: self.childNode(withName: "happiness_frame")! as! SKSpriteNode, with: self.pet!.happinessLevel)
        self.setStatusFill(for: self.childNode(withName: "energy_frame")! as! SKSpriteNode, with: self.pet!.energyLevel)
       
    }
    
    func updatePhysicsBody() {
        if let currentTexture = self.petSprite!.texture {
            let newSize = CGSize(width: abs(self.petSprite!.size.width * self.petSprite!.xScale), height: self.petSprite!.size.height)
            self.petSprite!.physicsBody = SKPhysicsBody(texture: currentTexture, size: newSize)
        }
    }
    
    override func didFinishUpdate() {
//        self.petSprite!.physicsBody = SKPhysicsBody(texture: self.petSprite!.texture!, size: CGSize(width: 200, height: 200))
//        self.petSprite!.physicsBody =  SKPhysicsBody(texture: self.petSprite!.texture!, size: self.petSprite!.size)
//        updatePhysicsBody()
    }
    
    var initialTouchLocation: CGPoint?
    var isPoked = false
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard let touch = touches.first else { return }
        initialTouchLocation = touch.location(in: self)
        
        
        let entitynya = self.pet!
        var entityComponent = entitynya.component(ofType: PetIntelligenceComponent.self)
        
        //        if entityComponent!.stateMachine.currentState!.isKind(of: SeekingState.self){
        //            entityComponent!.stateMachine.enter(WalkingState2.self)
        //        }
        //        else{
        //            entityComponent!.stateMachine.enter(SeekingState.self)
        //
//                    self.pet!.component(ofType: PetIntelligenceComponent.self)?.stateMachine.state(forClass: SeekingState.self)!.setSeeking(seeking: true)
        //        }
        if entityComponent!.stateMachine.currentState!.isKind(of: BathState.self)
        {
            if ((childNode(withName: "soap")?.contains(touch.location(in: self))) != nil){
                isDragging = true
            }
        }
        else if entityComponent!.stateMachine.currentState!.isKind(of: WalkingState2.self){
            isPoked = true
        }
        else if entityComponent!.stateMachine.currentState!.isKind(of: PlayingWandState.self){
            self.pet!.component(ofType: PetIntelligenceComponent.self)?.stateMachine.state(forClass: PlayingWandState.self)!.setSeeking(seeking: true)
            
        }
        
        
        
    }
    
    var previousLocation = CGPoint()
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let entitynya = self.pet!
        var entityComponent = entitynya.component(ofType: PetIntelligenceComponent.self)
        
                var tracking = self.pet!.component(ofType: PetIntelligenceComponent.self)?.stateMachine.state(forClass: SeekingState.self)!
      var startLocation = initialTouchLocation
        
        
        
        for touch in touches {
            
            
            let loc = touch.location(in: self)
            let location = touch.location(in: self)
            
            
            if abs(location.x - startLocation!.x) < 10 && abs(location.y - startLocation!.y) < 10 {
                
            }
            else{
                isPoked = false
                
            }
            
            
            tracking?.setTrackingAgent(location: location)
            
            if entityComponent!.stateMachine.currentState!.isKind(of: BathState.self){
            
                self.pet!.component(ofType:
                                        PetIntelligenceComponent.self)?.stateMachine.state(forClass: BathState.self)?.isDragging = true
                self.pet!.component(ofType: PetIntelligenceComponent.self)?.stateMachine.state(forClass: BathState.self)?.setDragging(location: location)
            }
            else if entityComponent!.stateMachine.currentState!.isKind(of: PlayingWandState.self){
                self.pet!.component(ofType: PetIntelligenceComponent.self)?.stateMachine.state(forClass: PlayingWandState.self)?.setDragging(location: location)
            }
            
            
                
                
                
//                ((self.pet?.component(ofType: PetIntelligenceComponent.self)?.stateMachine.currentState?.isKind(of: PlayingBallState.self)) != nil){
//                self.pet!.component(ofType: PetIntelligenceComponent.self)?.stateMachine.state(forClass: PlayingWandState.self)?.setDragging(location: location)
//            }
            
            
//            if abs(location.x - (previousLocation.location(in: self).x)!) > 1 || abs(location.y - (previousLocation.location(in: self).y)!) > 1 {
//                
//                self.pet!.component(ofType:
//                                        PetIntelligenceComponent.self)?.stateMachine.state(forClass: BathState.self)?.isDragging = true
//            }
//            else {
//                previousLocation = touch
//                
//            }
//            
//            
//            if previousLocation?.location(in: self) != location
//            {
//                if isDragging {
//                    
//                    self.pet!.component(ofType: PetIntelligenceComponent.self)?.stateMachine.state(forClass: BathState.self)?.setDragging(location: location)
//                    
//                    self.pet!.component(ofType:
//                                            PetIntelligenceComponent.self)?.stateMachine.state(forClass: BathState.self)?.isDragging = true
//                }
//            }
        }
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        
        
//        self.pet!.component(ofType: PetIntelligenceComponent.self)?.stateMachine.state(forClass: SeekingState.self)!.setSeeking(seeking: false)
//        if ((self.pet?.component(ofType: PetIntelligenceComponent.self)?.stateMachine.currentState?.isKind(of: PlayingBallState.self)) != nil){
//            self.pet!.component(ofType: PetIntelligenceComponent.self)?.stateMachine.state(forClass: PlayingWandState.self)?.setSeeking(seeking: false)
//        }

        
        
        let entitynya = self.pet!
        
        var entityComponent = entitynya.component(ofType: PetIntelligenceComponent.self)
        
//        if entityComponent!.stateMachine.currentState!.isKind(of: WalkingState2.self){
//            
//            entityComponent!.stateMachine.enter(SeekingState.self)
//        }
//        else{
//            entityComponent!.stateMachine.enter(WalkingState2.self)
//        }
        
        guard let touch = touches.first, let startLocation = initialTouchLocation else { return }
           let endLocation = touch.location(in: self)
           
           // Cek jika sentuhan berakhir dekat dengan tempat dimulai (toleransi tap)
           if abs(endLocation.x - startLocation.x) < 10 && abs(endLocation.y - startLocation.y) < 10 {
               
               let touchedNode = atPoint(touch.location(in: self))
               
               if let nodeName = touchedNode.name, menu.contains(nodeName) {
                    switchToState(for: nodeName)
                }
               
//               else if let sprite2 = atPoint(endLocation) as? SKShapeNode, sprite2.name == "button" {
//                   entityComponent!.stateMachine.enter(EatingState.self)
////                   sprite2.removeFromParent()
//               }
//               else if let sprite = atPoint(endLocation) as? SKSpriteNode, sprite.name == "buttonMakan" {
//                   entityComponent!.stateMachine.enter(BathState.self)
//               }
               
               else if let spriteInvent = atPoint(endLocation) as? SKSpriteNode, spriteInvent.name == "invent" {
                   toggleAdditionalNodesVisibility()
                   
               }
           
               
               else {
//                   entityComponent!.stateMachine.enter(WalkingState2.self)
                   
                   if isPoked {
                       if touchedNode.name == "pet"{
                           
                           
                           self.petSprite?.animatePoked()
                           // Contoh mengatur status
                           //                       setStatusFill(for: self.childNode(withName: "nodenya")!.childNode(withName: "") as! SKSpriteNode, with: 75)  // Angka 75 adalah contoh status yang ingin diset
                       }
                   }
               }
               
               // Periksa apakah sentuhan berada pada salah satu label node
            
            
               
           }else {
               if entityComponent!.stateMachine.currentState!.isKind(of: BathState.self){
               
                   self.pet!.component(ofType:
                                           PetIntelligenceComponent.self)?.stateMachine.state(forClass: BathState.self)?.isDragging = true
                   self.pet!.component(ofType: PetIntelligenceComponent.self)?.stateMachine.state(forClass: BathState.self)?.isDragging = false
               }
               else if entityComponent!.stateMachine.currentState!.isKind(of: PlayingWandState.self){
                   self.pet!.component(ofType: PetIntelligenceComponent.self)?.stateMachine.state(forClass: PlayingWandState.self)?.setSeeking(seeking: false)
               }
           }
        
        
        isDragging = false
        
        
    }
    
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
//        self.pet!.component(ofType: PetIntelligenceComponent.self)?.stateMachine.state(forClass: SeekingState.self)!.setSeeking(seeking: false)
        
        let entitynya = self.pet!
        var entityComponent = entitynya.component(ofType: PetIntelligenceComponent.self)
        
        
//        if entityComponent!.stateMachine.currentState!.isKind(of: WalkingState2.self){
//            entityComponent!.stateMachine.enter(SeekingState.self)
//        }
//        else{
//            entityComponent!.stateMachine.enter(WalkingState2.self)
//        }
    }
    
   

    func createAndShowSquareBoundaryObstacles(scene: SKScene, margin: CGFloat) -> [GKPolygonObstacle] {
        let frame = scene.frame.insetBy(dx: margin, dy: margin)  // Mengurangi ukuran frame dengan margin yang ditentukan
        
        // Fungsi untuk membuat persegi panjang visual dan obstacle
        func createObstacleAndNode(rect: CGRect, color: UIColor) -> GKPolygonObstacle {
            let points = [
                vector_float2(Float(rect.minX), Float(rect.minY)),
                vector_float2(Float(rect.maxX), Float(rect.minY)),
                vector_float2(Float(rect.maxX), Float(rect.maxY)),
                vector_float2(Float(rect.minX), Float(rect.maxY))
            ]
            let obstacle = GKPolygonObstacle(points: points)
            
            
            let shapeNode = SKShapeNode(rect: rect)
//            shapeNode.strokeColor = color
            shapeNode.lineWidth = 0
//            shapeNode.fillColor = color  // Semi-transparent fill
            //            shapeNode.physicsBody = SKPhysicsBody(rectangleOf: rect.size)
            shapeNode.physicsBody = SKPhysicsBody(edgeLoopFrom: rect)
                        
//            shapeNode.physicsBody = SKPhysicsBody(rectangleOf: rect.size)
            shapeNode.physicsBody?.affectedByGravity = false
            shapeNode.physicsBody?.allowsRotation = false
//            shapeNode.physicsBody?.categoryBitMask = wallCategory
//            shapeNode.physicsBody?.collisionBitMask = petCategory | ballCategory
//            shapeNode.physicsBody?.isDynamic = false
            scene.addChild(shapeNode)
            let obs = GKObstacle()
            
            return obstacle
        }
        
        // Membuat persegi panjang untuk setiap sisi
        //        let topRect = CGRect(x: frame.minX, y: frame.maxY + margin, width: frame.width, height: margin)
        //        let bottomRect = CGRect(x: frame.minX, y: frame.minY, width: frame.width, height: margin)
        //        let leftRect = CGRect(x: frame.minX - margin, y: frame.minY, width: margin, height: frame.height + margin )
        //        let rightRect = CGRect(x: frame.maxX, y: frame.minY, width: margin, height: frame.height)
        
        
        let topRect = CGRect(x: self.frame.minX, y: self.frame.midY , width: self.frame.width, height: margin)
        let bottomRect = CGRect(x: self.frame.minX - margin, y: self.frame.minY-margin+50, width: self.frame.width, height: margin)
        let leftRect = CGRect(x: self.frame.minX , y: self.frame.minY, width: margin, height: frame.height*2 )
        let rightRect = CGRect(x: self.frame.maxX - margin, y: self.frame.minY, width: margin, height: frame.height*2)
        
        // Membuat dan menampilkan obstacles
        let obstacles = [
            createObstacleAndNode(rect: topRect, color: .red),
            createObstacleAndNode(rect: bottomRect, color: .red),
            createObstacleAndNode(rect: leftRect, color: .red),
            createObstacleAndNode(rect: rightRect, color: .red)
        ]
        
        return obstacles
    }
    
    func setupCoinBox () {
        let coinBox = SKSpriteNode(imageNamed: "coin_box")
    }
    
    func setupStatusBars() {
        let frameNames = ["hunger_frame", "thirst_frame", "happiness_frame", "energy_frame"]
        let warna = [SKColor.systemOrange,SKColor.systemCyan, SKColor.systemRed, SKColor.systemYellow]
        let frameSize = CGSize(width: 43, height: 40)
        let cornerRadius: CGFloat = 4
        let spacing: CGFloat = 60 // Jarak antar status bar
        let startYPosition = frame.maxY - 100 // Posisi Y awal untuk status bar pertama
        let startXPosition = frame.maxX - (CGFloat(frameNames.count) * spacing - spacing/3) // Menghitung posisi X awal agar terpusat

//        for (index, frameName) in frameNames.enumerated() {
//            // Memuat texture dan membuat sprite node untuk frame
//            let frameTexture = SKTexture(imageNamed: frameName)
//            let frameNode = SKSpriteNode(texture: frameTexture)
//            frameNode.size = CGSize(width: 50, height: 50)
//            frameNode.position = CGPoint(x: startXPosition + CGFloat(index) * spacing, y: startYPosition)
//            frameNode.zPosition = 1000000000
//
//            // Membuat path untuk rounded rectangle
////            let bezierPath = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: frameSize.width, height: frameSize.height), cornerRadius: cornerRadius)
//
//            // Membuat SKShapeNode untuk fill
////            let statusFill = SKShapeNode(path: bezierPath.cgPath)
//            let statusFill = SKShapeNode(rectOf:CGSize(width: 40, height: 40), cornerRadius: cornerRadius)
//            statusFill.fillColor = SKColor.green // Menggunakan warna yang sama untuk semua, bisa diubah sesuai kebutuhan
//            statusFill.lineWidth = 0
//            statusFill.position = CGPoint(x: 0, y: 0)
//            statusFill.zPosition = -1
//
//            // Menambahkan fill ke frame
//            frameNode.addChild(statusFill)
//
//            // Menambahkan frame ke scene
//            self.addChild(frameNode)
//        }
        
        for (index, frameName) in frameNames.enumerated() {
            let frameTexture = SKTexture(imageNamed: frameName)
            let frameNode = SKSpriteNode(texture: frameTexture)
            frameNode.size = CGSize(width: 60, height: 60)
            frameNode.position = CGPoint(x: startXPosition + CGFloat(index) * spacing, y: startYPosition)
            frameNode.zPosition = 1000000000
            frameNode.name = frameNames[index]

            // Membuat SKShapeNode untuk fill
            let statusFill = SKShapeNode(rectOf: CGSize(width: 42, height: 42), cornerRadius: cornerRadius)
            statusFill.fillColor = warna[index]
            statusFill.lineWidth = 0
//            statusFill.position = CGPoint(x: 0, y: -(frameNode!.size.height/2 - (statusFill!.frame.size + 10)/2))
            statusFill.position = CGPoint(x: 0, y: 4 - ((frameNode.size.height - 10)/2 - statusFill.frame.height/2 ) )
            statusFill.zPosition = -10
            statusFill.name = "statusFill"  // Menambahkan nama untuk memudahkan pencarian node ini nanti

            // Menambahkan statusFill sebagai child dari frameNode
            frameNode.addChild(statusFill)

            // Tambahkan frameNode ke scene atau parent node
            addChild(frameNode)
        }

    }
    // Contoh fungsi untuk mengatur status
    func setStatusFill(for frameNode: SKSpriteNode, with status: Int) {
        // Asumsi maksimum status adalah 100
        let normalizedStatus = CGFloat(status) / 100.0

        // Mengatur skala x dari statusFill berdasarkan status
        frameNode.children.forEach { node in
            if var statusNode = node as? SKShapeNode {
                statusNode.yScale = normalizedStatus
                statusNode.position = CGPoint(x: 0, y: 4 - ((frameNode.size.height - 10)/2 - statusNode.frame.height/2 ) )
            }
        }

        // Mengubah warna berdasarkan status
        let statusFill = frameNode.children.compactMap { $0 as? SKShapeNode }.first
//        statusFill?.fillColor = colorForStatus(status)
    }

//    // Fungsi untuk menentukan warna berdasarkan status
//    func colorForStatus(_ status: Int) -> SKColor {
//        switch status {
//        case 0..<25:
//            return SKColor.red
//        case 25..<50:
//            return SKColor.orange
//        case 50..<75:
//            return SKColor.yellow
//        case 75...100:
//            return SKColor.green
//        default:
//            return SKColor.gray
//        }
//    }
    
    var inventTextureClose : SKTexture?
    var inventTextureOpen : SKTexture?
    
    func createInventNodes() {
        self.inventTextureClose = SKTexture(imageNamed: "invent_close")
        self.inventTextureOpen = SKTexture(imageNamed: "invent_open")
        let invent = SKSpriteNode(texture: inventTextureClose)
//        invent.position = CGPoint(x: self.frame.minX + 30 , y: self.frame.minY + 40)
        invent.position = CGPoint (x: 0,y: 0)
        invent.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        invent.zPosition = 10000
        let targetHeightInvent: CGFloat = 120
        let aspectRatioInvent = inventTextureClose!.size().width / inventTextureClose!.size().height
        let calculatedWidthInvent = targetHeightInvent * aspectRatioInvent
        invent.size = CGSize(width: calculatedWidthInvent, height: targetHeightInvent)
        invent.name = "invent"
        

        // Membuat mainNode untuk menyimpan semua node
        let mainNode = SKSpriteNode()
        mainNode.position = CGPoint(x: self.frame.minX + 60 , y: self.frame.minY + 80)
        mainNode.name = "mainNode"
        mainNode.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        mainNode.zPosition = 10000
        self.addChild(mainNode)

        // Menambahkan invent ke mainNode
        mainNode.addChild(invent)

        // Membuat container untuk node tambahan
        let additionalNodesContainer = SKNode()
    additionalNodesContainer.name = "additionalNodesContainer"
        additionalNodesContainer.zPosition = invent.zPosition + 1
        mainNode.addChild(additionalNodesContainer)
        additionalNodesContainer.isHidden = true
        // Menambahkan empat node secara vertikal di atas invent
        let spacing: CGFloat = 10
        var nextNodePositionY = invent.size.height / 2 + 10 + spacing / 2

        var text = ["food","ball","wand","bath"]
        var imgText = ["butt_eat", "butt_ball", "butt_wand", "butt_soap"]
        
        self.menu=text
        self.menu.append("eat")
        self.menu.append("drink")
        self.menu.append("close")

        
        for i in 1...text.count{
            let texture = SKTexture(imageNamed: imgText[i-1])
//            let belakang = SKShapeNode(circleOfRadius: 30)
//            belakang.fillColor = SKColor.green
            
            
            let node = SKSpriteNode(texture: texture, size: CGSize(width: 70, height: 70))
//            let node = SKSpriteNode(color: SKColor.blue, size: CGSize(width: 30, height: 30))
            node.position = CGPoint(x: 0, y: nextNodePositionY)
            node.zPosition = invent.zPosition - 1
//            belakang.zPosition = node.zPosition - 10000
            additionalNodesContainer.addChild(node)
//            node.addChild(belakang)
            node.name = text[i-1]
            nextNodePositionY += node.size.height + spacing
            
            
        }
    }
    func toggleAdditionalNodesVisibility() {
        if let mainNode = self.childNode(withName: "mainNode"), let inventNode = mainNode.childNode(withName: "invent") as? SKSpriteNode,
           let additionalNodesContainer = mainNode.childNode(withName: "additionalNodesContainer") {
            
            additionalNodesContainer.isHidden = !additionalNodesContainer.isHidden
            if additionalNodesContainer.isHidden {
                inventNode.texture = self.inventTextureClose
            }
            else{
                inventNode.texture = self.inventTextureOpen
            }
        }
    }
    
    func toggleOverlay() {
        if let mainNode = self.childNode(withName: "overlay")
        {
            
            mainNode.isHidden = !mainNode.isHidden
            /*toggleAdditionalNodesVisibility*/()
        }
    }
    
    
    
//    func createShopNodes() {
//        let shopTexture = SKTexture(imageNamed: "shop")
//        let shop = SKSpriteNode(texture: shopTexture)
//        shop.position = CGPoint(x: self.frame.maxX - 300 , y: self.frame.minY + 40)
//        shop.anchorPoint = CGPoint(x: 0.5, y: 0.5)
//        shop.zPosition = 100000
//        let targetHeightInvent: CGFloat = 120
//        let aspectRatioInvent = shopTexture.size().width / shopTexture.size().height
//        let calculatedWidthInvent = targetHeightInvent * aspectRatioInvent
//        shop.size = CGSize(width: calculatedWidthInvent, height: targetHeightInvent)
//        shop.name = "shop"
//
//        // Membuat mainNode untuk menyimpan semua node
//        let mainNode = SKNode()
//        mainNode.position = shop.position
//        mainNode.name = "mainNode"
//        self.addChild(mainNode)
//
//        // Menambahkan shop ke mainNode
//        mainNode.addChild(shop)
//
//        // Membuat container untuk node tambahan
//        let additionalNodesContainer = SKNode()
//    additionalNodesContainer.name = "additionalNodesContainer"
//        mainNode.addChild(additionalNodesContainer)
//
//        // Menambahkan empat node secara vertikal di atas shop
//        let spacing: CGFloat = 40
//        var nextNodePositionY = shop.size.height / 2 + spacing / 2
//
//        for i in 0..<4 {
//            let node = SKSpriteNode(color: SKColor.blue, size: CGSize(width: 30, height: 30))
//            node.position = CGPoint(x: 0, y: nextNodePositionY)
//            node.zPosition = shop.zPosition - 1
//            additionalNodesContainer.addChild(node)
//            nextNodePositionY += node.size.height + spacing
//        }
//    }

    
    func switchToState(for actionName: String) {
        print("Switching to state for action: \(actionName)")
        // Tambahkan logika untuk berpindah state di sini, misalnya menggunakan state machine atau pengaturan scene
        switch actionName {
        case "food":
            toggleOverlay()
            toggleAdditionalNodesVisibility()

            break
            
        case "close":
            toggleOverlay()
            
        case "eat":
            toggleOverlay()
            self.pet?.component(ofType: PetIntelligenceComponent.self)?.stateMachine.enter(EatingState.self)
//            toggleOverlay()
            break
        case "ball":
            self.pet?.component(ofType: PetIntelligenceComponent.self)?.stateMachine.enter(PlayingBallState.self)
            toggleAdditionalNodesVisibility()

            break
        case "wand":
             self.pet?.component(ofType: PetIntelligenceComponent.self)?.stateMachine.enter(PlayingWandState.self)
            toggleAdditionalNodesVisibility()

            break
        case "bath":
            self.pet?.component(ofType: PetIntelligenceComponent.self)?.stateMachine.enter(BathState.self)
            toggleAdditionalNodesVisibility()

            break
        default:
            self.pet?.component(ofType: PetIntelligenceComponent.self)?.stateMachine.enter(WalkingState2.self)
            toggleAdditionalNodesVisibility()

            break
        }
    }
    
    func makeOverlay(){
        let overlayTexture = SKTexture(imageNamed: "overlay")
        let overlay = SKSpriteNode(texture: overlayTexture)
        overlay.position = CGPoint(x: self.frame.midX , y: self.frame.midY)
        overlay.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        overlay.zPosition = 100000
        let targetHeightOverlay: CGFloat = self.frame.size.height * 0.8
        let aspectRatioOverlay = overlayTexture.size().width / overlayTexture.size().height
        let calculatedWidthOverlay = targetHeightOverlay * aspectRatioOverlay
        overlay.size = CGSize(width: calculatedWidthOverlay, height: targetHeightOverlay)
        overlay.name = "overlay"
        self.addChild(overlay)
        
        let closeButtonTexture = SKTexture(imageNamed: "butt_close")
        let closeButton = SKSpriteNode(texture: closeButtonTexture)
        closeButton.position = CGPoint(x: overlay.size.width/3, y:overlay.size.height/2.8)
        closeButton.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        closeButton.zPosition = 1000000
        let targetHeightcloseButton: CGFloat = overlay.size.height * 0.1
        let aspectRatiocloseButton = closeButtonTexture.size().width / closeButtonTexture.size().height
        let calculatedWidthcloseButton = targetHeightcloseButton * aspectRatiocloseButton
        closeButton.size = CGSize(width: calculatedWidthcloseButton, height: targetHeightcloseButton)
        closeButton.name = "close"
        overlay.addChild(closeButton)
        
        let spacing: CGFloat = 30
        var nextNodePositionY : CGFloat = 140 + spacing

        var text = ["eat","ball","wand","bath"]
        var imgText = ["chicken", "sausage", "ham", "bacon", "apple" ,"banana", "pineapple"]
        
      
        var nextNodePositionX : CGFloat =
        -(2*70 + 35 + 2*spacing/3 )/2
        var counter = 0
        for i in 1...(imgText.count)/3 + 1{
            
            
            for j in 1...3 {
                
               
                print(counter)
                
                let texture = SKTexture(imageNamed: imgText[(i-1)*3 + j-1 ])
                
                let targetWidth: CGFloat = 70
                let aspectRatio = texture.size().height/texture.size().width
                let calculatedHeight = targetWidth*aspectRatio
                
                let node = SKSpriteNode(texture: texture, size: CGSize(width: targetWidth, height: calculatedHeight))
                //            let node = SKSpriteNode(color: SKColor.blue, size: CGSize(width: 30, height: 30))
                node.position = CGPoint(x: nextNodePositionX, y: nextNodePositionY)
                node.zPosition = overlay.zPosition + 1
                //            belakang.zPosition = node.zPosition - 10000
                node.anchorPoint = CGPoint(x: 0.5, y: 0.5)
                overlay.addChild(node)
                //            node.addChild(belakang)
                node.name = text[0]
                nextNodePositionX += spacing + 70
                counter += 1
                if counter >= imgText.count {
                    break
                }
                
            }
            nextNodePositionX =
            -(2*70 + 35 + 2*spacing/3 )/2
            
            nextNodePositionY -= 70 + spacing
        }
        
        overlay.isHidden = true
        
    }

}
