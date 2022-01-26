//
//  GameScene.swift
//  WarFly
//
//  Created by Ярослав Антонович on 17.01.2022.
//

import SpriteKit
import GameplayKit


class GameScene: ParentScene {
    
    var backgroundMusic: SKAudioNode!
    
    fileprivate var player: PlayerPlane!
    fileprivate let hud = HUD()
    fileprivate let screenSize = UIScreen.main.bounds.size
    fileprivate var pauseNode = SKNode()
    fileprivate var lives = 3 {
        didSet {
            switch lives {
            case 3:
                hud.life1.isHidden = false
                hud.life2.isHidden = false
                hud.life3.isHidden = false
            case 2:
                hud.life1.isHidden = false
                hud.life2.isHidden = false
                hud.life3.isHidden = true
            case 1:
                hud.life1.isHidden = false
                hud.life2.isHidden = true
                hud.life3.isHidden = true
            default: break
            }
        }
    }
    fileprivate var shots = 1
    
    override func didMove(to view: SKView) {
        gameSettings.loadGameSettings()
        if gameSettings.isMusic && backgroundMusic == nil {
            if let musicURL = Bundle.main.url(forResource: "backgroundMusic", withExtension: "m4a") {
                print("##################TRALALALALALA#####################")
                backgroundMusic = SKAudioNode(url: musicURL)
                addChild(backgroundMusic)
            }
        }
        
        self.scene?.isPaused = false
        
        // cheking if scene exists
        guard sceneManager.gameScene == nil else { return }
        sceneManager.gameScene = self
        
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = CGVector.zero
        
        configureStartScene()
        spawnClouds()
        spawnIslands()
        self.player.performFly()
        spawnPowerUp()
        //        spawnEnemy(count: 5)
        spawnEnemies()
        createHUD()
    }
    
    fileprivate func createHUD() {
        addChild(hud)
        hud.configureUI(screenSize: screenSize)
    }
    
    fileprivate func spawnPowerUp() {
        let spawnAction = SKAction.run {
            let randomNumber = Int(arc4random_uniform(2))
            let powerUp = randomNumber == 1 ? BluePowerUp() : GreenPowerUp()
            let randomPositionX = arc4random_uniform(UInt32(self.size.width - 30))
            powerUp.position = CGPoint(x: CGFloat(randomPositionX), y: self.size.height + 100)
            powerUp.startMovement()
            self.addChild(powerUp)
        }
        let randomTimeSpawn = Double(arc4random_uniform(11) + 10)
        let waitAction = SKAction.wait(forDuration: randomTimeSpawn)
        self.run(SKAction.repeatForever(SKAction.sequence([spawnAction, waitAction])))
    }
    
    fileprivate func spawnEnemies() {
        let waitAction = SKAction.wait(forDuration: 3)
        let spawnSpiralAction = SKAction.run { [unowned self] in
            self.spawnSpiralOfEnemy()
        }
        self.run(SKAction.repeatForever(SKAction.sequence([waitAction, spawnSpiralAction])))
    }
    
    fileprivate func spawnSpiralOfEnemy() {
        let enemyTextureAtlas1 = Assets.shared.enemy1Atlas //SKTextureAtlas(named: "Enemy_1")
        let enemyTextureAtlas2 = Assets.shared.enemy2Atlas //SKTextureAtlas(named: "Enemy_2")
        SKTextureAtlas.preloadTextureAtlases([enemyTextureAtlas1, enemyTextureAtlas2]) { [unowned self] in
            
            let randomNumber = Int(arc4random_uniform(2))
            let arrayOfAtlasses = [enemyTextureAtlas1, enemyTextureAtlas2]
            let textureAtlas = arrayOfAtlasses[randomNumber]
            
            let waitAction = SKAction.wait(forDuration: 1.0)
            let spawnEnemy = SKAction.run {
                let textureNames = textureAtlas.textureNames.sorted()
                let texture = textureAtlas.textureNamed(textureNames[12])
                let enemy = Enemy(enemyTexture: texture)
                enemy.position = CGPoint(x: self.size.width / 2, y: self.size.height + 110)
                self.addChild(enemy)
                enemy.flySpiral()
            }
            let spawnAction = SKAction.sequence([waitAction, spawnEnemy])
            let repeatAction = SKAction.repeat(spawnAction, count: 3)
            self.run(repeatAction)
        }
    }
    
    fileprivate func spawnClouds() {
        let spawnCloudWait = SKAction.wait(forDuration: 1)
        let spawnCloudAction = SKAction.run {
            let cloud = Cloud.populate(at: nil)
            self.addChild(cloud)
        }
        
        let spawnCloudSequence = SKAction.sequence([spawnCloudWait, spawnCloudAction])
        let spawnCloudForever = SKAction.repeatForever(spawnCloudSequence)
        run(spawnCloudForever)
    }
    
    fileprivate func spawnIslands() {
        let spawnIslandWait = SKAction.wait(forDuration: 2)
        let spawnIslandAction = SKAction.run {
            let island = Island.populate(at: nil)
            self.addChild(island)
        }
        
        let spawnIslandSequence = SKAction.sequence([spawnIslandWait, spawnIslandAction])
        let spawnIslandForever = SKAction.repeatForever(spawnIslandSequence)
        run(spawnIslandForever)
    }
    
