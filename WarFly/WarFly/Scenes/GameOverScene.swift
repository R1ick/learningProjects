//
//  GameOverScene.swift
//  WarFly
//
//  Created by Ярослав Антонович on 24.01.2022.
//

import SpriteKit

class GameOverScene: ParentScene {
    
    override func didMove(to view: SKView) {
        
        setHeader(with: "game over", andBackground: "header_background")
        
        let titles = ["restart", "options", "best"]
        
        for (index, title) in titles.enumerated() {
            let button = ButtonNode(titled: title, backgroundName: "button_background")
            button.position = CGPoint(x: self.frame.midX, y: self.frame.midY - CGFloat(100 * index))
            button.name = title
            button.label.name = title  // если этого не сделать, то при нажатии на label на кнопке ничего не произойдет
            addChild(button)
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
        case "best":
            let transition = SKTransition.doorsCloseHorizontal(withDuration: 1)
            let bestScene = BestScene(size: self.size)
            bestScene.backScene = self
            bestScene.scaleMode = .aspectFill
            self.scene!.view?.presentScene(bestScene, transition: transition)
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
