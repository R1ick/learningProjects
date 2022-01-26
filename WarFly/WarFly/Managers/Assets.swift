//
//  Assets.swift
//  WarFly
//
//  Created by Ярослав Антонович on 20.01.2022.
//

import SpriteKit
// singleton
class Assets {
    static let shared = Assets()
    var isLoaded = false
    let yellowShotAtlas = SKTextureAtlas(named: "YellowAmmo")
    let enemy1Atlas = SKTextureAtlas(named: "Enemy_1")
    let enemy2Atlas = SKTextureAtlas(named: "Enemy_2")
    let bluePowerUpAtlas = SKTextureAtlas(named: "BluePowerUp")
    let greenPowerUpAtlas = SKTextureAtlas(named: "GreenPowerUp")
    let playerPlaneAtlas = SKTextureAtlas(named: "PlayerPlane")
    
    func preloadAssets() {
        yellowShotAtlas.preload {}
        enemy1Atlas.preload {}
        enemy2Atlas.preload {}
        bluePowerUpAtlas.preload {}
        greenPowerUpAtlas.preload {}
        playerPlaneAtlas.preload {}
    }
}
