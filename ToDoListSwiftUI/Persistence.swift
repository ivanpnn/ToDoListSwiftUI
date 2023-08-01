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
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
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
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
    }
    
    func saveChanges() {
        let context = container.viewContext

        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Could not save changes to Core Data.", error.localizedDescription)
            }
        }
    }
    
    func create(title: String, desc: String, dueDate: Date) {
        // create a NSManagedObject, will be saved to DB later
        let entity = TaskEntityList(context: container.viewContext)
        // attach value to the entity’s attributes
        entity.myId = UUID()
        entity.title = title
        entity.desc = desc
        entity.dueDate = dueDate
        // save changes to DB
        saveChanges()
    }
    
    func read(predicateFormat: String? = nil, fetchLimit: Int? = nil) -> [TaskEntityList] {
        // create a temp array to save fetched notes
        var results: [TaskEntityList] = []
        // initialize the fetch request
        let request = NSFetchRequest<TaskEntityList>(entityName: "TaskEntityList")

        // define filter and/or limit if needed
        if predicateFormat != nil {
            request.predicate = NSPredicate(format: predicateFormat!)
        }
        if fetchLimit != nil {
            request.fetchLimit = fetchLimit!
        }

        // fetch with the request
        do {
            results = try container.viewContext.fetch(request)
        } catch {
            print("Could not fetch notes from Core Data.")
        }

        return results
    }
    
    func update(entity: TaskEntityList, title: String? = nil, desc: String? = nil, dueDate: Date? = nil) {
        // create a temp var to tell if an attribute is changed
        var hasChanges: Bool = false

        // update the attributes if a value is passed into the function
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

        // save changes if any
        if hasChanges {
            saveChanges()
        }
    }
    
    func delete(_ entity: TaskEntityList) {
        container.viewContext.delete(entity)
        saveChanges()
    }
}
