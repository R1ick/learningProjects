//
//  GameSettings.swift
//  WarFly
//
//  Created by Ярослав Антонович on 24.01.2022.
//

import UIKit

class GameSettings: NSObject {
    
    let ud = UserDefaults.standard
    
    var isMusic = true
    var isSound = true
    
    var hightScore: [Int] = []
    var currentScore = 0
    let scoreKey = "score"
    let musicKey = "music"
    let soundKey = "sound"
    
    override init() {
        super.init()
        
        loadGameSettings()
        loadScores()
    }
    
    func saveScores() {
        hightScore.append(currentScore)
        hightScore = Array(hightScore.sorted { $0 > $1 }.prefix(3))  //упорядоченный массив
        
        ud.set(hightScore, forKey: scoreKey)
        ud.synchronize()
    }
    
    func loadScores() {
        guard ud.value(forKey: scoreKey) != nil else { return }
        hightScore = ud.array(forKey: scoreKey) as! [Int]
    }
    
    func saveGameSettings() {
        ud.set(isMusic, forKey: musicKey)
        ud.set(isSound, forKey: soundKey)
    }
    
    func loadGameSettings() {
        guard ud.value(forKey: musicKey) != nil && ud.value(forKey: soundKey) != nil else { return }
        isMusic = ud.bool(forKey: musicKey)
        isSound = ud.bool(forKey: soundKey)
    }
}
