//
//  BitMaskCategory.swift
//  WarFly
//
//  Created by Ярослав Антонович on 20.01.2022.
//

import SpriteKit

extension SKPhysicsBody {
    var category: BitMaskCategory {
        get {
            return BitMaskCategory(rawValue: self.categoryBitMask)
        }
        set {
            self.categoryBitMask = newValue.rawValue
        }
    }
}

struct BitMaskCategory: OptionSet {
    let rawValue: UInt32
    
    static let none    = BitMaskCategory(rawValue: 0 << 0)     // 000000000000...0
    static let player  = BitMaskCategory(rawValue: 1 << 0)     // 000000000000...1     1
    static let enemy   = BitMaskCategory(rawValue: 1 << 1)     // 00000000000...10     2
    static let powerUp = BitMaskCategory(rawValue: 1 << 2)     // 0000000000...100     4
    static let shot    = BitMaskCategory(rawValue: 1 << 3)     // 000000000...1000     8
    static let all     = BitMaskCategory(rawValue: UInt32.max) // 111111111...1111
}
