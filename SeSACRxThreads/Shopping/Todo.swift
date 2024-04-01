//
//  Todo.swift
//  SeSACRxThreads
//
//  Created by 이중엽 on 4/1/24.
//

import Foundation

struct Todo {
    
    var isChecked: Bool = false
    var description: String
    var isImportant: Bool = false
    
    init(isChecked: Bool, description: String, isImportant: Bool) {
        self.isChecked = isChecked
        self.description = description
        self.isImportant = isImportant
    }
}
