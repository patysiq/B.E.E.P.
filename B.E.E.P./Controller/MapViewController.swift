//
//  MapViewController.swift
//  B.E.E.P.
//
//  Created by Nathália Cardoso on 09/06/20.
//  Copyright © 2020 Eduardo Oliveira. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class MapViewController:UIViewController {
    
    override func loadView() {
        let view = SKView(frame: UIScreen.main.bounds)
        let scene = MapScene(size: view.bounds.size)
        
        scene.scaleMode = .aspectFill
        
        view.presentScene(scene)
        view.ignoresSiblingOrder = true
        view.showsFPS = true
        view.showsNodeCount = true
        
        self.view = view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
