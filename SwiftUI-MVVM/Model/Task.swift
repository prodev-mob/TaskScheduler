//
//  Task.swift
//  SwiftUI-MVVM
//
//  Created by DREAMWORLD on 10/01/24.
//

import Foundation

struct Task {
    let id: UUID
    var name: String
    var description: String
    var isCompleted: Bool
    var finishDate: Date
    
    static func createEmptyTask() -> Task {
        return Task(id: UUID(), name: "", description: "", isCompleted: false, finishDate: Date())
    }
}
