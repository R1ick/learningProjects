//
//  YellowShot.swift
//  WarFly
//
//  Created by Ярослав Антонович on 19.01.2022.
//

import SpriteKit

class YellowShot: Shot {
    init() {
        let textureAtlas = Assets.shared.yellowShotAtlas //SKTextureAtlas(named: "YellowAmmo")
        super.init(textureAtlas: textureAtlas)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
