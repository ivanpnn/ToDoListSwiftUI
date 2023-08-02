//
//  ContentView.swift
//  ToDoListSwiftUI
//
//  Created by MacBook Noob on 25/07/23.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State private var showNewTaskView: Bool = false
    @ObservedObject var vm: CoreDataManager = CoreDataManager()
    @StateObject var errorHandling = ErrorHandling.shared

    var body: some View {
        NavigationView {
            List {
                if vm.tasks.count > 0 {
                    ForEach(vm.tasks) { item in
                        TaskListCell(task: item, vm: vm)
                            .listRowSeparator(.hidden)
                            .listRowBackground(
                                RoundedRectangle(cornerRadius: 10)
                                    .background(.clear)
                                    .foregroundColor(.white)
                                    .padding(
                                        EdgeInsets(
                                            top: 2,
                                            leading: 10,
                                            bottom: 2,
                                            trailing: 10
                                        )
                                    )
                            )
                    }
                } else {
                    EmptyView()
                }
            }
            .toolbar {
                ToolbarItem {
                    Button(action: showTaskManagerView) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
            .sheet(isPresented: $showNewTaskView) {
                TaskManagerView(task: nil, vm: self.vm)
            }
            .alert(errorHandling.localizedError, isPresented: $errorHandling.hasError) {
                Button("Ok") {
                    errorHandling.dismissButton()
                }
            }
        }
    }
}

extension ContentView {
    private func showTaskManagerView() {
        self.showNewTaskView = true
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
