//
//  PlayerPlane.swift
//  WarFly
//
//  Created by Ярослав Антонович on 18.01.2022.
//

import SpriteKit
import CoreMotion

class PlayerPlane: SKSpriteNode {
    
    let motionManager = CMMotionManager()
    var xAcceleration: CGFloat = 0
    let screenSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
    // текстуры поворотов и полета прямо
    var leftTextureArrayAnimation = [SKTexture]()
    var rightTextureArrayAnimation = [SKTexture]()
    var forwardTextureArrayAnimation = [SKTexture]()
    // направление поворота
    var moveDirection: TurnDirection = .none
    var stillTurning = false
    let animationSpriteStrides = [(13, 1, -1), (13, 26, 1), (13, 13, 1)]
    // создать самолет
    static func populate(at point: CGPoint) -> PlayerPlane {
        let atlas = Assets.shared.playerPlaneAtlas
        let playerPlaneTexture = atlas.textureNamed("airplane_3ver2_13")
        let playerPlane = PlayerPlane(texture: playerPlaneTexture)
        playerPlane.setScale(0.5)
        playerPlane.position = point
        playerPlane.zPosition = 40
        
        let offsetX = playerPlane.frame.size.width * playerPlane.anchorPoint.x
        let offsetY = playerPlane.frame.size.height * playerPlane.anchorPoint.y
        let path = CGMutablePath()
        path.move(to: CGPoint(x: 84 - offsetX, y: 57 - offsetY))
        path.addLine(to: CGPoint(x: 143 - offsetX, y: 66 - offsetY))
        path.addLine(to: CGPoint(x: 141 - offsetX, y: 77 - offsetY))
        path.addLine(to: CGPoint(x: 86 - offsetX, y: 84 - offsetY))
        path.addLine(to: CGPoint(x: 79 - offsetX, y: 99 - offsetY))
        path.addLine(to: CGPoint(x: 71 - offsetX, y: 99 - offsetY))
        path.addLine(to: CGPoint(x: 63 - offsetX, y: 85 - offsetY))
        path.addLine(to: CGPoint(x: 8 - offsetX, y: 77 - offsetY))
        path.addLine(to: CGPoint(x: 7 - offsetX, y: 66 - offsetY))
        path.addLine(to: CGPoint(x: 64 - offsetX, y: 55 - offsetY))
        path.closeSubpath()
        playerPlane.physicsBody = SKPhysicsBody(polygonFrom: path)
        
        //playerPlane.physicsBody = SKPhysicsBody(texture: playerPlaneTexture, alphaThreshold: 0.5, size: playerPlane.size)
        playerPlane.physicsBody?.isDynamic = false
        playerPlane.physicsBody?.categoryBitMask = BitMaskCategory.player.rawValue
        playerPlane.physicsBody?.collisionBitMask = BitMaskCategory.enemy.rawValue | BitMaskCategory.powerUp.rawValue
        playerPlane.physicsBody?.contactTestBitMask = BitMaskCategory.enemy.rawValue | BitMaskCategory.powerUp.rawValue
        
        return playerPlane
    }
    
    func checkPosition() {
        self.position.x += xAcceleration * 50
        
        if self.position.x < -70 {
            self.position.x = screenSize.width + 70
        } else if self.position.x > screenSize.width + 70 {
            self.position.x = -70
        }
    }
    
    func performFly() {
//        planeAnimationFillArray()
        preloadTextureArrays()
        motionManager.accelerometerUpdateInterval = 0.2
        motionManager.startAccelerometerUpdates(to: OperationQueue.current!) { [unowned self] (data, error) in
            guard let data = data else { return }
            let acceleration = data.acceleration
            self.xAcceleration = CGFloat(acceleration.x) * 0.7 + self.xAcceleration * 0.3
        }
        
        let planeWaitAction = SKAction.wait(forDuration: 1.0)
        let planeDirectionCheckAction = SKAction.run { [unowned self] in
            self.movementDirectionCheck()
        }
        let planeSequence = SKAction.sequence([planeWaitAction, planeDirectionCheckAction])
        let planeSequenceForever = SKAction.repeatForever(planeSequence)
        self.run(planeSequenceForever)
    }
    
