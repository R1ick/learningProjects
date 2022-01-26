//
//  User.swift
//  ToDoFire
//
//  Created by Ярослав Антонович on 14.12.2021.
//

import Foundation
import Firebase

struct SUser {
    
    let uid: String
    let email: String
    
    init(user: User) {
        self.uid = user.uid
        self.email = user.email!
    }
    
}
