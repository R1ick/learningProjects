//
//  Task.swift
//  ToDoFire
//
//  Created by Ярослав Антонович on 14.12.2021.
//

import Foundation
import Firebase
import FirebaseDatabase

struct Task {
    
    let title: String
    let userId: String
    let ref: DatabaseReference?
    var completed: Bool = false
    
    init(title: String, userId: String) {
        self.title = title
        self.userId = userId
        self.ref = nil
    }
    init(snapshot: DataSnapshot) {
        let snapshotValue = snapshot.value as! [String: AnyObject]
        title = snapshotValue["title"] as! String
        userId = snapshotValue["userId"] as! String
        completed = snapshotValue["completed"] as! Bool
        ref = snapshot.ref
        
    }
    
    func convertToDict() -> NSDictionary {
        return NSDictionary(dictionary: ["title": title, "userId": userId, "completed": completed])
    }
}
