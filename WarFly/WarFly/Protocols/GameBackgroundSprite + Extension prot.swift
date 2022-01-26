//
//  GameBackgroundSprite + Extension prot.swift
//  WarFly
//
//  Created by Ярослав Антонович on 18.01.2022.
//

import SpriteKit
import GameplayKit

protocol GameBackgroundSpritable {
    static func populate(at point: CGPoint?) -> Self  // Self с большой буквы означает, что должен вернуться тип класса, внутри которого вы используете этот метод
    static func randomPoint() -> CGPoint
}

extension GameBackgroundSpritable {
    static func randomPoint() -> CGPoint {
        let screen = UIScreen.main.bounds
        let distribution = GKRandomDistribution(lowestValue: Int(screen.size.height) + 400, highestValue: Int(screen.size.height) + 500)
        let y = CGFloat(distribution.nextInt())
        let x = CGFloat(GKRandomSource.sharedRandom().nextInt(upperBound: Int(screen.size.width)))
        return CGPoint(x: x, y: y)
    }
}
