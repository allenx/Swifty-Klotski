//
//  GameViewController.swift
//  Swifty-Klotski
//
//  Created by Allen X on 12/23/16.
//  Copyright © 2016 allenx. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit


class GameViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            
            let backgroundImageView: UIImageView = {
                $0.image = #imageLiteral(resourceName: "background")
                $0.frame = view.frame
                return $0
            }(UIImageView())
            
            //self.view.addSubview(backgroundImageView)
            print(self.view.bounds.size)
            let scene = GameScene(size: view.bounds.size)
            
            scene.scaleMode = .aspectFill
            view.presentScene(scene)
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = false
            view.showsNodeCount = false
        }
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