    fileprivate func preloadTextureArrays() {
        for i in 0...2 {
            self.preloadArray(_stride: animationSpriteStrides[i]) { [unowned self] array in
                switch i {
                case 0: self.leftTextureArrayAnimation = array
                case 1: self.rightTextureArrayAnimation = array
                case 2: self.forwardTextureArrayAnimation = array
                default: break
                }
            }
        }
    }
    
    
    fileprivate func preloadArray(_stride: (Int, Int, Int), callback: @escaping (_ array: [SKTexture]) -> ()) {
        var array = [SKTexture]()
        for i in stride(from: _stride.0, through: _stride.1, by: _stride.2) {
            let number = String(format: "%02d", i)
            let texture = SKTexture(imageNamed: "airplane_3ver2_\(number)") // создание текстуры
            array.append(texture)
        }
        SKTexture.preload(array) {
            callback(array)
        }
    }
    
//    fileprivate func planeAnimationFillArray() {
//        SKTextureAtlas.preloadTextureAtlases([SKTextureAtlas(named: "PlayerPlane")]) {
//            self.leftTextureArrayAnimation = {
//                var array = [SKTexture]()
//                for i in stride(from: 13, through: 1, by: -1) {
//                    let number = String(format: "%02d", i) // двузначное целое число
//                    let texture = SKTexture(imageNamed: "airplane_3ver2_\(number)") // создание текстуры
//                    array.append(texture)
//                }
//                SKTexture.preload(array) { // предзагрузка
//                    print("preload is done")
//                }
//                return array
//            }()
//
//            self.rightTextureArrayAnimation = {
//                var array = [SKTexture]()
//                for i in stride(from: 13, through: 26, by: 1) {
//                    let number = String(format: "%02d", i)
//                    let texture = SKTexture(imageNamed: "airplane_3ver2_\(number)")
//                    array.append(texture)
//                }
//                SKTexture.preload(array) {
//                    print("preload is done")
//                }
//                return array
//            }()
//
//            self.forwardTextureArrayAnimation = {
//                var array = [SKTexture]()
//                let texture = SKTexture(imageNamed: "airplane_3ver2_13")
//                array.append(texture)
//
//                SKTexture.preload(array) {
//                    print("preload is done")
//                }
//                return array
//            }()
//        }
//    }
    // определить в какую сторону запустить анимацию
    fileprivate func movementDirectionCheck() {
        if xAcceleration > 0.02, moveDirection != .right, stillTurning == false  { // начался ли поворот и был ли поворот в                                                                             эту сторону
            stillTurning = true
            moveDirection = .right
            turnPlane(direction: .right)
        } else if xAcceleration < -0.02, moveDirection != .left, stillTurning == false {
            stillTurning = true
            moveDirection = .left
            turnPlane(direction: .left)
        } else if stillTurning == false {
            turnPlane(direction: .none)
        }
    }
    
    fileprivate func turnPlane(direction: TurnDirection) {
        var array = [SKTexture]()
        
        switch direction {
        case .left:
            array = leftTextureArrayAnimation
        case .right:
            array = rightTextureArrayAnimation
        case .none:
            array = forwardTextureArrayAnimation
        }
        
        let forwardAction = SKAction.animate(with: array, timePerFrame: 0.05, resize: true, restore: false)
        let backwardAction = SKAction.animate(with: array.reversed(), timePerFrame: 0.05, resize: true, restore: false)
        let sequenceAction = SKAction.sequence([forwardAction, backwardAction])
        self.run(sequenceAction) { [unowned self] in
            self.stillTurning = false
        }
    }
    
    func greenPowerUp() {
        let colorAction = SKAction.colorize(with: .green, colorBlendFactor: 1.0, duration: 0.2)
        let uncolorAction = SKAction.colorize(with: .green, colorBlendFactor: 0.0, duration: 0.2)
        let sequenceAction = SKAction.sequence([colorAction, uncolorAction])
        let repeatAction = SKAction.repeat(sequenceAction, count: 5)
        self.run(repeatAction)
    }
    
    func bluePowerUp() {
        let colorAction = SKAction.colorize(with: .blue, colorBlendFactor: 1.0, duration: 0.2)
        let uncolorAction = SKAction.colorize(with: .blue, colorBlendFactor: 0.0, duration: 0.2)
        let sequenceAction = SKAction.sequence([colorAction, uncolorAction])
        let repeatAction = SKAction.repeat(sequenceAction, count: 5)
        self.run(repeatAction)
    }
}
// повороты
enum TurnDirection {
    case left
    case right
    case none
}
