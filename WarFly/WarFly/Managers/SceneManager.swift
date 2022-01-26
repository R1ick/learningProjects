//
//  SceneManager.swift
//  WarFly
//
//  Created by Ярослав Антонович on 21.01.2022.
//

import Foundation

// SINGLETON
class SceneManager {
    static let shared = SceneManager()
    
    var gameScene: GameScene?
    var pauseScene: PauseScene?
}
