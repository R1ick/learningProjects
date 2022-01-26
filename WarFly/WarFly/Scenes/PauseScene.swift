//
//  PauseScene.swift
//  WarFly
//
//  Created by Ярослав Антонович on 21.01.2022.
//

import SpriteKit

class PauseScene: ParentScene {
    
    override func didMove(to view: SKView) {
        
        setHeader(with: "pause", andBackground: "header_background")
        
        let titles = ["restart", "options", "resume"]
        
        for (index, title) in titles.enumerated() {
            let button = ButtonNode(titled: title, backgroundName: "button_background")
            button.position = CGPoint(x: self.frame.midX, y: self.frame.midY - CGFloat(100 * index))
            button.name = title
            button.label.name = title  // если этого не сделать, то при нажатии на label на кнопке ничего не произойдет
            addChild(button)
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        guard let gameScene = sceneManager.gameScene else { return }
        if !gameScene.isPaused {
            gameScene.isPaused = true
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let location = touches.first!.location(in: self)
        let node = self.atPoint(location)
        switch node.name {
        case "restart":
            sceneManager.gameScene = nil
            let transition = SKTransition.crossFade(withDuration: 1)
            let gameScene = GameScene(size: self.size)
            gameScene.scaleMode = .aspectFill
            self.scene!.view?.presentScene(gameScene, transition: transition)
        case "resume":
            let transition = SKTransition.doorsCloseHorizontal(withDuration: 1)
            guard let gameScene = sceneManager.gameScene else { return }
            gameScene.scaleMode = .aspectFill
            self.scene!.view?.presentScene(gameScene, transition: transition)
        case "options":
            let transition = SKTransition.doorsCloseHorizontal(withDuration: 1)
            let optionScene = OptionsScene(size: self.size)
            optionScene.backScene = self
            optionScene.scaleMode = .aspectFill
            self.scene!.view?.presentScene(optionScene, transition: transition)
        default: break
        }
       
    }
}
