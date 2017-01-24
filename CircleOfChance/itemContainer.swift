//
//  itemContainer.swift
//  CircleOfChance
//
//  Created by Mac on 1/24/17.
//  Copyright © 2017 KJB Apps LLC. All rights reserved.
//

import Foundation
import SpriteKit

class itemContainer: SKSpriteNode{
    var skinItem: Skins?
    var themeItem: Themes?
    
    init() {
        let texture = SKTexture(imageNamed: "itemContainer")
        super.init(texture: texture,color: UIColor.clearColor(), size: texture.size())
        zPosition = 10
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
