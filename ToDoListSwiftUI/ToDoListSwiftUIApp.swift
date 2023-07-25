//
//  ToDoListSwiftUIApp.swift
//  ToDoListSwiftUI
//
//  Created by MacBook Noob on 25/07/23.
//

import SwiftUI

@main
struct ToDoListSwiftUIApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
