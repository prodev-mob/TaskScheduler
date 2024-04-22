//
//  TaskViewModelFactory.swift
//  SwiftUI-MVVM
//
//  Created by DREAMWORLD on 10/01/24.
//

import Foundation

final class TaskViewModelFactory {
    static func createTaskViewModel() -> TaskViewModel {
        return TaskViewModel(taskRepository: TaskRepositoryImplementation())
    }
}
