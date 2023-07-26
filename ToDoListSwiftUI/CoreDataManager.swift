//
//  CoreDataManager.swift
//  ToDoListSwiftUI
//
//  Created by MacBook Noob on 26/07/23.
//

import Foundation

class ViewModel: ObservableObject {
    // save fetched notes for view loading
    @Published var tasks: [TaskEntityList] = []

    let dataService = PersistenceController.shared

    init() {
        getAllTask()
    }

    func createTask(title: String, desc: String, dueDate: Date) {
        dataService.create(title: title, desc: desc, dueDate: dueDate)
        getAllTask()
    }
    
    func getAllTask() {
        tasks = dataService.read()
    }
}
