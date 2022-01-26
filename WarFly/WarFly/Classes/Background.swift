//
//  Background.swift
//  WarFly
//
//  Created by Ярослав Антонович on 17.01.2022.
//

import SpriteKit

class Background: SKSpriteNode {

    static func popilateBackground(at point: CGPoint) -> Background {
        let background = Background(imageNamed: "background")
        background.position = point
        background.zPosition = 0
        
        return background
    }
}
