//
//  TaskEntity+CoreDataProperties.swift
//  SwiftUI-MVVM
//
//  Created by DREAMWORLD on 10/01/24.
//

import Foundation
import CoreData

extension TaskEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TaskEntity> {
        return NSFetchRequest<TaskEntity>(entityName: "TaskEntity")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var isCompleted: Bool
    @NSManaged public var finishDate: Date?
    @NSManaged public var taskDescription: String?

}

extension TaskEntity: Identifiable {
    
}