    fileprivate func configureStartScene() {
        let screenCenterPoint = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        let background = Background.popilateBackground(at: screenCenterPoint)
        background.size = self.size
        self.addChild(background)
        
        let screen = UIScreen.main.bounds
        
        let island1 = Island.populate(at: CGPoint(x: 100, y: 200) )
        self.addChild(island1)
        
        let island2 = Island.populate(at: CGPoint(x: self.size.width - 100, y: self.size.height - 200))
        self.addChild(island2)
        
        player = PlayerPlane.populate(at: CGPoint(x: screen.size.width / 2, y: 150))
        self.addChild(player)
    }
    
    override func didSimulatePhysics() {
        player.checkPosition()
        
        enumerateChildNodes(withName: "sprite") { (node, stop) in
            if node.position.y <= -100 {
                node.removeFromParent()
            }
        }
        enumerateChildNodes(withName: "shotSprite") { (node, stop) in
            if node.position.y >= self.size.height + 100 {
                node.removeFromParent()
            }
        }
        enumerateChildNodes(withName: "bluePowerUp") { (node, stop) in
            if node.position.y <= -100 {
                node.removeFromParent()
            }
        }
        enumerateChildNodes(withName: "greenPowerUp") { (node, stop) in
            if node.position.y <= -100 {
                node.removeFromParent()
            }
        }
    }
    
    fileprivate func playerFire() {
        if self.shots == 1 {
            let shot = YellowShot()
            shot.position = self.player.position
            shot.startMovement()
            self.addChild(shot)
        } else {
            for i in 1...2 {
                let shot = YellowShot()
                shot.position = CGPoint(x: self.player.position.x + (-30 + CGFloat(i * 20)) * 2, y: self.player.position.y)
                shot.startMovement()
                self.addChild(shot)
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let location = touches.first!.location(in: self)
        let node = self.atPoint(location)
        if node.name == "pause" {
            let transition = SKTransition.doorway(withDuration: 1)
            let pauseScene = PauseScene(size: self.size)
            pauseScene.scaleMode = .aspectFill
            sceneManager.gameScene = self
            self.scene?.isPaused = true
            self.scene!.view?.presentScene(pauseScene, transition: transition)
        } else {
            if self.shots == 1 {
                playerFire()
            } else {
                playerFire()
                self.shots -= 1
            }
        }
    }
}

extension GameScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        // взрыв
        let explosion = SKEmitterNode(fileNamed: "EnemyExplosion")
        let contactPoint = contact.contactPoint
        explosion?.position = contactPoint
        explosion?.zPosition = 25
        let waitForExplosionAction = SKAction.wait(forDuration: 1)
    
        let contactCategory: BitMaskCategory = [contact.bodyA.category, contact.bodyB.category]
        switch contactCategory {
        case [.enemy, .player]:
            if contact.bodyA.node?.name == "sprite" {
                if contact.bodyA.node?.parent != nil {
                    contact.bodyA.node?.removeFromParent()
                    lives -= 1
                }
            } else {
                if contact.bodyB.node?.parent != nil {
                    contact.bodyB.node?.removeFromParent()
                    lives -= 1
                }
            }
            addChild(explosion!)
            self.run(waitForExplosionAction) { explosion?.removeFromParent() }
            if lives == 0 {
                gameSettings.currentScore = hud.score
                gameSettings.saveScores()
                let gameOverScene = GameOverScene(size: self.size)
                gameOverScene.scaleMode = .aspectFill
                let transition = SKTransition.doorsCloseVertical(withDuration: 1)
                self.scene!.view?.presentScene(gameOverScene, transition: transition)
            }
        case [.powerUp, .player]:
            
            if contact.bodyA.node?.parent != nil || contact.bodyB.node?.parent != nil {
                if contact.bodyA.node?.name == "bluePowerUp" {
                    contact.bodyA.node?.removeFromParent()
                    lives = 3
                    player.bluePowerUp()
                } else if contact.bodyB.node?.name == "bluePowerUp" {
                    contact.bodyB.node?.removeFromParent()
                    lives = 3
                    player.bluePowerUp()
                }
                
                if contact.bodyA.node?.name == "greenPowerUp" {
                    contact.bodyA.node?.removeFromParent()
                    self.shots = 10
                    player.greenPowerUp()
                } else if contact.bodyB.node?.name == "greenPowerUp" {
                    contact.bodyB.node?.removeFromParent()
                    self.shots = 10
                    player.greenPowerUp()
                }
                
                
            }
        case [.enemy, .shot]:
            if contact.bodyA.node?.parent != nil && contact.bodyB.node?.parent != nil {
                contact.bodyA.node?.removeFromParent()
                contact.bodyB.node?.removeFromParent()
                if gameSettings.isSound {
                    self.run(SKAction.playSoundFileNamed("hitSound", waitForCompletion: false))
                }
                hud.score += 5
                addChild(explosion!)
                self.run(waitForExplosionAction) { explosion?.removeFromParent() }
            }
        default: preconditionFailure("Unable to detect collision category")
        }
    }
    
    func didEnd(_ contact: SKPhysicsContact) {
        
    }
    
}