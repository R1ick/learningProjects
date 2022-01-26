//
//  OptionsScene.swift
//  WarFly
//
//  Created by Ярослав Антонович on 21.01.2022.
//

import SpriteKit

class OptionsScene: ParentScene {
    
    var isMusic: Bool!
    var isSound: Bool!
    
    override func didMove(to view: SKView) {
    
        isMusic = gameSettings.isMusic
        isSound = gameSettings.isSound
        
        setHeader(with: "options", andBackground: "header_background")
        
        let names = ["music", "sound", "back"]
        
        for (index, name) in names.enumerated() {
            var backgroundNameForMusic: String!
            var backgroundNameForSound: String!
            var button = ButtonNode(titled: nil, backgroundName: name)
            if name == "music" {
                backgroundNameForMusic = isMusic == true ? name : "nomusic"
                button = ButtonNode(titled: nil, backgroundName: backgroundNameForMusic)
            }
            if name == "sound" {
                backgroundNameForSound = isMusic == true ? name : "nosound"
                button = ButtonNode(titled: nil, backgroundName: backgroundNameForSound)
            }
           
            if name != "back" {
                button.position = CGPoint(x: self.frame.midX - 50 + CGFloat(index) * 100, y: self.frame.midY )
                button.name = name
                button.label.isHidden = true
            } else {
                button = ButtonNode(titled: name, backgroundName: "button_background")
                button.position = CGPoint(x: self.frame.midX, y: self.frame.midY - 100)
                button.name = name
                button.label.name = name
            }
            addChild(button)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let location = touches.first!.location(in: self)
        let node = self.atPoint(location)
        switch node.name {
        case "music":
            isMusic = !isMusic
            update(node: node as! SKSpriteNode, property: isMusic)
        case "sound":
            isSound = !isSound
            update(node: node as! SKSpriteNode, property: isSound)
        case "back":
            gameSettings.isSound = isSound
            gameSettings.isMusic = isMusic
            gameSettings.saveGameSettings()
            guard let backScene = backScene else { return }
            let transition = SKTransition.crossFade(withDuration: 1.0)
            backScene.scaleMode = .aspectFill
            self.scene!.view?.presentScene(backScene, transition: transition)
        default: break
        }
    }
    
    func update(node: SKSpriteNode, property: Bool) {
        if let name = node.name {
            node.texture = property ? SKTexture(imageNamed: name) : SKTexture(imageNamed: "no" + name)
        }
    }
}
