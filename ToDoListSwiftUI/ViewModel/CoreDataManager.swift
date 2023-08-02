//
//  CoreDataManager.swift
//  ToDoListSwiftUI
//
//  Created by MacBook Noob on 26/07/23.
//

import Foundation

class CoreDataManager: ObservableObject {
    @Published var tasks: [TaskEntityList] = []

    let dataService = PersistenceController.shared

    init() {
        getAllTask()
    }

    func createTask(title: String, desc: String, dueDate: Date) throws {
        guard !title.isEmpty else {
            throw DataError.taskFieldIsEmpry
        }
        dataService.create(title: title, desc: desc, dueDate: dueDate)
        getAllTask()
    }
    
    func getAllTask() {
        tasks = dataService.read()
    }
    
    func deleteTask(task: TaskEntityList) {
        dataService.delete(task)
        getAllTask()
    }
    
    func updateTask(task: TaskEntityList, title: String? = nil, desc: String? = nil, dueDate: Date? = nil, taskDone: Bool) throws {
        guard let title = title, !title.isEmpty else {
            throw DataError.taskFieldIsEmpry
        }
        dataService.update(entity: task, title: title, desc: desc, dueDate: dueDate, taskDone: taskDone)
        getAllTask()
    }
}
