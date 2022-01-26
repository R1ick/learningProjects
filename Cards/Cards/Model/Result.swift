//
//  Result.swift
//  Cards
//
//  Created by Ярослав Антонович on 25.11.2021.
//

import Foundation

class Result {
    var userName: String? = ""
    var points: Int16 = 0
    func getName() -> String {
        return userName ?? ""
    }
    func setName(name: String) {
        self.userName = name
    }
    init() {
        
    }
    init(name: String, points: Int16) {
        self.userName = name
        self.points = points
    }
    init(name: String) {
        self.userName = name
    }
    init(points: Int16) {
        self.points = points
    }
}
