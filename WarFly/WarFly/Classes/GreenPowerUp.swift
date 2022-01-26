//
//  GreenPowerUp.swift
//  WarFly
//
//  Created by Ярослав Антонович on 19.01.2022.
//

import SpriteKit

class GreenPowerUp: PowerUp {
    init() {
        let textureAtlas = Assets.shared.greenPowerUpAtlas //SKTextureAtlas(named: "GreenPowerUp")
        super.init(textureAtlas: textureAtlas)
        name = "greenPowerUp"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
