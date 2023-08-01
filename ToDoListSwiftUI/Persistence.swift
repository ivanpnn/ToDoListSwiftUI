//
//  Persistence.swift
//  ToDoListSwiftUI
//
//  Created by MacBook Noob on 25/07/23.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        for _ in 0..<10 {
            let newItem = Item(context: viewContext)
            newItem.timestamp = Date()
        }
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            ErrorHandling.shared.handle(error: nsError)
        }
        return result
    }()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "ToDoListSwiftUI")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                ErrorHandling.shared.handle(error: error)
            }
        })
    }
    
    func saveChanges() {
        let context = container.viewContext

        if context.hasChanges {
            do {
                try context.save()
            } catch {
                ErrorHandling.shared.handle(error: error)
            }
        }
    }
    
    func create(title: String, desc: String, dueDate: Date) {
        let entity = TaskEntityList(context: container.viewContext)
        entity.myId = UUID()
        entity.title = title
        entity.desc = desc
        entity.dueDate = dueDate
        saveChanges()
    }
    
    func read(predicateFormat: String? = nil, fetchLimit: Int? = nil) -> [TaskEntityList] {
        var results: [TaskEntityList] = []
        let request = NSFetchRequest<TaskEntityList>(entityName: "TaskEntityList")

        if predicateFormat != nil {
            request.predicate = NSPredicate(format: predicateFormat!)
        }
        if fetchLimit != nil {
            request.fetchLimit = fetchLimit!
        }

        do {
            results = try container.viewContext.fetch(request)
        } catch {
            ErrorHandling.shared.handle(error: error)
        }

        return results
    }
    
    func update(entity: TaskEntityList, title: String? = nil, desc: String? = nil, dueDate: Date? = nil) {
        var hasChanges: Bool = false

        if title != nil {
            entity.title = title!
            hasChanges = true
        }
        if desc != nil {
            entity.desc = desc!
            hasChanges = true
        }
        if dueDate != nil {
            entity.dueDate = dueDate!
            hasChanges = true
        }

        if hasChanges {
            saveChanges()
        }
    }
    
    func delete(_ entity: TaskEntityList) {
        container.viewContext.delete(entity)
        saveChanges()
    }
}
