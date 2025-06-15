//
//  GameViewController.swift
//  Petopia
//
//  Created by Michelle Swastika on 29/05/24.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    static var scene : GameScene?
    
//    init() {
//    
//        self.scene = GameScene(size: self.view.bounds.size)
//        
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GameViewController.scene = GameScene(size: self.view.bounds.size)
        
        
//        let scene = GameScene(size: view.bounds.size)
        let skView = self.view as! SKView
        skView.showsFPS = false
        skView.showsNodeCount = false
        skView.ignoresSiblingOrder = true
        skView.backgroundColor = .black
        skView.showsPhysics = false
        GameViewController.scene!.scaleMode = .aspectFill
        skView.presentScene(GameViewController.scene!)
        
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
