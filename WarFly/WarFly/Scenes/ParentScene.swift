//
//  ParentScene.swift
//  WarFly
//
//  Created by Ярослав Антонович on 21.01.2022.
//

import SpriteKit

class ParentScene: SKScene {
    
    let gameSettings = GameSettings()
    
    let sceneManager = SceneManager.shared
    var backScene: SKScene?
    
    func setHeader(with name: String?, andBackground background: String) {
        let header = ButtonNode(titled: name, backgroundName: background)
        header.position = CGPoint(x: self.frame.midX, y: self.frame.midY + 150)
        self.addChild(header)
    }
    
    override init(size: CGSize) {
        super.init(size: size)
        backgroundColor = SKColor(red: 0.15, green: 0.15, blue: 0.3, alpha: 1.0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
