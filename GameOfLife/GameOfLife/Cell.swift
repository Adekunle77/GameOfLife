//
//  Cell.swift
//  GameOfLife
//
//  Created by Ade Adegoke on 07/02/2019.
//  Copyright © 2019 AKA. All rights reserved.
//

import SpriteKit
import GameplayKit
import Foundation


class Cell: SKSpriteNode {
    
    var hasLife: Bool = false
    var row = 1
    var col = 1
    var cellColour: UIColor?
    
    
    init(size: CGSize, cellColour: UIColor ) {
        self.cellColour = cellColour
        super.init(texture: nil, color: cellColour, size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
