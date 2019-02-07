//
//  GameViewController.swift
//  GameOfLife
//
//  Created by Ade Adegoke on 06/02/2019.
//  Copyright © 2019 AKA. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var startButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(forName: GameStartedNotificationName, object: nil, queue: nil) { (_) in
          self.startButton?.isEnabled = false
        }
        NotificationCenter.default.addObserver(forName: GameStoppedNotificationName, object: nil, queue: nil) { (_) in
          self.startButton?.isEnabled = true
        }
        
        if let view = self.view as! SKView? {
            //Load the SKScene from "GameScene.sks"
            if let scene = SKScene(fileNamed: "GameScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFit
                
                // Present the scene
                view.presentScene(scene)
            }
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = false
            view.showsNodeCount = false
        }
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    
    
    @IBAction func resetGame(_ sender: Any) {
        let name = ResetNotificationName
        NotificationCenter.default.post(name: name, object: nil)
    }
    
    
    @IBAction func startGame(_ sender: Any) {
        let name = StartNotificationName
        NotificationCenter.default.post(name: name, object: nil)
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
