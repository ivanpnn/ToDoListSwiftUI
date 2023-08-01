//
//  TaskEntityList+CoreDataProperties.swift
//  
//
//  Created by MacBook Noob on 25/07/23.
//
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension TaskEntityList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TaskEntityList> {
        return NSFetchRequest<TaskEntityList>(entityName: "TaskEntityList")
    }

    @NSManaged public var desc: String
    @NSManaged public var dueDate: Date
    @NSManaged public var title: String
    @NSManaged public var myId: UUID

}

extension TaskEntityList : Identifiable {

}
